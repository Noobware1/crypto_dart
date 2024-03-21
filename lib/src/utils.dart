import 'enc.dart';
import 'encoders/base64.dart';
import 'encoders/hex.dart';
import 'encoders/utf16.dart';
import 'encoders/utf8.dart';

Encoder getEncoder(String encoding) {
  switch (encoding) {
    case 'base64':
      return BASE64();
    case 'utf8':
      return UTF8();
    case 'hex':
      return HEX();
    case 'utf16':
      return UTF16();
    default:
      throw ArgumentError('UnKnown Encoding $encoding');
  }
}
