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
  final String _keyEncoding;

  PBKDF2(
      {required this.digest,
      required this.iterations,
      required this.blockLength,
      required this.keylength,
      required this.salt,
      String? keyEncoding,
      required this.key})
      : _keyEncoding = keyEncoding ?? 'utf8';

  Uint8List deriveKey() {
    final pbkdf2 = PBKDF2KeyDerivator(HMac(Digest(digest), blockLength));
    pbkdf2.init(Pbkdf2Parameters(salt, iterations, keylength));
    final derivedKey = pbkdf2.process(getEncoder(_keyEncoding).parse(key));
    return derivedKey;
  }
}
// // keySize: 128/32,
// //           hasher: SHA256,
// //           iterations: 250000

// class PBKFDeriveKey {
//   final String digest;
//   final int iterations;
//   final int keySize;
//   final Uint8List salt;
//   final String key;
//   final int blockLength;
//   final String _keyEncoding;


//   PBKFDeriveKey(
//       {required this.digest,
//       required this.iterations,
//       required this.blockLength,
//       required this.keySize,
//       required this.salt,
//       String? keyEncoding,
//       required this.key})
//       : _keyEncoding = keyEncoding ?? 'utf8';

//   Uint8List _deriveKey() {
//     final keySize = this.keySize * 32;
// // SHA224Digest
//     final pbkdf2 = PBKDF2KeyDerivator(HMac(Digest(digest), keySize));

//     pbkdf2.init(Pbkdf2Parameters(salt, iterations, keySize));

//     final derivedKey = pbkdf2.process(getEncoder(_keyEncoding).parse(key));

//     return derivedKey;
//   }
// }
