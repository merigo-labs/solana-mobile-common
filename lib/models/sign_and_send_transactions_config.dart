/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_mobile_common/models/serialisable.dart';


/// Sign And Send Transactions Config
/// ------------------------------------------------------------------------------------------------

class SignAndSendTransactionsConfig extends Serialisable {

  /// Request configurations options for `sign_and_send_transactions` method calls.
  const SignAndSendTransactionsConfig({
    this.minContextSlot,
  });

  /// The minimum slot number at which to perform preflight transaction checks.
  final int? minContextSlot;

  @override
  Map<String, dynamic> toJson() => {
    'min_context_slot': minContextSlot,
  };
}