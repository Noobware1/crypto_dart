// ignore_for_file: non_constant_identifier_names

import 'dart:typed_data';

import 'package:crypto_dart/src/encoders/utf8.dart';
import 'package:pointycastle/api.dart';

class EvpKDFResult {
  final Uint8List key;
  final Uint8List iv;

  EvpKDFResult(this.key, this.iv);

  @override
  String toString() {
    return 'EvpKDFResult{key: $key, iv: $iv}';
  }
}

/// Generates a key and an initialization vector (IV) with the given salt and password.
///
/// https://stackoverflow.com/a/41434590
/// This method is equivalent to OpenSSL's EVP_BytesToKey function
/// (see https://github.com/openssl/openssl/blob/master/crypto/evp/evp_key.c).
/// By default, OpenSSL uses a single iteration, MD5 as the algorithm and UTF-8 encoded password data.
///
/// * keyLength the length of the generated key (in bytes)
/// * ivLength the length of the generated IV (in bytes)
/// * iterations the number of digestion rounds
/// * salt the salt data (8 bytes of data or `null`)
/// * password the password data (optional)
/// * md the message digest algorithm to use
///
/// returns an two-element array with the generated key and IV
EvpKDFResult EvpKDF({
  required dynamic password,
  required Uint8List salt,
  int keySize = 4,
  int ivSize = 0,
  int iterations = 1,
  String hasher = 'MD5',
}) {
  final _password = password is! Uint8List ? UTF8().parse(password) : password;

  Digest digest = Digest(hasher);

  final digestLength = digest.digestSize;
  final int requiredLength =
      (keySize + ivSize + digestLength - 1) ~/ digestLength * digestLength;
  final generatedData = Uint8List(requiredLength);
  var generatedLength = 0;

  digest.reset();

  // Repeat process until sufficient data has been generated
  while (generatedLength < keySize + ivSize) {
    // Digest data (last digest if available, password data, salt if available)
    if (generatedLength > 0) {
      digest.update(
          generatedData, generatedLength - digestLength, digestLength);
    }
    digest.update(_password, 0, _password.length);
    digest.update(salt, 0, salt.length);
    digest.doFinal(generatedData, generatedLength);

    // additional rounds
    for (var i = 1; i < iterations; i++) {
      digest.update(generatedData, 0, generatedData.length);
      digest.doFinal(generatedData, generatedLength);
    }
    generatedLength += digestLength;
  }

  return EvpKDFResult(
    Uint8List.sublistView(generatedData, 0, keySize),
    ivSize > 0
        ? Uint8List.sublistView(generatedData, keySize, keySize + ivSize)
        : Uint8List(0),
  );
}
