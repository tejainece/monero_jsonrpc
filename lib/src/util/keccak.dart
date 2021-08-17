import 'dart:typed_data';

import 'package:sha3/sha3.dart';

List<int> keccak256(Uint8List bytes) => (SHA3(256, KECCAK_PADDING, 256)
      ..update(bytes)
      ..finalize())
    .digest();
