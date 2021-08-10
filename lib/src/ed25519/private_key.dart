import 'dart:typed_data';

class PrivateKey {
  final Uint8List bytes;

  PrivateKey(this.bytes);

  PublicKey toPublic() {
    throw UnimplementedError();
  }
}

class PublicKey {
  final Uint8List bytes;

  PublicKey(this.bytes);
}