import 'package:crypto_dart/crypto_dart.dart';

void main() {
  // Encrypt and decrypt data using AES
  final key = 'ThisIsASecretKey';
  final plainText = 'Hello, World!';
  final encryptedText = CryptoDart.AES.encrypt(plainText, key);
  final decryptedText = CryptoDart.AES
      .decrypt(encryptedText, key)
      .convertToString(CryptoDart.enc.Utf8);
  print('Encrypted Text: $encryptedText');
  print('Decrypted Text: $decryptedText');
}
