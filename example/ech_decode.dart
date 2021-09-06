import 'package:monero_jsonrpc/monero_jsonrpc.dart';
import 'package:ninja_ed25519/curve.dart';
import 'package:ninja_hex/ninja_hex.dart';

void main() {
  final R = Point25519.fromHex(
      '6a61e8ddf530e303a63fa33ffb835ee29c7309b8b7011bef33f40372a067a752');
  final prvKey = PrivateKey.fromHexes(
      '96d54cd4f1d71e10a1eb76125aad65219cded6a987fd0b6cc1f758417b99d20c',
      '9468b7a83b937c0a438a802c841183401d690f18742cfea6b9096f865ef84e02');
  int voutIndex = 0;
  final amountTStr = 'fd07426faae4a99f';
  print('amountT: $amountTStr');
  final amountT = hexDecode(amountTStr).reversed.toList();
  final amount = prvKey.getAmount(R, voutIndex, amountT);
  print(amount);
}
