import 'dart:convert';
import 'package:crypto/crypto.dart';

String convertToMd5(String input) {
  List<int> bytes = utf8.encode(input);
  Digest md5Hash = md5.convert(bytes);
  String md5String = md5Hash.toString();
  return md5String;
}
