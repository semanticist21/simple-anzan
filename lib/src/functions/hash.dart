import 'dart:convert';

import 'package:crypto/crypto.dart';

String getHashId() {
  var hashStr = DateTime.now().toString();

  // Hash the string using sha256
  List<int> bytes = utf8.encode(hashStr);
  Digest hash = sha256.convert(bytes);

  return hash.toString();
}
