/// Imports
/// ------------------------------------------------------------------------------------------------

import '../models/authorize_result.dart';
import '../models/clone_authorization_result.dart';
import '../models/deauthorize_result.dart';
import '../models/get_capabilities_result.dart';
import '../models/sign_and_send_transactions_config.dart';
import '../models/sign_and_send_transactions_result.dart';
import '../models/sign_messages_result.dart';
import '../models/sign_transactions_result.dart';
import '../utils/types.dart';


/// JSON RPC Wallet Adapter
/// ------------------------------------------------------------------------------------------------

abstract class JsonRpcWalletAdapter {

  /// This method allows the dApp endpoint to request authorization from the wallet endpoint for 
  /// access to `privileged methods`. On success, it returns an [AuthorizeResult.authToken] 
  /// providing access to privileged methods, along with addresses and optional labels for all 
  /// authorized accounts. It may also return a URI suitable for future use as an 
  /// `endpoint-specific URI`. After a successful call to [authorize], the current session will be 
  /// placed into an authorized state, with privileges associated with the returned 
  /// [AuthorizeResult.authToken]. On failure, the current session with be placed into the 
  /// unauthorized state.
  /// 
  /// This [AuthorizeResult.authToken] may be used to [reauthorize] future sessions between the 
  /// dApp and wallet endpoint.
  Future<AuthorizeResult> authorize();

  /// Revokes the dApp's authroization from the wallet endpoint.
  Future<DeauthorizeResult> deauthorize();

  /// Requests dApp reauthorization with the wallet endpoint to put the current session in an 
  /// authorized state.
  Future<AuthorizeResult> reauthorize();

  /// Requests dApp `reauthorization/authorization` based on the current state.
  Future<AuthorizeResult> reauthorizeOrAuthorize();

  /// Gets the limits of a wallet endpoint’s implementation of the specification. It returns whether 
  /// optional specification features are supported, as well as any implementation-specific limits.
  Future<GetCapabilitiesResult> getCapabilities();

  /// Invokes the wallet endpoint to simulate the transactions provided by [payloads] and present 
  /// them to the user for approval (if applicable). If approved (or if it does not require 
  /// approval), the wallet endpoint should sign the transactions with the private keys for the 
  /// requested authorized account addresses, and return the signed transactions to the dapp 
  /// endpoint.
  Future<SignTransactionsResult> signTransactions(
    final List<Base64EncodedTransaction> payloads,
  );

  /// `Implementation of this method by a wallet endpoint is optional.`
  /// 
  /// Invokes the wallet endpoint to simulate the transactions provided by [payloads] and present 
  /// them to the user for approval (if applicable). If approved (or if it does not require 
  /// approval), the wallet endpoint should verify the transactions, sign them with the private keys 
  /// for the authorized addresses, submit them to the network, and return the transaction 
  /// signatures to the dapp endpoint.
  /// 
  /// The [config] object allows customization of how the wallet endpoint processes the transactions 
  /// it sends to the Solana network. If specified, [SignAndSendTransactionsConfig.minContextSlot] 
  /// specifies the minimum slot number that the transactions should be evaluated at. This allows 
  /// the wallet endpoint to wait for its network RPC node to reach the same point in time as the 
  /// node used by the dApp endpoint, ensuring that, e.g., the recent blockhash encoded in the 
  /// transactions will be available.
  Future<SignAndSendTransactionsResult> signAndSendTransactions(
    final List<Base64EncodedTransaction> payloads, {
    final SignAndSendTransactionsConfig? config,
  });

  /// Invokes the wallet endpoint to present the provided messages to the user for approval. If 
  /// approved, the wallet endpoint should sign the messages with the private key for the authorized 
  /// account address, and return the signed messages to the dApp endpoint. 
  /// 
  /// The signatures should be appended to the message, in the same order as addresses.
  Future<SignMessagesResult> signMessages({
    required final List<Base64EncodedTransaction> payloads,
    required final List<Base64EncodedAddress> addresses,
  });

  /// `Implementation of this method by a wallet endpoint is optional.`
  /// 
  /// Attempts to clone the session’s currently active authorization in a form suitable for sharing 
  /// with another instance of the dApp endpoint, possibly running on a different system. Whether or 
  /// not the wallet endpoint supports cloning an auth_token is an implementation detail. If this 
  /// method succeeds, it will return an auth token appropriate for sharing with another instance of 
  /// the same dApp endpoint.
  Future<CloneAuthorizationResult> cloneAuthorization();
}