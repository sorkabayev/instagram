import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:instagram/pages/sign_in_page.dart';
import 'package:instagram/services/auth_service.dart';
import '../models/user_model.dart' as model;
import '../services/data_service.dart';
import '../services/pref_service.dart';
import '../services/theme_service.dart';
import '../services/utils.dart';
import '../view/button_widget.dart';
import '../view/textField_widget.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  static const String id = "sign_up_page";

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  bool isLoading = false;

  /// Do Sing Up
  void _doSignUp() async {
    String email = emailController.text.trim().toString();
    String password = passwordController.text.trim().toString();
    String fullName = fullNameController.text.trim().toString();

    if (email.isEmpty || password.isEmpty || fullName.isEmpty) {
      Utils.fireSnackBar("Please complete fields", context);
      return;
    }

    setState(() {
      isLoading = true;
    });
    var modelUser = model.User(
      password: password,
      email: email,
      fullName: fullName,
    );
    await AuthService.signUpUser(modelUser).then((value) {
      _getFirebaseUser(modelUser, value);
    });
  }

  void _getFirebaseUser(model.User modelUser, Map<String, User?> map) async {
    setState(() {
      isLoading = false;
    });
    if (!map.containsKey("SUCCESS")) {
      if (map.containsKey("weak-password")) Utils.fireSnackBar("The password provided is too weak.", context);
      if (map.containsKey("ERROR"))Utils.fireSnackBar("Check Your Information.", context);
      return;
    }
    User? user = map["SUCCESS"];
    if (user == null) return;

    await Prefs.store(StorageKeys.UID, user.uid);
    modelUser.uid = user.uid;

    print("Navigatorga keldi ----------");

    DataService.storeUser(modelUser).then((value) =>
          Navigator.pushReplacementNamed(context, SignInPage.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: ThemeService.backgroundGradient,
          child: Column(
            children: [
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //App name
                  const Text(
                    "Instagram",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 45,
                        fontFamily: ThemeService.fontHeader),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  textField(
                      hintText: "FullName",
                      textEditingController: fullNameController),
                  const SizedBox(
                    height: 10,
                  ),
                  textField(
                      hintText: "Email",
                      textEditingController: emailController),
                  const SizedBox(
                    height: 10,
                  ),
                  textField(
                      hintText: "Password",
                      textEditingController: passwordController),
                  const SizedBox(
                    height: 10,
                  ),
                  button(title: "Sign Up", onPressed: _doSignUp)
                ],
              )),
              RichText(
                  text: TextSpan(
                      text: "Don't have an accaunt ?",
                      style: TextStyle(color: Colors.white),
                      children: [
                    TextSpan(
                        text: "Sign In",
                        style: TextStyle(fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacementNamed(
                                context, SignInPage.id);
                          })
                  ]))
            ],
          ),
        ),
      ),
    );
  }
}
