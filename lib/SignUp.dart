

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:livelong/Login.dart';
import 'package:livelong/colors.dart';
import 'package:http/http.dart'as http;
import 'package:livelong/register_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Home.dart';
import 'api_constants.dart';


class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  GlobalKey<ScaffoldState> scaffold_state = new GlobalKey<ScaffoldState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController deviceidController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  RegisterModel registerModel;
  bool _isRegistering = false;
  var dev_id;
  Future <String> postRegister() async {
    var base_url=APIS.base_url;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isRegistering = true;
      dev_id=prefs.getString('dev_id');
    });

    var body = {
      'name' : '${nameController.text}',
      'email' : '${emailController.text}',
      'address' : '',
      'password' : '${passwordController.text}',
      'device_id' : '$dev_id',
      'phone' : '${phoneController.text}'
    };
    var url =
        '$base_url/api/httprequest/Register';
    var response = await http.post(url, body: body);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    print('Response status: ${response.persistentConnection}');
    if(response.body.contains('"status_code":"201"')){
      print('ssssssssssssss');
      setState(() {
        var convertPost = json.decode(response.body);
        registerModel = RegisterModel.fromJson(convertPost);
      });

      prefs.setString('user_id', '${registerModel.userId}');
      print('UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU${registerModel.userId.toString()}');
      print('dddddddddddddddddddddddddddddddddddddddddddddddddddd$dev_id');
  /*    prefs.setString('otp_verified', 'false');*/
      setAsLoggedIn(true);
      Navigator.of(context).pushAndRemoveUntil(

        MaterialPageRoute(
          builder: (BuildContext context) => Home(),
        ),
            (Route route) => false,
      );

    }else{
      print('fail');
      setState(() {
        _isRegistering = false;
      });
      scaffold_state.currentState.showSnackBar(snackBar);
    }



  }
  setAsLoggedIn(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', status);
  }


  @override
  void initState() {
    // TODO: implement initState
    /*  fToast = FToast();
    fToast.init(context);*/


    super.initState();
  }

  DateTime currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;

      scaffold_state.currentState.showSnackBar( SnackBar(
        backgroundColor: accent,
        content: Text('press back again to exit',style: TextStyle(color: Colors.black),),
        duration: snackBarDuration,
      ));

      return Future.value(false);
    }
    return Future.value(true);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffold_state,
      resizeToAvoidBottomInset : false,
      backgroundColor:bg,
      body: WillPopScope(
        onWillPop: onWillPop,
        child: SafeArea(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Padding(
                      padding: EdgeInsets.only(left: 12,right: 12),
                      child: Row(
                        children: [
                          Text("Sign Up", style: TextStyle(
                              fontSize: 24,
                              color: activehead,
                              fontFamily: 'Poppins-Semibold'
                          ),),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 12,right: 12,top: 30, bottom: 12),
                      width: double.infinity,

                      child: Row(
                        children: [

                          Expanded(
                            child: TextField(

                              controller: nameController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                // border: InputBorder.none,
                                prefixIcon: Icon(Icons.person,color: accent,),
                                hintText: "Full Name",
                                hintStyle: TextStyle(color: activebody),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: activehead,width: 3),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: activehead,width: 3),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: activehead,width: 3),
                                ),
                              ),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: activebody
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 12,right: 12,top: 12, bottom: 12),
                      width: double.infinity,

                      child: Row(
                        children: [

                          Expanded(
                            child: TextField(

                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                // border: InputBorder.none,
                                prefixIcon: Icon(Icons.mail,color: accent,),
                                hintText: "Email",
                                hintStyle: TextStyle(color: activebody),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: activehead,width: 3),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: activehead,width: 3),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: activehead,width: 3),
                                ),
                              ),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: activebody
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 12,right: 12,top: 12, bottom: 12),
                      width: double.infinity,

                      child: Row(
                        children: [

                          Expanded(
                            child: TextField(

                              controller: phoneController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                // border: InputBorder.none,
                                prefixIcon: Icon(Icons.phone,color: accent,),
                                hintText: "Phone Number (optional)",
                                hintStyle: TextStyle(color: activebody),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: activehead,width: 3),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: activehead,width: 3),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: activehead,width: 3),
                                ),
                              ),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: activebody
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 12,right: 12,top: 12, bottom: 40),
                      width: double.infinity,

                      child: Row(
                        children: [

                          Expanded(
                            child: TextField(

                              controller: passwordController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(

                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: activehead,width: 3),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: activehead,width: 3),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: activehead,width: 3),
                                ),

                                suffixStyle: TextStyle(color: activebody),
                                prefixIcon: Icon(Icons.lock,color: accent,),
                                hintText: "Password",
                                hintStyle: TextStyle(color: activebody),

                              ),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: activebody
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: ()async{
                        postRegister();
                      },
                      child: Container(
                        padding: EdgeInsets.all(16),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: accent,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Center(
                          child:_isRegistering
                                ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                                : Text("Sign Up",
                            style: TextStyle(
                                fontSize: 20,
                                color: navbaricon
                            ),
                          ),
                        ),
                      ),
                    ),



                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(top:58.0),
                  child: Row(

                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?", style: TextStyle(
                          fontSize: 13,
                          color: activehead
                      ),),
                      InkWell(
                        onTap: openSignUpPage,
                        child: Text(" Sign In", style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: activehead
                        ),),
                      )
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top:28.0),
                  child: InkWell(
                    onTap: (){
                      Navigator.of(context).pushAndRemoveUntil(

                        MaterialPageRoute(
                          builder: (BuildContext context) => Home(),
                        ),
                            (Route route) => false,
                      );
                    },
                    child: Text("Not Now", style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: activehead
                    ),),
                  ),
                ),



              ],
            ),
          ),
        ),
      ),
    );
  }

  void openSignUpPage()
  {
    //Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
    //Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpPage()));
      Navigator.of(context).pushAndRemoveUntil(

      MaterialPageRoute(
        builder: (BuildContext context) => LoginPage(),
      ),
          (Route route) => false,
    );
  }
  void openHomePage()
  {
    /* Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePageWithSideBar()));*/
  }
  _showFailToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        //color: yellow,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.close),
          SizedBox(
            width: 12.0,
          ),
          Text("Failed to Login"),
        ],
      ),
    );


    /* fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 3),
    );
*/
    // Custom Toast Position

  }

  static const snackBarDuration = Duration(seconds: 3);
  final snackBar = SnackBar(
    backgroundColor:accent ,
    content: Text('Failed to Login',style: TextStyle(color: Colors.black),),
    duration: snackBarDuration,
  );
}

