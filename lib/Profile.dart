import 'dart:async';

import 'package:flutter/material.dart';
import 'package:livelong/Home.dart';


import 'package:livelong/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ResetPassword.dart';
import 'colors.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => new _ProfileState();
}

class _ProfileState extends State<Profile> {

  String iframeUrl = "https://www.youtube.com/embed/sPW7nDBqt8w";
  GlobalKey<ScaffoldState> scaffold_state = new GlobalKey<ScaffoldState>();
  DateTime currentBackPressTime;
  static const snackBarDuration = Duration(seconds: 3);
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;

      scaffold_state.currentState.showSnackBar( SnackBar(
        backgroundColor:Colors.black ,
        content: Text('press back again to exit',style: TextStyle(color: Colors.white),),
        duration: snackBarDuration,
      ));

      return Future.value(false);
    }
    return Future.value(true);
  }
  bool isLogIn=false;
islog()async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  setState(() {
    isLogIn= prefs.getBool('isLoggedIn') ?? false;
  });
}
@override
  void initState() {
    // TODO: implement initState
    islog();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffold_state,
backgroundColor: bg,
        body: WillPopScope(
          onWillPop: onWillPop,
          child: SafeArea(
            child: Column(
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Image.asset('assets/images/Asset 34@4x.png',height: 20,),
                      Image.asset('assets/images/Exttended Logomark.png',height: 70,),
                      //Image.asset('assets/images/Asset 33@4x.png',height: 20,),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:15.0,left: 28),
                  child: Row(
                    children: [
                      Text('Profile',style: TextStyle(color: accent,fontFamily: 'Poppins-Bold',fontSize: 26),),
                    ],
                  ),
                ),
                isLogIn?
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top:30.0,left: 28),
                      child: InkWell(
                        onTap: ()async{
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          try {
                            prefs.remove("isLoggedIn");
                             prefs.remove('user_id');


                            setState(() {
                              Home.index=2;
                            });
                            // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {return LoginPage();}), ModalRoute.withName('/'));
                            Navigator.of(context).pushAndRemoveUntil(

                              MaterialPageRoute(
                                builder: (BuildContext context) => Home(),
                              ),
                                  (Route route) => false,
                            );
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: Row(
                          children: [
                            Text('Logout',style: TextStyle(color: Colors.white,fontFamily: 'Poppins-SemiBold',fontSize: 19),),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:10.0,left: 28),
                      child:   InkWell(
                        child:  Row(
                          children: [
                            Text('Reset Password',style: TextStyle(color: Colors.white,fontFamily: 'Poppins-SemiBold',fontSize: 19),),
                          ],
                        ),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Resetpassword()));
                        },
                      ),
                    )
                  ],
                ): Padding(
                  padding: const EdgeInsets.only(top:30.0,left: 28),
                  child: InkWell(
                    onTap: ()async{
                      setState(() {
                        Home.index=2;
                      });
                      Navigator.of(context).pushAndRemoveUntil(

                        MaterialPageRoute(
                          builder: (BuildContext context) => LoginPage(),
                        ),
                            (Route route) => false,
                      );
                    },
                    child: Row(
                      children: [
                        Text('Login',style: TextStyle(color: Colors.white,fontFamily: 'Poppins-SemiBold',fontSize: 19),),
                      ],
                    ),
                  ),
                ),



              ],
            ),
          ),
        )
    );
  }
}
