  import 'dart:typed_data';

void arrayCopy(Uint8List source, int srcPos, List<int> destination,
      int destPos, int length) {
    for (var i = 0; i < length; i++) {
      destination[destPos + i] = source[srcPos + i];
    }
  }