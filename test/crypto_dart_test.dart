import 'dart:typed_data';

import 'package:crypto_dart/crypto_dart.dart';
import 'package:test/test.dart';

void main() {
  group('CryptoDart tests', () {
    group('Hashers', () {
      test('MD2', () {
        expect(CryptoDart.MD5('my message').toString(),
            '8ba6c19dc1def5702ff5acbf2aeea5aa');
      });
      test('MD4', () {
        expect(CryptoDart.MD5('my message').toString(),
            '8ba6c19dc1def5702ff5acbf2aeea5aa');
      });
      test('MD5', () {
        expect(CryptoDart.MD5('my message').toString(),
            '8ba6c19dc1def5702ff5acbf2aeea5aa');
      });

      test('RIPEMD160', () {
        expect(CryptoDart.RIPEMD160('my message').toString(),
            'e9f9d7b470969abf6ebcd267a722b4914e54833f');
      });

      test('SHA1', () {
        expect(CryptoDart.SHA1('my message').toString(),
            '104ab42f1193c336aa2cf08a2c946d5c6fd0fcdb');
      });

      test('SHA3', () {
        expect(CryptoDart.SHA3('my message').toString(),
            '084611f7bfa9b9d0f41c453daa2ac884e777f49c0a9e01fd16ecfbf2b9ff89ef8ca3863757fafe8e24dbe0f3a26240bd7057ec756096cbc6d3e52d9bd4b241e7');
      });

      test('SHA224', () {
        expect(CryptoDart.SHA224('my message').toString(),
            '54848b5a8903e1cda43d3e64c40ed521dd41d5207fe5f887ec5ca50d');
      });

      test('SHA256', () {
        expect(CryptoDart.SHA256('my message').toString(),
            'ea38e30f75767d7e6c21eba85b14016646a3b60ade426ca966dac940a5db1bab');
      });

      test('SHA384', () {
        expect(CryptoDart.SHA384('my message').toString(),
            '9791046473d60f94470b923b1547b4c757acc653787dc984ca7de3a18388b7a507fd39c8a905acefa528f611455d6964');
      });

      test('SHA512', () {
        expect(CryptoDart.SHA512('my message').toString(),
            '0786de62875fd9c50f9c8aa74706f45107b37ee310f4795bb20a12ff29ff59e7674340a0c2eda6d74a1cbf7887334eb3c6d2974d2919ac3b56d48ccccc127ea9');
      });

      test('TIGER', () {
        expect(CryptoDart.TIGER('my message').toString(),
            '8ccfcd291880bc0c81a0a82e00fd0a7a3981b2fc13161f1b');
      });

      test('WHIRLPOOL', () {
        expect(CryptoDart.WHIRLPOOL('my message').toString(),
            'e3877cfeb36e018f83eba8604634d28564c31fc31bdea051776c7acbe1481e2e483dd24cf42adbce37c0de45d9e9d5f27d004d4d46ef5697b2760ac4a6c59184');
      });
    });

    test('PBKDF2', () {
      expect(
        CryptoDart.PBKDF2(
          salt: Uint8List.fromList(
              [3805526817, 3395707149, 844792142, 2160882934]),
          password: 'password123',
          iterations: 1000,
          keySize: 256 ~/ 32,
        ).convertToString(),
        'a6866b17915bc34450e5e532b27153380b6375a7035dd3ac23f1fdf23c8328f3b5fa200264ddc1527589afc9ff7365b4d91953e0f3a19f03b2ad230b42536e3a',
      );
    });

    test('EvpKDF', () {
      expect(
        CryptoDart.EvpKDF(
          salt:
              Uint8List.fromList([834107908, 667361473, 2110182259, 243069802]),
          password: CryptoDart.enc.Utf8.parse('password123'),
          iterations: 1000,
          keySize: 256 ~/ 32,
        ).key.convertToString(),
        '792600ae60406c8d',
      );
    });

    test('AES', () {
      var key = CryptoDart.enc.Hex.parse('000102030405060708090a0b0c0d0e0f');
      var ciphertext = CryptoDart.AES.encrypt('my message', key).toString();

      expect(ciphertext, 'xXfRlxj5anT5YgvJGq4BDQ==');

      var message = CryptoDart.AES
          .decrypt(ciphertext, key)
          .convertToString(CryptoDart.enc.Utf8);

      expect(message, 'my message');
    });

    test('TripleDES', () {
      var key = CryptoDart.enc.Hex.parse('000102030405060708090a0b0c0d0e0f');
      var ciphertext =
          CryptoDart.TripleDES.encrypt('my message', key).toString();

      expect(ciphertext, 'IH7uF88KYm/vRH78dgUSvw==');

      var message = CryptoDart.TripleDES.decrypt(ciphertext, key)
          .convertToString(CryptoDart.enc.Utf8);

      expect(message, 'my message');
    });
  });
}
