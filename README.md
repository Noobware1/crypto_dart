<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

Crypto Dart is made to have crypto-js like usage and results;

## Features

AES ENCRYPTION 128-192-256
AES DECRYPTION 128-192-256

OPENSSL EVP_BYTESTOKEY 



## Getting started

import the package then create a instance of CryptoDart

```dart
import 'package:crypto_dart/crypto_dart';

final CryptoDart crypto = CryptoDart();
```

## Usage

AES ENCRYPTION
```dart
final encrypted = crypto.aes.encrypt('Hello, World', 'my secret key');

```

AES DECRYPTION
```dart
final decrypted = crypto.aes.decrypt(encrypted.toString(), 'my secret key');

print(decrypted.convertToString(crypto.enc.utf8));


```



## Additional information

none for know except that it's work in progress