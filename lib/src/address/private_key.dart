import 'package:monero_jsonrpc/src/address/public_key.dart';
import 'package:monero_jsonrpc/src/ed25519/private_key.dart' as ed25519;

class PrivateKey {
  final ed25519.PrivateKey privateSpendKey;
  final ed25519.PrivateKey privateViewKey;
  // TODO

  PrivateKey(this.privateSpendKey, this.privateViewKey);

  PublicKey toPublic() {
    return PublicKey(privateSpendKey.toPublic(), privateViewKey.toPublic());
  }

  String getPrivateSpendKey() {
    throw UnimplementedError();
  }

  String getPrivateViewKey() {
    throw UnimplementedError();
  }

  String getPublicSpendKey() {
    throw UnimplementedError();
  }

  String getPublicViewKey() {
    throw UnimplementedError();
  }

  String getAddress({Network network = Network.mainnet}) {
    throw UnimplementedError();
  }
}

class Network {
  final String name;
  final int networkByte;
  const Network({required this.name, required this.networkByte});

  static const mainnet = Network(name: 'mainnet', networkByte: 0);
  static const stagenet = Network(name: 'stagenet', networkByte: 0);
  static const testnet = Network(name: 'testnet', networkByte: 0);
}
