import 'dart:typed_data' show Uint8List;

abstract interface class Encoder {
  /// Encodes the given [data] into a [String].
  String stringify(Uint8List data);

  /// Decodes the given [encoded] [String] into a [Uint8List].
  Uint8List parse(String encoded);
}
