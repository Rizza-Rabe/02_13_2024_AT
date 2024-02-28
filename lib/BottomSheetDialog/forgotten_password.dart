

import 'package:audit_tracker/Dialogs/classic_dialog.dart';
import 'package:audit_tracker/Dialogs/loading_dialog.dart';
import 'package:audit_tracker/MessageToaster/message_toaster.dart';
import 'package:audit_tracker/Utility/utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Utility/default_values.dart';

class ForgottenPassword{
  final _emailAddressTextController = TextEditingController();
  final _loadingDialog = LoadingDialog();
  final _classicDialog = ClassicDialog();

  late BuildContext context;
  late void Function() callback;

  void showForgottenPassword(BuildContext context) async {
    this.context = context;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        useSafeArea: true,
        builder: (modalContext){
          return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(modalContext).viewInsets.bottom),
              child: _view()
          );
        });
  }

  Widget _view (){
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState){
          return Container(
            padding: const EdgeInsets.all(20),
            width: DefaultValues().getDefaultWidth(),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    child: Text(
                      "Forgotten Password",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  const Padding(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    child: Text(
                      "We will send a password reset link to your registered email address.",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.blueGrey
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  TextFormField(
                    textInputAction: TextInputAction.next,
                    maxLines: 1,
                    autofocus: false,
                    controller: _emailAddressTextController,
                    decoration: const InputDecoration(
                        labelStyle: TextStyle(color: Colors.black),
                        focusColor: Colors.black,
                        hintStyle: TextStyle(color: Colors.black),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)
                        ),
                        labelText: 'Email Address',
                        border: OutlineInputBorder(),

                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (text){
                      setState(() {});
                    },
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  Row(
                    children: [
                      Expanded(
                          child: TextButton(
                            onPressed: (){
                              Navigator.of(context).pop();
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

                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                  color: Colors.white
                              ),
                            ),
                          )
                      ),

                      const SizedBox(
                        width: 10,
                      ),

                      Expanded(
                          child: TextButton(
                            onPressed: (){
                              if(_emailAddressTextController.text.isEmpty){
                                MessageToaster().showErrorMessage("Please enter email address");
                                return;
                              }
                              _sendPasswordResetLink(_emailAddressTextController.text.toString());
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

                            child: const Text(
                              "Send Reset Link",
                              style: TextStyle(
                                  color: Colors.white
                              ),
                            ),
                          )
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  /// Send Password Reset Link to the registered email address of the user
  void _sendPasswordResetLink(String emailAddress) async {
    _loadingDialog.showLoadingDialog(context);
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailAddress);
    }catch(a){
      /// Something went wrong sending the password reset link.
      Utility().printLog("Error: ${a.toString()}");
      if(context.mounted) _loadingDialog.dismissDialog(context);
      _classicDialog.setTitle("Something went wrong!");
      _classicDialog.setMessage(a.toString());
      _classicDialog.setPositiveButtonTitle("Close");
      _classicDialog.setCancelable(false);
      if(context.mounted) _classicDialog.showOneButtonDialog(context, () { });
      return;
    }

    /// Password reset link was successfully sent to the registered email address.
    callback();
    if(context.mounted) _loadingDialog.dismissDialog(context);
    _classicDialog.setTitle("Sent Successful");
    _classicDialog.setMessage("The password reset link was successfully sent to \"$emailAddress\". Please check SPAM MESSAGES if you can't find the link.");
    _classicDialog.setPositiveButtonTitle("Great!");
    _classicDialog.setCancelable(false);
    if(context.mounted) _classicDialog.showOneButtonDialog(context, () { });
  }

  void cleatField() {
    _emailAddressTextController.text = "";
  }
}