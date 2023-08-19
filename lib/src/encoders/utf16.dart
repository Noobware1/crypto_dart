import 'dart:typed_data';

import 'package:crypto_dart/src/enc.dart';

class Utf16 extends Encoder {
  @override
  Uint8List parse(String encoded) => Uint8List.fromList(encoded.codeUnits);

  @override
  String stringify(Uint8List data) => String.fromCharCodes(data);
}
