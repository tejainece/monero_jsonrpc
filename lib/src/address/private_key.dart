import 'dart:typed_data';
import 'package:monero_jsonrpc/src/util/write_varint.dart';
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

  bool isMyVout(Point25519 R, int outputIndex, String voutAddress) {
    final Di = R
        .multiplyScalar(privateViewKey.keyAsBigInt)
        .multiplyScalar(BigInt.from(8));
    final fiPreHash = Uint8List.fromList(
        Di.asBytes.toList()..addAll(encodeVarInt(outputIndex)));
    final fiBytes = keccak256(fiPreHash);
    final fi = scReduce32(fiBytes.asBigInt(endian: Endian.little));
    final Fi = curve25519.scalarMultiplyBase(fi);
    final Pi = Fi + publicSpendKey.asPoint;
    final PiHex = Pi.asCompressedHex(endian: Endian.big);
    return PiHex == voutAddress;
  }

  /// https://monero.stackexchange.com/questions/11272/where-is-the-encrypted-mask-value
  /// https://github.com/monero-project/monero/commit/7d375981584e5ddac4ea6ad8879e2211d465b79d
  ///
  BigInt getAmount(Point25519 R, int outputIndex, List<int> commitment) {
    final Di = R
        .multiplyScalar(privateViewKey.keyAsBigInt)
        .multiplyScalar(BigInt.from(8));
    final fiPreHash = Uint8List.fromList(
        Di.asBytes.toList()..addAll(encodeVarInt(outputIndex)));
    final fiBytes = keccak256(fiPreHash);
    final unmasked = 'amount'.codeUnits.toList()..addAll(fiBytes);
    final uh = keccak256(Uint8List.fromList(unmasked));
    final ret = xor8(commitment, uh);
    print(ret.toHex());
    return ret.asBigInt();
  }
}

BigInt scReduce32(BigInt input) {
  return input % Curve25519.l;
}

List<int> xor8(List<int> a, List<int> b) {
  if(a.length < 8) {
    throw ArgumentError.value(a, 'a', 'should have at least 8 bytes');
  }
  if(b.length < 8) {
    throw ArgumentError.value(b, 'b', 'should have at least 8 bytes');
  }
  final ret = List<int>.filled(8, 0);
  for(int i = 0; i < 8; i++) {
    ret[i] = a[i] ^ b[i];
  }
  return ret;
}
