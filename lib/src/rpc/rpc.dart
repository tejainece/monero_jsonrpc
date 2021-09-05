import 'dart:convert';
import 'dart:io';

import 'package:json_rpc_client/json_rpc_client.dart';
import 'package:monero_jsonrpc/src/rpc/model/block.dart';
import 'package:monero_jsonrpc/src/rpc/model/transaction.dart';

class XMRRPC {
  final JRPCHttpClient client;
  XMRRPC(this.client);

  Future<BigInt> getBlockCount() async {
    final resp = await client.callRPCv2(
        JRPC2Request(id: client.nextId, method: 'get_block_count'),
        pathSuffix: '/json_rpc');
    if (resp.error != null) {
      throw resp.error!;
    }
    return BigInt.from((resp.result as Map)['count']);
  }

  Future<Block> getBlockByHeight(BigInt height) async {
    final resp = await client.callRPCv2(
        JRPC2Request(
            id: client.nextId,
            method: 'get_block',
            params: {'height': height.toString()}),
        pathSuffix: '/json_rpc');
    if (resp.error != null) {
      throw resp.error!;
    }
    // print(resp.result);
    return Block.fromMap(resp.result as Map);
  }

  Future<GetTransactionResponse> getTransactions(List<String> txHashes,
      {bool decodeAsJson = false, bool prune = false}) async {
    final uri = client.uri.replace(path: client.uri.path + '/get_transactions');
    final body = <String, dynamic>{
      'txs_hashes': txHashes,
    };
    if (decodeAsJson) {
      body['decode_as_json'] = true;
    }
    if (prune) {
      body['prune'] = true;
    }
    final resp = await client.client.post(uri,
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(body));
    if (resp.statusCode != 200) {
      throw resp;
    }
    final json = jsonDecode(resp.body);
    if (json['status'] != 'OK') {
      throw Exception('invalid status: ${json['status']}');
    }
    // print(json);
    return GetTransactionResponse.fromMap(json);
  }
}

abstract class RPCUri {
  static final testnet = Uri.parse('http://monero-testnet.exan.tech:28081');
  static final stagenet = Uri.parse('http://monero-stagenet.exan.tech:38081');
  static final localStagenet = Uri.parse('http://localhost:38081');
  static final localTestnet = Uri.parse('http://localhost:28081');
  static final localMainnet = Uri.parse('http://localhost:18081');
}
