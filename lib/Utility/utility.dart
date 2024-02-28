

import 'package:flutter/foundation.dart';

class Utility{

  void printLog(String message){
    if (kDebugMode) {
      print(message);
    }
  }

}