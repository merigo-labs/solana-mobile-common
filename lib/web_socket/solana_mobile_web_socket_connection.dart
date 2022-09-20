/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:async' show FutureOr, StreamSubscription, TimeoutException;
import 'dart:convert' show json;
import 'dart:io' show WebSocket, WebSocketException;
import 'package:flutter/material.dart';
import 'solana_mobile_web_socket.dart';
import 'web_socket_exchange_manager.dart';
import 'web_socket_subscription_manager.dart';
import '../protocol/json_rpc_request.dart';
import '../protocol/json_rpc_request_config.dart';
import '../protocol/json_rpc_response.dart';


/// Solana Mobile Web Socket Connection
/// ------------------------------------------------------------------------------------------------

abstract class SolanaMobileWebSocketConnection {

  /// An abstraction over a [SolanaMobileWebSocket] to map web socket requests to their responses.
  SolanaMobileWebSocketConnection({
    final int? maxAttempts,
    final List<int>? backoffSchedule = const [],
    final Iterable<String>? protocols,
  }) {
    socket = SolanaMobileWebSocket(
      maxAttempts: maxAttempts,
      backoffSchedule: backoffSchedule,
      protocols: protocols,
    )..listen(
        onConnect: _onWebSocketConnect,
      );
  }

  /// The web socket connection.
  @protected
  late final SolanaMobileWebSocket socket;

  /// The [socket]'s stream listener subscription.
  StreamSubscription? _socketStreamSubscription;

  /// Maps [JsonRpcRequest]s to their corresponding [JsonRpcResponse].
  @protected
  final WebSocketExchangeManager webSocketExchangeManager = WebSocketExchangeManager();

  /// Adds and removes stream listeners for a web socket subscription.
  @protected
  final WebSocketSubscriptionManager webSocketSubscriptionManager = WebSocketSubscriptionManager();

  /// Disposes of all the acquired resources:
  /// * Complete pending requests with [error].
  /// * Close subsscription listeners.
  /// * Disconnect web socket.
  @protected
  @mustCallSuper
  Future<void> dispose([final Object? error, final StackTrace? stackTrace]) {
    webSocketExchangeManager.dispose(error, stackTrace);
    return Future.wait([
      webSocketSubscriptionManager.dispose(),
      socket.disconnect(),
    ]);
  }

  /// Subscribes to the web socket [connection]'s stream and calls [onWebSocketConnect].
  void _onWebSocketConnect(final WebSocket connection) {
    _socketStreamSubscription?.cancel().ignore();
    _socketStreamSubscription = connection.listen(
      onWebSocketData,
      onError: onWebSocketError,
      onDone: _onWebSocketDisconnect,
    );
    onWebSocketConnect();
  }

  /// Called when the web socket connects.
  @protected
  void onWebSocketConnect();

  /// Called when the web socket receives [data].
  @protected
  void onWebSocketData(final dynamic data);

  /// Called when the web socket receives an [error].
  @protected
  void onWebSocketError(final Object error, [final StackTrace? stackTrace]);

  /// Cancels the stream subscription and calls [onWebSocketDisconnect].
  @protected
  void _onWebSocketDisconnect([final int? code, final String? reason]) {
    _socketStreamSubscription?.cancel().ignore();
    onWebSocketDisconnect();
  }
  
  /// Called when the web socket closes.
  @protected
  void onWebSocketDisconnect([final int? code, final String? reason]);

  /// Creates an `onTimeout` callback function for a [webSocketExchange].
  @protected
  Future<JsonRpcResponse<T>> Function() onWebSocketExchangeTimeout<T>() 
    => () => Future.error(
      TimeoutException('[SolanaMobileWebSocketConnection] web socket request timed out.'),
    );

  /// A hook that can be used to encrypt [data].
  @protected
  FutureOr<List<int>> encrypt(final List<int> data) => data;

  /// Makes a JSON-RPC data request to the web [socket] server.
  /// 
  /// The request's `timeout` duration can be set using the [config] object's 
  /// [JsonRpcRequestConfig.timeout] property. 
  /// 
  /// All other configurations are ignored.
  @protected
  Future<JsonRpcResponse<T>> webSocketExchange<T>(
    final Uri uri,
    final JsonRpcRequest request, {
    final JsonRpcRequestConfig? config,
  }) async {

    // The subscription's request/response cycle.
    WebSocketExchange<T>? exchange;

    try {
      // Connect the web socket.
      await socket.connect(uri);
      
      // Get the existing request/response cycle (if it exists).
      exchange = webSocketExchangeManager.get(request.hash());

      // If an exchange created using the current connection exists, return the response (which may 
      // still be pending).
      if (exchange != null) {
        final DateTime? connectedAt = socket.connectedAt;
        if (connectedAt == null) {
          throw const WebSocketException('[WebSocketConnection.connectedAt] is null.');
        }
        if (exchange.createdAt.isBefore(connectedAt)) {
          if (exchange.isCompleted) {
            await webSocketSubscriptionManager.close(exchangeId: exchange.id);
          } else {
            throw const WebSocketException('The exchange request expired.');
          }
        } else {
          return exchange.response;
        }
      }

      // Check that existing requests have an id and new requests do not.
      assert(
        exchange == null ? request.id == null : request.id == exchange.id, 
        'A [WebSocketExchange] must be initialized with a new or existing exchange request.',
      );

      // Create a WebSocketExchange for the subscription's request/response cycle.
      exchange = WebSocketExchange<T>(request);

      // Store the exchange (request/response) to be used for future subscriptions or cancellation.
      webSocketExchangeManager.set(exchange);

      // Send the [exchange.request] to the JSON-RPC web socket server (the response will be 
      // recevied by `onSocketData`). The original request may have been modified by 
      // WebSocketExchange, so use [exchange.request].
      //_debugWebSocketRequest(exchange.request);
      final List<int> data = json.encode(exchange.request.toJson()).codeUnits;
      socket.send(await encrypt(data));

      // Return the pending subscription that completes when a success response is received from the 
      // web socket server (onSocketData) or the request times out.
      final Duration timeLimit = config?.timeout ?? const Duration(seconds: 60);
      return await exchange.response.timeout(timeLimit, onTimeout: onWebSocketExchangeTimeout());

    } catch (error, stackTrace) {
      webSocketExchangeManager.remove(exchange?.id);
      exchange?.completeError(error, stackTrace);
      return Future.error(error, stackTrace);
    }
  }
}