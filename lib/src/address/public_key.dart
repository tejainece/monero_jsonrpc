import 'dart:math';
import 'dart:typed_data';

import 'package:monero_jsonrpc/src/util/keccak.dart';
import 'package:ninja_ed25519/ninja_ed25519.dart' as ed25519;
import 'package:bs58check/bs58check.dart';

class PublicKey {
  final ed25519.PublicKey publicSpendKey;
  final ed25519.PublicKey publicViewKey;

  PublicKey(this.publicSpendKey, this.publicViewKey);

  String get publicSpendKeyHex => publicSpendKey.asHex;
  String get publicViewKeyHex => publicViewKey.asHex;

  String getAddress({Network network = Network.mainnet}) {
    final bytes = Uint8List(69);
    bytes[0] = network.networkByte;
    bytes.setRange(1, 33, publicSpendKey.bytes);
    bytes.setRange(33, 65, publicViewKey.bytes);
    final List<int> hashed = keccak256(bytes.sublist(0, 65));
    bytes.setRange(65, 69, hashed);
    final sb = StringBuffer();
    for (int i = 0; i < 69; i = i + 8) {
      final block = bytes.sublist(i, min(i + 8, 69));
      final blockStr = base58.encode(block).padRight(i + 8 < 69 ? 11 : 7, '1');
      sb.write(blockStr);
    }
    return sb.toString();
  }
}

class Network {
  final String name;
  final int networkByte;
  const Network({required this.name, required this.networkByte});

  static const mainnet = Network(name: 'mainnet', networkByte: 0x12);
  static const stagenet = Network(name: 'stagenet', networkByte: 0x35);
  static const testnet = Network(name: 'testnet', networkByte: 0x18);
}
