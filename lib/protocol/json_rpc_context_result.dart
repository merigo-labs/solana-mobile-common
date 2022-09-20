/// Imports
/// ------------------------------------------------------------------------------------------------

import 'json_rpc_context.dart';
import '../models/serialisable.dart';
import '../utils/library.dart' as utils;
import '../utils/types.dart';


/// JSON RPC Context Result
/// ------------------------------------------------------------------------------------------------

class JsonRpcContextResult<T> extends Serialisable {
  
  /// Defines a common JSON-RPC `success` result.
  const JsonRpcContextResult({
    required this.context,
    required this.value,
  });

  /// A JSON-RPC response context.
  final JsonRpcContext context;

  /// The value returned by the operation.
  final T? value;

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// [JsonRpcContextResult.value] is set to the return value of `parse(json['value'])`.
  /// 
  /// ```
  /// JsonRpcContextResult.parse({ '<parameter>': <value> }, (U) => T);
  /// ```
  static JsonRpcContextResult<T> parse<T, U>(
    final Map<String, dynamic> json, 
    final JsonRpcParser<T, U> parse,
  ) {
    const String valueKey = 'value';
    json[valueKey] = utils.tryParse(json[valueKey], parse);
    return JsonRpcContextResult<T>.fromJson(json);
  }

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// [JsonRpcContextResult.value] is set to the return value of `parse(json['value'])`.
  /// 
  /// Returns `null` if [json] is omitted.
  /// 
  /// ```
  /// JsonRpcContextResult.tryParse({ '<parameter>': <value> }, (U) => T);
  /// ```
  static JsonRpcContextResult<T>? tryParse<T, U> (
    final Map<String, dynamic>? json, 
    final JsonRpcParser<T, U> parse,
  ) => json != null ? JsonRpcContextResult.parse(json, parse) : null;

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// JsonRpcContextResult.fromJson({ '<parameter>': <value> });
  /// ```
  factory JsonRpcContextResult.fromJson(final Map<String, dynamic> json) => JsonRpcContextResult(
    context: JsonRpcContext.fromJson(json['context']), 
    value: json['value'],
  );

  @override
  Map<String, dynamic> toJson() => {
    'context': context.toJson(),
    'value': value,
  };
}