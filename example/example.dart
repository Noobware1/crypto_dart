import 'package:crypto_dart/crypto_dart.dart';
import 'package:crypto_dart/hashers.dart';

void main(List<String> args) {
  // two ways to use this libary
  // 1. use the static methods
  var ciphertext = CryptoDart.MD5('my message').toString();

  print(ciphertext);

  // 2. create instance
  ciphertext = MD5('my message').toString();

  print(ciphertext);
}
