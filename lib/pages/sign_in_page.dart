import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:instagram/pages/main_page.dart';
import 'package:instagram/pages/sign_up_page.dart';
import 'package:instagram/services/auth_service.dart';
import 'package:instagram/services/theme_service.dart';
import 'package:instagram/services/utils.dart';
import 'package:instagram/view/button_widget.dart';
import 'package:instagram/view/textField_widget.dart';

import '../services/pref_service.dart';
import 'home_page.dart';


class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();

  static const String id = "SignInPage";
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  void _doSignIn() async {
    String email = emailController.text.trim().toString();
    String password = passwordController.text.trim().toString();

    if(email.isEmpty || password.isEmpty) {
      Utils.fireSnackBar("Please complete all the fields", context);
      return;
    }

    setState(() {
      isLoading = true;
    });

    await AuthService.signInUser(email, password).then((response) {
      _getFirebaseUser(response);
    });
  }

  void _getFirebaseUser(Map<String, User?> map) async {
    setState(() {
      isLoading = false;
    });

    if(!map.containsKey("SUCCESS")) {
      if(map.containsKey("user-not-found")) Utils.fireSnackBar("No user found for that email.", context);
      if(map.containsKey("wrong-password")) Utils.fireSnackBar("Wrong password provided for that user.", context);
      if(map.containsKey("ERROR")) Utils.fireSnackBar("Check Your Information.", context);
      return;
    }

    User? user = map["SUCCESS"];
    if(user == null) return;

    await Prefs.store(StorageKeys.UID, user.uid);
    Navigator.pushReplacementNamed(context, MainPage.id);
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
                  button(title: "Sign In", onPressed: () {
                    _doSignIn();
                  })
                ],
              )),
              RichText(text: TextSpan(
                text: "Don't have an accaunt ?",
                style: const TextStyle(color: Colors.white),
                children: [
                  TextSpan(
                    text: " Sign Up",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()..onTap = (){
                      Navigator.pushReplacementNamed(context, SignUpPage.id);
                    }
                  )
                ]
              ))
            ],
          ),
        ),
      ),
    );
  }
}
