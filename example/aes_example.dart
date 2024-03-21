import 'package:crypto_dart/crypto_dart.dart';

void main(List<String> args) {
  // Encrypt
  var ciphertext =
      CryptoDart.AES.encrypt('my message', 'secret key 123').toString();

  // Decrypt
  var bytes = CryptoDart.AES.decrypt(ciphertext, 'secret key 123');
  var originalText = bytes.convertToString(CryptoDart.enc.Utf8);

  print(originalText);
}
