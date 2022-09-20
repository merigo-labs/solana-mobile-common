/// Imports
/// ------------------------------------------------------------------------------------------------

import 'json_rpc_request.dart';
import '../exceptions/json_rpc_exception.dart';
import '../models/serialisable.dart';
import '../utils/types.dart' show JsonRpcParser;


/// JSON RPC Response Object Exception
/// ------------------------------------------------------------------------------------------------

class _JsonRpcResponseObjectException extends JsonRpcException {
  const _JsonRpcResponseObjectException(): super('Unexpected JSON-RPC response object format.');
}


/// JSON RPC Response
/// ------------------------------------------------------------------------------------------------

class JsonRpcResponse<T> extends Serialisable {
  
  /// Defines a JSON-RPC response.
  /// 
  /// The response is expressed as a single JSON object; a `success` response must contain a 
  /// [result] key and an `error` response must contain an [error] key. A response cannot contain 
  /// both a [result] and an [error].
  const JsonRpcResponse({
    required this.jsonrpc,
    this.result,
    this.error,
    this.id,
  });

  /// The JSON-RPC version.
  final String jsonrpc;

  /// The requested data or success confirmation (array|number|object|string|RpcException).
  final T? result;

  /// The error response of a failed request.
  final JsonRpcException? error;

  /// The client-generated identifier sent with the request.
  final int? id;

  /// If true, this instance represents a `success` response.
  /// 
  /// Success responses contain a [result] value, which can be `null`.
  bool get isSuccess => error == null;

  /// If true, this instance represents an `error` response.
  /// 
  /// Error responses contain a `non-null` [error] value.
  bool get isError => error != null;

  /// The response object's `jsonrpc` key.
  static const String jsonRpcKey = 'jsonrpc';

  /// The response object's `result` key.
  static const String resultKey = 'result';

  /// The response object's `error` key.
  static const String errorKey = 'error';

  /// The response object's `id` key.
  static const String idKey = 'id';
  
  /// Returns true if the response [json] contains a result of type T.
  static bool isType<T>(final Map<String, dynamic> json) {
    return json[resultKey] is T;
  }

  /// Creates an [JsonRpcResponse] for the provided [result].
  factory JsonRpcResponse.fromResult(final T result, { final int? id }) => JsonRpcResponse(
    jsonrpc: JsonRpcRequest.version, 
    result: result,
    id: id,
  );

  /// Creates an [JsonRpcResponse] for the provided [error].
  factory JsonRpcResponse.fromError(
    final JsonRpcException error, { 
    final int? id, 
  }) => JsonRpcResponse(
    jsonrpc: JsonRpcRequest.version, 
    error: error,
    id: id,
  );

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// A `success` response will set [JsonRpcResponse.result] to the return value of 
  /// `parse(json['result'])`.
  /// 
  /// ```
  /// JsonRpcResponse.parse({ '<parameter>': <value> }, (U) => T);
  /// ```
  static JsonRpcResponse<T> parse<T, U>(
    final Map<String, dynamic> json,
    final JsonRpcParser<T, U> parse,
  ) {
    
    /// Success responses contain a 'result' key.
    if (json.containsKey(resultKey)) {
      json[resultKey] = parse.call(json[resultKey]);
      return JsonRpcResponse<T>.fromJson(json);
    }

    /// Error responses contain an 'error' key.
    if (json.containsKey(errorKey)) {
      json[errorKey] = JsonRpcException.fromJson(json[errorKey]);
      return JsonRpcResponse<T>.fromJson(json);
    }

    /// A valid JSON-RPC 2.0 response object must contain a 'result' or 'error', but not both.
    /// https://www.jsonrpc.org/specification#response_object
    return JsonRpcResponse<T>(jsonrpc: '', error: const _JsonRpcResponseObjectException());
  }

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// A `success` response will set [JsonRpcResponse.result] to the return value of 
  /// `parse(json['result'])`.
  /// 
  /// Return's `null` if [json] is `null` or `badly formatted`.
  /// 
  /// ```
  /// JsonRpcResponse.tryParse({ '<parameter>': <value> }, (U) => T);
  /// ```
  static JsonRpcResponse<T>? tryParse<T, U>(
    final Map<String, dynamic>? json,
    final JsonRpcParser<T, U> parse,
  ) {
    final JsonRpcResponse<T>? response = json != null ? JsonRpcResponse.parse(json, parse) : null;
    return response?.error is _JsonRpcResponseObjectException ? null : response;
  }

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// JsonRpcResponse.fromJson({ '<parameter>': <value> });
  /// ```
  factory JsonRpcResponse.fromJson(final Map<String, dynamic> json) => JsonRpcResponse<T>(
    jsonrpc: json[jsonRpcKey], 
    result: json[resultKey],
    error: json[errorKey],
    id: json[idKey],
  );

  @override
  Map<String, dynamic> toJson() => {
    jsonRpcKey: jsonrpc,
    resultKey: result,
    errorKey: error,
    idKey: id,
  };
}