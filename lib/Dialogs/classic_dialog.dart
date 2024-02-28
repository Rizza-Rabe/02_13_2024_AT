
import 'package:flutter/material.dart';
import '../Utility/default_values.dart';

class ClassicDialog{

  String title = "";
  String message = "";
  String positiveButtonTitle = "";
  String negativeButtonTitle = "";

  bool cancelable = true;

  void showOneButtonDialog(BuildContext context, VoidCallback buttonClicked) async {
    showDialog(
        barrierDismissible: cancelable,
        context: context,
        builder: (BuildContext context){
          return PopScope(
            canPop: cancelable,
            child: AlertDialog(
              insetPadding: DefaultValues().dialogContentPadding(),
            title: Text(
              title,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),
            ),
            content: SizedBox(
              width: DefaultValues().getDefaultWidth(),
              child: SingleChildScrollView(
                child: Text(
                  message,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.blueGrey
                  ),
                ),
              ),
            ),

            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                    buttonClicked();
                  },
                  style: ButtonStyle(
                    textStyle: const MaterialStatePropertyAll(
                        TextStyle(
                            fontSize: 16
                        )
                    ),
                    minimumSize: MaterialStateProperty.all(
                        const Size(100, 45)
                    ),
                    overlayColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        return Colors.white24;
                      },
                    ),
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  child: Text(
                      positiveButtonTitle,
                    style: const TextStyle(
                      color: Colors.white
                    ),
                  )
              )
            ],
          ),
          );
        });
  }

  void showTwoButtonDialog(BuildContext context, VoidCallback leftButtonClicked, VoidCallback rightButtonClicked) async {
    showDialog(
        barrierDismissible: cancelable,
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            insetPadding: DefaultValues().dialogContentPadding(),
            title: Text(
              title,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),
            ),
            content: SizedBox(
              width: DefaultValues().getDefaultWidth(),
              child: SingleChildScrollView(
                child: Text(
                  message,
                  style: const TextStyle(
                    fontSize: 16,
                      color: Colors.blueGrey
                  ),
                ),
              ),
            ),

            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                    rightButtonClicked();
                  },
                  style: ButtonStyle(
                    textStyle: const MaterialStatePropertyAll(
                        TextStyle(
                            fontSize: 16
                        )
                    ),
                    minimumSize: MaterialStateProperty.all(
                        const Size(100, 45)
                    ),
                    overlayColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        return Colors.white24;
                      },
                    ),
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  child: Text(
                      negativeButtonTitle,
                    style: const TextStyle(
                      color: Colors.white
                    ),
                  )
              ),

              TextButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                    leftButtonClicked();
                  },
                  style: ButtonStyle(
                    textStyle: const MaterialStatePropertyAll(
                        TextStyle(
                            fontSize: 16
                        )
                    ),
                    minimumSize: MaterialStateProperty.all(
                        const Size(100, 45)
                    ),
                    overlayColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        return Colors.white24;
                      },
                    ),
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  child: Text(
                      positiveButtonTitle,
                    style: const TextStyle(
                      color: Colors.white
                    ),
                  )
              ),
            ],
          );
        });
  }

  void showTwoButtonDialogWithFunc(BuildContext context, Function(bool positiveClicked) positiveClicked, Function(bool negativeClicked) negativeClicked) async {
    showDialog(
        barrierDismissible: cancelable,
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            insetPadding: DefaultValues().dialogContentPadding(),
            title: Text(
              title,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),
            ),
            content: SizedBox(
              width: DefaultValues().getDefaultWidth(),
              child: SingleChildScrollView(
                child: Text(
                  message,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blueGrey
                  ),
                ),
              ),
            ),

            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                    negativeClicked(true);
                  },

                style: ButtonStyle(
                  textStyle: const MaterialStatePropertyAll(
                      TextStyle(
                          fontSize: 16
                      )
                  ),
                  minimumSize: MaterialStateProperty.all(
                      const Size(100, 45)
                  ),
                  overlayColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors.white24;
                    },
                  ),
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),

                  child: Text(
                      negativeButtonTitle,
                    style: const TextStyle(
                      color: Colors.white
                    ),
                  ),
              ),

              TextButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                    positiveClicked(true);
                  },
                  style: ButtonStyle(
                    textStyle:
                    const MaterialStatePropertyAll(
                        TextStyle(
                            fontSize: 16
                        )
                    ),
                    minimumSize: MaterialStateProperty.all(
                        const Size(100, 45)
                    ),
                    overlayColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        return Colors.white24;
                      },
                    ),
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),

                  child: Text(
                      positiveButtonTitle,
                    style: const TextStyle(
                      color: Colors.white
                    ),
                  )
              ),
            ],
          );
        });
  }

  void dismiss(BuildContext context){
    Navigator.of(context).pop();
  }

  void setNegativeButtonTitle(String buttonTitle){
    negativeButtonTitle = buttonTitle;
  }

  void setPositiveButtonTitle(String buttonTitle){
    positiveButtonTitle = buttonTitle;
  }

  void setTitle(String title){
    this.title = title;
  }

  void setMessage(String message){
    this.message = message;
  }

  void setCancelable(bool cancelable){
    this.cancelable = cancelable;
  }

}