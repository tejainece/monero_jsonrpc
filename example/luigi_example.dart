import 'dart:typed_data';

import 'package:ninja/ninja.dart';
import 'package:ninja_ed25519/curve.dart';
import 'package:monero_jsonrpc/monero_jsonrpc.dart';

void step1() {
  final AStr =
      '6bb8297dc3b54407ac78ffa4efa4afbe5f1806e5e41aa56ae98c2fe53032bb4b';
  final A = Point25519.fromHex(AStr);

  final rStr =
      'c91ae3053f640fcad393fb6c74ad9f064c25314c8993c5545306154e070b1f0f';
  final r = Scalar.fromString(rStr, radix: 16, endian: Endian.big).value;
  final D = A.multiplyScalar(r).multiplyScalar(BigInt.from(8));
  print(D.asCompressedHex(endian: Endian.big));
  // a1d198629fadc698b48f33dc2e280301679ab2c75a76974fd185ba66ab8418cc
  print('----------');
}

void step2() {
  final RStr =
      '396fc23bc389046b214087a9522c0fbd673d2f3f00ab9768f35fa52f953fef22';
  final R = Point25519.fromHex(RStr);

  final aStr =
      'fadf3558b700b88936113be1e5342245bd68a6b1deeb496000c4148ad4b61f02';
  final a = Scalar.fromString(aStr, radix: 16, endian: Endian.big).value;
  // final a = scalar(aStr);
  final D = R.multiplyScalar(a).multiplyScalar(BigInt.from(8));
  print(D.asCompressedHex(endian: Endian.big));
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
  final r = Scalar.fromString(rStr, radix: 16, endian: Endian.big).value;
  final R = curve25519.scalarMultiplyBase(r);
  print(R.asCompressedHex(endian: Endian.big));
  print('----------');
}

void main() {
  address();
  computeR();
  step1();
  step2();
  // TODO
}
