import 'dart:typed_data';

import 'package:ninja/ninja.dart';
import 'package:ninja_ed25519/ninja_ed25519.dart';
import 'package:ninja_ed25519/curve.dart';
import 'package:monero_jsonrpc/monero_jsonrpc.dart';

void step1() {
  final AStr =
      '6bb8297dc3b54407ac78ffa4efa4afbe5f1806e5e41aa56ae98c2fe53032bb4b';
  final A = Point25519.fromHex(AStr);

  final rStr =
      'c91ae3053f640fcad393fb6c74ad9f064c25314c8993c5545306154e070b1f0f';
  final D = A.multiplyScalar(BigInt.parse(rStr, radix: 16)
      .asBytes(outLen: 32, endian: Endian.big)
      .asBigInt());
  print(D.asCompressedHex);
  // a1d198629fadc698b48f33dc2e280301679ab2c75a76974fd185ba66ab8418cc
}

void main() {
  step1();
  // TODO
}
