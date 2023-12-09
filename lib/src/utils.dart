import 'enc.dart';
import 'encoders.dart';

Encoder getEncoder(String encoding) {
  final Encoders encoders = Encoders();

  switch (encoding) {
    case 'base64':
      return encoders.BASE64;
    case 'utf8':
      return encoders.UTF8;
    case 'hex':
      return encoders.HEX;
    case 'utf16':
      return encoders.UTF16;
    default:
      throw ArgumentError('UnKnown Encoding $encoding');
  }
}
