import 'encoders/base64.dart';
import 'encoders/hex.dart';
import 'encoders/utf16.dart';
import 'encoders/utf8.dart';

class Encoders {
  Base64 get BASE64 => Base64();
  Hex get HEX => Hex();
  Utf8 get UTF8 => Utf8();
  Utf16 get UTF16 => Utf16();
}
