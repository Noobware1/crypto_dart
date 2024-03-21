import 'encoders/base64.dart' as base64;
import 'encoders/hex.dart' as hex;
import 'encoders/utf16.dart' as utf16;
import 'encoders/utf8.dart' as utf8;

class Encoders {
  base64.BASE64 get BASE64 => base64.BASE64();

  hex.HEX get HEX => hex.HEX();
  utf8.UTF8 get UTF8 => utf8.UTF8();
  utf16.UTF16 get UTF16 => utf16.UTF16();
}
