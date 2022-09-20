/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter_test/flutter_test.dart';
import 'package:solana_mobile_common/config/cluster.dart';


/// Solana Mobile Common Tests
/// ------------------------------------------------------------------------------------------------

void main() {
  test('cluster', () {
    assert(Cluster.custom().name == null);
    assert(Cluster.devnet.name == 'devnet');
    assert(Cluster.testnet.name == 'testnet');
    assert(Cluster.mainnet.name == 'mainnet-beta');
  });
}
