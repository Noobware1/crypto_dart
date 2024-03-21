import 'dart:typed_data';
import 'package:crypto_dart/crypto_dart.dart' as crypto show CryptoDart;
import 'package:crypto_dart/src/block_ciphers/utils.dart';
import 'package:crypto_dart/src/helpers/array_copy.dart';
import 'package:crypto_dart/src/mode.dart';
import 'package:crypto_dart/src/utils.dart';
import 'package:pointycastle/export.dart';
import 'package:crypto_dart/src/block_ciphers/block_cipher.dart' as cipher;
import 'package:crypto_dart/src/cipher_options.dart';
import 'package:crypto_dart/src/cipher_params.dart';
import 'package:crypto_dart/src/padding/padding.dart' as pad;

class TripleDES extends cipher.BlockCipher {
  static const _KEY_SIZE = 24; // 256 bits
  static const _IV_SIZE = 16; // 128 bits
  static const _SALT_SIZE = 8; // 64
  static const _KDF_DIGEST = 'MD5';

  static const String _APPEND = "Salted__";

  @override
  CipherParams encrypt<Text, Key>(Text? plainText, Key? key,
      {CipherOptions? options}) {
    areParamsVaild(plainText, key);
    final Uint8List encrypted;

    final Uint8List ctbytes = getPlaintText(plainText, enc.Utf8);

    final Uint8List _key;

    final Uint8List _iv;

    final mode = options?.mode ?? Mode.CBC;
    final paddingUsed = options?.padding ?? pad.Padding.PKCS7;
    final padding = getPadding(paddingUsed);
    final Uint8List? salt;
    if (key is String && options?.keyEncoding == null) {
      salt = getSalt(options?.salt ?? generateSalt(_SALT_SIZE), _SALT_SIZE);
      final keyAndIV = crypto.CryptoDart.EvpKDF(
        password: enc.Utf8.parse(key),
        keySize: _KEY_SIZE,
        ivSize: _IV_SIZE,
        salt: salt,
        hasher: _KDF_DIGEST,
        iterations: 1,
      );

      _key = keyAndIV.key;
      _iv = keyAndIV.iv;

      final cipherText = _runTripleDes(
          forEncryption: true,
          key: _key,
          iv: _iv,
          plaintext: ctbytes,
          mode: mode,
          padding: padding);

      var sbytes = enc.Utf8.parse(_APPEND);
      var b = Uint8List(_IV_SIZE + cipherText.length);

      arrayCopy(sbytes, 0, b, 0, sbytes.length);
      arrayCopy(salt, 0, b, _SALT_SIZE, _SALT_SIZE);
      arrayCopy(cipherText, 0, b, 16, cipherText.length);

      encrypted = b;
    } else {
      _key = getKey(key, options?.keyEncoding);

      _iv = getIV(options?.iv, _IV_SIZE, options?.ivEncoding);
      salt = null;
      encrypted = _runTripleDes(
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

  @override
  Uint8List decrypt<Text, Key>(Text? ciphertext, Key? key,
      {CipherOptions? options}) {
    areParamsVaild(ciphertext, key, options: options);
    final Uint8List decrypted;
    final mode = options?.mode ?? Mode.CBC;
    final paddingused = options?.padding ?? pad.Padding.PKCS7;
    final padding = getPadding(paddingused);

    final Uint8List _key;

    final Uint8List _iv;

    Uint8List? saltbytes;
    if (options?.salt != null) {
      if (options!.salt is String) {
        saltbytes =
            getEncoder(options.saltEncoding ?? 'hex').parse(options.salt);
      } else {
        saltbytes = getSalt(options.salt, _SALT_SIZE);
      }
    }

    if (key is String && options?.keyEncoding == null) {
      var ctBytes = enc.Base64.parse(ciphertext as String);
      final cipherTextBytes =
          saltbytes == null ? ctBytes.sublist(_IV_SIZE) : ctBytes;
      saltbytes ??= ctBytes.sublist(_SALT_SIZE, _IV_SIZE);
      final keyAndIV = crypto.CryptoDart.EvpKDF(
        password: enc.Utf8.parse(key),
        keySize: _KEY_SIZE,
        ivSize: _IV_SIZE,
        hasher: _KDF_DIGEST,
        salt: saltbytes,
        iterations: 1,
      );
      _key = keyAndIV.key;
      _iv = keyAndIV.iv;
      decrypted = _runTripleDes(
          key: _key,
          iv: _iv,
          plaintext: cipherTextBytes,
          mode: mode,
          forEncryption: false,
          padding: padding);
    } else {
      _iv = getIV(options?.iv, _IV_SIZE, options?.ivEncoding);
      _key = getKey(key, options?.keyEncoding);
      saltbytes = null;
      decrypted = _runTripleDes(
        key: _key,
        iv: _iv,
        plaintext: getCipherText(ciphertext, options?.textEncoding),
        mode: mode,
        forEncryption: false,
        padding: padding,
      );
    }

    return decrypted;
  }

  Uint8List _runTripleDes(
      {required Uint8List key,
      required Uint8List iv,
      required Uint8List plaintext,
      required Mode mode,
      required bool forEncryption,
      required Padding padding}) {
    final BlockCipher cipher;
    final BlockCipher underlyingchiper;
    if (mode == Mode.CBC) {
      underlyingchiper = BlockCipher('DESede');
    } else if (mode == Mode.ECB) {
      underlyingchiper = BlockCipher('DESede');
    } else {
      throw ArgumentError('Invaild Mode $mode');
    }

    ParametersWithIV<KeyParameter> params =
        ParametersWithIV<KeyParameter>(KeyParameter(key), iv);

    underlyingchiper.init(forEncryption, KeyParameter(key));

    cipher = PaddedBlockCipherImpl(padding, underlyingchiper);

    PaddedBlockCipherParameters<ParametersWithIV<KeyParameter>, KeyParameter>
        paddingParams = PaddedBlockCipherParameters<
            ParametersWithIV<KeyParameter>, KeyParameter>(params, null);

    cipher.init(forEncryption, paddingParams);

    return cipher.process(plaintext);
  }
}
