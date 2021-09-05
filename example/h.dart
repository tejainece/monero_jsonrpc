import 'dart:typed_data';

import 'package:ninja/ninja.dart';

import 'package:monero_jsonrpc/src/util/keccak.dart';
import 'package:ninja_ed25519/curve.dart';

void main() {
  // 8b655970153799af2aeadc9ff1add0ea6c7251d54154cfa92c173a0dd39c1f94
  final H = Point25519.fromBytes(keccak256(Curve25519.G.asBytes))
      .multiplyScalar(BigInt.from(8));
  print(H.asCompressedHex(outLen: 64, endian: Endian.big));
  print(H.asCompressedHex(outLen: 64, endian: Endian.big));
}
