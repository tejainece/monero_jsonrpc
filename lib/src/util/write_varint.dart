import 'dart:typed_data';

Uint8List encodeVarInt(int value) {
  int length = (value.bitLength / 7).ceil();
  if(length == 0) {
    length = 1;
  }
  final ret = Uint8List(length);
  for (int i = 0; i < length - 1; i++) {
    ret[i] = 0x80 | value & 0x7F;
    value >>= 7;
  }
  ret.last = value;
  return ret;
}
