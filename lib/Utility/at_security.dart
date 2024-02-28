
import 'dart:convert';
import 'package:crypto/crypto.dart';

class ATSecurity{

  Future<String> getHashedPassword(String password) async {
    var hashed = sha256.convert(utf8.encode(password));
    return hashed.toString();
  }

}