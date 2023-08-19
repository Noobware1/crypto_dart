import 'encoders/base64.dart';
import 'encoders/hex.dart';
import 'encoders/utf16.dart';
import 'encoders/utf8.dart';

class Encoders {
  Base64 get base64 => Base64();
  Hex get hex => Hex();
  Utf8 get utf8 => Utf8();
  Utf16 get utf16 => Utf16();
}
