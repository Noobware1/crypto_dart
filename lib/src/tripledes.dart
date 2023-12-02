// // ignore_for_file: constant_identifier_names, no_leading_underscores_for_local_identifiers

// import 'dart:math';
// import 'dart:typed_data';
// import 'package:crypto_dart/crypto_dart.dart' as crypto show CryptoDart;
// import 'package:crypto_dart/encoders.dart';
// import 'package:crypto_dart/src/enc.dart';
// import 'package:crypto_dart/src/mode.dart';
// import 'package:crypto_dart/src/padding/zero_padding.dart';
// import 'package:crypto_dart/src/utils.dart';
// import 'package:pointycastle/export.dart';
// import 'package:crypto_dart/src/block_cipher.dart' as cipher;
// import 'package:crypto_dart/src/cipher_options.dart';
// import 'package:crypto_dart/src/cipher_params.dart';
// import 'package:crypto_dart/src/padding/padding.dart' as pad;

// class TripleDES extends cipher.BlockCipher {
//   final _enc = crypto.CryptoDart.enc;

//   static const _KEY_SIZE = 32; // 256 bits
//   static const _IV_SIZE = 16; // 128 bits
//   static const _SALT_SIZE = 8; // 64
//   static const _KDF_DIGEST = 'MD5';

//   static const String _APPEND = "Salted__";

//   @override
//   Uint8List decrypt<Text, Key>(Text? ciphertext, Key? key,
//       {CipherOptions? options}) {
//     throw UnimplementedError();
//   }

//   @override
//   CipherParams encrypt<Text, Key>(Text? plainText, Key? key,
//       {CipherOptions? options}) {
//     areParamsVaild(plainText, key);
//     final Uint8List encrypted;

//     final Uint8List ctbytes = _getPlaintText(plainText, _enc.utf8);

//     final Uint8List _key;

//     final Uint8List _iv;

//     final mode = options?.mode ?? Mode.cbc;
//     final paddingUsed = options?.padding ?? pad.Padding.pkcs7;
//     final padding = _getPadding(paddingUsed);
//     final Uint8List? salt;
//     if (key is String && options?.keyEncoding == null) {
//       salt = _getSalt(options?.salt ?? _generateSalt(_SALT_SIZE));
//       final keyAndIV = crypto.CryptoDart.generateKeyAndIV(
//         password: _enc.utf8.parse(key),
//         keySize: _KEY_SIZE,
//         ivSize: _IV_SIZE,
//         salt: salt,
//         hashAlgorithm: _KDF_DIGEST,
//         iterations: 1,
//       );

//       _key = keyAndIV[0];
//       _iv = keyAndIV[1];

//       final cipherText = compute(
//           forEncryption: true,
//           key: _key,
//           iv: _iv,
//           plaintext: ctbytes,
//           mode: mode,
//           padding: padding);

//       var sbytes = _enc.utf8.parse(_APPEND);
//       var b = Uint8List(_IV_SIZE + cipherText.length);

//       arrayCopy(sbytes, 0, b, 0, sbytes.length);
//       arrayCopy(salt, 0, b, _SALT_SIZE, _SALT_SIZE);
//       arrayCopy(cipherText, 0, b, 16, cipherText.length);

//       encrypted = b;
//     } else {
//       _key = _getKey(key, options?.keyEncoding);

//       _iv = _getIV(options?.iv, options?.ivEncoding);
//       salt = null;
//       encrypted = compute(
//           forEncryption: true,
//           iv: _iv,
//           key: _key,
//           mode: mode,
//           padding: padding,
//           plaintext: ctbytes);
//     }

//     return CipherParams(
//       cipherText: encrypted,
//       iv: _iv,
//       key: _key,
//       mode: mode,
//       padding: paddingUsed,
//       salt: salt,
//     );
//   }

//   Uint8List _getCipherText<Text>(Text cipherText, [String? encoding]) {
//     if (cipherText is List<int>) {
//       return Uint8List.fromList(cipherText);
//     } else if (cipherText is Uint8List) {
//       return cipherText;
//     } else if (cipherText is String && encoding != null) {
//       return getEncoder(encoding).parse(cipherText);
//     } else {
//       throw _invailedParams(cipherText);
//     }
//   }

//   Uint8List _getSalt<T>(T salt) {
//     Uint8List checkLen(Uint8List bytes) {
//       if (bytes.length < _SALT_SIZE) {
//         return Uint8List.fromList(
//             [...bytes, ..._generateSalt(_SALT_SIZE - bytes.length)]);
//       }
//       return bytes;
//     }

//     if (salt is Uint8List) {
//       return checkLen(salt);
//     } else if (salt is List<int>) {
//       return checkLen(Uint8List.fromList(salt));
//     } else {
//       throw _invailedParams(salt);
//     }
//   }

//   Uint8List _generateSalt(int length) {
//     final random = Random.secure();

//     final salt = <int>[];
//     for (var i = 0; i < length; i++) {
//       salt.add(random.nextInt(256)); // Generate a random byte value (0-255)
//     }

//     return Uint8List.fromList(salt);
//   }

//   Padding _getPadding(pad.Padding padding) {
//     switch (padding) {
//       case pad.Padding.nopadding:
//         return ZeroPadding();
//       case pad.Padding.pkc5:
//         return PKCS7Padding();
//       default:
//         return PKCS7Padding();
//     }
//   }

//   Uint8List _getKey<Key>(Key key, [String? encoding]) {
//     if (key is String && encoding != null) {
//       return getEncoder(encoding).parse(key);
//     }
//     if (key is Uint8List) {
//       return key;
//     } else if (key is List<int>) {
//       return Uint8List.fromList(key);
//     } else {
//       throw _invailedParams(key);
//     }
//   }

//   Uint8List _getIV<T>(T? iv, [String? encoding]) {
//     if (iv == null) return Uint8List(16);
//     if (iv is String && encoding != null) {
//       return getEncoder(encoding).parse(iv);
//     }

//     // ignore: no_leading_underscores_for_local_identifiers
//     final Uint8List _iv;
//     if (iv is List<int>) {
//       _iv = Uint8List.fromList(iv);
//     } else if (iv is String) {
//       _iv = _enc.utf8.parse(iv);
//     } else if (iv is Uint8List) {
//       _iv = iv;
//     } else {
//       throw _invailedParams(iv);
//     }
//     if (_iv.length < 16) {
//       return _generateIV(_iv);
//     }
//     return _iv;
//   }

//   Uint8List _generateIV(Uint8List bytes) {
//     final iv = [...bytes];
//     for (var i = iv.length; i < _IV_SIZE; i++) {
//       iv.add(0);
//     }
//     return Uint8List.fromList(iv);
//   }

//   Uint8List _getPlaintText<Text>(Text plainText, [Encoder? encoding]) {
//     if (plainText is String) {
//       return encoding?.parse(plainText) ?? _decodeString(plainText, 'base64');
//     } else if (plainText is List<int>) {
//       return Uint8List.fromList(plainText);
//     } else if (plainText is Uint8List) {
//       return plainText;
//     }
//     throw _invailedParams(plainText);
//   }

//   Uint8List _decodeString(String str, String encoding) {
//     try {
//       if (encoding == 'base64') {
//         return _enc.base64.parse(str);
//       } else if (encoding == 'hex') {
//         return _enc.base64.parse(str);
//       } else {
//         throw ArgumentError();
//       }
//     } catch (_) {
//       return Uint8List.fromList(str.codeUnits);
//     }
//   }

//   ArgumentError _invailedParams<T>(T element) {
//     return ArgumentError(
//         'Excepted a String or List<int> or Uint8List but recevied $element');
//   }

//   void arrayCopy(Uint8List source, int srcPos, List<int> destination,
//       int destPos, int length) {
//     for (var i = 0; i < length; i++) {
//       destination[destPos + i] = source[srcPos + i];
//     }
//   }

//   // Uint8List worker(
//   //     Uint8List plaintext, Uint8List key, Uint8List iv, bool isEncrypt) {
//   //   // Create a new cipher using the block cipher factory method
//   //   final cipher = pointy_castle.BlockCipher("3DES");

//   //   // Create a new padding with the padding factory method
//   //   final padding = pointy_castle.Padding("PKCS7");

//   //   // Create a new PaddedBlockCipher
//   //   final paddedCipher = pointy_castle.PaddedBlockCipherImpl(padding, cipher);

//   //   // Create a new CipherParameters using the key and initialization vector
//   //   final params =
//   //       pointy_castle.PaddedBlockCipherParameters(pointy_castle.KeyParameter(key), pointy_castle.Iv(iv));

//   //   // Initialize the cipher
//   //   paddedCipher.init(isEncrypt, params);

//   //   // Encrypt or decrypt the plaintext
//   //   return paddedCipher.process(plaintext);
//   // }

//   Uint8List compute(
//       {required Uint8List key,
//       required Uint8List iv,
//       required Uint8List plaintext,
//       required Mode mode,
//       required bool forEncryption,
//       required Padding padding}) {
//     final BlockCipher cipher;
//     final BlockCipher underlyingchiper;
//     if (mode == Mode.cbc) {
//       underlyingchiper = BlockCipher('3DES');
//     } else if (mode == Mode.ecb) {
//       underlyingchiper =
//           BlockCipher('3DES'); // ..init(true, KeyParameter(key));
//     } else {
//       throw ArgumentError('Invaild Mode $mode');
//     }
//     cipher = PaddedBlockCipherImpl(padding, underlyingchiper);

//     ParametersWithIV<KeyParameter> params =
//         ParametersWithIV<KeyParameter>(KeyParameter(key), iv);
//     PaddedBlockCipherParameters<ParametersWithIV<KeyParameter>, KeyParameter>
//         paddingParams = PaddedBlockCipherParameters<
//             ParametersWithIV<KeyParameter>, KeyParameter>(params, null);

//     cipher.init(forEncryption, paddingParams);

//     return cipher.process(plaintext);
//   }

//   int get keySize => 64 ~/ 32;

//   int get ivSize => 64 ~/ 32;

//   int get blockSize => 64 ~/ 32;
// }

// void main(List<String> args) {
//   // Example keys (you should use secure, random keys in a real scenario)
//   const key1 = "12345678";
//   const key2 = "87654321";
//   const key3 = "abcdefgh";

// // Message to encrypt
//   const message = "hello world";

//   final a = TripleDES();

//   final b = a.compute(
//       forEncryption: true,
//       iv: Encoders().utf8.parse(key2),
//       key: Encoders().utf8.parse(key1),
//       mode: Mode.ecb,
//       plaintext: Encoders().utf8.parse(message),
//       padding: PKCS7Padding());

//   print(Encoders().base64.stringify(b));
// }
