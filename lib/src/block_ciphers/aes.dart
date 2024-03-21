import 'dart:typed_data';

import 'package:crypto_dart/src/block_ciphers/block_cipher.dart'
    as block_cipher;
import 'package:crypto_dart/src/block_ciphers/utils.dart';
import 'package:crypto_dart/src/helpers/array_copy.dart';
import 'package:crypto_dart/src/utils.dart';
import 'package:pointycastle/export.dart';
import 'package:crypto_dart/src/padding/padding.dart' as pad;
import 'package:crypto_dart/src/cipher_options.dart';
import 'package:crypto_dart/src/cipher_params.dart';
import 'package:crypto_dart/src/crypto_dart.dart';
import 'package:crypto_dart/src/mode.dart';

class AES extends block_cipher.BlockCipher {
  @override
  CipherParams encrypt<Text, Key>(Text? plainText, Key? key,
      {CipherOptions? options}) {
    assert(plainText != null && key != null);

    areParamsVaild(plainText, key, options: options);

    final Uint8List encrypted;

    final Uint8List ctbytes = getPlaintText(plainText, enc.UTF8);

    final Uint8List _key;
    final Uint8List _iv;

    final mode = options?.mode ?? Mode.CBC;
    final paddingUsed = options?.padding ?? pad.Padding.PKCS7;
    final padding = getPadding(paddingUsed);
    final Uint8List? salt;
    if (key is String && options?.keyEncoding == null) {
      salt = getSalt(options?.salt ?? _generateSalt(SALT_SIZE));
      final keyAndIV = CryptoDart.EvpKDF(
        password: enc.UTF8.parse(key),
        keySize: KEY_SIZE,
        ivSize: IV_SIZE,
        salt: salt,
        hasher: KDF_DIGEST,
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

      var sbytes = enc.UTF8.parse(APPEND);
      var b = Uint8List(IV_SIZE + cipherText.length);

      arrayCopy(sbytes, 0, b, 0, sbytes.length);
      arrayCopy(salt, 0, b, SALT_SIZE, SALT_SIZE);
      arrayCopy(cipherText, 0, b, 16, cipherText.length);

      encrypted = b;
    } else {
      _key = getKey(key, options?.keyEncoding);

      _iv = getIV(options?.iv, options?.ivEncoding);
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
        saltbytes = getSalt(options.salt);
      }
    }

    if (key is String && options?.keyEncoding == null) {
      var ctBytes = enc.BASE64.parse(ciphertext as String);
      final cipherTextBytes =
          saltbytes == null ? ctBytes.sublist(IV_SIZE) : ctBytes;
      saltbytes ??= ctBytes.sublist(SALT_SIZE, IV_SIZE);
      final keyAndIV = CryptoDart.EvpKDF(
        password: enc.UTF8.parse(key),
        keySize: KEY_SIZE,
        ivSize: IV_SIZE,
        hasher: KDF_DIGEST,
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
      _iv = getIV(options?.iv, options?.ivEncoding);
      _key = getKey(key, options?.keyEncoding);
      saltbytes = null;
      decrypted = _runAes(
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

  static Uint8List _runAes({
    required Uint8List key,
    required Uint8List iv,
    required Uint8List plaintext,
    required Mode mode,
    required bool forEncryption,
    required Padding padding,
  }) {
    final BlockCipher cipher;
    final BlockCipher underlyingchiper;
    if (mode == Mode.CBC) {
      underlyingchiper = BlockCipher('AES/CBC');
    } else if (mode == Mode.ECB) {
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
}
