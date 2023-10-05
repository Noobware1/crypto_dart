import 'package:crypto_dart/crypto_dart.dart';
import 'package:crypto_dart/src/hashers/hasher.dart';

class SHA256 extends Hasher {
  SHA256(super.data);

  @override
  String get algo => HashAlgorithms.SHA256;
}
