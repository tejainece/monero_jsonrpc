import 'dart:typed_data';
import 'package:monero_jsonrpc/src/util/write_varint.dart';
import 'package:ninja/ninja.dart';

import 'package:monero_jsonrpc/src/address/public_key.dart';
import 'package:monero_jsonrpc/src/util/keccak.dart';
import 'package:ninja_ed25519/curve.dart';
import 'package:ninja_ed25519/ninja_ed25519.dart' as ed25519;

export 'public_key.dart';

class PrivateKey {
  final ed25519.Scalar privateSpendKey;
  final ed25519.Scalar privateViewKey;
  late PublicKey publicKey = PublicKey(
      ed25519.PublicKey(privateSpendKey.multiplyBase().asBytes),
      ed25519.PublicKey(privateViewKey.multiplyBase().asBytes));

  factory PrivateKey.fromSpendHex(String spendHex) {
    final spendKey =
        ed25519.Scalar.fromString(spendHex, radix: 16, endian: Endian.big);
    final viewKey = ed25519.Scalar(hashAndToScalar(spendKey.toBytes()));
    return PrivateKey(spendKey, viewKey);
  }

  PrivateKey(this.privateSpendKey, this.privateViewKey);
  factory PrivateKey.fromHexes(String spendKeyStr, String viewKeyStr) {
    final spendKey =
        ed25519.Scalar.fromString(spendKeyStr, radix: 16, endian: Endian.big);
    final viewKey =
        ed25519.Scalar.fromString(viewKeyStr, radix: 16, endian: Endian.big);
    return PrivateKey(spendKey, viewKey);
  }

  ed25519.PublicKey get publicSpendKey => privateSpendKey.toPublicKey();
  ed25519.PublicKey get publicViewKey => privateViewKey.toPublicKey();

  String get privateSpendKeyHex =>
      privateSpendKey.toHex(outLen: 64, endian: Endian.big);
  String get privateViewKeyHex =>
      privateViewKey.toHex(outLen: 64, endian: Endian.big);
  String get publicSpendKeyHex => publicSpendKey.asHex;
  String get publicViewKeyHex => publicViewKey.asHex;

  String getAddress({Network network = Network.mainnet}) =>
      publicKey.getAddress(network: network);

  /// = Hs(8aR||i)
  BigInt computeTxSharedSecretFromTxPubKey(Point25519 R, int outputIndex) {
    final Di = R
        .multiplyScalar(privateViewKey.value)
        .multiplyScalar(BigInt.from(8));
    final fiPreHash = Uint8List.fromList(
        Di.asBytes.toList()..addAll(encodeVarInt(outputIndex)));
    return hashAndToScalar(fiPreHash);
  }

  bool isVoutSentToMe(Point25519 R, int outputIndex, String voutAddress) {
    final fi = computeTxSharedSecretFromTxPubKey(R, outputIndex);
    final Fi = curve25519.scalarMultiplyBase(fi);
    final Pi = Fi + publicSpendKey.asPoint;
    final PiHex = Pi.asCompressedHex(endian: Endian.big);
    return PiHex == voutAddress;
  }

  /// https://monero.stackexchange.com/questions/11272/where-is-the-encrypted-mask-value
  /// https://github.com/monero-project/monero/commit/7d375981584e5ddac4ea6ad8879e2211d465b79d
  /// https://monero.stackexchange.com/questions/12139/calculate-the-output-amount-using-mininero
  /// amount = amountT XOR keccak256("amount" || Hs(8aR||i))
  BigInt decodeAmount(Point25519 R, int outputIndex, List<int> commitment) {
    final fi = computeTxSharedSecretFromTxPubKey(R, outputIndex);
    final unmasked = 'amount'.codeUnits.toList()
      ..addAll(fi.asBytes(outLen: 32, endian: Endian.little));
    final uh = keccak256(Uint8List.fromList(unmasked));
    final ret = xor8(commitment, uh);
    print(ret.toHex());
    return ret.asBigInt(endian: Endian.little);
  }

  /// amountT = amount XOR keccak256("amount" || Hs(8aR||i))
  String encodeAmountUsingTxPubKey(
      Point25519 R, int outputIndex, BigInt amount) {
    final fi = computeTxSharedSecretFromTxPubKey(R, outputIndex);
    final unmasked = 'amount'.codeUnits.toList()
      ..addAll(fi.asBytes(outLen: 32, endian: Endian.little));
    final uh = keccak256(Uint8List.fromList(unmasked));
    final ret =
        xor8(amount.asBytes(outLen: 8, endian: Endian.little), uh.toList());
    return ret.toHex();
  }
}

BigInt scReduce32(BigInt input) {
  return input % Curve25519.l;
}

List<int> xor8(List<int> a, List<int> b) {
  if (a.length < 8) {
    throw ArgumentError.value(a, 'a', 'should have at least 8 bytes');
  }
  if (b.length < 8) {
    throw ArgumentError.value(b, 'b', 'should have at least 8 bytes');
  }
  final ret = List<int>.filled(8, 0);
  for (int i = 0; i < 8; i++) {
    ret[i] = a[i] ^ b[i];
  }
  return ret;
}

BigInt hashAndToScalar(Uint8List input) {
  final fiBytes = keccak256(input);
  return scReduce32(fiBytes.asBigInt(endian: Endian.little));
}
