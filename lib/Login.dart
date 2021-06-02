

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:livelong/Home.dart';
import 'package:livelong/ResetPassword.dart';
import 'package:livelong/SignUp.dart';
import 'package:livelong/api_constants.dart';
import 'package:livelong/colors.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'login_model.dart';




class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'workSans'
      ),
      home: loginPage(),
    );
  }
}
class loginPage extends StatefulWidget {
  @override
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  LoginModel loginModel;
  bool _isRegistering =false;
  var otp_verified;
  var dev_id;
  GlobalKey<ScaffoldState> scaffold_state = new GlobalKey<ScaffoldState>();
  //FToast fToast;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future <String> postLogin() async {
    var base_url=APIS.base_url;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isRegistering = true;
      dev_id=prefs.getString('dev_id');
    });
print(dev_id);

    var body = {
      'email' : '${emailController.text}',
      'password' : '${passwordController.text}',
      'device_id' : '$dev_id'
    };
    var url =
        '$base_url/api/httprequest/Login';
    var response = await http.post(url, body: body);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

  if(response.body.contains('"status_code":"200"')){
    print('ssssssssssssss');

    setState(() {
      var convertPost = json.decode(response.body);
      loginModel = LoginModel.fromJson(convertPost);
    });

    prefs.setString('user_id', '${loginModel.user.id}');

   // prefs.setString('otp_verified', '${loginModel.user.otpVerified}');
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
  Future <String> requestOtp() async {
    var base_url=APIS.base_url;
    var body = {
      'email' : '${emailController.text}'
    };
    var url =
        '$base_url/api/httprequest/forgot_password';
    var response = await http.post(url, body: body);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

  }
  @override
  void initState() {
    // TODO: implement initState
    /*  fToast = FToast();
    fToast.init(context);*/


    super.initState();
  }
  setAsLoggedIn(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', status);
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
                            Text("Sign In", style: TextStyle(
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
                        padding: EdgeInsets.only(left: 12,right: 12,top: 12, bottom: 40),
                        width: double.infinity,

                        child: Row(
                          children: [

                            Expanded(
                              child: TextFormField(
                                obscureText: true,
                                controller: passwordController,
                                keyboardType: TextInputType.visiblePassword,
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

                                  suffix: InkWell(
                                    onTap: (){
                                      showAlertDialog(context);

                                    },
                                    child: Text('Forgot!',style: TextStyle(color: activebody,fontSize: 15),),),

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
                          //Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
                           postLogin();

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
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                                : Text("Sign In",
                              style: TextStyle(
                                  fontSize: 20,
                                color: navbaricon
                              ),
                            ),
                          ),
                        ),
                      ),


                     /* Padding(
                        padding: const EdgeInsets.only(top:28.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Sign in using',style: TextStyle(color: activehead,fontSize: 15),),
                            SizedBox(width: 20,),
                            Container(height: 25,child: Image.asset('assets/images/Asset 32@4x.png')),
                            SizedBox(width: 10,),
                            Container(height: 25,child: Image.asset('assets/images/Asset 31@4x.png')),
                            SizedBox(width: 10,),
                            Container(height: 25,child: Image.asset('assets/images/Asset 30@4x.png'))
                          ],
                        ),
                      )*/
                    ],
                  ),




                Padding(
                  padding: const EdgeInsets.only(top:58.0),
                  child: Row(

                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Not yet registered?", style: TextStyle(
                          fontSize: 13,
                        color: activehead
                      ),),
                      InkWell(
                        onTap: openSignUpPage,
                        child: Text(" Sign Up", style: TextStyle(
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
   // Navigator.push(context, MaterialPageRoute(builder: (context)=>Signup()));
    Navigator.of(context).pushAndRemoveUntil(

      MaterialPageRoute(
        builder: (BuildContext context) => Signup(),
      ),
          (Route route) => false,
    );
  }


  static const snackBarDuration = Duration(seconds: 3);
  final snackBar = SnackBar(
   backgroundColor:accent ,
    content: Text('Failed to Login',style: TextStyle(color: Colors.black),),
    duration: snackBarDuration,
  );

  showAlertDialog(BuildContext bcontext) {

    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () { },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.all(
              Radius.circular(10.0))),
      backgroundColor: bg,
      title: Text("Forgot Password ?",style: TextStyle(color: activehead),),
      content:Container(
        height: 150,

        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(

                child: TextField(

                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    // border: InputBorder.none,prefixIcon: Icon(Icons.mail,color: accent,),
                    hintText: "Enter Email",
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
              ),
              Padding(
                padding: const EdgeInsets.only(top:28.0),
                child: InkWell(
                  onTap: ()async{

                    Navigator.of(context, rootNavigator: true).pop();
                    requestOtp();
                    showSuccessDialog(context);

                  },
                  child: Container(
                    padding: EdgeInsets.all(16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: accent,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Center(
                      child:Text("Send Otp",
                        style: TextStyle(
                            fontSize: 20,
                            color: navbaricon
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ),
      ),

    );

    // show the dialog
    showDialog(

      context: context,
      builder: (BuildContext context) {
        return Container(
            height:100,width:100,child: alert);
      },
    );
  }
  showSuccessDialog(BuildContext context) {




    Widget notnowButton = FlatButton(
      child: Text("Ok",style: TextStyle(color: accent,fontSize:18),),
      onPressed:  () {
        Navigator.of(context, rootNavigator: true).pop();

        /* Navigator.of(context, rootNavigator: true).pop();*/
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: bg,
      title: Text("Success",style: TextStyle(color: accent, ),),
content: Text("OTP has been sent to your E-Mail",style: TextStyle(color: activehead, ),),
      actions: [
        notnowButton,

      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

