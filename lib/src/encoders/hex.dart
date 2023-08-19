import 'dart:typed_data';
import 'package:convert/convert.dart' show hex;

import 'package:crypto_dart/src/enc.dart';



class Hex extends Encoder {
  @override
  Uint8List parse(String encoded) => Uint8List.fromList(hex.decode(encoded));

  @override
  String stringify(Uint8List data) => hex.encode(data);
}


