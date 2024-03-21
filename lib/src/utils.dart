import 'dart:math';
import 'dart:typed_data';

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

Uint8List randomUint8List(int nBytes) {
  final words = <int>[];

  for (var i = 0; i < nBytes; i += 4) {
    words.add(cryptoSecureRandomInt());
  }
  print(words);

  return Uint8List.fromList(words);
}

/// Cryptographically secure pseudorandom number generator
int cryptoSecureRandomInt() {
  Random random = Random.secure();
  return random.nextInt(pow(2, 32).toInt());
}
