import 'dart:convert';

import 'package:crypto_dart/src/padding/padding.dart';

import 'enc.dart';
import 'mode.dart';

class CipherOptions<A, B, C, D, E> {
  final B? iv;
  final Padding? padding;
  final E? salt;
  final String? textEncoding;
  final String? ivEncoding;
  final String? keyEncoding;
  final String? saltEncoding;
  final Mode? mode;

  const CipherOptions({
    this.iv,
    this.ivEncoding,
    this.saltEncoding,
    this.keyEncoding,
    this.textEncoding,
    this.salt,
    this.mode,
    this.padding,
  });

  @override
  String toString([Encoder? encoder]) {
    return json.encode({
      'iv': iv,
      'padding': padding,
      'salt': salt,
      'saltEncoding': saltEncoding,
      'textEncoding': textEncoding,
      'mode': mode,
      'ivEncoding': ivEncoding,
      'keyEncoding': keyEncoding,
    });
  }
}
