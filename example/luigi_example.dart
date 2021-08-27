import 'dart:typed_data';

import 'package:ninja/ninja.dart';
import 'package:ninja_ed25519/ninja_ed25519.dart' hide PrivateKey, PublicKey;
import 'package:ninja_ed25519/curve.dart';
import 'package:monero_jsonrpc/monero_jsonrpc.dart';

BigInt scalar(String hex) {
  return BigInt.parse(hex, radix: 16)
      .asBytes(outLen: 32, endian: Endian.little)
      .asBigInt();
}

void step1() {
  final AStr =
      '6bb8297dc3b54407ac78ffa4efa4afbe5f1806e5e41aa56ae98c2fe53032bb4b';
  final A = Point25519.fromHex(AStr);

  final rStr =
      'c91ae3053f640fcad393fb6c74ad9f064c25314c8993c5545306154e070b1f0f';
  final r = scalar(rStr);
  final D = A.multiplyScalar(r);
  print(D.asCompressedHex);
  print(D.multiplyScalar(BigInt.from(8)).asCompressedHex);
  // a1d198629fadc698b48f33dc2e280301679ab2c75a76974fd185ba66ab8418cc
  print('----------');
}

void step2() {
  final RStr =
      '396fc23bc389046b214087a9522c0fbd673d2f3f00ab9768f35fa52f953fef22';
  final R = Point25519.fromHex(RStr);

  final aStr =
      'fadf3558b700b88936113be1e5342245bd68a6b1deeb496000c4148ad4b61f02';
  final a = scalar(aStr);
  final D = R.multiplyScalar(a);
  print(D.asCompressedHex);
  // a1d198629fadc698b48f33dc2e280301679ab2c75a76974fd185ba66ab8418cc
  print('----------');
}

void address() {
  final prvKey = PrivateKey.fromSpendHex(
      'c595161ea20ccd8c692947c2d3ced471e9b13a18b150c881232794e8042bf107');
  print(prvKey.privateSpendKey.keyAsHex);
  print(prvKey.privateViewKey.keyAsHex);
  print(prvKey.publicSpendKeyHex);
  print(prvKey.publicViewKeyHex);
  print('----------');
}

void computeR() {
  final rStr =
      'c91ae3053f640fcad393fb6c74ad9f064c25314c8993c5545306154e070b1f0f';
  final r = scalar(rStr);
  final R = Curve25519.G.multiplyScalar(r);
  print(R.asCompressedHex);
  print('----------');
}

void computeR2() {
  final rStr =
      'c91ae3053f640fcad393fb6c74ad9f064c25314c8993c5545306154e070b1f0f';
  final r = scalar(rStr);
  final GStr =
      '5866666666666666666666666666666666666666666666666666666666666666';
  final G = Point25519.fromHex(GStr);
  final R = G.multiplyScalar(r);
  print(R.asCompressedHex);
  print('----------');
}

void main() {
  address();
  computeR();
  computeR2();
  step1();
  step2();
  // TODO
}
