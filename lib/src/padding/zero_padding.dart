import 'dart:typed_data';

import 'package:pointycastle/export.dart';

class ZeroPadding implements Padding {
  @override
  int addPadding(Uint8List data, int offset) {
    return 0;
  }

  @override
  String get algorithmName => 'PKCS0';

  @override
  void init([CipherParameters? params]) {}

  @override
  int padCount(Uint8List data) {
    return 0;
  }

  @override
  Uint8List process(bool pad, Uint8List data) {
    return data;
  }
}
