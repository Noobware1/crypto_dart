import 'package:crypto_dart/crypto_dart.dart';
import 'package:crypto_dart/src/hashers/hasher.dart';

class SHA3 extends Hasher {
  SHA3(super.bytes);

  @override
  String get algo => HashAlgorithms.SHA3;
}
