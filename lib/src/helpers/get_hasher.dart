import 'package:crypto_dart/src/hashers/hasher.dart';
import 'package:crypto_dart/src/hashers/md5.dart';
import 'package:crypto_dart/src/hashers/sha1.dart';
import 'package:crypto_dart/src/hashers/sha224.dart';
import 'package:crypto_dart/src/hashers/sha256.dart';
import 'package:crypto_dart/src/hashers/sha3.dart';
import 'package:crypto_dart/src/hashers/sha384.dart';
import 'package:crypto_dart/src/hashers/sha512.dart';

Hasher? getHasher(String name, dynamic data, List<dynamic> args) {
  switch (name) {
    case "MD5":
      return MD5(data);
    case "SHA1":
      return SHA1(data);
    case "SHA224":
      return SHA224(data);
    case "SHA256":
      return SHA256(data);
    case "SHA384":
      return SHA384(data);
    case "SHA512":
      return SHA512(data);
    case "SHA3":
      return SHA3(data, outputLength: args.isNotEmpty ? args[0] as int : 512);
    default:
      return null;
  }
}
