/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:convert';
import 'package:solana_mobile_common/models/serialisable.dart';
import 'package:solana_mobile_common/utils/convert.dart';
import '../exceptions/solana_mobile_wallet_adapter_exception.dart';
import '../models/account.dart';
import '../utils/types.dart';


/// Authorize Result
/// ------------------------------------------------------------------------------------------------

class AuthorizeResult extends Serialisable {

  /// The result of a successful `authorize` request containing the [accounts] authorized by the 
  /// wallet for use by the dApp. You can cache this and use it later to invoke privileged methods.
  const AuthorizeResult({
    required this.accounts,
    required this.authToken,
    required this.walletUriBase,
  });
  
  /// The accounts to which the [authToken] corresponds.
  final List<Account> accounts;

  /// An opaque string representing a unique identifying token issued by the wallet endpoint to the 
  /// dApp endpoint. The dApp endpoint can use this on future connections to reauthorize access to 
  /// privileged methods.
  final AuthToken authToken;

  /// The wallet endpoint's specific URI that should be used for subsequent connections where it 
  /// expects to use this [authToken].
  final Uri? walletUriBase;

  /// Throws a [SolanaMobileWalletAdapterException] if the provided [walletUriBase] is invalid.
  static void checkwalletUriBase(final Uri? walletUriBase) {
    if (walletUriBase != null && !walletUriBase.isScheme('HTTPS')) {
      throw const SolanaMobileWalletAdapterException(
        'The wallet base uri prefix must start with "https://"', 
        code: SolanaMobileWalletAdapterExceptionCode.forbiddenWalletBaseUri,
      );
    }
  }

  /// Creates a [walletUriBase] from the provided [uri].
  /// 
  /// Throws a [SolanaMobileWalletAdapterException] if the provided [uri] is invalid.
  static Uri? _parseWalletUriBase(final String? uri) {
    final Uri? uriPrefix = uri != null ? Uri.tryParse(uri) : null;
    checkwalletUriBase(uriPrefix);
    return uriPrefix;
  }

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// AuthorizeResult.fromJson({ '<parameter>': <value> });
  /// ```
  factory AuthorizeResult.fromJson(final Map<String, dynamic> json) => AuthorizeResult(
    accounts: list.decode(List.from(json['accounts']), Account.fromJson),
    authToken: json['auth_token'], 
    walletUriBase: _parseWalletUriBase(json['wallet_uri_base']),
  );

  /// Creates an instance of `this` class from the [jsonString].
  /// 
  /// ```
  /// AuthorizeResult.fromJsonString("{ '<parameter>': <value> }");
  /// ```
  factory AuthorizeResult.fromJsonString(final String jsonString)
    => AuthorizeResult.fromJson(json.decode(jsonString));

  @override 
  Map<String, dynamic> toJson() => {
    'accounts': list.encode(accounts),
    'auth_token': authToken,
    'wallet_uri_base': walletUriBase,
  };

  /// Serialises this class into a JSON string.
  String toJsonString() => json.encode(toJson());
}