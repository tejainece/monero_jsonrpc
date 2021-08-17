import 'dart:typed_data';

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
        extra: map['extra'],
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
