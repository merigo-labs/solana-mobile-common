/// Imports
/// ------------------------------------------------------------------------------------------------

import '../models/serialisable.dart';


/// Solana Mobile Exception
/// ------------------------------------------------------------------------------------------------

class SolanaMobileException<T> extends Serialisable implements Exception {

  /// Defines the format of an exception, which contains a short descriptive [message] of the error
  /// and an optional error [code].
  const SolanaMobileException(
    this.message, {
    this.code,
  });

  /// A short description of the error.
  final String message;

  /// The error type.
  final T? code;

  @override
  Map<String, dynamic> toJson() => {
    'message': message,
    'code': code,
  };

  @override
  String toString() => '[$runtimeType] ${code != null ? '$code : ' : ''}$message';
}