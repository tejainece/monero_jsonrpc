import 'dart:typed_data';

Uint8List writeVarInt(int value) {
  final length = (value.bitLength / 7).ceil();
  final ret = Uint8List(length);
  for (int i = 0; i < length - 1; i++) {
    ret[i] = 0x80 | value & 0x7F;
    value >>= 7;
  }
  ret.last = value;
  return ret;
}
