import 'package:crypto_dart/crypto_dart.dart';
import 'package:crypto_dart/src/hashers/hasher.dart';

class MD2 extends Hasher {
  MD2(super.data);

  @override
  String get algo => HashAlgorithms.MD2;
}
