import 'dart:typed_data' show Uint8List;

abstract interface class Encoder {
  String stringify(Uint8List data);

  Uint8List parse(String encoded);
}
