/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_mobile_common/models/serialisable.dart';
import 'package:solana_mobile_common/models/sign_and_send_transactions_params.dart';
import '../utils/types.dart';


/// Sign And Send Transactions Result
/// ------------------------------------------------------------------------------------------------

class SignAndSendTransactionsResult extends Serialisable {

  /// The result of a successful `sign_and_send_transactions` request.
  const SignAndSendTransactionsResult({
    required this.signatures,
  });

  /// The corresponding base-64 encoded signed transactions of the request's 
  /// [SignAndSendTransactionsParams.payloads].
  final List<Base64EncodedSignature> signatures;

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// SignAndSendTransactionsResult.fromJson({ '<parameter>': <value> });
  /// ```
  factory SignAndSendTransactionsResult.fromJson(final Map<String, dynamic> json) 
    => SignAndSendTransactionsResult(
      signatures: List<Base64EncodedSignature>.from(json['signatures']),
    );

  @override
  Map<String, dynamic> toJson() => {
    'signatures': signatures,
  };
}