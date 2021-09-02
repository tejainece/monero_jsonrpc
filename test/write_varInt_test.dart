import 'package:ninja/ninja.dart';

import 'package:monero_jsonrpc/src/util/write_varint.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

class TestCase {
  final int input;
  final String output;
  TestCase({required this.input, required this.output});

  void perform() {
    final actual = encodeVarInt(input);
    final expected = BigInt.parse(output).asBytes();
    expect(actual, expected);
  }
}

void main() {
  group('util', () {
    test('writeVarInt', () {
      TestCase(input: 0x2040, output: '0xc040').perform();
      TestCase(input: 0x204012345678, output: '0xf8acd191818808').perform();
    });
  });
}
