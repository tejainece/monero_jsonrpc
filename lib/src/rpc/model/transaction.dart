import 'dart:convert';
import 'dart:typed_data';

import 'package:monero_jsonrpc/src/rpc/model/model.dart';

class GetTransactionResponse {
  final String topHash;
  final List<TransactionDetails> txs;
  final List<String> txsAsHex;
  final List<Map> txAsJson;

  GetTransactionResponse(
      {required this.topHash,
      required this.txs,
      required this.txsAsHex,
      required this.txAsJson});

  static GetTransactionResponse fromMap(Map map) {
    return GetTransactionResponse(
      topHash: map['top_hash'],
      txs: TransactionDetails.fromList(map['txs'] as List),
      txsAsHex: (map['txs_as_hex'] as List).cast<String>(),
      txAsJson: (map['txs_as_json'] as List)
          .cast<String>()
          .map(jsonDecode)
          .cast<Map>()
          .toList(),
    );
  }
}

class TransactionDetails {
  final String asHex;
  final Transaction tx;
  final int blockHeight;
  final DateTime blockTimestamp;
  final bool doubleSpendSeen;
  final bool inPool;
  final List<int> outputIndices;
  final String prunableAsHex;
  final String prunableHash;
  final String prunedAsHex;
  final String txHash;

  TransactionDetails(
      {required this.asHex,
      required this.tx,
      required this.blockHeight,
      required this.blockTimestamp,
      required this.doubleSpendSeen,
      required this.inPool,
      required this.outputIndices,
      required this.prunableAsHex,
      required this.prunableHash,
      required this.prunedAsHex,
      required this.txHash});

  static TransactionDetails fromMap(Map map) => TransactionDetails(
        asHex: map['as_hex'],
        tx: Transaction.fromMap(jsonDecode(map['as_json'])),
        blockHeight: map['block_height'],
        blockTimestamp: fromTimestamp(map['block_timestamp']),
        doubleSpendSeen: map['double_spend_seen'],
        inPool: map['in_pool'],
        outputIndices: (map['output_indices'] as List).cast<int>(),
        prunableAsHex: map['prunable_as_hex'],
        prunableHash: map['prunable_hash'],
        prunedAsHex: map['pruned_as_hex'],
        txHash: map['tx_hash'],
      );

  static List<TransactionDetails> fromList(List list) =>
      list.cast<Map>().map(fromMap).toList();
}

class Transaction {
  final int version;
  final int unlockTime;
  // TODO vin
  final List<Vout> vouts;
  final Uint8List extra;
  // TODO signatures

  Transaction({
    required this.version,
    required this.unlockTime,
    required this.vouts,
    required this.extra,
  });

  Map<String, dynamic> toJson() => {
        'version': version,
        'unlock_time': unlockTime,
        // TODO vin
        'vout': vouts,
        'extra': extra,
      };

  static Transaction fromMap(Map map) => Transaction(
        version: map['version'],
        unlockTime: map['unlock_time'],
        vouts: Vout.fromList(map['vout'] as List),
        extra: Uint8List.fromList((map['extra'] as List).cast<int>()),
      );

  static List<Transaction> fromList(List list) =>
      list.cast<Map>().map(fromMap).toList();
}

class Vout {
  final int amount;
  final String key;
  Vout({required this.amount, required this.key});

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'target': {
          'key': key,
        },
      };

  static Vout fromMap(Map map) =>
      Vout(amount: map['amount'], key: map['target']['key']);

  static List<Vout> fromList(List list) =>
      list.cast<Map>().map(fromMap).toList();
}
