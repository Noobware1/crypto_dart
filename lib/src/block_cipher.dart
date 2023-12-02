/// The `block_cipher.dart` file contains the definition of an abstract class `BlockCipher`.
/// This class provides a blueprint for block cipher encryption and decryption operations.

import 'dart:typed_data';
import 'package:crypto_dart/crypto_dart.dart';

/// `BlockCipher` is an abstract class that defines two methods: `encrypt` and `decrypt`.
abstract class BlockCipher {
  /// The `encrypt` method takes in plain text, a key, and optionally an initialization vector (iv) and cipher options.
  /// It returns a `CipherParams` object which contains the encrypted data.
  /// The method is generic and can work with any type of data for the plain text, key, and iv.
  CipherParams encrypt<Text, Key>(Text? plainText, Key? key,
      {CipherOptions? options});

  /// The `decrypt` method takes in cipher text, a key, and optionally an initialization vector (iv) and cipher options.
  /// It returns a `Uint8List` which contains the decrypted data.
  /// The method is generic and can work with any type of data for the cipher text, key, and iv.
  Uint8List decrypt<Text, Key>(Text? ciphertext, Key? key,
      {CipherOptions? options});

  void areParamsVaild<A, B, C>(C? cipherText, A? key,
      {CipherOptions? options}) {
    assert(cipherText != null && key != null);
  }
}
