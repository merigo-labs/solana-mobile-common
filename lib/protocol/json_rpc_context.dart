/// Imports
/// ------------------------------------------------------------------------------------------------

import '../models/serialisable.dart';


/// JSON RPC Context
/// ------------------------------------------------------------------------------------------------

class JsonRpcContext extends Serialisable {
  
  /// Defines a JSON-RPC (response) context.
  const JsonRpcContext({
    required this.slot,
  });

  /// The slot at which the operation was evaluated.
  final int slot;

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// JsonRpcContext.fromJson({ '<parameter>': <value> });
  /// ```
  factory JsonRpcContext.fromJson(final Map<String, dynamic> json) 
    => JsonRpcContext(slot: json['slot']);

  @override
  Map<String, dynamic> toJson() => {
    'slot': slot,
  };
}