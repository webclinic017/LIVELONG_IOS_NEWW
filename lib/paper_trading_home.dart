import 'dart:async';


import 'package:flutter/material.dart';

import 'package:livelong/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'ResetPassword.dart';
import 'colors.dart';


class PaperTrading extends StatefulWidget {
  @override
  _PaperTradingState createState() => new _PaperTradingState();
}

class _PaperTradingState extends State<PaperTrading> {
  bool show_chart = false;
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

  @override
  Widget build(BuildContext context) {
    var data = [
      ClicksPerYear(100, 500, Colors.red),
      ClicksPerYear(200, 500, Colors.yellow),
      ClicksPerYear(300, 755, Colors.green),
      ClicksPerYear(400, 770, Colors.pink),
      ClicksPerYear(500, 790, Colors.white),
      ClicksPerYear(600, 810, Colors.grey),
      ClicksPerYear(700, 850, Colors.orange),
      ClicksPerYear(800, 400, Colors.redAccent),
      ClicksPerYear(900, 350, Colors.blue),


    ];

    var series = [
      charts.Series(

        domainFn: (ClicksPerYear clickData, _) => clickData.year,
        measureFn: (ClicksPerYear clickData, _) => clickData.clicks,
        colorFn: (ClicksPerYear clickData, _) => clickData.color,
        id: 'Clicks',
        data: data,
      ),
    ];

    /*var chart = charts.BarChart(
      series,
      animate: true,
    );*/
    var linchart = charts.LineChart(series,animate: true);

    var chartWidget = Padding(
      padding: EdgeInsets.all(32.0),
      child: SizedBox(
        height: 450.0,
        child: linchart,
      ),
    );
    return Scaffold(

        key: scaffold_state,
        backgroundColor: bg,
      appBar: AppBar(
        

        backgroundColor:accent ,

        iconTheme: IconThemeData(color: Colors.black,),
        title: Center(
        child: Padding(
          padding: const EdgeInsets.only(left:18.0,right: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(width: 15,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Watchlist',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black),),

                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.arrow_upward_sharp,color: Colors.black,size: 28,),
                  SizedBox(width: 15,),
                  Icon(Icons.add_circle_outline,color: Colors.black,size: 28,),

                ],
              ),
            ],
          ),
        ),
      ),),
        body: WillPopScope(
          onWillPop: onWillPop,
          child: SafeArea(
            child: show_chart ?Column(children: [
              Container(
                height: 60,
                color: accent,

                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left:12.0,right: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Row(
                              children: [
                                InkWell(
                                    onTap: (){
                                      setState(() {
                                        show_chart=false;
                                      });
                                    },
                                    child: Icon(Icons.arrow_back,size: 35,)),
                                SizedBox(width: 20,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Text('AXIS BANK',style: TextStyle(color: Colors.black,fontSize: 18),),
                                    Text('NSE EQ',style: TextStyle(color: Colors.black,fontSize: 13),),

                                  ],
                                )
                              ],
                            ),
                            Row(
                              children: [

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text('₹ 45686.25',style: TextStyle(color: Colors.green,fontSize: 18),),
                                    Text('+ 276.25 (1.14%)',style: TextStyle(color: Colors.black,fontSize: 14),),

                                  ],
                                )
                              ],
                            )
                          ],
                        ),

                      ],
                    ),
                  ),
                ),


              ),
               chartWidget




            ],): Column(
              children: <Widget>[
                Container(
                  height: 50,
                  color: Colors.black87,

                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left:12.0,right: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                            Row(
                              children: [
                                Text('SENSEX',style: TextStyle(color: Colors.white,fontSize: 18),),
                                SizedBox(width: 15,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('₹ 34875.25',style: TextStyle(color: Colors.white,fontSize: 15),),
                                    Text('+ 345.25 (1.14%)',style: TextStyle(color: Colors.green,fontSize: 11),),

                                  ],
                                )
                              ],
                            ),
                              Row(
                                children: [
                                  Text('NIFTY',style: TextStyle(color: Colors.white,fontSize: 18),),
                                  SizedBox(width: 15,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,

                                    children: [
                                      Text('₹ 45686.25',style: TextStyle(color: Colors.white,fontSize: 15),),
                                      Text('+ 276.25 (1.14%)',style: TextStyle(color: Colors.green,fontSize: 11),),

                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),


                ),
                Expanded(
                  child: ListView.builder(itemCount:10,itemBuilder: (context, index){
                    return InkWell(
                      onTap: (){
                        setState(() {
                          show_chart=true;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left:12.0,right: 12),
                        child: Card(
                          child: Container(
                            height: 60,
                            color: Colors.grey[200],

                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(left:12.0,right: 12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                      children: [
                                        Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('AXIS BANK',style: TextStyle(color: Colors.black,fontSize: 18),),
                                                Text('NSE EQ',style: TextStyle(color: Colors.black,fontSize: 13),),

                                              ],
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [

                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,

                                              children: [
                                                Text('₹ 45686.25',style: TextStyle(color: Colors.black,fontSize: 18),),
                                                Text('+ 276.25 (1.14%)',style: TextStyle(color: Colors.green,fontSize: 14),),

                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    ),

                                  ],
                                ),
                              ),
                            ),


                          ),
                        ),
                      ),
                    );
                  }, scrollDirection: Axis.vertical,),
                ),





              ],
            )
          ),
        ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: accent,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
    );
  }


}

class ClicksPerYear {
  final int year;
  final int clicks;
  final charts.Color color;

  ClicksPerYear(this.year, this.clicks, Color color)
      : this.color = new charts.Color(
      r: color.red, g: color.green, b: color.blue, a: color.alpha);
}