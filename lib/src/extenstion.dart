import 'dart:typed_data';

import 'enc.dart';
import 'encoders/hex.dart';

extension Uint8ListUtils on Uint8List {
  String convertToString([Encoder? encoder, bool allowMalFormed = false]) =>
      (encoder ?? Hex()).stringify(this);
}
