import 'package:monero_jsonrpc/monero_jsonrpc.dart';
import 'package:ninja_ed25519/curve.dart';

void main() {
  final prvKey = PrivateKey.fromSpendHex(
      'c595161ea20ccd8c692947c2d3ced471e9b13a18b150c881232794e8042bf107');
  final RStr =
      '396fc23bc389046b214087a9522c0fbd673d2f3f00ab9768f35fa52f953fef22';
  final voutAddress =
      '6cabaac48d3b9043525a703e9e5feb72132f69ea6deca9b4acf9228beb74cd8f';
  final R = Point25519.fromHex(RStr);
  print(prvKey.isVoutSentToMe(R, 0, voutAddress));
}
