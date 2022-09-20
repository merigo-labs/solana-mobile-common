/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_mobile_common/models/serialisable.dart';
import 'package:solana_mobile_common/models/sign_transactions_params.dart';
import '../utils/types.dart';


/// Sign Transactions Result
/// ------------------------------------------------------------------------------------------------

class SignTransactionsResult extends Serialisable {

  /// The result of a successful `sign_transactions` request.
  const SignTransactionsResult({
    required this.signedPayloads,
  });
  
  /// The corresponding base-64 encoded signed transactions of the request's 
  /// [SignTransactionsParams.payloads].
  final List<Base64EncodedSignedTransaction> signedPayloads;

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// SignTransactionsResult.fromJson({ '<parameter>': <value> });
  /// ```
  factory SignTransactionsResult.fromJson(final Map<String, dynamic> json) 
    => SignTransactionsResult(
      signedPayloads: List<Base64EncodedSignedTransaction>.from(json['signed_payloads']),
    );

  @override
  Map<String, dynamic> toJson() => {
    'signed_payloads': signedPayloads,
  };
}