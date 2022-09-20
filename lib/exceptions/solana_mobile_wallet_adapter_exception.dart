/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_mobile_common/exceptions/solana_mobile_exception.dart';


/// Solana Mobile Wallet Adapter Exception Codes
/// ------------------------------------------------------------------------------------------------

enum SolanaMobileWalletAdapterExceptionCode {
  forbiddenWalletBaseUri,
  secureContextRequired,
  sessionClosed,
  sessionKeypair,
  walletNotFound,
  remoteConnectCancelled,
  ;
}


/// Solana Mobile Wallet Adapter Exception
/// ------------------------------------------------------------------------------------------------

typedef SolanaMobileWalletAdapterException 
  = SolanaMobileException<SolanaMobileWalletAdapterExceptionCode>;