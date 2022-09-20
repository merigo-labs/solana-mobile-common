/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:convert';
import '../exceptions/json_rpc_exception.dart';
import '../models/serialisable.dart';
import '../protocol/json_rpc_response.dart';


/// JSON RPC Request
/// ------------------------------------------------------------------------------------------------

class JsonRpcRequest<T> extends Serialisable {
  
  /// Creates a JSON-RPC request to invoke [method] with [params].
  /// 
  /// ```
  /// {
  ///   'jsonrpc': '2.0',
  ///   'id': [id],
  ///   'method': [method],
  ///   'params': [params],
  /// }
  /// ```
  const JsonRpcRequest(
    this.method, {
    this.params, 
    this.id,
  }): assert(id == null || id >= 0);

  /// The default JSON-RPC protocol version.
  static const String version = '2.0';

  /// The JSON-RPC protocol version.
  final String jsonrpc = version;

  /// The method to be invoked.
  final Enum method;

  /// A JSON array of ordered parameter values.
  final T? params;
  
  /// A unique client-generated identifier.
  final int? id;

  /// Generates a hash that uniquely identifies this request's method invocation.
  /// 
  /// The [hash] is derived by JSON encoding the request's [method] and [params]. Two 
  /// [JsonRpcRequest]s will produce the same hash if they contain the same [method] and `ordered` 
  /// [params].
  /// 
  /// ```
  /// final p0 = ['Gr54...5Fd5', { 'encoding': 'base64', 'commitment': 'finalized' }];
  /// final r0 = JsonRpcRequest(Method.getAccountInfo, params: p0, id: 0);
  /// 
  /// final p1 = ['Gr54...5Fd5', { 'encoding': 'base64', 'commitment': 'finalized' }];
  /// final r1 = JsonRpcRequest(Method.getAccountInfo, params: p1, id: 1);
  /// 
  /// final p2 = ['Gr54...5Fd5', { 'commitment': 'finalized', 'encoding': 'base64' }];
  /// final r2 = JsonRpcRequest(Method.getAccountInfo, params: p2, id: 1);
  /// 
  /// assert(r0.hash() == r1.hash()); // true
  /// assert(r1.hash() == r2.hash()); // false, the configuration values are ordered differently.
  /// 
  /// TODO: Sort by keys, then hash.
  /// ```
  String hash() => json.encode([method.name, params]);

  /// Creates a JSON [JsonRpcRequest] to invoke a [method].
  /// 
  /// The [method]'s parameters are passed using the [params] list and [config] object.
  /// 
  /// ```
  /// JsonRpcRequest.build(                                   // {
  ///   Method.getAccountInfo,                            //   'jsonrpc': '2.0',
  ///   [                                                 //   'id': 1,
  ///     '3C4iYswhNe7Z2LJvxc9qQmF55rsKDUGdiuKVUGpTbRsK', //   'method': 'getAccountInfo',
  ///   ],                                                //   'params': [
  ///   GetAccountInfoConfig(                             //     '3C4iYswh...UGpTbRsK',
  ///     id: 1,                                          //     {
  ///     encoding: AccountEncoding.base64,               //       'encoding': 'base64',
  ///   ),                                                //     },
  /// );                                                  //   ],
  ///                                                     // }
  /// ```
  // factory JsonRpcRequest.build(
  //   final Method method,
  //   final List<Object> params, 
  //   final JsonRpcRequestConfig config,
  // ) {
  //   final Map<String, dynamic> object = config.object();
  //   final List<Object>? parameters = object.isEmpty ? params : params..add(object);
  //   return JsonRpcRequest._(method, params: parameters, id: config.id);
  // }

  /// Creates a copy of `this` instance, applying the provided parameters to the new instance.
  /// 
  /// ```
  /// const JsonRpcRequest request = JsonRpcRequest(
  ///   Method.getAccountInfo, 
  ///   params: ['4fGh...GTh6'],
  ///   id: 0,
  /// );
  /// final JsonRpcRequest newRequest = request.copyWith(id: 1);
  /// print(newRequest.toJson()); // { 
  ///                             //    'jsonrpc': '2.0', 
  ///                             //    'method': 'getAccountInfo', 
  ///                             //    'params': ['4fGh...GTh6'], 
  ///                             //    'id': 1, 
  ///                             // }
  /// ```
  JsonRpcRequest copyWith({
    Enum? method,
    List<Object>? params,
    int? id,
  }) => JsonRpcRequest(
    method ?? this.method,
    params: params ?? this.params,
    id: id ?? this.id,
  );

  @override
  Map<String, dynamic> toJson() => {
    'jsonrpc': jsonrpc,
    'method': method.name,
    'params': params,
    'id': id,
  };

  /// Creates a [JsonRpcResponse] for this request.
  JsonRpcResponse<T> toResponse({ 
    final T? result, 
    final JsonRpcException? error, 
  }) => JsonRpcResponse(
    jsonrpc: jsonrpc,
    result: result,
    error: error,
    id: id,
  );
}