import 'dart:math';
import 'dart:typed_data';

import 'package:crypto_dart/src/crypto_dart.dart';
import 'package:crypto_dart/src/enc.dart';
import 'package:crypto_dart/src/encoders.dart';
import 'package:crypto_dart/src/padding/zero_padding.dart';
import 'package:crypto_dart/src/utils.dart';
import 'package:crypto_dart/src/padding/padding.dart';
import 'package:crypto_dart/src/block_ciphers/block_cipher.dart';
import 'package:pointycastle/export.dart' as pointycastle;

extension BlockCipherUtils on BlockCipher {
  Encoders get enc => CryptoDart.enc;

  static const KEY_SIZE = 24; // 256 bits
  static const IV_SIZE = 16; // 128 bits
  static const SALT_SIZE = 8; // 64
  static const KDF_DIGEST = 'MD5';

  static const String APPEND = "Salted__";

  Uint8List getSalt<T>(T salt) {
    Uint8List checkLen(Uint8List bytes) {
      if (bytes.length < SALT_SIZE) {
        return Uint8List.fromList(
            [...bytes, ..._generateSalt(SALT_SIZE - bytes.length)]);
      }
      return bytes;
    }

    if (salt is Uint8List) {
      return checkLen(salt);
    } else if (salt is List<int>) {
      return checkLen(Uint8List.fromList(salt));
    } else {
      throw invailedParams(salt);
    }
  }

  Uint8List _generateSalt(int length) {
    final random = Random.secure();

    final salt = <int>[];
    for (var i = 0; i < length; i++) {
      salt.add(random.nextInt(256)); // Generate a random byte value (0-255)
    }

    return Uint8List.fromList(salt);
  }

  pointycastle.Padding getPadding(Padding padding) {
    switch (padding) {
      case Padding.ZEROPADDING:
        return ZeroPadding();
      case Padding.PKCS5:
      case Padding.PKCS7:
      default:
        return pointycastle.PKCS7Padding();
    }
  }

  Uint8List getKey<T>(T key, [String? encoding]) {
    if (key is String && encoding != null) {
      return getEncoder(encoding).parse(key);
    }
    if (key is Uint8List) {
      return key;
    } else if (key is List<int>) {
      return Uint8List.fromList(key);
    } else {
      throw invailedParams(key);
    }
  }

  Uint8List getIV<T>(T? iv, [String? encoding]) {
    if (iv == null) return Uint8List(16);
    if (iv is String && encoding != null) {
      return getEncoder(encoding).parse(iv);
    }

    final Uint8List $iv;
    if (iv is List<int>) {
      $iv = Uint8List.fromList(iv);
    } else if (iv is String) {
      $iv = enc.UTF8.parse(iv);
    } else if (iv is Uint8List) {
      $iv = iv;
    } else {
      throw invailedParams(iv);
    }
    if ($iv.length < 16) {
      return generateIV($iv);
    }
    return $iv;
  }

  Uint8List generateIV(Uint8List bytes) {
    final iv = [...bytes];
    for (var i = iv.length; i < IV_SIZE; i++) {
      iv.add(0);
    }
    return Uint8List.fromList(iv);
  }

  Uint8List getPlaintText<T>(T plainText, [Encoder? encoding]) {
    if (plainText is String) {
      return encoding?.parse(plainText) ?? _decodeString(plainText, 'base64');
    } else if (plainText is List<int>) {
      return Uint8List.fromList(plainText);
    } else if (plainText is Uint8List) {
      return plainText;
    }
    throw invailedParams(plainText);
  }

  Uint8List getCipherText<Text>(Text cipherText, [String? encoding]) {
    if (cipherText is List<int>) {
      return Uint8List.fromList(cipherText);
    } else if (cipherText is Uint8List) {
      return cipherText;
    } else if (cipherText is String && encoding != null) {
      return getEncoder(encoding).parse(cipherText);
    } else {
      throw invailedParams(cipherText);
    }
  }

  Uint8List _decodeString(String str, String encoding) {
    try {
      switch (encoding) {
        case 'base64':
          return enc.BASE64.parse(str);
        case 'hex':
          return enc.HEX.parse(str);
        default:
          throw ArgumentError.value(encoding, 'encoding', 'Invalid encoding');
      }
    } catch (_) {
      return Uint8List.fromList(str.codeUnits);
    }
  }

  ArgumentError invailedParams<T>(T element) {
    return ArgumentError(
        'Excepted a String or List<int> or Uint8List but recevied $element');
  }
}
