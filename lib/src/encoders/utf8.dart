import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto_dart/src/enc.dart';

class UTF8 implements Encoder {
  const UTF8();

  @override
  Uint8List parse(String encoded) => Uint8List.fromList(utf8.encode(encoded));

  @override
  String stringify(Uint8List data) => utf8.decode(data, allowMalformed: true);
}
