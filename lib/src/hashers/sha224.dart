import 'package:crypto_dart/crypto_dart.dart';
import 'package:crypto_dart/src/hashers/hasher.dart';

class SHA224 extends Hasher {
  SHA224(super.data);

  @override
  String get algo => HashAlgorithms.SHA224;
}
