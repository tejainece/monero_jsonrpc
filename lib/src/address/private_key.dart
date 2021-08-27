import 'dart:typed_data';
import 'package:ninja/ninja.dart';

import 'package:monero_jsonrpc/src/address/public_key.dart';
import 'package:monero_jsonrpc/src/util/keccak.dart';
import 'package:ninja_ed25519/curve.dart';
import 'package:ninja_ed25519/ninja_ed25519.dart' as ed25519;

export 'public_key.dart';

class PrivateKey {
  final ed25519.PrivateKey privateSpendKey;
  final ed25519.PrivateKey privateViewKey;
  late PublicKey public =
      PublicKey(privateSpendKey.publicKey, privateViewKey.publicKey);

  factory PrivateKey.fromSpendHex(String spendHex) {
    final spendKey = ed25519.PrivateKey.fromHex(spendHex);
    final viewKey = ed25519.PrivateKey(
        scReduce32(keccak256(spendKey.keyBytes).asBigInt(endian: Endian.little))
            .asBytes(outLen: 32, endian: Endian.little));
    return PrivateKey(spendKey, viewKey);
  }

  PrivateKey(this.privateSpendKey, this.privateViewKey);
  factory PrivateKey.fromHexes(String spendKeyStr, String viewKeyStr) {
    final spendKey = ed25519.PrivateKey.fromHex(spendKeyStr);
    final viewKey = ed25519.PrivateKey.fromHex(viewKeyStr);
    return PrivateKey(spendKey, viewKey);
  }

  PublicKey get toPublic =>
      PublicKey(privateSpendKey.publicKey, privateViewKey.publicKey);

  ed25519.PublicKey get publicSpendKey => privateSpendKey.publicKey;
  ed25519.PublicKey get publicViewKey => privateViewKey.publicKey;

  String get privateSpendKeyHex => privateSpendKey.keyAsHex;
  String get privateViewKeyHex => privateViewKey.keyAsHex;
  String get publicSpendKeyHex => publicSpendKey.asHex;
  String get publicViewKeyHex => publicViewKey.asHex;

  String getAddress({Network network = Network.mainnet}) =>
      toPublic.getAddress(network: network);
}

BigInt scReduce32(BigInt input) {
  return input % Curve25519.l;
}
