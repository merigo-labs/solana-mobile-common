/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_mobile_common/protocol/json_rpc_context_result.dart';
import 'package:solana_mobile_common/protocol/json_rpc_response.dart';


/// JSON RPC Context Response
/// ------------------------------------------------------------------------------------------------

typedef JsonRpcContextResponse<T> = JsonRpcResponse<JsonRpcContextResult<T>>;