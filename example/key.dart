import 'dart:typed_data';

import 'package:bs58check/bs58check.dart';
import 'package:monero_jsonrpc/src/address/private_key.dart';
import 'package:monero_jsonrpc/src/address/public_key.dart';

void main() {
  final key = PrivateKey.fromHexes('0b5bf4fe452fdf86ece44aeaa61d4a5460a1019c0f77a0f2b8d1e22ca1d82e07',
      'ec2e9de472bcc640959bf560144f2be389971ef82f09015ada673428529b9702');
  print(key.publicSpendKeyHex);
  print(key.publicViewKeyHex);
  final address = key.getAddress(network: Network.mainnet);
  print(address);
}