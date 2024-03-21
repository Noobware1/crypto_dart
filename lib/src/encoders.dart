import 'encoders/base64.dart';
import 'encoders/hex.dart';
import 'encoders/utf16.dart';
import 'encoders/utf8.dart';

class Encoders {
  BASE64 get Base64 => BASE64();
  HEX get Hex => HEX();
  UTF8 get Utf8 => UTF8();
  UTF16 get Utf16 => UTF16();
}
