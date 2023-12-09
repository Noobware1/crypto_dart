import 'dart:typed_data';

import 'package:crypto_dart/src/encoders.dart';
import 'package:pointycastle/export.dart';

abstract class Hasher {
  late Uint8List _bytes;
  Uint8List get bytes => _bytes;
  String get algo;

  Hasher(dynamic data) {
    init(data);
  }

  @override
  String toString() {
    return Encoders().HEX.stringify(bytes);
  }

  void init(dynamic data) {
    if (data is String) {
      data = Encoders().UTF8.parse(data);
    } else if (data is List<int>) {
      data = Uint8List.fromList(data);
    }
    if (data is! Uint8List) {
      throw ArgumentError.value(
          data, 'HashHelper', 'excepted a String or Uint8List');
    } else {
      final digest = Digest(algo);

      _bytes = digest.process(data);
    }
  }

  int get blockSize => 512 ~/ 32;
}
