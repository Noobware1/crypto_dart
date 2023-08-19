import 'dart:typed_data';


import 'enc.dart';
import 'encoders/base64.dart';
import 'mode.dart';
import 'padding/padding.dart';

class CipherParams {
  final Uint8List key;
  final Uint8List iv;
  final Uint8List cipherText;
  final Padding? padding;
  final Uint8List? salt;
  final Mode mode;

  const CipherParams({
    required this.key,
    required this.iv,
    required this.salt,
    required this.cipherText,
    required this.mode,
    required this.padding,
  });

  @override
  String toString([Encoder? encoder]) {
    return (encoder ?? Base64()).stringify(cipherText);
  }
}
