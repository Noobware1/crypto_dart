import 'dart:convert' show base64Encode, base64Decode;
import 'dart:typed_data';

import 'package:crypto_dart/src/enc.dart';

class BASE64 implements Encoder {
  const BASE64();

  @override
  Uint8List parse(String encoded) => base64Decode(encoded);

  @override
  String stringify(Uint8List data) => base64Encode(data);
}
