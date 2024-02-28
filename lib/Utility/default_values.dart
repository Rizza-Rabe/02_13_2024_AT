
import 'dart:collection';

import 'package:flutter/material.dart';

class DefaultValues{
  final double textFormFieldHeight = 50.0;

  String defaultProfilePicture () {
    return  "https://firebasestorage.googleapis.com/v0/b/audit-tracker-d4e91.appspot.com/o/user.png?alt=media&token=b17c90e3-5244-4a4c-a6f6-0c960b052d13";
}

  double getAppbarDefaultFontSize(){
    return 18.0;
  }

  Color? getDefaultBackgroundColor(){
    return Colors.grey[300];
  }

  double getDefaultWidth(){
    return 600.0;
  }

  EdgeInsets dialogContentPadding (){
    return const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8);
  }

  Size getDefaultButtonMinimumSize() {
    return const Size(95, 42);
  }
}