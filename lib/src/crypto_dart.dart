// ignore_for_file: non_constant_identifier_names

import 'dart:typed_data';

import 'package:crypto_dart/src/hash_algorithms.dart';
import 'package:crypto_dart/src/hashers/hasher.dart';

import 'package:crypto_dart/src/hashers/md2.dart' as md2;
import 'package:crypto_dart/src/hashers/md4.dart' as md4;
import 'package:crypto_dart/src/hashers/md5.dart' as md5;
import 'package:crypto_dart/src/hashers/ripemd160.dart' as ripemd160;
import 'package:crypto_dart/src/hashers/sha1.dart' as sha1;

import 'package:crypto_dart/src/hashers/sha3.dart' as sha3;
import 'package:crypto_dart/src/hashers/sha224.dart' as sha224;
import 'package:crypto_dart/src/hashers/sha256.dart' as sha256;
import 'package:crypto_dart/src/hashers/sha384.dart' as sha384;
import 'package:crypto_dart/src/hashers/sha512.dart' as sha512;
import 'package:crypto_dart/src/hashers/tiger.dart' as tiger;
import 'package:crypto_dart/src/hashers/whirlpool.dart' as whirlpool;

import 'aes.dart' as aes;
import 'tripledes.dart' as tripledes;
import 'encoders.dart';
import 'evpkdf.dart' as key_and_iv_gen;
import 'pbkdf2.dart' as pbkdf2;

class CryptoDart {
  static Encoders enc = Encoders();

  static aes.AES AES = aes.AES();

  static tripledes.TripleDES TripleDES = tripledes.TripleDES();

  static Hasher MD2(dynamic data) => md2.MD2(data);

  static Hasher MD4(dynamic data) => md4.MD4(data);

  static Hasher MD5(dynamic data) => md5.MD5(data);

  static Hasher RIPEMD160(dynamic data) => ripemd160.RIPEMD160(data);

  static Hasher SHA1(dynamic data) => sha1.SHA1(data);

  static Hasher SHA3(dynamic data) => sha3.SHA3(data);

  static Hasher SHA224(dynamic data) => sha224.SHA224(data);

  static Hasher SHA256(dynamic data) => sha256.SHA256(data);

  static Hasher SHA384(dynamic data) => sha384.SHA384(data);

  static Hasher SHA512(dynamic data) => sha512.SHA512(data);

  static Hasher TIGER(dynamic data) => tiger.TIGER(data);

  static Hasher WHIRLPOOL(dynamic data) => whirlpool.WHIRLPOOL(data);

  static Uint8List PBKDF2(
      {String hasher = HashAlgorithms.SHA256,
      int iterations = 250000,
      required int blockLength,
      int keySize = 4,
      required Uint8List salt,
      String keyEncoding = 'utf8',
      required String key}) {
    return pbkdf2.PBKDF2(
        iterations: iterations,
        salt: salt,
        key: key,
        hasher: hasher,
        keyEncoding: keyEncoding,
        blockLength: blockLength,
        keySize: keySize);
  }

  static List<Uint8List> EvpKDF({
    required Uint8List password,
    required int keySize,
    required int ivSize,
    required Uint8List salt,
    required int iterations,
    required String hasher,
  }) =>
      key_and_iv_gen.EvpKDF(
          password: password,
          keySize: keySize,
          ivSize: ivSize,
          salt: salt,
          iterations: iterations,
          hasher: hasher);
}
