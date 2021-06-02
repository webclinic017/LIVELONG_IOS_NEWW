import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livelong/Home.dart';
import 'package:livelong/Login.dart';
import 'package:livelong/splash.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'SignUp.dart';

import 'package:flutter_windowmanager/flutter_windowmanager.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //statusBarColor: Colors.white,
    statusBarBrightness:  Brightness.dark,
    statusBarIconBrightness: Brightness.light,
  ));

}
/*void main() {
  runApp(MyApp());
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //statusBarColor: Colors.white,
    statusBarBrightness:  Brightness.dark,
    statusBarIconBrightness: Brightness.light,
  ));

}*/

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  @override
  void initState() {
    // TODO: implement initState
    pushNotification();
    //secureScreen();
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        '/splash':(BuildContext context) => new SplashScreen(),
        '/login':(BuildContext context) => new LoginPage(),
        '/signup':(BuildContext context) => new Signup(),
        '/home':(BuildContext context) => new Home(),


      },
    );



  }
  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }
  pushNotification() async{
    await Firebase.initializeApp();
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {

      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      if (notification != null && android != null) {

      }
    });
    FirebaseMessaging.instance.getToken().then((token) {
      update(token);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');

    });
    /*firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
      onBackgroundMessage: myBackgroundMessageHandler,
    );
    firebaseMessaging.getToken().then((token) {
      update(token);
    });*/
  }
  void update(String token)async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('TTTTTTTTTTTTTTTTTTTOOOKK====$token');
    String textValue = token;
    prefs.setString('dev_id', '$token');
    setState(() {});
  }

}