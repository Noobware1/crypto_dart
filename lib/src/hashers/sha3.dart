import 'dart:typed_data';

import 'package:crypto_dart/crypto_dart.dart';
import 'package:crypto_dart/hashers.dart';
import 'package:crypto_dart/src/encoders/utf8.dart';
import 'package:pointycastle/export.dart';

class SHA3 extends Hasher {
  late Uint8List _bytes;

  @override
  Uint8List get bytes => _bytes;

  final int outputLength;
  SHA3(super.bytes, {this.outputLength = 512});

  @override
  void init(dynamic data) {
    if (data is String) {
      data = UTF8().parse(data);
    } else if (data is List<int>) {
      data = Uint8List.fromList(data);
    }
    if (data is! Uint8List) {
      throw ArgumentError.value(
          data, 'HashHelper', 'excepted a String or Uint8List');
    } else {
      final digest = SHA3Digest(outputLength);

      _bytes = digest.process(data);
    }
  }

  @override
  String get algo => HashAlgorithms.SHA3;
}
