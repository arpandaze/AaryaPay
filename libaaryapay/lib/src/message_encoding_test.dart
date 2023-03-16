import 'dart:ffi';
import 'dart:typed_data';
import 'dart:convert';

import 'package:libaaryapay/src/main.dart';

Map<String, dynamic> balanceVerification = {
  "user_id": 1010.11,
  "available_balance": 10011,
  "time_stamp": 1042134
};

Map<String, dynamic> message = {
  "amount": 123,
  "to": 4817234,
  "balance_verification": balanceVerification
};

void main() async {
  ByteData buffer = ByteData(balanceVerification.length * 4);

  int offset = 0;

  for (var value in balanceVerification.values) {
    if (value is int) {
      buffer.setUint32(offset, value);
      offset += 4;
    } else if (value is double) {
      buffer.setFloat32(offset, value);
      offset += 4;
    }
  }

  List<int> bytes = buffer.buffer.asUint8List();
  print(bytes);
}
