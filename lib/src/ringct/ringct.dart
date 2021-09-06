import 'package:ninja_ed25519/curve.dart';

/// H = 8 * point(keccak256(G))
/// 8b655970153799af2aeadc9ff1add0ea6c7251d54154cfa92c173a0dd39c1f94
final H = Point25519.fromHex(
    '8b655970153799af2aeadc9ff1add0ea6c7251d54154cfa92c173a0dd39c1f94');
