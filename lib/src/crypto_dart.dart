// ignore_for_file: non_constant_identifier_names

import 'dart:typed_data';


import 'package:crypto_dart/src/hash_algorithms.dart';

import 'aes.dart' as aes;
import 'encoders.dart';
import 'generate_key_and_iv.dart' as key_and_iv_gen;
import 'pbkdf2.dart' as pbkdf2;

class CryptoDart {
  static Encoders enc = Encoders();

  static aes.AES AES = aes.AES();

  Uint8List PBKDF2(
      {String digest = HashAlgorithms.SHA1,
      required int iterations,
      int blockLength = 128,
      int keylength = 16,
      String? keyEncoding,
      required Uint8List salt,
      required String key}) {
    return pbkdf2
        .PBKDF2(
            iterations: iterations,
            salt: salt,
            key: key,
            blockLength: blockLength,
            digest: digest,
            keyEncoding: keyEncoding,
            keylength: keylength)
        .deriveKey();
  }

  static List<Uint8List> generateKeyAndIV({
    required Uint8List password,
    required int keySize,
    required int ivSize,
    required Uint8List salt,
    required int iterations,
    required String hashAlgorithm,
  }) =>
      key_and_iv_gen.generateKeyAndIV(
          password: password,
          keySize: keySize,
          ivSize: ivSize,
          salt: salt,
          iterations: iterations,
          hashAlgorithm: hashAlgorithm);
}
