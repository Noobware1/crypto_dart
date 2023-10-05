import 'dart:typed_data';

import 'package:crypto_dart/crypto_dart.dart';
import 'package:pointycastle/export.dart';

abstract class Hasher {
  late final Uint8List _bytes;
  Uint8List get bytes => _bytes;
  String get algo;

  Hasher(dynamic data) {
    _init(data);
  }

  @override
  String toString() {
    return Encoders().hex.stringify(bytes);
  }

  _init(dynamic data) {
    if (data is String) {
      data = Encoders().utf8.parse(data);
    } else if (data is List<int>) {
      data = Uint8List.fromList(data);
    }
    if (data is! Uint8List) {
      throw ArgumentError.value(
          data, 'HashHelper', 'excepted a String or Uint8List');
    } else {
      _bytes = Digest(algo).process(data);
    }
  }
}
