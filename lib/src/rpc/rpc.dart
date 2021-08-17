import 'package:json_rpc_client/json_rpc_client.dart';
import 'package:monero_jsonrpc/src/rpc/model/block.dart';

class XMRRPC {
  final JRPCClient client;
  XMRRPC(this.client);

  Future<BigInt> getBlockCount() async {
    final resp = await client
        .callRPCv2(JRPC2Request(id: client.nextId, method: 'get_block_count'));
    if (resp.error != null) {
      throw resp.error!;
    }
    return BigInt.from((resp.result as Map)['count']);
  }

  Future<Block> getBlockByHeight(BigInt height) async {
    // get_block
    final resp = await client.callRPCv2(JRPC2Request(
        id: client.nextId,
        method: 'get_block',
        params: {'height': height.toString()}));
    if (resp.error != null) {
      throw resp.error!;
    }
    print(resp.result);
    return Block.fromMap(resp.result as Map);
  }
}
