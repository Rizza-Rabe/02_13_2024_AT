
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:pointycastle/api.dart';

class ATSecurity{

  Future<String> getHashedPassword(String password) async {
    var hashed = sha256.convert(utf8.encode(password));
    return hashed.toString();
  }

}