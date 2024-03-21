import 'dart:typed_data';

import 'enc.dart';
import 'encoders/hex.dart';

extension Uint8ListUtils on Uint8List {
  /// Useful extension method that converts a [Uint8List] to a [String] using the provided [encoder].
  String convertToString([Encoder? encoder]) =>
      (encoder ?? HEX()).stringify(this);
}
