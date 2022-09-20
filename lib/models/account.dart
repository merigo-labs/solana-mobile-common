/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_mobile_common/models/serialisable.dart';
import '../utils/types.dart';


/// Account
/// ------------------------------------------------------------------------------------------------

class Account extends Serialisable {

  /// Wallet account.
  /// 
  /// ```
  /// final account = Account(
  ///   address: 'BQU8XcxOALDAs5yEFghOD61XYpKNty/MMsCqmSiN0QM=',
  ///   label: 'Wallet 1'
  /// );
  /// ```
  const Account({
    required this.address,
    required this.label,
  });
  
  /// The base-64 encoded address of this account.
  final Base64EncodedAddress address;

  /// A human-readable string that describes this account.
  final String? label;

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// Account.fromJson({ '<parameter>': <value> });
  /// ```
  factory Account.fromJson(final Map<String, dynamic> json) => Account(
    address: json['address'], 
    label: json['label'],
  );

  @override
  Map<String, dynamic> toJson() => {
    'address': address,
    'label': label
  };
}