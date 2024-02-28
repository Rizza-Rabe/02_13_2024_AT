
import 'package:flutter/material.dart';

import '../Utility/utility.dart';

class LoadingDialog{

  bool _isLoadingDialogShowing = false;

  String title = "Loading...";

  StateSetter? _setState;

  AlertDialog alertDialog (BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      content: PopScope(
        canPop: false,
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter stateSetter) {
            _setState = stateSetter;
            return SizedBox(
              width: 150,
              height: 100,
              child: Card(
                color: Colors.white,
                elevation: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),

                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void setTitle(String title){
    if(_setState != null && _isLoadingDialogShowing){
      _setState!((){
        this.title = title;
      });
    }
  }

  Future<void> showLoadingDialog(BuildContext context) async {
    title = "Loading...";
    if (!_isLoadingDialogShowing) {
      _isLoadingDialogShowing = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return alertDialog(context);
        },
      );
      return;
    } else {
      return;
    }
  }

  void dismissDialog(BuildContext context) {
    if (_isLoadingDialogShowing) {
      _isLoadingDialogShowing = false;
      Navigator.of(context, rootNavigator: true).pop();
    } else {
      Utility().printLog("Loading dialog is not showing. Nothing to dismiss here");
    }
  }
}