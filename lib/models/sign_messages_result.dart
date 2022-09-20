/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_mobile_common/models/serialisable.dart';
import 'package:solana_mobile_common/models/sign_messages_params.dart';
import '../utils/types.dart';


/// Sign Messages Result
/// ------------------------------------------------------------------------------------------------

class SignMessagesResult extends Serialisable {

  /// The result of a successful `sign_messages` request.
  const SignMessagesResult({
    required this.signedPayloads,
  });
  
  /// The corresponding base-64 encoded signed transactions of the request's 
  /// [SignMessagesParams.payloads].
  final List<Base64EncodedTransaction> signedPayloads;

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// SignMessagesResult.fromJson({ '<parameter>': <value> });
  /// ```
  factory SignMessagesResult.fromJson(final Map<String, dynamic> json) 
    => SignMessagesResult(
      signedPayloads: List<Base64EncodedTransaction>.from(json['signed_payloads']),
    );
    
  @override
  Map<String, dynamic> toJson() => {
    'signed_payloads': signedPayloads,
  };
}