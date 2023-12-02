import 'dart:math';
import 'dart:typed_data';

// import 'package:crypto_dart/crypto_dart.dart';
import 'package:crypto_dart/src/helpers/array_copy.dart';
import 'package:crypto_dart/src/utils.dart';
import 'package:pointycastle/export.dart';
import 'enc.dart';
import 'padding/padding.dart' as pad;
import 'cipher_options.dart';
import 'cipher_params.dart';
import 'crypto_dart.dart';
import 'mode.dart';
import 'padding/zero_padding.dart';

//Mostly is copied from https://github.com/aniyomiorg/aniyomi-extensions/blob/master/lib/cryptoaes/src/main/java/eu/kanade/tachiyomi/lib/cryptoaes/CryptoAES.kt

class AES {
   final _enc = CryptoDart.enc;

  // ignore: constant_identifier_names
  static const _KEY_SIZE = 32; // 256 bits
  // ignore: constant_identifier_names
  static const _IV_SIZE = 16; // 128 bits
  // ignore: constant_identifier_names
  static const _SALT_SIZE = 8; // 64
  // ignore: constant_identifier_names
  static const _KDF_DIGEST = 'MD5';
  // static const _SHA_DIGEST = 'SHA-512';

  // Seriously crypto-js, what's wrong with you?
  // ignore: constant_identifier_names
  static const String _APPEND = "Salted__";

  ///  Encrypt using CryptoJS defaults compatible method.
  ///  Uses KDF equivalent to OpenSSL's EVP_BytesToKey function if key is String it assumes it as a password passphrase
  ///
  ///  http://stackoverflow.com/a/29152379/4405051
  ///  @param cipherText base64 encoded ciphertext
  ///  @param password passphrase
  ///
  ///  Otherwise it can also to normal Encrypt if
  ///  @param key
  ///  @param cipherText
  ///  @param iv
  ///  are all in bytes format

  CipherParams encrypt<A, B, C>(C? plainText, A? key,
      {B? iv, CipherOptions? options}) {
    areParamsVaild(plainText, key, iv: iv, options: options);

    final Uint8List encrypted;

    final Uint8List ctbytes = _getPlaintText(plainText, _enc.utf8);

    // ignore: no_leading_underscores_for_local_identifiers
    final Uint8List _key;
    // ignore: no_leading_underscores_for_local_identifiers
    final Uint8List _iv;

    final mode = options?.mode ?? Mode.cbc;
    final paddingUsed = options?.padding ?? pad.Padding.PKCS7;
    final padding = _getPadding(paddingUsed);
    final Uint8List? salt;
    if (key is String && options?.keyEncoding == null) {
      salt = _getSalt(options?.salt ?? _generateSalt(_SALT_SIZE));
      final keyAndIV = CryptoDart.generateKeyAndIV(
        password: _enc.utf8.parse(key),
        keySize: _KEY_SIZE,
        ivSize: _IV_SIZE,
        salt: salt,
        hashAlgorithm: _KDF_DIGEST,
        iterations: 1,
      );

      _key = keyAndIV[0];
      _iv = keyAndIV[1];

      final cipherText = _runAes(
          forEncryption: true,
          key: _key,
          iv: _iv,
          plaintext: ctbytes,
          mode: mode,
          padding: padding);

      var sbytes = _enc.utf8.parse(_APPEND);
      var b = Uint8List(_IV_SIZE + cipherText.length);

      arrayCopy(sbytes, 0, b, 0, sbytes.length);
      arrayCopy(salt, 0, b, _SALT_SIZE, _SALT_SIZE);
      arrayCopy(cipherText, 0, b, 16, cipherText.length);

      encrypted = b;
    } else {
      _key = _getKey(key, options?.keyEncoding);

      _iv = _getIV(iv ?? options?.iv, options?.ivEncoding);
      salt = null;
      encrypted = _runAes(
          forEncryption: true,
          iv: _iv,
          key: _key,
          mode: mode,
          padding: padding,
          plaintext: ctbytes);
    }

    return CipherParams(
      cipherText: encrypted,
      iv: _iv,
      key: _key,
      mode: mode,
      padding: paddingUsed,
      salt: salt,
    );
  }

  ///  Decrypt using CryptoJS defaults compatible method.
  ///  Uses KDF equivalent to OpenSSL's EVP_BytesToKey function if key is String it assumes it as a password passphrase
  ///
  ///  http://stackoverflow.com/a/29152379/4405051
  ///  @param cipherText base64 encoded ciphertext
  ///  @param password passphrase
  ///
  ///  Otherwise it can also to normal Encrypt if
  ///  @param key
  ///  @param cipherText
  ///  @param iv
  ///  are all in bytes format

  Uint8List decrypt<A, B, C>(C? ciphertext, A? key,
      {B? iv, CipherOptions? options}) {
    areParamsVaild(ciphertext, key, iv: iv, options: options);
    final Uint8List decrypted;
    final mode = options?.mode ?? Mode.cbc;
    final paddingused = options?.padding ?? pad.Padding.PKCS7;
    final padding = _getPadding(paddingused);

    // ignore: no_leading_underscores_for_local_identifiers
    final Uint8List _key;

    // ignore: no_leading_underscores_for_local_identifiers
    final Uint8List _iv;

    Uint8List? saltbytes;
    if (options?.salt != null) {
      if (options!.salt is String) {
        saltbytes =
            getEncoder(options.saltEncoding ?? 'hex').parse(options.salt);
      } else {
        saltbytes = _getSalt(options.salt);
      }
    }

    if ( // ((ciphertext ?? options?.cipherText) is Uint8List &&
        //       ((ciphertext ?? options?.cipherText) as Uint8List)
        //           .join('')
        //           .startsWith(utf8.encode(_APPEND).join(''))) ||

        key is String && options?.keyEncoding == null) {
      var ctBytes = _enc.base64.parse(ciphertext as String);
      final cipherTextBytes =
          saltbytes == null ? ctBytes.sublist(_IV_SIZE) : ctBytes;
      saltbytes ??= ctBytes.sublist(_SALT_SIZE, _IV_SIZE);
      final keyAndIV = CryptoDart.generateKeyAndIV(
        password: _enc.utf8.parse(key),
        keySize: _KEY_SIZE,
        ivSize: _IV_SIZE,
        hashAlgorithm: _KDF_DIGEST,
        salt: saltbytes,
        iterations: 1,
      );
      _key = keyAndIV[0];
      _iv = keyAndIV[1];
      decrypted = _runAes(
          key: _key,
          iv: _iv,
          plaintext: cipherTextBytes,
          mode: mode,
          forEncryption: false,
          padding: padding);
    } else {
      _iv = _getIV(iv ?? options?.iv, options?.ivEncoding);
      _key = _getKey(key, options?.keyEncoding);
      saltbytes = null;
      decrypted = _runAes(
        key: _key,
        iv: _iv,
        plaintext: _getCipherText(ciphertext, options?.textEncoding),
        mode: mode,
        forEncryption: false,
        padding: padding,
      );
    }

    return decrypted;
  }

  Uint8List _getCipherText<T>(T cipherText, [String? encoding]) {
    if (cipherText is List<int>) {
      return Uint8List.fromList(cipherText);
    } else if (cipherText is Uint8List) {
      return cipherText;
    } else if (cipherText is String && encoding != null) {
      return getEncoder(encoding).parse(cipherText);
    } else {
      throw _invailedParams(cipherText);
    }
  }

  Uint8List _getSalt<T>(T salt) {
    Uint8List checkLen(Uint8List bytes) {
      if (bytes.length < _SALT_SIZE) {
        return Uint8List.fromList(
            [...bytes, ..._generateSalt(_SALT_SIZE - bytes.length)]);
      }
      return bytes;
    }

    if (salt is Uint8List) {
      return checkLen(salt);
    } else if (salt is List<int>) {
      return checkLen(Uint8List.fromList(salt));
    } else {
      throw _invailedParams(salt);
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

  Padding _getPadding(pad.Padding padding) {
    switch (padding) {
      case pad.Padding.ZEROPADDING:
        return ZeroPadding();
      case pad.Padding.PKCS7:
        return PKCS7Padding();
      default:
        return PKCS7Padding();
    }
  }


  Uint8List _getKey<T>(T key, [String? encoding]) {
    if (key is String && encoding != null) {
      return getEncoder(encoding).parse(key);
    }
    if (key is Uint8List) {
      return key;
    } else if (key is List<int>) {
      return Uint8List.fromList(key);
    } else {
      throw _invailedParams(key);
    }
  }

  Uint8List _getIV<T>(T? iv, [String? encoding]) {
    if (iv == null) return Uint8List(16);
    if (iv is String && encoding != null) {
      return getEncoder(encoding).parse(iv);
    }

    // ignore: no_leading_underscores_for_local_identifiers
    final Uint8List _iv;
    if (iv is List<int>) {
      _iv = Uint8List.fromList(iv);
    } else if (iv is String) {
      _iv = _enc.utf8.parse(iv);
    } else if (iv is Uint8List) {
      _iv = iv;
    } else {
      throw _invailedParams(iv);
    }
    if (_iv.length < 16) {
      return _generateIV(_iv);
    }
    return _iv;
  }

  Uint8List _generateIV(Uint8List bytes) {
    final iv = [...bytes];
    for (var i = iv.length; i < _IV_SIZE; i++) {
      iv.add(0);
    }
    return Uint8List.fromList(iv);
  }

  Uint8List _getPlaintText<T>(T plainText, [Encoder? encoding]) {
    if (plainText is String) {
      return encoding?.parse(plainText) ?? _decodeString(plainText, 'base64');
    } else if (plainText is List<int>) {
      return Uint8List.fromList(plainText);
    } else if (plainText is Uint8List) {
      return plainText;
    }
    throw _invailedParams(plainText);
  }

  Uint8List _decodeString(String str, String encoding) {
    try {
      if (encoding == 'base64') {
        return _enc.base64.parse(str);
      } else if (encoding == 'hex') {
        return _enc.base64.parse(str);
      } else {
        throw ArgumentError();
      }
    } catch (_) {
      return Uint8List.fromList(str.codeUnits);
    }
  }

  ArgumentError _invailedParams<T>(T element) {
    return ArgumentError(
        'Excepted a String or List<int> or Uint8List but recevied $element');
  }





  static Uint8List _runAes(
      {required Uint8List key,
      required Uint8List iv,
      required Uint8List plaintext,
      required Mode mode,
      required bool forEncryption,
      required Padding padding}) {
    final BlockCipher cipher;
    final BlockCipher underlyingchiper;
    if (mode == Mode.cbc) {
      underlyingchiper = BlockCipher('AES/CBC');
    } else if (mode == Mode.ecb) {
      underlyingchiper =
          BlockCipher('AES/EBC'); // ..init(true, KeyParameter(key));
    } else {
      throw ArgumentError('Invaild Mode $mode');
    }

    cipher = PaddedBlockCipherImpl(padding, underlyingchiper);

    ParametersWithIV<KeyParameter> params =
        ParametersWithIV<KeyParameter>(KeyParameter(key), iv);
    PaddedBlockCipherParameters<ParametersWithIV<KeyParameter>, KeyParameter>
        paddingParams = PaddedBlockCipherParameters<
            ParametersWithIV<KeyParameter>, KeyParameter>(params, null);

    cipher.init(forEncryption, paddingParams);

    return cipher.process(plaintext);
  }

  void areParamsVaild<A, B, C>(C? cipherText, A? key,
      {B? iv, CipherOptions? options}) {
    assert(cipherText != null && key != null);

    if (iv != null && options?.iv != null) {
      throw ArgumentError('IV is defined two times');
    }
  }
}
