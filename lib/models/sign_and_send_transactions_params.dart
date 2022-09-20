/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_mobile_common/models/serialisable.dart';
import 'sign_and_send_transactions_config.dart';
import '../utils/types.dart';


/// Sign And Send Transactions Params
/// ------------------------------------------------------------------------------------------------

class SignAndSendTransactionsParams extends Serialisable {

  /// Request parameters for `sign_and_send_transactions` method calls.
  const SignAndSendTransactionsParams({
    required this.payloads,
    this.options,
  });

  /// Base-64 encoded transaction payloads to sign.
  final List<Base64EncodedTransaction> payloads;

  /// Configuration options.
  final SignAndSendTransactionsConfig? options;

  @override
  Map<String, dynamic> toJson() => {
    'payloads': payloads,
    'options': options?.toJson(),
  };
}