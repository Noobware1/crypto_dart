import 'package:crypto_dart/src/hash_algorithms.dart';
import 'package:crypto_dart/src/hashers/hasher.dart';

class WHIRLPOOL extends Hasher {
  WHIRLPOOL(super.data);

  @override
  String get algo => HashAlgorithms.WHIRLPOOL;
}
