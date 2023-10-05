import 'package:crypto_dart/crypto_dart.dart';
import 'package:crypto_dart/src/hashers/hasher.dart';

class MD4 extends Hasher {
  MD4(super.data);

  @override
  String get algo => HashAlgorithms.MD4;
}
