import 'dart:typed_data';

import 'package:monero_jsonrpc/src/util/keccak.dart';
import 'package:monero_jsonrpc/src/util/write_varint.dart';
import 'package:ninja/ninja.dart';
import 'package:ninja_ed25519/curve.dart';
import 'package:monero_jsonrpc/monero_jsonrpc.dart';

final B = Point25519.fromHex('3bcb82eecc13739b463b386fc1ed991386a046b478bf4864673ca0a229c3cec1');

Point25519 computeD() {
  print('>>>>>> Compute D');
  final AStr =
      '6bb8297dc3b54407ac78ffa4efa4afbe5f1806e5e41aa56ae98c2fe53032bb4b';
  final A = Point25519.fromHex(AStr);

  final rStr =
      'c91ae3053f640fcad393fb6c74ad9f064c25314c8993c5545306154e070b1f0f';
  final r = Scalar.fromString(rStr, radix: 16, endian: Endian.big).value;
  final D = A.multiplyScalar(r).multiplyScalar(BigInt.from(8));
  print(D.asCompressedHex(endian: Endian.big));
  // a1d198629fadc698b48f33dc2e280301679ab2c75a76974fd185ba66ab8418cc
  return D;
}

void address() {
  print('>>>>>> Compute address');
  final prvKey = PrivateKey.fromSpendHex(
      'c595161ea20ccd8c692947c2d3ced471e9b13a18b150c881232794e8042bf107');
  print(prvKey.privateSpendKey.keyAsHex);
  print(prvKey.privateViewKey.keyAsHex);
  print(prvKey.publicSpendKeyHex);
  print(prvKey.publicViewKeyHex);
}

void computeR() {
  print('>>>>>> Compute R');
  final rStr =
      'c91ae3053f640fcad393fb6c74ad9f064c25314c8993c5545306154e070b1f0f';
  final r = Scalar.fromString(rStr, radix: 16, endian: Endian.big).value;
  final R = curve25519.scalarMultiplyBase(r);
  print(R.asCompressedHex(endian: Endian.big));
}

Point25519 computeF(Point25519 D, int outputIndex) {
  print('>>>>>> Compute F');
  final preHash =
      Uint8List.fromList(D.asBytes.toList()..addAll(encodeVarInt(outputIndex)));
  final bytes = keccak256(preHash);
  final f = scReduce32(bytes.asBigInt(endian: Endian.little));
  // bf1d230a09bfdb0bc7fe04cddf8c1635d0ebaaf159ef85dc408ae60879752509
  print(f.asBytes(outLen: 32, endian: Endian.little).toHex(outLen: 64));
  final F = curve25519.scalarMultiplyBase(f);
  // 3e4b39c5b5110d6fbdb77fbcd203709c19fefd28c982a86bda3f3d35fc099738
  print(F.asCompressedHex(endian: Endian.big));
  return F;
}

Point25519 computeP(Point25519 F, Point25519 B) {
  print('>>>>>> Compute P');
  final P = F + B;
  print(P.asCompressedHex(endian: Endian.big));
  return P;
}

void computeDt() {
  print('>>>>>> Compute Dt');
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
}

void main() {
  // Sign
  address();
  computeR();
  final D = computeD();
  final F = computeF(D, 0);
  final P = computeP(F, B);

  // Verify
  final Dt = computeDt();
  // TODO
}
