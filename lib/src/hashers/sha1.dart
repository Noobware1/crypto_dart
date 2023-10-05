import 'package:crypto_dart/src/hash_algorithms.dart';

import 'hasher.dart';

class SHA1 extends Hasher {
  SHA1(super.bytes);

  @override
  String get algo => HashAlgorithms.SHA1;
}
