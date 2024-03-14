import 'package:audit_tracker/Dialogs/classic_dialog.dart';
import 'package:audit_tracker/Dialogs/loading_dialog.dart';
import 'package:audit_tracker/MainActivity/home.dart';
import 'package:audit_tracker/MessageToaster/message_toaster.dart';
import 'package:audit_tracker/Utility/at_security.dart';
import 'package:audit_tracker/Utility/utility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: const FirebaseOptions(
      databaseURL: 'https://audit-tracker-d4e91-default-rtdb.firebaseio.com',
      storageBucket: 'gs://audit-tracker-d4e91.appspot.com',
      apiKey: 'AIzaSyDDQNhxuGUmz-tDA2EFcOq3F7uMDRU7VUM',
      appId: '1:927395022304:web:8357868ed8e766cb581785',
      messagingSenderId: '927395022304',
      projectId: 'audit-tracker-d4e91'));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audit Tracker LGU',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _userNameTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _loadingDialog = LoadingDialog();
  final _classicDialog = ClassicDialog();

  late SharedPreferences _preferences;

  bool _isPasswordVisible = false;

  @override
  void initState() {
    _initializeLogic();
    super.initState();
  }

  void _initializeLogic() async {
    _preferences = await SharedPreferences.getInstance();

    if(mounted) _loadingDialog.showLoadingDialog(context);
    await Future.delayed(const Duration(milliseconds: 700));
    if(_preferences.getString("userName").toString() != "null" && _preferences.getString("userPassword").toString() != "null"){
      if(mounted) _loadingDialog.dismissDialog(context);
      MessageToaster().showSuccessMessage("Logged-in success");
      if(mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home()));
      return;
    }

    if(mounted) _loadingDialog.dismissDialog(context);
  }

  // Log in the user.
  void _logInUser() async {
    // Check user fields
    if(_userNameTextController.text.isEmpty){
      MessageToaster().showErrorMessage("Please enter your username");
      return;
    }
    if(_passwordTextController.text.isEmpty){
      MessageToaster().showErrorMessage("Please enter your password");
      return;
    }

    // Log in user
    _loadingDialog.showLoadingDialog(context);
    await Future.delayed(const Duration(milliseconds: 500));
    DocumentSnapshot documentSnapshot;
    try{
      documentSnapshot = await FirebaseFirestore.instance.collection("user_data").doc(_userNameTextController.text).get();
    }catch(a){
      if(mounted) _loadingDialog.dismissDialog(context);
      _classicDialog.setTitle("Something went wrong!");
      _classicDialog.setMessage(a.toString());
      _classicDialog.setCancelable(false);
      _classicDialog.setPositiveButtonTitle("Close");
      if(mounted) _classicDialog.showOneButtonDialog(context, () { });
      return;
    }

    if(!documentSnapshot.exists){
      if(mounted) _loadingDialog.dismissDialog(context);
      _classicDialog.setTitle("Username not found!");
      _classicDialog.setMessage("The username you entered is invalid or does not exist. Please double check and try again.");
      _classicDialog.setCancelable(false);
      _classicDialog.setPositiveButtonTitle("Close");
      if(mounted) _classicDialog.showOneButtonDialog(context, () { });
      return;
    }

    String userPassword = documentSnapshot["userPassword"].toString();
    if(userPassword == "DILG_PROV"){
      Utility().printLog("Password is the default password. Log-in the account.");
      _preferences.setString("userName", documentSnapshot["userName"]);
      _preferences.setString("userFullName", documentSnapshot["userFullName"]);
      _preferences.setString("userPassword", documentSnapshot["userPassword"]);
      _preferences.setString("userProfilePicture", documentSnapshot["userProfilePicture"]);
      MessageToaster().showSuccessMessage("Log-in successful");
      if(mounted) _loadingDialog.dismissDialog(context);
      await Future.delayed(const Duration(milliseconds: 300));
      if(mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home()));

      return;
    }

    String providedHashedPassword = await ATSecurity().getHashedPassword(_passwordTextController.text);
    Utility().printLog("Database user password: $userPassword");
    Utility().printLog("Provided user password: $providedHashedPassword");

    if(providedHashedPassword != userPassword){
      if(mounted) _loadingDialog.dismissDialog(context);
      _classicDialog.setTitle("Wrong password");
      _classicDialog.setMessage("You have entered an invalid password. Please try again.");
      _classicDialog.setCancelable(false);
      _classicDialog.setPositiveButtonTitle("Close");
      if(mounted) _classicDialog.showOneButtonDialog(context, () { });
      return;
    }

    // Log in user
    Utility().printLog("User name exist and password matched. Log in the user.");
    Utility().printLog("User name: ${documentSnapshot["userName"]}");
    Utility().printLog("User full name: ${documentSnapshot["userFullName"]}");
    Utility().printLog("User hashed password: ${documentSnapshot["userPassword"]}");
    Utility().printLog("User profile picture: ${documentSnapshot["userProfilePicture"]}");

    _preferences.setString("userName", documentSnapshot["userName"]);
    _preferences.setString("userFullName", documentSnapshot["userFullName"]);
    _preferences.setString("userPassword", documentSnapshot["userPassword"]);
    _preferences.setString("userProfilePicture", documentSnapshot["userProfilePicture"]);
    MessageToaster().showSuccessMessage("Log-in successful");
    if(mounted) _loadingDialog.dismissDialog(context);
    await Future.delayed(const Duration(milliseconds: 300));
    if(mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home()));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue[100],
        body: Center(
            child: Stack(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Image.asset(
                      'assets/background.png',
                      fit: BoxFit.cover,
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                    );
                  },
                ),

                Center(
                  child: SingleChildScrollView(
                    child: SizedBox(
                        width: 500,
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          child: Card(
                            color: Colors.white,
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                // Add border radius to the card
                                borderRadius: BorderRadius.circular(15.0),
                                side: const BorderSide(
                                  // Add border side
                                  color: Colors.blueGrey, // Set border color
                                  width: 0.5, // Set border width
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          'assets/app_logo_rounded.png',
                                          height: 100,
                                          width: 100,
                                        ),

                                        const SizedBox(
                                          width: 15,
                                        ),

                                        Image.asset(
                                          'assets/dilg_logo.png',
                                          height: 80,
                                          width: 80,
                                        ),
                                      ],
                                    ),

                                    const SizedBox(
                                      height: 10,
                                    ),

                                    const Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        "Log in to your account",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold
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
                                      controller: _userNameTextController,
                                      decoration: InputDecoration(
                                        labelStyle: const TextStyle(color: Colors.black),
                                        focusColor: Colors.black,
                                        hintStyle: const TextStyle(color: Colors.black),
                                        focusedBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black)
                                        ),
                                        labelText: 'User Name',
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
                                      controller: _passwordTextController,
                                      obscureText: !_isPasswordVisible,
                                      decoration: InputDecoration(
                                        labelStyle: const TextStyle(color: Colors.black),
                                        focusColor: Colors.black,
                                        hintStyle: const TextStyle(color: Colors.black),
                                        focusedBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black)
                                        ),
                                        labelText: 'Password',
                                        border: const OutlineInputBorder(),

                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _isPasswordVisible = !_isPasswordVisible;
                                            });
                                          },
                                        ),
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

                                    TextButton(
                                      onPressed: (){
                                        setState(() {
                                          if(_isPasswordVisible) _isPasswordVisible = false;
                                        });

                                        _logInUser();
                                      },

                                      style: ButtonStyle(
                                        textStyle: const MaterialStatePropertyAll(
                                            TextStyle(
                                                fontSize: 16
                                            )
                                        ),
                                        minimumSize: MaterialStateProperty.all(
                                            const Size(300, 45)
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
                                        'Log In',
                                        style: TextStyle(
                                            color: Colors.white
                                        ),
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 30,
                                    ),
                                  ],
                                ),
                              )
                          ),
                        )
                    ),
                  ),
                )
              ],
            )
        ),
      ),
    );
  }
}
