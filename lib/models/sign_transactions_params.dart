/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_mobile_common/models/serialisable.dart';
import '../utils/types.dart';


/// Sign Transactions Params
/// ------------------------------------------------------------------------------------------------

class SignTransactionsParams extends Serialisable {

  /// Sign transactions request parameters.
  const SignTransactionsParams({
    required this.payloads,
  });

  /// Base-64 encoded transaction payloads to sign.
  final List<Base64EncodedTransaction> payloads;

  @override
  Map<String, dynamic> toJson() => {
    'payloads': payloads,
  };
}