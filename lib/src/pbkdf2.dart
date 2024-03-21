import 'dart:typed_data';

import 'package:crypto_dart/encoders.dart';
import 'package:pointycastle/export.dart';

/// This function generates a cryptographic password using the PBKDF2 (Password-Based Key Derivation Function 2) algorithm.
///
/// * hasher The hash function to use. Default is 'SHA256'.
/// * iterations The number of iterations to perform. Default is 250000.
/// * keySize The size of the password to generate. Default is 4.
/// * salt The salt to use in the PBKDF2 algorithm. This is a required parameter.
/// * keyEncoding The encoding of the password. Default is 'utf8'.
/// * blockLength The length of the block to use in the HMAC. This is a required parameter.
/// * password The password to derive the password from. This is a required parameter.
///
/// * returns [Uint8List] The derived password.
Uint8List PBKDF2({
  required Uint8List salt,
  required dynamic password,
  String hasher = 'SHA256',
  int iterations = 250000,
  int keySize = 4,
  int? blockLength,
}) {
  final Uint8List _password =
      password is! Uint8List ? UTF8().parse(password) : password;

  final digest = Digest(hasher);

  final pbkdf2 =
      PBKDF2KeyDerivator(HMac(digest, blockLength ?? digest.digestSize * 4));

  pbkdf2.init(Pbkdf2Parameters(salt, iterations, keySize * 8));

  final derivedKey = pbkdf2.process(_password);

  return derivedKey;
}
