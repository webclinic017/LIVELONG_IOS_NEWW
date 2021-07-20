import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'api_constants.dart';
import 'colors.dart';
import 'package:http/http.dart'as http;
import 'package:webview_flutter/webview_flutter.dart';

class AlgoDetail extends StatefulWidget {
  var buy_sell,id,expire,tade_accept;
  var title;
  var EP;
  var SL;
  var TP;
  var publish_date;
  var trade_duration;
  var notes;


  AlgoDetail({this.buy_sell, this.title, this.EP,this.SL, this.TP,this.id,this.expire,this.tade_accept,
    this.publish_date, this.trade_duration, this.notes});

  @override
  _AlgoDetailState createState() => _AlgoDetailState(buy_sell: buy_sell,title: title,EP: EP,SL: SL,TP: TP,id: id,expire: expire,
  tade_accept: tade_accept,publish_date: publish_date,trade_duration: trade_duration,notes: notes);
}

class _AlgoDetailState extends State<AlgoDetail> {
  var buy_sell,id,expire,tade_accept;
  var title;
  var EP;
  var SL;
  var TP;
  var publish_date;
  var trade_duration;
  var notes;


  _AlgoDetailState({this.buy_sell, this.title, this.EP,this.SL, this.TP,this.id,this.expire,this.tade_accept,
    this.publish_date, this.trade_duration, this.notes});


  GlobalKey<ScaffoldState> scaffold_state = new GlobalKey<ScaffoldState>();
  var userId,dev_id;
  @override
  void initState() {
    // TODO: implement initState
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffold_state,
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left:18.0,right: 18,top: 18),
                child: InkWell(
                  onTap: (){
                    Navigator.of(context).pop(true);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.arrow_back,color: accent,size: 30,)
                    ],
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(left:18.0,right: 18,top: 18),
                  child: Column(
                    children: [
                      Card(
                        color: selectiontabbg,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: Container(

                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child:Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 22,left: 27,right: 23),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('$title',style: TextStyle(color: Colors.white,fontFamily: 'Poppins-Semibold',
                                                fontSize: 14),),
                                            SizedBox(height: 5,),
                                            Row(

                                              children: [
                                                buy_sell.toString().toLowerCase()=="buy"?
                                                Container(height: 13,width: 26,
                                                  decoration: BoxDecoration(color: Color(0xff0CAB61),
                                                      borderRadius: BorderRadius.all(Radius.circular(4))),
                                                  child: Center(
                                                    child: Text('Buy',style: TextStyle(color: Colors.white,fontFamily: 'Poppins-Semibold',
                                                        fontSize: 8),),
                                                  ),
                                                ):
                                                Container(height: 13,width: 26,
                                                  decoration: BoxDecoration(color: Colors.red,
                                                      borderRadius: BorderRadius.all(Radius.circular(4))),
                                                  child: Center(
                                                    child: Text('Sell',style: TextStyle(color: Colors.white,fontFamily: 'Poppins-Semibold',
                                                        fontSize: 8),),
                                                  ),
                                                ),
                                                SizedBox(width: 6,),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(('Published on : $publish_date').substring(0,34),style: TextStyle(color: Color(0xff888888),fontFamily: 'Poppins-Semibold',
                                                        fontSize: 8),),
                                                    Text('Trade Duration : $trade_duration',style: TextStyle(color: Color(0xff888888),fontFamily: 'Poppins-Semibold',
                                                        fontSize: 8),),
                                                  ],
                                                ),

                                              ],
                                            )
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text('Expire In',style: TextStyle(color: Color(0xff888888),fontFamily: 'Poppins-Semibold',
                                                fontSize: 7),),
                                            Text((expire == "Expired")?"Expired":convertToDayHoursMin(int.parse(expire)),style: TextStyle(color: Colors.white,fontFamily: 'Poppins-Semibold',
                                                fontSize: 9),),
                                            SizedBox(height: 5,),
                                            /* Row(

                                                                        children: [
                                                                          Container(height: 3,width: 3,
                                                                            decoration: BoxDecoration(color: Color(0xff0CAB61),
                                                                                shape: BoxShape.circle),

                                                                          ),
                                                                          SizedBox(width: 3,),
                                                                          Text('Activated',style: TextStyle(color: Color(0xff888888),fontFamily: 'Poppins-Semibold',
                                                                              fontSize: 7),),

                                                                        ],
                                                                      )*/
                                          ],
                                        )

                                      ],
                                    ),
                                    SizedBox(height: 17,),
                                    Divider(
                                      color: Color(0xff4A4A4A,),
                                      thickness: 1.5,
                                    ),
                                    SizedBox(height: 16,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [

                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Entry Price',style: TextStyle(color: Color(0xffA8A8A8),fontFamily: 'Poppins-Semibold',
                                                fontSize: 9),),
                                            SizedBox(height: 5,),
                                            Row(

                                              children: [

                                                Text('$EP',style: TextStyle(color: Colors.white,fontFamily: 'Poppins-Semibold',
                                                    fontSize: 12),),

                                              ],
                                            )
                                          ],
                                        )

                                      ],
                                    ),
                                    SizedBox(height: 20,),
                                    Row(
                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TP=='0'?Container():
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Target Price',style: TextStyle(color: Color(0xffA8A8A8),fontFamily: 'Poppins-Semibold',
                                                fontSize: 9),),
                                            SizedBox(height: 5,),
                                            Row(

                                              children: [

                                                Text('$TP',style: TextStyle(color: Colors.white,fontFamily: 'Poppins-Semibold',
                                                    fontSize: 12),),

                                              ],
                                            )
                                          ],
                                        ),
                                        TP=='0'?Container():
                                        SizedBox(width: 45,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Stop Loss',style: TextStyle(color: Color(0xffA8A8A8),fontFamily: 'Poppins-Semibold',
                                                fontSize: 9),),
                                            SizedBox(height: 5,),
                                            Row(

                                              children: [

                                                Text('$SL',style: TextStyle(color: Colors.white,fontFamily: 'Poppins-Semibold',
                                                    fontSize: 12),),

                                              ],
                                            )
                                          ],
                                        )

                                      ],
                                    ),
                                    SizedBox(height: 26,),

                                  ],
                                ),

                              ),

                            ],
                          ),

                        ),
                      ),

                    ],
                  )
              ),
              Padding(
                padding: const EdgeInsets.only(top:15.0,left: 28,bottom: 0),
                child: Row(
                  children: [
                    Text('Description',style: TextStyle(color: accent,fontFamily: 'Poppins-Bold',fontSize: 18),),
                  ],
                ),
              ),
              SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.only(left: 28,right: 28),
                child: Row(
                  children: [
                    Expanded(

                      child: Text(notes, style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,

                      ),textAlign: TextAlign.left,),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.only(top:15.0,left: 28,bottom: 25),
                child: Row(
                  children: [
                    Text('Chart',style: TextStyle(color: accent,fontFamily: 'Poppins-Bold',fontSize: 18),),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left:18.0,right: 18,bottom: 18),
                child: Container(
                  height: MediaQuery.of(context).size.height*0.3,
                  child: WebView(
                    initialUrl: 'https://in.tradingview.com/chart/?symbol=NSE%3A$title',
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (WebViewController webViewController) {
                      _controller.complete(webViewController);
                    },
                    onProgress: (int progress) {
                      print("WebView is loading (progress : $progress%)");
                    },

                    navigationDelegate: (NavigationRequest request) {
                      if (request.url.startsWith('https://www.youtube.com/')) {
                        print('blocking navigation to $request}');
                        return NavigationDecision.prevent;
                      }
                      print('allowing navigation to $request');
                      return NavigationDecision.navigate;
                    },
                    onPageStarted: (String url) {
                      print('Page started loading: $url');
                    },
                    onPageFinished: (String url) {
                      print('Page finished loading: $url');
                    },
                    gestureNavigationEnabled: true,
                  )

                ),
              ),

              SizedBox(height: 10,),
              (expire == "Expired")?InkWell(
                onTap: (){

                },
                child: Container(height: 40,width: 167,
                  decoration: BoxDecoration(color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  child: Center(
                    child: Text('Expired',style: TextStyle(color: Colors.black,fontFamily: 'Poppins-Semibold',
                        fontSize: 14),),
                  ),
                ),
              ):
              InkWell(
                onTap: (){

                  show_alet(buy_sell,
                      id, expire,
                      tade_accept, title,
                      EP, SL, TP,0);

                },
                child:
                tade_accept==false?
                Container(height: 40,width: 167,
                  decoration: BoxDecoration(color: accent,
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  child: Center(
                    child: Text('Accept Order',style: TextStyle(color: Colors.black,fontFamily: 'Poppins-Semibold',
                        fontSize: 14),),
                  ),
                ):Container(height: 40,width: 167,
                  decoration: BoxDecoration(color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  child: Center(
                    child: Text('Cancel Order',style: TextStyle(color: Colors.white,fontFamily: 'Poppins-Semibold',
                        fontSize: 14),),
                  ),
                ),
              ),
              SizedBox(height: 30,),
            ],
          ),
        ),
      ),
    );
  }
  void showLoadingIndicator() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async => false,
            child:SizedBox(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0))
                      ),
                      backgroundColor: Colors.white,
                      content: Column(
                        children: [
                          CircularProgressIndicator(),
                        ],
                      )
                  ),
                ],
              ),
            )
        );
      },
    );

  }
  show_alet( var buy_sell,id,expire,tade_accept,title,EP,SL,TP,index){

    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)), //this right here
      child: Container(
        height: 374.0,
        width: 301.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          color: selectiontabbg,
        ),


        child:Padding(
          padding: const EdgeInsets.only(top: 10,left: 32,right: 28,),
          child: Column(
            children: [
              Text('Are you sure to accept this trade now?',style: TextStyle(color: Colors.white,fontFamily: 'Poppins-Semibold',
                  fontSize: 16,letterSpacing: 0.4),textAlign: TextAlign.center,),
              SizedBox(height: 12,),
              Divider(
                color: Color(0xff4A4A4A,),
                thickness: 1.5,
              ),
              SizedBox(height: 12,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$title',style: TextStyle(color: Colors.white,fontFamily: 'Poppins-Semibold',
                          fontSize: 14),),
                      SizedBox(height: 5,),
                      Row(

                        children: [

                          Text(' 1-Month',style: TextStyle(color: Color(0xff888888),fontFamily: 'Poppins-Semibold',
                              fontSize: 8),),

                        ],
                      )
                    ],
                  ),


                ],
              ),
              SizedBox(height: 12,),
              Divider(
                color: Color(0xff4A4A4A,),
                thickness: 1.5,
              ),
              SizedBox(height: 16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Entry Price',style: TextStyle(color: Color(0xffA8A8A8),fontFamily: 'Poppins-Semibold',
                          fontSize: 9),),
                      SizedBox(height: 5,),
                      Row(

                        children: [

                          Text('$EP',style: TextStyle(color: Colors.white,fontFamily: 'Poppins-Semibold',
                              fontSize: 12),),

                        ],
                      )
                    ],
                  )

                ],
              ),
              SizedBox(height: 15,),
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Target Price',style: TextStyle(color: Color(0xffA8A8A8),fontFamily: 'Poppins-Semibold',
                          fontSize: 9),),
                      SizedBox(height: 5,),
                      Row(

                        children: [

                          Text('$TP',style: TextStyle(color: Colors.white,fontFamily: 'Poppins-Semibold',
                              fontSize: 12),),

                        ],
                      )
                    ],
                  ),
                  SizedBox(width: 45,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Stop Loss',style: TextStyle(color: Color(0xffA8A8A8),fontFamily: 'Poppins-Semibold',
                          fontSize: 9),),
                      SizedBox(height: 5,),
                      Row(

                        children: [

                          Text('$SL',style: TextStyle(color: Colors.white,fontFamily: 'Poppins-Semibold',
                              fontSize: 12),),

                        ],
                      )
                    ],
                  )

                ],
              ),
              SizedBox(height: 15,),
              Divider(
                color: Color(0xff4A4A4A,),
                thickness: 1.5,
              ),
              SizedBox(height: 20,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  tade_accept==false?
                  InkWell(
                    onTap: (){
                      //show_alet();
                      Navigator.of(context, rootNavigator: true).pop();
                      accept_trade(id).then((value) {
                       /* setState(() {
                          print("MMYYYVVAAALL   $value");
                          if(value=="true"){
                            setState(() {
                             tade_accept=true;
                            });
                          }
                        });*/
                      });

                    },
                    child: Container(height: 24,width: 116,
                      decoration: BoxDecoration(color: accent,
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      child: Center(
                        child: Text('Accept Trade',style: TextStyle(color: Colors.black,fontFamily: 'Poppins-Semibold',
                            fontSize: 8),),
                      ),
                    ),
                  ):
                  InkWell(
                    onTap: (){
                      //show_alet();
                      Navigator.of(context, rootNavigator: true).pop();
                      cancel_trade(id).then((value) {
                       /* setState(() {
                          print("MMYYYVVAAALL   $value");
                          if(value=="true"){
                            setState(() {
                             tade_accept=false;
                            });
                          }
                        });*/
                      });

                    },
                    child: Container(height: 24,width: 116,
                      decoration: BoxDecoration(color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      child: Center(
                        child: Text('Cancel Order',style: TextStyle(color: Colors.white,fontFamily: 'Poppins-Semibold',
                            fontSize: 8),),
                      ),
                    ),
                  ),
                  SizedBox(width: 26,),
                  InkWell(
                    onTap: (){
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: Text('Cancel',style: TextStyle(color: Color(0xffA8A8A8),fontFamily: 'Poppins-Semibold',
                        fontSize: 10),),
                  ),
                ],
              ),

            ],
          ),
        ) ,
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => errorDialog);
  }
  Future <String> accept_trade(var trade_id) async {
    showLoadingIndicator();
    var base_url=APIS.base_url;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('user_id');
      dev_id=prefs.getString('dev_id');
    });
    var body = {
      'user_id' : '$userId',
      'device_id' : '$dev_id',
      'trade_id' :'$trade_id'
    };
    var url =
        '$base_url/api/httprequest/trade_accept';
    var response = await http.post(url, body: body);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if(response.body.contains('"status_code":"200"')){


      Navigator.of(context, rootNavigator: true).pop();
      setState(() {
        tade_accept=true;
      });
      show_alert_success();
      return "true";


    }else{
      print('fail');
      Navigator.of(context, rootNavigator: true).pop();
      scaffold_state.currentState.showSnackBar(SnackBar(
        backgroundColor: accent,
        content: Text("failed to accept trade, date expired",style: TextStyle(color: bg),),
      ));
      return "false";
    }

  }
  Future <String> cancel_trade(var trade_id) async {
    showLoadingIndicator();
    var base_url=APIS.base_url;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('user_id');
      dev_id=prefs.getString('dev_id');
    });
    var body = {
      'user_id' : '$userId',
      'device_id' : '$dev_id',
      'tc_id' :'$trade_id'
    };
    var url =
        '$base_url/api/httprequest/cancel_trade_accept';
    var response = await http.post(url, body: body);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if(response.body.contains('"status_code":"200"')){


      Navigator.of(context, rootNavigator: true).pop();
      setState(() {
        tade_accept=false;
      });
      show_alert_fail();
      return "true";


    }else{
      print('fail');
      Navigator.of(context, rootNavigator: true).pop();
      scaffold_state.currentState.showSnackBar(SnackBar(
        backgroundColor: accent,
        content: Text("failed to cancel trade",style: TextStyle(color: bg),),
      ));
      return "false";
    }

  }
  show_alert_success( ){

    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)), //this right here
      child: Container(
        height: 374.0,
        width: 301.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          color: selectiontabbg,
        ),


        child:Padding(
          padding: const EdgeInsets.only(top: 10,left: 32,right: 28,),
          child: Column(
            children: [
              SizedBox(height: 48,),
              Container(
                height: 83,
                width: 78,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image:AssetImage( "assets/images/Group 18.png")
                    )
                ),
              ),
              SizedBox(height: 17,),
              Divider(
                color: Color(0xff4A4A4A,),
                thickness: 1.5,
              ),
              SizedBox(height: 29,),
              Text('Your trade is executed successfully.',style: TextStyle(color: Colors.white,fontFamily: 'Poppins-Semibold',
                  fontSize: 16,letterSpacing: 0.4),textAlign: TextAlign.center,),
              SizedBox(height: 10,),
              Text('Find your executed trades in ‘My Trades’.',style: TextStyle(color: Color(0xff969696),fontFamily: 'Poppins-Semibold',
                  fontSize: 10,letterSpacing: 0.4),textAlign: TextAlign.center,),
              SizedBox(height: 38,),
              InkWell(
                onTap: (){
                  //show_alet();
                  Navigator.of(context, rootNavigator: true).pop();

                },
                child: Container(height: 24,width: 168,
                  decoration: BoxDecoration(color: accent,
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  child: Center(
                    child: Text('OK',style: TextStyle(color: Colors.black,fontFamily: 'Poppins-Semibold',
                        fontSize: 8),),
                  ),
                ),
              )



            ],
          ),
        ) ,
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => errorDialog);
  }
  show_alert_fail( ){

    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)), //this right here
      child: Container(
        height: 200.0,
        width: 301.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          color: selectiontabbg,
        ),


        child:Padding(
          padding: const EdgeInsets.only(top: 10,left: 32,right: 28,),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text('Your trade is cancelled successfully.',style: TextStyle(color: Colors.white,fontFamily: 'Poppins-Semibold',
                  fontSize: 16,letterSpacing: 0.4),textAlign: TextAlign.center,),
              SizedBox(height: 38,),
              InkWell(
                onTap: (){
                  //show_alet();
                  Navigator.of(context, rootNavigator: true).pop();

                },
                child: Container(height: 24,width: 168,
                  decoration: BoxDecoration(color: accent,
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  child: Center(
                    child: Text('OK',style: TextStyle(color: Colors.black,fontFamily: 'Poppins-Semibold',
                        fontSize: 8),),
                  ),
                ),
              )



            ],
          ),
        ) ,
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => errorDialog);
  }

  String convertToDayHoursMin(int seconds)
  {
    var d = Duration(seconds:seconds);
    List<String> parts = d.toString().split(':');
    print(d.toString());

    return'${parts[0]}hours ${parts[1]}minutes';
  }
}
