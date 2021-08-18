import 'dart:convert';

import 'package:json_rpc_client/json_rpc_client.dart';
import 'package:monero_jsonrpc/monero_jsonrpc.dart';

Future<void> main() async {
  final rpc = XMRRPC(JRPCHttpClient(RPCUri.stagenet));
  final height = (await rpc.getBlockCount()) - BigInt.from(10);
  print(height);
  final block = await rpc.getBlockByHeight(BigInt.from(901769));
  // print(jsonEncode(block.toJson()));
  final tx = await rpc.getTransactions(block.txHashes, decodeAsJson: true);
}
