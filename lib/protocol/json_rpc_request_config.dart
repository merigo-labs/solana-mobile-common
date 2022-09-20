/// Imports
/// ------------------------------------------------------------------------------------------------

import 'json_rpc_http_headers.dart';


/// JSON RPC Request Config
/// ------------------------------------------------------------------------------------------------

abstract class JsonRpcRequestConfig {
  
  /// Defines the configurations for JSON-RPC `requests`.
  const JsonRpcRequestConfig({
    required this.id,
    required this.headers,
    required this.timeout,
  });

  /// A unique client-generated identifier.
  final int? id;

  /// The request's HTTP headers.
  final JsonRpcHttpHeaders? headers;

  /// The request's timeout duration.
  final Duration? timeout;

  /// Returns the `configuration object` passed to a method call as the last item in the `params` 
  /// list.
  /// 
  /// ```
  /// {
  ///   'jsonrpc': '2.0',
  ///   ...,
  ///   'params': [
  ///     '3C4iYswhNe7Z2LJvxc9qQmF55rsKDUGdiuKVUGpTbRsK',
  ///     // The value returned by this object() call
  ///     {
  ///       'commitment': 'processed',
  ///     }
  ///   ]
  /// }
  /// ```
  Map<String, dynamic> object();
}