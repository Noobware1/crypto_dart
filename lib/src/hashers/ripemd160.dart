import 'package:crypto_dart/hashers.dart';
import 'package:crypto_dart/src/hash_algorithms.dart';

class RIPEMD160 extends Hasher {
  RIPEMD160(super.data);

  @override
  String get algo => HashAlgorithms.RIPEMD160;
}
