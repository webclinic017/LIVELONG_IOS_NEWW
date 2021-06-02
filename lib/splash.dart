import 'package:flutter/material.dart';
import 'dart:async';

import 'package:livelong/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool loaded = false;
  double logoSize = 20;
  @override
  void initState() {
    super.initState();

    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: Column(
        children: <Widget>[
          Expanded(child: Container()),
          AnimatedContainer(
            height: logoSize,
            width: logoSize,
            duration: Duration(milliseconds: 1000),
              curve: Curves.easeOutBack,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/Logo mark.png"),
                )
              ),
          ),
          SizedBox(height: 10),

          Expanded(child: Container()),
          Padding(
            padding: const EdgeInsets.only(bottom:18.0),
            child: Column(
              children: [
                Text('From',style: TextStyle(fontSize: 20,color: activehead,fontFamily: 'Poppins-Regular'),),
                Text('Livelong Wealth',style: TextStyle(fontSize: 20,color: activehead,fontFamily: 'Poppins-Regular'),),
              ],
            ),
          ),


        ],
      ),
    );
  }

  startTime() async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
   bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

   var zoomTimer = new Duration(milliseconds: 5);
   new Timer(zoomTimer, (){
     logoSize = 200;
     setState(() {

     });
   });

    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, () {
     // isLoggedIn ? navigationPage('/home') : navigationPage('/login');
      navigationPage('/home');
     // navigationPage('/login');
    });



  }

  void navigationPage(String destination) {
    Navigator.of(context).pushReplacementNamed(destination);
  }
}
