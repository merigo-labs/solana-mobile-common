/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_mobile_common/models/serialisable.dart';
import '../utils/types.dart';


/// Deauthorize Params
/// ------------------------------------------------------------------------------------------------

class DeauthorizeParams extends Serialisable {

  /// Request parameters for `deauthorize` method calls.
  const DeauthorizeParams({
    required this.authToken,
  });

  /// An opaque string previously returned by a call to `authorize`, `reauthorize` or 
  /// `clone_authorization`.
  final AuthToken authToken;

  @override
  Map<String, dynamic> toJson() => {
    'auth_token': authToken,
  };
}