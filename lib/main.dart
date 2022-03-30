import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:instagram/pages/add_page.dart';
import 'package:instagram/pages/main_page.dart';
import 'package:instagram/pages/profile_page.dart';
import 'package:instagram/pages/like_page.dart';
import 'package:instagram/pages/home_page.dart';
import 'package:instagram/pages/search_page.dart';
import 'package:instagram/pages/sign_in_page.dart';
import 'package:instagram/pages/sign_up_page.dart';
import 'package:instagram/pages/splash_page.dart';

Future<void> main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // notification
  var initAndroidSetting = const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initIosSetting = const IOSInitializationSettings();
  var initSetting = InitializationSettings(android: initAndroidSetting, iOS: initIosSetting);
  await FlutterLocalNotificationsPlugin().initialize(initSetting);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /// For Checking LOGIN/UP
    _checkLogin() {
      final FirebaseAuth _auth = FirebaseAuth.instance;

      final User? user = _auth.currentUser;
      if (user == null) {
        return const SignInPage();
      }
      return const SplashPage();
    }

    ///#################################

    return MaterialApp(
      theme: ThemeData(
          appBarTheme:
              const AppBarTheme(backgroundColor: Colors.white, elevation: 0),
          backgroundColor: Colors.white),
      themeMode: ThemeMode.system,
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: _checkLogin(),
      routes: {
        SearchPage.id: (context) => SearchPage(),
        AddPage.id: (context) => AddPage(),
        LikePage.id: (context) => LikePage(),
        ProfilePage.id: (context) => ProfilePage(),
        SplashPage.id: (context) => SplashPage(),
        SignInPage.id: (context) => SignInPage(),
        SignUpPage.id: (context) => SignUpPage(),
        HomePage.id: (context) => HomePage(),
        MainPage.id: (context) => MainPage(),
      },
    );
  }
}
