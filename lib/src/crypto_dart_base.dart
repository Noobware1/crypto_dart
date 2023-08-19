import 'dart:typed_data';

import 'aes.dart';
import 'digest_names.dart';
import 'encoders.dart';
import 'generate_key_and_iv.dart' as key_and_iv_gen;
import 'pbkdf2.dart';

class CryptoDart {
  Encoders get enc => Encoders();

  AES get aes => AES();

  DigestNames get digestNames => DigestNames();

  Uint8List pbkdf2(
      {String digest = 'SHA-1',
      required int iterations,
      int blockLength = 128,
      int keylength = 16,
      String? keyEncoding,
      required Uint8List salt,
      required String key}) {
    return PBKDF2(
            iterations: iterations,
            salt: salt,
            key: key,
            blockLength: blockLength,
            digest: digest,
            keyEncoding: keyEncoding,
            keylength: keylength)
        .deriveKey();
  }

  List<Uint8List> generateKeyAndIV({
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
