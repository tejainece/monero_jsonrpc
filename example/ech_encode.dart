import 'dart:typed_data';
import 'package:ninja/ninja.dart';

import 'package:monero_jsonrpc/monero_jsonrpc.dart';
import 'package:monero_jsonrpc/src/util/keccak.dart';
import 'package:monero_jsonrpc/src/util/write_varint.dart';
import 'package:ninja_ed25519/curve.dart';

void main() {
  final R = Point25519.fromHex(
      '6a61e8ddf530e303a63fa33ffb835ee29c7309b8b7011bef33f40372a067a752');
  final prvKey = PrivateKey.fromHexes(
      '96d54cd4f1d71e10a1eb76125aad65219cded6a987fd0b6cc1f758417b99d20c',
      '9468b7a83b937c0a438a802c841183401d690f18742cfea6b9096f865ef84e02');
  int outputIndex = 0;
  final amount = BigInt.parse('1000000000000', radix: 10)
      .asBytes(outLen: 8, endian: Endian.little);

  final Di = R
      .multiplyScalar(prvKey.privateViewKey.keyAsBigInt)
      .multiplyScalar(BigInt.from(8));
  final fiPreHash = Uint8List.fromList(
      Di.asBytes.toList()..addAll(encodeVarInt(outputIndex)));
  final fiBytes = keccak256(fiPreHash);
  final fi = scReduce32(fiBytes.asBigInt(endian: Endian.little));
  final unmasked = 'amount'.codeUnits.toList()
    ..addAll(fi.asBytes(outLen: 32, endian: Endian.little));
  final uh = keccak256(Uint8List.fromList(unmasked));
  final ret = xor8(amount, uh.toList());
  print(ret.toHex());
  // fd07426faae4a99f
}
