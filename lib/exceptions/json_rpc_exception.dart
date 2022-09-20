/// Imports
/// ------------------------------------------------------------------------------------------------

import 'solana_mobile_exception.dart';


/// JSON RPC Exception Code
/// ------------------------------------------------------------------------------------------------

enum JsonRpcExceptionCode {

  serverErrorBlockCleanedUp(-32001),
  serverErrorSendTransactionPreflightFailure(-32002),
  serverErrorTransactionSignatureVerifcationFailure(-32003),
  serverErrorBlockNotAvailable(-32004),
  serverErrorNodeUnhealthy(-32005),
  serverErrorTransactionPrecompileVerificationFailure(-32006),
  serverErrorSlotSkipped(-32007),
  serverErrorNoSnapshot(-32008),
  serverErrorLongTermStorageSlotSkipped(-32009),
  serverErrorKeyExcludedFromSecondaryIndex(-32010),
  serverErrorTransactionHistoryNotAvailable(-32011),
  scanError(-32012),
  serverErrorTransactionSignatureLenMismatch(-32013),
  serverErrorBlockStatusNotAvailableYet(-32014),
  serverErrorUnsupportedTransactionVersion(-32015),
  serverErrorMinContextSlotNotReached(-32016),

  methodNotFound(-32601),
  invalidParams(-32602),
  ;

  /// Stores the error code's value as a property of the enum variant.
  const JsonRpcExceptionCode(this.value);

  /// The error code's integer value.
  final int value;
}


/// JSON RPC Exception
/// ------------------------------------------------------------------------------------------------

class JsonRpcException<T> extends SolanaMobileException<T> {

  /// Creates an exception for a failed JSON-RPC request.
  const JsonRpcException(
    super.message, {
    super.code,
    this.data,
  });

  /// Additional information about the error, defined by the server.
  final dynamic data;

  /// Creates an `unknown` exception for a failed JSON-RPC request.
  factory JsonRpcException.unknown() {
    return const JsonRpcException('JSON-RPC Unknown Exception.');
  }

  /// Returns true if [error] is a [JsonRpcException] for the provided error [code].
  static bool isType(final Object? error, final JsonRpcExceptionCode? code) {
    return error is JsonRpcException && (code == null || error.code == code.value);
  }

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// JsonRpcException.fromJson({ '<parameter>': <value> });
  /// ```
  factory JsonRpcException.fromJson(final Map<String, dynamic> json) => JsonRpcException(
    json['message'],
    code: json['code'], 
    data: json['data'],
  );

  @override
  Map<String, dynamic> toJson() => {
    'message': message,
    'code': code,
    'data': data,
  };
}