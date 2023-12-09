import 'package:crypto_dart/src/hash_algorithms.dart';
import 'package:crypto_dart/src/hashers/hasher.dart';

class TIGER extends Hasher {
  TIGER(super.data);

  @override
  String get algo => HashAlgorithms.TIGER;
}

