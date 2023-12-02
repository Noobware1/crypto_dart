import 'package:crypto_dart/crypto_dart.dart';

class RIPEMD160 extends Hasher {
  RIPEMD160(super.data);

  @override
  String get algo => HashAlgorithms.RIPEMD160;
}

