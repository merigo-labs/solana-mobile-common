/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_mobile_common/models/serialisable.dart';


/// Identity
/// ------------------------------------------------------------------------------------------------

class Identity extends Serialisable {

  /// The dApp's identity information. 
  /// 
  /// Wallet enpoints use the `[uri]` to verify the dApp and decide whether or not to extend trust 
  /// to it based on the attested web domain.
  /// 
  /// Identity verification on `Android` relies on 
  /// [Digital Asset Links](https://developers.google.com/digital-asset-links/v1/getting-started) to 
  /// associate apps with a web domain.
  /// 
  /// ```
  /// final identity = Identity(
  ///   uri: Uri.parse('https://myDApp.com'), 
  ///   icon: Uri.parse('favicon.ico'), 
  ///   name: 'My DApp', 
  /// );
  /// ```
  const Identity({
    this.uri,
    this.icon,
    this.name,
  });

  /// A URI representing the web address associated with the dApp endpoint making this authorization 
  /// request. If present, it must be an absolute, hierarchical URI.
  final Uri? uri;

  /// A relative path from [uri] to an image asset file of an icon identifying the dApp endpoint 
  /// making the authorization request.
  final Uri? icon;

  /// The display name of the dApp making the authorization request.
  final String? name;
  
  @override
  Map<String, dynamic> toJson() => {
    'uri': uri?.toString(),
    'icon': icon?.toString(),
    'name': name,
  };
}