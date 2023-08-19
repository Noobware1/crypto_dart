import 'enc.dart';
import 'encoders.dart';

Encoder getEncoder(String encoding) {
  final Encoders encoders = Encoders();

  switch (encoding) {
    case 'base64':
      return encoders.base64;
    case 'utf8':
      return encoders.utf8;
    case 'hex':
      return encoders.hex;
    case 'utf16':
      return encoders.utf16;
    default:
      throw ArgumentError('UnKnown Encoding $encoding');
  }
}
