import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram/pages/main_page.dart';
import 'package:instagram/pages/sign_in_page.dart';
import 'package:instagram/services/theme_service.dart';

import '../services/pref_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  static const String id = "splash_page";

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  _initTimer() {
    Timer(const Duration(seconds: 3), () => _callHomePage());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initTimer();
    _initNotification();
  }

  _callHomePage() {
    Navigator.pushReplacementNamed(context, MainPage.id);
  }

  _initNotification() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    await _firebaseMessaging.getToken().then((token) {
      print(token);
      Prefs.store(StorageKeys.TOKEN, token!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: ThemeService.backgroundGradient,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Expanded(
              child: Center(
                child: Text(
                  "Instagram",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 45,
                      fontFamily: 'Billabong'),
                ),
              ),
            ),
            Text(
              "Powered By \n     META",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
