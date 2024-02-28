import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MessageToaster{
  void showNeutralMessage(String message){
    Fluttertoast.showToast(
      webPosition: "center",
      webBgColor: "black",
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }

  void showErrorMessage(String message){
    Fluttertoast.showToast(
      webPosition: "center",
      webBgColor: "red",
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  void showSuccessMessage(String message){
    Fluttertoast.showToast(
      webPosition: "center",
      webBgColor: "green",
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }
}