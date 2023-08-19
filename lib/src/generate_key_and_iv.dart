 import 'dart:typed_data';

import 'package:pointycastle/api.dart';

/// Generates a key and an initialization vector (IV) with the given salt and password.
  ///
  /// https://stackoverflow.com/a/41434590
  /// This method is equivalent to OpenSSL's EVP_BytesToKey function
  /// (see https://github.com/openssl/openssl/blob/master/crypto/evp/evp_key.c).
  /// By default, OpenSSL uses a single iteration, MD5 as the algorithm and UTF-8 encoded password data.
  ///
  /// @param keyLength the length of the generated key (in bytes)
  /// @param ivLength the length of the generated IV (in bytes)
  /// @param iterations the number of digestion rounds
  /// @param salt the salt data (8 bytes of data or `null`)
  /// @param password the password data (optional)
  /// @param md the message digest algorithm to use
  /// @return an two-element array with the generated key and IV
   List<Uint8List> generateKeyAndIV({
    required Uint8List password,
    required int keySize,
    required int ivSize,
    required Uint8List salt,
    required int iterations,
    required String hashAlgorithm,
  }) {
    Digest md = Digest(hashAlgorithm);

    final digestLength = md.digestSize;
    final int requiredLength =
        (keySize + ivSize + digestLength - 1) ~/ digestLength * digestLength;
    final generatedData = Uint8List(requiredLength);
    var generatedLength = 0;

    md.reset();

    // Repeat process until sufficient data has been generated
    while (generatedLength < keySize + ivSize) {
      // Digest data (last digest if available, password data, salt if available)
      if (generatedLength > 0) {
        md.update(generatedData, generatedLength - digestLength, digestLength);
      }
      md.update(password, 0, password.length);
      md.update(salt, 0, salt.length);
      md.doFinal(generatedData, generatedLength);

      // additional rounds
      for (var i = 1; i < iterations; i++) {
        md.update(generatedData, 0, generatedData.length);
        md.doFinal(generatedData, generatedLength);
      }
      generatedLength += digestLength;
    }

    // Copy key and IV into separate byte arrays
    final result = <Uint8List>[
      Uint8List.sublistView(generatedData, 0, keySize)
    ];
    if (ivSize > 0) {
      result
          .add(Uint8List.sublistView(generatedData, keySize, keySize + ivSize));
    }
    return result;
  }

 