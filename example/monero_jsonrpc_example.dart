import 'package:json_rpc_client/json_rpc_client.dart';
import 'package:monero_jsonrpc/monero_jsonrpc.dart';

Future<void> main() async {
  final rpc = XMRRPC(JRPCHttpClient(Uri.parse('http://monero-stagenet.exan.tech:38081/json_rpc')));
  final height = await rpc.getBlockCount();
  print(height);
}
