/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:async';
import 'dart:io';
import '../protocol/json_rpc_request.dart';
import '../protocol/json_rpc_response.dart';
import 'web_socket_manager_lookup.dart';


/// Web Socket Subscribe Exchange
/// ------------------------------------------------------------------------------------------------

typedef WebSocketSubscribeExchange = WebSocketExchange<int>;


/// Web Socket Unsubscribe Exchange
/// ------------------------------------------------------------------------------------------------

typedef WebSocketUnsubscribeExchange = WebSocketExchange<bool>;


/// Web Socket Exchange
/// ------------------------------------------------------------------------------------------------

class WebSocketExchange<T> {

  /// Tracks the request/response cycle of a JSON-RPC web socket method call.
  /// 
  /// The [request] is assigned its own unique `id`, which is used to match the request to its 
  /// corresponding [response].
  /// 
  /// The async [response] returns when a call is made to [complete] or [completeError].
  /// 
  /// ```
  /// const RpcRequest request = RpcRequest(
  ///   Method.getAccountInfo,
  ///   params: ['3C4iYswhNe7Z2LJvxc9qQmF55rsKDUGdiuKVUGpTbRsK'],
  ///   id: null // Must be null
  /// );
  /// 
  /// final WebSocketExchange exchange = WebSocketExchange(request);
  /// print(exchange.id); // 1
  /// 
  /// responseHandler(final Map<String, dynamic> json) { // Async handler
  ///   final RpcResponse<int> response = RpcResponse.parse(json, cast<int>);
  ///   exchange.complete(response);
  /// }
  /// 
  /// final RpcResponse response = await exchange.response;
  /// ```
  WebSocketExchange(
    final JsonRpcRequest request,
  ):  request = request.id != null ? request : request.copyWith(id: ++_id), // Add a unique id.
      createdAt = DateTime.now().toUtc(),
      _completer = Completer.sync();

  /// An `auto increment` id that's assigned to the [request] of each [WebSocketExchange] instance.
  /// 
  /// TODO: on reconnect, check that [_id] is equal to the largest resubscribed [exchange.id].
  static int _id = 0;

  /// The JSON-RPC request.
  final JsonRpcRequest request;

  /// The response completer.
  final Completer<JsonRpcResponse<T>> _completer;

  /// The JSON-RPC response.
  Future<JsonRpcResponse<T>> get response => _completer.future;

  /// The UTC timestamp at which this exchange was created.
  final DateTime createdAt;

  /// Returns true if the request/response cycle is complete.
  bool get isCompleted => _completer.isCompleted;

  /// The unique id of the request.
  int get id => request.id!;

  /// The hash that uniquely identifies the request's method invocation.
  String get hash => request.hash();

  /// Disposes of all the acquired resources.
  void dispose() {
    completeError(const WebSocketException('The [WebSocketExchange] has been disposed.'));
  }

  /// Completes the [WebSocketExchange] with a [response].
  void complete(final JsonRpcResponse<T> response) {
    if (!_completer.isCompleted) {
      if (id == response.id) {
        _completer.complete(response);
      } else {
        completeError(WebSocketException(
          'Invalid `response` passed to [WebSocketExchange.complete].\n'
          'The response.id ${response.id} does not match the request.id $id.'
        ));
      }
    }
  }

  /// Completes the [WebSocketExchange] with an [error].
  void completeError(final Object error, [final StackTrace? stackTrace]) {
    if (!_completer.isCompleted) {
      _completer.completeError(error, stackTrace);
    }
  }
}


/// Web Socket Exchange Manager
/// ------------------------------------------------------------------------------------------------

class WebSocketExchangeManager {

  /// Maps an [JsonRpcRequest.hash] and [JsonRpcRequest.id]/[JsonRpcResponse.id] to a single 
  /// [WebSocketExchange].
  WebSocketExchangeManager();

  /// Maps a request `id` and `hash` to a [WebSocketExchange].
  final WebSocketManagerLookup _keyToExchange = WebSocketManagerLookup<MultiKey, WebSocketExchange>();

  /// All `exchanges`.
  Iterable<WebSocketExchange> get values => _keyToExchange.values as Iterable<WebSocketExchange>;

  /// The first element in [values].
  WebSocketExchange get first => values.first;

  /// The last element in [values].
  WebSocketExchange get last => values.last;

  /// The number of key/value pairs in the lookup table.
  int get length => _keyToExchange.length;

  /// Returns the `exchange` associated with [key].
  /// 
  /// Note that [key] can be any of the [MultiKey]s.
  /// 
  /// Returns null if key was not in the map.
  WebSocketExchange<T>? get<T>(final dynamic key) => _keyToExchange[key];

  /// Associates the exchange `id` and `hash` with its [value].
  void set(final WebSocketExchange value) => _keyToExchange[MultiKey([value.id, value.hash])] = value;

  /// Removes [id] and its associated value from the map.
  /// 
  /// Returns the value associated with id before it was removed. 
  /// 
  /// Returns null if id was not in the map.
  WebSocketExchange<T>? remove<T>(final int? id) => _keyToExchange.removeAt(id, index: 0);

  /// Removes the first entry in the map and returns its associated value.
  /// 
  /// Returns null if the map is empty.
  WebSocketExchange<T>? removeFirst<T>() => remove(_keyToExchange.keys.first[0]);

  /// Remove all entries.
  void clear() => _keyToExchange.clear();

  /// Completes all exchanges with [error] (or a [WebSocketException]) and clears the lookup table.
  void dispose([Object? error, final StackTrace? stackTrace]) {
    error ??= const WebSocketException('The [WebSocketExchange] request has been abandoned.');
    final List<WebSocketExchange> exchanges = values.toList(growable: false);
    for (final exchange in exchanges) {
      exchange.completeError(error, stackTrace);
    }
    _keyToExchange.clear();
  }

  /// Completes the exchange for the provided [response].
  void complete(final JsonRpcResponse response, { final bool remove = false }) {
    final WebSocketExchange? exchange = remove 
      ? _keyToExchange.remove(response.id)
      : _keyToExchange[response.id];
    if (exchange != null) {
      if (response.isSuccess) {
        exchange.complete(response);
      } else {
        exchange.completeError(response.error!);
      }
    }
  }

  @override
  String toString() => _keyToExchange.toString();
}