import 'dart:typed_data';

import 'package:crypto_dart/src/utils.dart';
import 'package:pointycastle/export.dart';

class PBKDF2 {
  final String digest;
  final int iterations;
  final int keylength;
  final Uint8List salt;
  final String key;
  final int blockLength;
  final String keyEncoding;

  PBKDF2(
      {required this.digest,
      required this.iterations,
      required this.blockLength,
      required this.keylength,
      required this.salt,
      this.keyEncoding = 'utf8',
      required this.key});

  Uint8List deriveKey() {
    final pbkdf2 = PBKDF2KeyDerivator(
      HMac(
        Digest(digest),
        128,
      ),
    );

    pbkdf2.init(Pbkdf2Parameters(salt, iterations, keylength));
    final derivedKey = pbkdf2.process(getEncoder(keyEncoding).parse(key));
    return derivedKey;
  }
}
