import 'package:crypto_dart/crypto_dart.dart';
import 'package:crypto_dart/src/hashers/hasher.dart';

class SHA512 extends Hasher {
  SHA512(super.data);

  @override
  String get algo => HashAlgorithms.SHA512;
}
