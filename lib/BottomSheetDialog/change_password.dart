

import 'package:audit_tracker/Dialogs/classic_dialog.dart';
import 'package:audit_tracker/Dialogs/loading_dialog.dart';
import 'package:audit_tracker/MessageToaster/message_toaster.dart';
import 'package:audit_tracker/Utility/at_security.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Utility/default_values.dart';

class ChangePassword{
  final _currentPasswordTextController = TextEditingController();
  final _newPasswordTextController = TextEditingController();
  final _confirmPasswordTextController = TextEditingController();
  final _classicDialog = ClassicDialog();
  final _loadingDialog = LoadingDialog();

  String? _userName;
  BuildContext? _context;
  BuildContext? _modalContext;

  void showChangePasswordDialog(BuildContext mainContext, String userName, String currentPassword) async {
    _userName = userName;
    _context = mainContext;

    showModalBottomSheet(
        context: mainContext,
        isDismissible: false,
        enableDrag: false,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (modalContext){
          _modalContext = _modalContext;

          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(modalContext).viewInsets.bottom),
            child: StatefulBuilder(
              builder: (stateContext, setState){
                return Container(
                  padding: const EdgeInsets.all(20),
                  width: DefaultValues().getDefaultWidth(),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Change Password",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        TextFormField(
                          textInputAction: TextInputAction.next,
                          maxLines: 1,
                          autofocus: false,
                          controller: _currentPasswordTextController,
                          decoration: InputDecoration(
                            labelStyle: const TextStyle(color: Colors.black),
                            focusColor: Colors.black,
                            hintStyle: const TextStyle(color: Colors.black),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)
                            ),
                            labelText: 'Current Password',
                            border: const OutlineInputBorder(),
                            prefixIcon: Container(
                              height: 1,
                              width: 1,
                              margin: const EdgeInsets.all(12),
                              child: Image.asset(
                                'assets/key.png',
                              ),
                            ),
                          ),

                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: (text){
                            setState(() {});
                          },
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        TextFormField(
                          textInputAction: TextInputAction.next,
                          maxLines: 1,
                          autofocus: false,
                          controller: _newPasswordTextController,
                          decoration: InputDecoration(
                            labelStyle: const TextStyle(color: Colors.black),
                            focusColor: Colors.black,
                            hintStyle: const TextStyle(color: Colors.black),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)
                            ),
                            labelText: 'New Password',
                            border: const OutlineInputBorder(),
                            prefixIcon: Container(
                              height: 1,
                              width: 1,
                              margin: const EdgeInsets.all(12),
                              child: Image.asset(
                                'assets/key.png',
                              ),
                            ),
                          ),

                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: (text){
                            setState(() {});
                          },
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        TextFormField(
                          textInputAction: TextInputAction.next,
                          maxLines: 1,
                          autofocus: false,
                          controller: _confirmPasswordTextController,
                          decoration: InputDecoration(
                            labelStyle: const TextStyle(color: Colors.black),
                            focusColor: Colors.black,
                            hintStyle: const TextStyle(color: Colors.black),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)
                            ),
                            labelText: 'Confirm Password',
                            border: const OutlineInputBorder(),
                            prefixIcon: Container(
                              height: 1,
                              width: 1,
                              margin: const EdgeInsets.all(12),
                              child: Image.asset(
                                'assets/key.png',
                              ),
                            ),
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextButton(
                                  onPressed: (){
                                    Navigator.of(modalContext).pop();

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
                                    "Cancel",
                                    style: TextStyle(
                                        color: Colors.white
                                    ),
                                  )
                              ),
                            ),

                            const SizedBox(
                              width: 10,
                            ),

                            Expanded(
                              child: TextButton(
                                  onPressed: (){
                                    if(_currentPasswordTextController.text.isEmpty){
                                      MessageToaster().showErrorMessage("Current password is required!");
                                      return;
                                    }
                                    if(_newPasswordTextController.text.isEmpty){
                                      MessageToaster().showErrorMessage("New password is required!");
                                      return;
                                    }
                                    if(_confirmPasswordTextController.text.isEmpty){
                                      MessageToaster().showErrorMessage("Confirm password is required!");
                                      return;
                                    }
                                    if(_currentPasswordTextController.text.toString() != currentPassword){
                                      _classicDialog.setTitle("Current password is wrong");
                                      _classicDialog.setMessage("Your current password is wrong. Please try again.");
                                      _classicDialog.setCancelable(false);
                                      _classicDialog.setPositiveButtonTitle("Close");
                                      _classicDialog.showOneButtonDialog(_context!, () { });
                                      return;
                                    }
                                    if(_newPasswordTextController.text.toString() != _confirmPasswordTextController.text.toString()){
                                      _classicDialog.setTitle("Password do not match");
                                      _classicDialog.setMessage("Your new password does not match the confirm password.");
                                      _classicDialog.setCancelable(false);
                                      _classicDialog.setPositiveButtonTitle("Close");
                                      _classicDialog.showOneButtonDialog(_context!, () { });
                                      return;
                                    }

                                    _changePassword(_newPasswordTextController.text.toString());
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
                                    "Change Password",
                                    style: TextStyle(
                                        color: Colors.white
                                    ),
                                  )
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
    );
  }

  void _changePassword(String newPassword) async {
    _loadingDialog.showLoadingDialog(_context!);
    String newHashedPassword = await ATSecurity().getHashedPassword(newPassword);
    DocumentReference documentReference = FirebaseFirestore.instance.collection("user_data").doc(_userName);
    try{
      await documentReference.update({"userPassword": newHashedPassword});
    }catch(a){
      _classicDialog.setTitle("An error occurred!");
      _classicDialog.setMessage(a.toString());
      _classicDialog.setCancelable(false);
      _classicDialog.setPositiveButtonTitle("Close");
      _classicDialog.showOneButtonDialog(_context!, () { });
      return;
    }

    if(_context!.mounted) _loadingDialog.dismissDialog(_context!);
    Navigator.of(_context!).pop();
    MessageToaster().showSuccessMessage("Password updated successfully!");
  }
}