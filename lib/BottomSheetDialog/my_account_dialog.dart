

import 'dart:async';
import 'dart:collection';
import 'package:audit_tracker/BottomSheetDialog/change_password.dart';
import 'package:audit_tracker/Dialogs/classic_dialog.dart';
import 'package:audit_tracker/Dialogs/loading_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../Dialogs/image_source_select_dialog.dart';
import '../MessageToaster/message_toaster.dart';
import '../Utility/default_values.dart';
import '../Utility/utility.dart';
import 'dart:io';


class MyAccountDialog{
  final _userFullNameTextController = TextEditingController();
  final _userAddressTextController = TextEditingController();
  final _zoneIdTextController = TextEditingController();
  final _imageSourceSelectDialog = ImageSourceSelectDialog();
  final _imagePicker = ImagePicker();
  final _loadingDialog = LoadingDialog();
  final _classicDialog = ClassicDialog();
  final _changePassword = ChangePassword();

  String? _userProfileImage;
  String? _userName;
  StateSetter? _stateSetter;

  late BuildContext _context;

  void showMyAccountDialog(BuildContext mainContext, HashMap<String, dynamic> userData) {
    _context = mainContext;

    String userProfilePicture = userData["userProfilePicture"].toString();
    _userProfileImage = userProfilePicture;
    _userName = userData["userName"].toString();
    _userFullNameTextController.text = userData["userFullName"];
    _userAddressTextController.text = userData["userAddress"];
    _zoneIdTextController.text = userData["userZoneId"];

    showModalBottomSheet(
        context: mainContext,
        isDismissible: false,
        enableDrag: false,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (modalContext){
          return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(modalContext).viewInsets.bottom),
            child: StatefulBuilder(
            builder: (context, setState){
              _stateSetter = setState;

              return Container(
                padding: const EdgeInsets.all(20),
                width: DefaultValues().getDefaultWidth(),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 3, bottom: 3),
                        child: Text(
                          "My Account",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      InkWell(
                        onTap: (){
                          _imageSourceSelectDialog.showSourceSelection(context, (source) {
                            Utility().printLog("Selected source: $source");
                            _pickImage(source);
                          });
                        },

                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          margin: const EdgeInsets.only(top: 3, bottom: 3, left: 3, right: 3),
                          width: 80,
                          height: 80,
                          child: ClipOval(
                            child: Image.network(
                                _userProfileImage!
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 5,
                      ),

                      const Text(
                        "*Tap the image to pick",
                        style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      TextFormField(
                        textInputAction: TextInputAction.next,
                        maxLines: 1,
                        autofocus: false,
                        controller: _userFullNameTextController,
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.black),
                          focusColor: Colors.black,
                          hintStyle: const TextStyle(color: Colors.black),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)
                          ),
                          labelText: 'User full name',
                          border: const OutlineInputBorder(),
                          prefixIcon: Container(
                            height: 1,
                            width: 1,
                            margin: const EdgeInsets.all(12),
                            child: Image.asset(
                              'assets/user.png',
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
                        controller: _userAddressTextController,
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.black),
                          focusColor: Colors.black,
                          hintStyle: const TextStyle(color: Colors.black),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)
                          ),
                          labelText: 'LGU Address',
                          border: const OutlineInputBorder(),
                          prefixIcon: Container(
                            height: 1,
                            width: 1,
                            margin: const EdgeInsets.all(12),
                            child: Image.asset(
                              'assets/user.png',
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

                      IgnorePointer(
                        ignoring: true,
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          maxLines: 1,
                          autofocus: false,
                          controller: _zoneIdTextController,
                          decoration: InputDecoration(
                            labelStyle: const TextStyle(color: Colors.grey),
                            focusColor: Colors.grey,
                            hintStyle: const TextStyle(color: Colors.grey),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)
                            ),
                            labelText: 'Zone ID',
                            helperText: '*Not editable',
                            border: const OutlineInputBorder(),
                            prefixIcon: Container(
                              height: 1,
                              width: 1,
                              margin: const EdgeInsets.all(12),
                              child: Image.asset(
                                'assets/user.png',
                              ),
                            ),
                          ),

                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: (text){
                            setState(() {});
                          },
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                            onTap: (){
                              _changePassword.showChangePasswordDialog(mainContext, userData["userName"], userData["userPassword"]);
                            },

                            borderRadius: BorderRadius.circular(5),
                            child: const Padding(
                              padding: EdgeInsets.all(5),
                              child: Text(
                              "Change Password",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          )
                        )
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
                                  HashMap<String, dynamic> newUserData = HashMap();
                                  newUserData["userFullName"] = _userFullNameTextController.text.toString();
                                  newUserData["userAddress"] = _userAddressTextController.text.toString();
                                  _updateUserInformation(newUserData, modalContext);
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
                                  "Save Changes",
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
                )
              );
            },
            ),
          );
        });
  }

  Future<void> _pickImage(int source) async {
    try{
      XFile? pickedFile;
      if(source == ImageSourceSelectDialog().cameraSource){
        pickedFile = await _imagePicker.pickImage(source: ImageSource.camera);
        if (pickedFile != null) {
          Utility().printLog("Picked file path: ${pickedFile.path}");
          _cropXFile(pickedFile);
        } else {
          Utility().printLog("Upload cancelled");
        }
      }else if(source == ImageSourceSelectDialog().gallerySource){
        pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          Utility().printLog("Picked file path: ${pickedFile.path}");
          _cropXFile(pickedFile);
        } else {
          Utility().printLog("Upload cancelled");
        }
      }else {
        MessageToaster().showErrorMessage("Invalid source.");
        return;
      }
    } catch(a){
      Utility().printLog("Error: ${a.toString()}");
    }
  }

  Future<void> _cropXFile(XFile imageFile) async {
    try{
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 70,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Image Cropper',
              toolbarColor: Colors.black,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              hideBottomControls: true,
              lockAspectRatio: true
          ),
          WebUiSettings(
            context: _context,
            presentStyle: CropperPresentStyle.dialog,
            boundary: const CroppieBoundary(
              width: 300,
              height: 300,
            ),
            viewPort:
            const CroppieViewPort(width: 300, height: 300, type: 'circle'),
            enableExif: true,
            enableZoom: true,
            showZoomer: true,
          ),

          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      );

      if(croppedFile != null){
        Utility().printLog("Cropped file: ${croppedFile.path}");
        if(_context.mounted) _loadingDialog.showLoadingDialog(_context);
        _deleteCurrentUserProfileImage(croppedFile);
      }
    }catch(a){
      Utility().printLog("Error Cropped: ${a.toString()}");
    }
  }

  void _deleteCurrentUserProfileImage(CroppedFile imagePath) async {
    try{
      if(_userProfileImage == "null" || _userProfileImage == DefaultValues().defaultProfilePicture()){
        // Upload the image.
        Utility().printLog("There is no current image URL. Uploading the file...");
        _uploadUserProfileImage(imagePath);
      }else {
        Utility().printLog("Deleting old URL");
        final firebaseStorage = FirebaseStorage.instance;
        final storageReference = firebaseStorage.refFromURL(_userProfileImage!);
        try{
          storageReference.delete().then((value) {
            _uploadUserProfileImage(imagePath);
          }).onError((error, stackTrace) async {
            if(error.toString().contains("(storage/object-not-found)")){
              Utility().printLog("Profile pic does not exist. Continue to upload...");
              Utility().printLog("Old profile picture has been deleted.");
              _uploadUserProfileImage(imagePath);
            }else {
              _loadingDialog.dismissDialog(_context);
              _classicDialog.setTitle("An error occurred!");
              _classicDialog.setMessage(error.toString());
              _classicDialog.setPositiveButtonTitle("Close");
              _classicDialog.setCancelable(false);
              _classicDialog.showOneButtonDialog(_context, () { });
            }
          });
        }catch (error) {
          _loadingDialog.dismissDialog(_context);
          _classicDialog.setTitle("An error occurred!");
          _classicDialog.setMessage(error.toString());
          _classicDialog.setPositiveButtonTitle("Close");
          _classicDialog.setCancelable(false);
          _classicDialog.showOneButtonDialog(_context, () { });
        }

      }
    }catch(error){
      _loadingDialog.dismissDialog(_context);
      _classicDialog.setTitle("An error occurred!");
      _classicDialog.setMessage(error.toString());
      _classicDialog.setPositiveButtonTitle("Close");
      _classicDialog.setCancelable(false);
      _classicDialog.showOneButtonDialog(_context, () { });
    }
  }

  void _uploadUserProfileImage(CroppedFile userProfileImagePath) async {
    try{
      DateTime now = DateTime.now();
      final dateFormat = DateFormat("MMM dd, yyyy HH:mm:ss.SSS");
      String fileName = dateFormat.format(now);
      final firebaseStorage = FirebaseStorage.instance;
      String newProfileURL = "";
      if(kIsWeb){
        final storageReference = firebaseStorage.ref("profiles/profile_$fileName");
        final imageBytes = await userProfileImagePath.readAsBytes();
        final uploadTask = storageReference.putData(imageBytes, SettableMetadata(contentType: 'image/jpeg'));
        await uploadTask.whenComplete(() => null);
        newProfileURL = await storageReference.getDownloadURL();
      }else {
        final storageReference = firebaseStorage.ref("profiles/profile_$fileName");
        var file = File(userProfileImagePath.path);
        UploadTask? uploadTask = storageReference.putFile(file);
        await uploadTask.whenComplete(() => null);
        newProfileURL = await storageReference.getDownloadURL();
      }

      //_updateUserAccountData(newProfileURL);
      Utility().printLog("New profile URL: $newProfileURL");
      _updateUserProfilePicture(newProfileURL);
    } catch(error){
      if(_context.mounted) _loadingDialog.dismissDialog(_context);
      _classicDialog.setTitle("An error occurred!");
      _classicDialog.setMessage(error.toString());
      _classicDialog.setPositiveButtonTitle("Close");
      _classicDialog.setCancelable(false);
      if(_context.mounted) _classicDialog.showOneButtonDialog(_context, () { });
    }
  }

  void _updateUserProfilePicture(String newUserProfileURL) async {
    DocumentReference documentReference = FirebaseFirestore.instance.collection("user_data").doc(_userName!);
    try{
      await documentReference.update({"userProfilePicture":newUserProfileURL});
    }catch(a){
      if(_context.mounted) _loadingDialog.dismissDialog(_context);
      _classicDialog.setTitle("An error occurred!");
      _classicDialog.setMessage(a.toString());
      _classicDialog.setCancelable(false);
      _classicDialog.setPositiveButtonTitle("Close");
      if(_context.mounted) _classicDialog.showOneButtonDialog(_context, () { });
    }
    if(_context.mounted) _loadingDialog.dismissDialog(_context);
    MessageToaster().showSuccessMessage("Uploaded successfully");
    _userProfileImage = newUserProfileURL;
    _stateSetter!((){});
  }

  void _updateUserInformation(HashMap<String, dynamic> newUserData, BuildContext modalContext) async {
    _loadingDialog.showLoadingDialog(_context);
    DocumentReference documentReference = FirebaseFirestore.instance.collection("user_data").doc(_userName!);
    try{
      await documentReference.update(newUserData);
    }catch(a){
      if(_context.mounted) _loadingDialog.dismissDialog(_context);
      _classicDialog.setTitle("An error occurred!");
      _classicDialog.setMessage(a.toString());
      _classicDialog.setCancelable(false);
      _classicDialog.setPositiveButtonTitle("Close");
      if(_context.mounted) _classicDialog.showOneButtonDialog(_context, () { });
    }

    if(_context.mounted) _loadingDialog.dismissDialog(_context);
    MessageToaster().showSuccessMessage("Saved successfully");
    if(modalContext.mounted) Navigator.of(modalContext).pop();
  }
}