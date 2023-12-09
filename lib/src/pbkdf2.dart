import 'dart:typed_data';

import 'package:crypto_dart/src/utils.dart';
import 'package:pointycastle/export.dart';

Uint8List PBKDF2(
    {String hasher = 'SHA256',
    int iterations = 250000,
    int keySize = 4,
    required Uint8List salt,
    String keyEncoding = 'utf8',
    required String key}) {
  final digest = Digest(hasher);

  final pbkdf2 = PBKDF2KeyDerivator(HMac(digest, keySize * digest.digestSize));

  pbkdf2.init(Pbkdf2Parameters(salt, iterations, keySize * 8));

  final derivedKey = pbkdf2.process(getEncoder(keyEncoding).parse(key));

  return derivedKey;
}
