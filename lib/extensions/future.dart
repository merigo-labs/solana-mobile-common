/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:async';
import '../protocol/json_rpc_context_response.dart';
import '../protocol/json_rpc_context_result.dart';
import '../protocol/json_rpc_response.dart';


/// Future Extension
/// ------------------------------------------------------------------------------------------------

/// Future extensions for [JsonRpcResponse]s.
extension FutureRpcResponse<T> on Future<JsonRpcResponse<T>> {

  /// Waits for `this` future to complete and returns its [JsonRpcResponse.result].
  /// 
  /// The caller must ensure that [JsonRpcResponse.result] will `not be null`.
  Future<T> unwrap() async => (await this).result!;

  /// Waits for `this` future to complete and returns its [JsonRpcResponse.result].
  Future<T?> optional() async => (await this).result;
}

/// Future extensions for [JsonRpcContextResponse]s.
extension FutureRpcContextResponse<T> on Future<JsonRpcContextResponse<T>> {

  /// Waits for `this` future to complete and returns its [JsonRpcContextResult.value].
  /// 
  /// The caller must ensure that [JsonRpcContextResult.value] will `not be null`.
  Future<T> unwrap() => then((final JsonRpcContextResponse<T> value) => value.result!.value!);

  /// Waits for `this` future to complete and returns its [JsonRpcContextResult.value].
  Future<T?> optional() => then((final JsonRpcContextResponse<T> value) => value.result?.value);
}