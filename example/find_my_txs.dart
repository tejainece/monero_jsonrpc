import 'dart:convert';
import 'dart:typed_data';

import 'package:ninja/ninja.dart';
import 'package:ninja_hex/ninja_hex.dart';

import 'package:json_rpc_client/json_rpc_client.dart';
import 'package:monero_jsonrpc/monero_jsonrpc.dart';
import 'package:monero_jsonrpc/src/rpc/model/model.dart';

import 'package:ninja_ed25519/ninja_ed25519.dart' as ed25519;
import 'package:ninja_ed25519/curve.dart' as ed25519;

final key = PrivateKey.fromHexes(
    '96d54cd4f1d71e10a1eb76125aad65219cded6a987fd0b6cc1f758417b99d20c',
    '9468b7a83b937c0a438a802c841183401d690f18742cfea6b9096f865ef84e02');

Future<void> search(GetTransactionResponse txs) async {
  if (txs.txs.isEmpty) return;

  final txDet = txs.txs[0];
  final ed25519.Point25519 R = txDet.tx.getTxPublicKey()!;
  print('TX public key: ' + R.asCompressedHex(endian: Endian.big));
  for (int voutIndex = 0; voutIndex < txDet.tx.vouts.length; voutIndex++) {
    final addr = txDet.tx.vouts[voutIndex].key;
    print('Stealth address: ' + addr);

    if (key.isMyVout(R, voutIndex, addr)) {
      print('yes');
      final amount = key.getAmount(
          R,
          voutIndex,
          hexDecode(txDet.tx.rctSignatures.ecdhInfo[voutIndex].amount)
              .reversed
              .toList());
      print(amount);
    }
  }
}

Future<void> main() async {
  final rpc = XMRRPC(JRPCHttpClient(RPCUri.stagenet));
  final block = await rpc.getBlockByHeight(BigInt.from(896162));
  // print(jsonEncode(block.toJson()));
  final txs = await rpc.getTransactions(block.txHashes, decodeAsJson: true);
  await search(txs);
}
