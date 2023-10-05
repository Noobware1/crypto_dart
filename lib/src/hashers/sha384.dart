import 'package:crypto_dart/crypto_dart.dart';
import 'package:crypto_dart/src/hashers/hasher.dart';

class SHA384 extends Hasher {
  SHA384(super.data);

  @override
  String get algo => HashAlgorithms.SHA384;
}
