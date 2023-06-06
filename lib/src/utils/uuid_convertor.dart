import 'dart:typed_data';

class UuidConvertor {
  static int toInt(String uuid) {
    // Convert the UUID to a byte list
    Uint8List bytes = Uint8List.fromList(uuid.codeUnits);

    // Use the first 8 bytes of the UUID to create a 64-bit integer
    int msb = ((bytes[0] << 24) | (bytes[1] << 16) | (bytes[2] << 8) | bytes[3]) << 32;
    int lsb = (bytes[4] << 24) | (bytes[5] << 16) | (bytes[6] << 8) | bytes[7];
    int uuidInt = msb | lsb;

    return uuidInt.abs(); // return the absolute value of the UUID integer to make it positive
  }
}