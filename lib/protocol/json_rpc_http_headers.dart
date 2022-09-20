/// Imports
/// ------------------------------------------------------------------------------------------------

import '../models/serialisable.dart';
import '../utils/library.dart' as utils show tryParse;


/// JSON RPC Http Headers
/// ------------------------------------------------------------------------------------------------

class JsonRpcHttpHeaders extends Serialisable {
  
  /// Defines the HTTP headers for a JSON-RPC request.
  const JsonRpcHttpHeaders({
    this.contentType = 'application/json',
  });

  /// The content type (default: `application/json`).
  final String contentType;

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// JsonRpcHttpHeaders.fromJson({ '<parameter>': <value> });
  /// ```
  factory JsonRpcHttpHeaders.fromJson(final Map<String, dynamic> json) => JsonRpcHttpHeaders(
    contentType: json['content-type'],
  );

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// Returns `null` if [json] is omitted.
  /// 
  /// ```
  /// JsonRpcHttpHeaders.tryFromJson({ '<parameter>': <value> });
  /// ```
  static JsonRpcHttpHeaders? tryFromJson(final Map<String, dynamic>? json) {
    return utils.tryParse(json, JsonRpcHttpHeaders.fromJson);
  }

  @override
  Map<String, String> toJson() {
    return { 
      'content-type': contentType 
    };
  }
}