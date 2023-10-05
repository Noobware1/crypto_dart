import 'package:crypto_dart/crypto_dart.dart';
import 'package:crypto_dart/src/hashers/hasher.dart';

class MD5 extends Hasher {
  MD5(super.data);

  @override
  String get algo => HashAlgorithms.MD5;
}
