

import 'package:flutter/material.dart';
import 'package:livelong/colors.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'api_constants.dart';


class Resetpassword extends StatefulWidget {
  @override
  _ResetpasswordState createState() => _ResetpasswordState();
}

class _ResetpasswordState extends State<Resetpassword> {

  GlobalKey<ScaffoldState> scaffold_state = new GlobalKey<ScaffoldState>();
  //FToast fToast;

  TextEditingController oldpasswordController = TextEditingController();
  TextEditingController newpasswordController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    /*  fToast = FToast();
    fToast.init(context);*/


    super.initState();
  }
  bool _isRegistering = false;
  var userId;
  var dev_id;
  Future <String> resetPswd() async {
    var base_url=APIS.base_url;
setState(() {
  _isRegistering =true;
});
SharedPreferences prefs = await SharedPreferences.getInstance();
setState(() {
  userId = prefs.getString('user_id');
  dev_id=prefs.getString('dev_id');
});
    var body = {
      'user_id' : '$userId',
      'device_id' : '$dev_id',
      'old_password' : '${oldpasswordController.text}',
      'new_password' : '${newpasswordController.text}',
    };
    var url =
        '$base_url/api/httprequest/reset_password';
    var response = await http.post(url, body: body);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    Navigator.of(context).pop();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffold_state,
      resizeToAvoidBottomInset : false,
      backgroundColor:bg,
      body: SafeArea(
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
                        Text("Reset Password", style: TextStyle(
                            fontSize: 24,
                            color: activehead,
                            fontFamily: 'Poppins-Semibold'
                        ),),
                      ],
                    ),
                  ),


                  Container(
                    padding: EdgeInsets.only(left: 12,right: 12,top: 12, bottom: 12),
                    width: double.infinity,

                    child: Row(
                      children: [

                        Expanded(
                          child: TextFormField(
                            obscureText: true,
                            controller: newpasswordController,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              // border: InputBorder.none,
                              prefixIcon: Icon(Icons.lock,color: accent,),
                              hintText: "New Password",
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
                            controller: oldpasswordController,
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
                              suffixText: 'Forgot!',
                              suffixStyle: TextStyle(color: activebody),
                              prefixIcon: Icon(Icons.lock,color: accent,),
                              hintText: "Old Password",
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
                     resetPswd();
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
                              : Text("Reset",
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







            ],
          ),
        ),
      ),
    );
  }

  void openSignUpPage()
  {
    //Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpPage()));
    /*  Navigator.of(context).pushAndRemoveUntil(

      MaterialPageRoute(
        builder: (BuildContext context) => SignUpPage(),
      ),
          (Route route) => false,
    );*/
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
    // backgroundColor:yellow ,
    content: Text('Failed to Login',style: TextStyle(color: Colors.black),),
    duration: snackBarDuration,
  );
}

