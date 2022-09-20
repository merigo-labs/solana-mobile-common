/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:async';
import 'package:flutter/foundation.dart' show protected;
import 'package:solana_mobile_common/utils/types.dart';
import 'web_socket_manager_lookup.dart';
import '../protocol/json_rpc_subscribe_response.dart';


/// Web Socket Subscription
/// ------------------------------------------------------------------------------------------------

class WebSocketSubscription<T> {

  /// Stores a web socket stream subscription.
  /// 
  /// Use the [on] method to attach handlers to the stream.
  WebSocketSubscription(
    this.id, {
    required this.exchangeId,
    required this.streamSubscription,
  }): createdAt = DateTime.now().toUtc();

  /// The subscription id.
  final int id;

  /// The `subscribe` request/response id.
  final int exchangeId;

  /// The stream subscription.
  @protected
  final StreamSubscription<T> streamSubscription;

  /// The UTC created date time.
  final DateTime createdAt;

  /// Cancels the stream subscription.
  @protected
  Future<void> cancel() => streamSubscription.cancel();

  /// Attaches the provided handlers to the stream subscription.
  void on(
    void Function(T data)? onData, {
    void Function(Object error, [StackTrace? stackTrace])? onError,
    void Function()? onDone,
  }) {
    streamSubscription
      ..onData(onData)
      ..onError(onError)
      ..onDone(onDone);
  }
}


/// Web Socket Subscription Manager
/// ------------------------------------------------------------------------------------------------

class WebSocketSubscriptionManager {

  /// Adds and removes stream listeners for a web socket subscription.
  WebSocketSubscriptionManager();

  /// Maps a subscription `id` to a [StreamController].
  final _subscriptionIdToController = WebSocketManagerLookup<MultiKey<int>, StreamController>();

  /// True if there are no subscriptions.
  bool get isEmpty => _subscriptionIdToController.isEmpty;

  /// True if there's at least one subscriber.
  bool get isNotEmpty => _subscriptionIdToController.isNotEmpty;

  /// All subscriptions.
  Iterable<StreamController> get values => _subscriptionIdToController.values;

  /// Returns the stream controller for [subscriptionId].
  StreamController<T>? _controller<T>({ required final SubscriptionId subscriptionId })
    => _subscriptionIdToController.at(subscriptionId, index: 0) as StreamController<T>?;

  /// Closes all stream controllers.
  Future<void> dispose() {
    final List<StreamController> controllers = values.toList(growable: false);
    final Iterable<Future<void>> futures = controllers.map((c) => c.close());
    _subscriptionIdToController.clear();
    return Future.wait(futures);
  }

  /// Closes the stream controller for [exchangeId].
  Future<void> close({ required final int exchangeId }) {
    final StreamController? controller = _subscriptionIdToController.at(exchangeId, index: 1);
    return controller?.close() ?? Future.value();
  }

  /// Returns true if there's a subscriber on the [Stream].
  bool hasListener(final SubscriptionId subscriptionId) {
    final StreamController? controller = _controller(subscriptionId: subscriptionId);
    return controller != null && controller.hasListener;
  }

  /// Adds a subscriber to the [Stream] associated with the `subscribe` [response].
  WebSocketSubscription<T> subscribe<T>(final JsonRpcSubscribeResponse response) {

    // Debug the response.
    assert(response.id != null, 'The response.id must not be null.');
    assert(response.isSuccess, 'The response must contain a result.');

    // The subscription id.
    final int subscriptionId = response.result!;
    
    // The request/response id.
    final int exchangeId = response.id!;

    // Get or create a stream controller for the subscription.
    StreamController<T>? controller = _controller<T>(subscriptionId: subscriptionId);
    if (controller == null || controller.isClosed) {
      final MultiKey<int> key = MultiKey([subscriptionId, exchangeId]);
      _subscriptionIdToController[key] = controller = StreamController.broadcast(sync: true);
    }
    
    // Create a stream listener.
    return WebSocketSubscription(
      subscriptionId, 
      exchangeId: exchangeId, 
      streamSubscription: controller.stream.listen(null),
    );
  }

  /// Removes a subscriber from the [Stream] associated with the [subscription].
  Future<void> unsubscribe<T>(final WebSocketSubscription<T> subscription) async {
    await subscription.cancel();
    final StreamController? controller = _controller(subscriptionId: subscription.id);
    if(controller != null && !controller.hasListener) {
      assert(controller.stream.isBroadcast);  // close() will never complete for non-broadcast 
      await controller.close();               // streams that are never listened to.
      _subscriptionIdToController.remove(subscription.id);
    }
  }

  @override
  String toString() => _subscriptionIdToController.toString();
}