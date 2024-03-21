Welcome to the Dart Crypto package! This package aims to provide cryptographic functions similar to those found in CryptoJS, but for Dart developers. With this package, you can perform various cryptographic operations, including encryption, decryption, hashing, and more, all within your Dart applications.

## Features:
Encryption/Decryption: Encrypt and decrypt data using popular algorithms such as AES, Triple DES.
Hashing: Generate hash values for your data using algorithms like MD5, SHA-1, SHA-256, SHA-512, etc.
Encoding/Decoding: Encode and decode data using Base64, Hex, Utf8, and other encoding formats.

## Installation:
You can install this package via pub.dev by adding it as a dependency in your pubspec.yaml file:

```yaml
dependencies:
  crypto_dart: ^1.0.3+1
```
Then, run pub get to fetch the package.

## Usage:
Here's a quick example demonstrating how to use some of the functionalities provided by this package:

```dart
import 'package:crypto_dart/crypto_dart.dart';

void main() {
  // Encrypt and decrypt data using AES
  final key = 'ThisIsASecretKey';
  final plainText = 'Hello, World!';
  final encryptedText = CryptoDart.AES.encrypt(plainText, key);
  final decryptedText = CryptoDart.AES.decrypt(encryptedText, key);
  print('Encrypted Text: $encryptedText');
  print('Decrypted Text: $decryptedText');

  // Generate SHA-256 hash
  final dataToHash = 'SensitiveData';
  final hashValue = CryptoDart.SHA256(dataToHash);
  print('SHA-256 Hash: $hashValue');

}
```
## Contributing:
Contributions to this package are welcome! If you find any bugs, want to request a new feature, or want to contribute code, feel free to open an issue or submit a pull request on the GitHub repository: [https://github.com/Noobware1/crypto_dart].

## License:
This package is distributed under the MIT License. See the LICENSE file for more information.

## Acknowledgements:
This package was inspired by CryptoJS and aims to provide similar functionality for Dart developers. Thanks to the Dart community for their support and contributions.

For more detailed documentation and usage examples, please refer to the package documentation.

If you have any questions or need further assistance, feel free to reach out to the package maintainer or open an issue on the GitHub repository.

Happy coding! 🚀