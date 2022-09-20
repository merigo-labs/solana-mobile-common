/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_mobile_common/models/serialisable.dart';
import '../utils/types.dart';


/// Sign Messages Params
/// ------------------------------------------------------------------------------------------------

class SignMessagesParams extends Serialisable {

  /// Sign messages request parameters.
  const SignMessagesParams({
    required this.addresses,
    required this.payloads,
  });

  /// Base-64 encoded addresses of the accounts which should be used to sign message. These should 
  /// be a subset of the addresses returned by authorize or reauthorize for the current session’s 
  /// authorization.
  final List<Base64EncodedAddress> addresses;

  /// Base-64 URL encoded message payloads to sign.
  final List<Base64EncodedMessage> payloads;

  @override
  Map<String, dynamic> toJson() => {
    'addresses': addresses,
    'payloads': payloads,
  };
}