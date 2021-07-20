import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:livelong/AlgoDetail.dart';
import 'package:livelong/copy_trade_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_constants.dart';
import 'colors.dart';
class CopyTrade extends StatefulWidget {
  @override
  _CopyTradeState createState() => _CopyTradeState();
}

class _CopyTradeState extends State<CopyTrade> with TickerProviderStateMixin{
var userId,dev_id;
CopyTradeModel copyTradeModel;
List<Trade> stock_suggestion_list=[];
List<Trade> forex_list=[];
List<Trade> shortStraddle_list = [];
List<Forex_List_Model>FLM=[];
List<Stock_List_Model>SLM=[];
List<shortStraddleListModel>SSM = [];
Timer _refreshTimer;
TabController _tabController;

  Future <String> trade_message__list() async {
    var base_url=APIS.base_url;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('user_id');
      dev_id=prefs.getString('dev_id');
    });
    var body = {
      'user_id' : '$userId',
      'device_id' : '$dev_id',
    };
    var url =
        '$base_url/api/httprequest/trade_message_list';
    var response = await http.post(url, body: body);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if(response.body.contains('"status_code":"200"')){
      print('ssssssssssssss');
      stock_suggestion_list=[];
      forex_list=[];
      FLM=[];
      SLM=[];
      SSM = [];
      setState(() {
        var convertPost = json.decode(response.body);
        copyTradeModel = CopyTradeModel.fromJson(convertPost);
      });
      if(copyTradeModel.trade.length!=0)
        {
          for(var i=0;i<copyTradeModel.trade.length;i++)
            {
              if(copyTradeModel.trade[i].category=="Stock Suggestion"){
                setState(() {
                  stock_suggestion_list.add(copyTradeModel.trade[i]);
                  SLM.add(Stock_List_Model(copyTradeModel.trade[i].buySell, copyTradeModel.trade[i].scriptName, copyTradeModel.trade[i].entryPrice, copyTradeModel.trade[i].sl, copyTradeModel.trade[i].tp1, copyTradeModel.trade[i].id,
                      copyTradeModel.trade[i].expireAt, copyTradeModel.trade[i].tradeAccepted, copyTradeModel.trade[i].publishDate, copyTradeModel.trade[i].tradeDuration, copyTradeModel.trade[i].notes,false));

                  //print(message);
                  // if(message.contains("SELL")){
                  //   setState(() {
                  //     buy_sell=str.substring(0,4);
                  //     message=message.substring(4);
                  //
                  //     title=message.substring(0,message.indexOf('Entryprice'));
                  //
                  //     message=message.substring(message.indexOf('Entryprice')+10);
                  //
                  //     EP=message.substring(0,message.indexOf('TP'));
                  //
                  //     message=message.substring(message.indexOf('TP')+2);
                  //
                  //     TP=message.substring(0,message.indexOf('SL'));
                  //
                  //     message=message.substring(message.indexOf('SL')+2);
                  //
                  //     SL=message.substring(0);
                  //     SLM.add(Stock_List_Model(buy_sell, title, EP, SL, TP, copyTradeModel.trade[i].id,
                  //         copyTradeModel.trade[i].expireAt, copyTradeModel.trade[i].tradeAccepted));
                  //
                  //
                  //   });
                  //
                  // }else{
                  //   setState(() {
                  //     buy_sell=str.substring(0,3);
                  //
                  //     message=message.substring(3);
                  //
                  //     title=message.substring(0,message.indexOf('Entryprice'));
                  //
                  //     message=message.substring(message.indexOf('Entryprice')+10);
                  //
                  //     EP=message.substring(0,message.indexOf('TP'));
                  //
                  //     message=message.substring(message.indexOf('TP')+2);
                  //
                  //     TP=message.substring(0,message.indexOf('SL'));
                  //
                  //     message=message.substring(message.indexOf('SL')+2);
                  //
                  //     SL=message.substring(0);
                  //
                  //     SLM.add(Stock_List_Model(buy_sell, title, EP, SL, TP, copyTradeModel.trade[i].id,
                  //         copyTradeModel.trade[i].expireAt, copyTradeModel.trade[i].tradeAccepted));
                  //
                  //
                  //   });
                  // }

                });
              }
              else if(copyTradeModel.trade[i].category=="Forex"){
               setState(() {
                 forex_list.add(copyTradeModel.trade[i]);
                  var tempObj = copyTradeModel.trade[i];
                 FLM.add(Forex_List_Model(tempObj.buySell, tempObj.scriptName, tempObj.entryPrice, tempObj.sl, tempObj.tp1, tempObj.tp2, tempObj.tp3,
                     tempObj.id, tempObj.expireAt, tempObj.tradeAccepted, tempObj.publishDate, tempObj.tradeDuration, tempObj.notes,false));


                 // var buy_sell;
                 // var title;
                 // var EP;
                 // var TP;
                 // var SL;
                 // var TP1='0';
                 // var TP2='0';
                 // var TP3='0';
                 // var str="${copyTradeModel.trade[i].message.toString()}";
                 // var message=str.replaceAll(' ', '');
                 // //print(message);
                 // if(message.contains("SELL")){
                 //   setState(() {
                 //     buy_sell=str.substring(0,4);
                 //     message=message.substring(4);
                 //
                 //     title=message.substring(0,message.indexOf('Entryprice'));
                 //
                 //     message=message.substring(message.indexOf('Entryprice')+10);
                 //
                 //     EP=message.substring(0,message.indexOf('TP1'));
                 //
                 //     message=message.substring(message.indexOf('TP1')+3);
                 //     if(message.contains("TP2")){
                 //       setState(() {
                 //         TP1=message.substring(0,message.indexOf('TP2'));
                 //
                 //         message=message.substring(message.indexOf('TP2')+3);
                 //       });
                 //       if(message.contains("TP3")){
                 //         TP2=message.substring(0,message.indexOf('TP3'));
                 //
                 //         message=message.substring(message.indexOf('TP3')+3);
                 //         TP3=message.substring(0,message.indexOf('SL'));
                 //
                 //         message=message.substring(message.indexOf('SL')+2);
                 //         SL=message.substring(0);
                 //         FLM.add(Forex_List_Model(buy_sell, title, EP, SL, TP1, TP2, TP3,
                 //             copyTradeModel.trade[i].id, copyTradeModel.trade[i].expireAt, copyTradeModel.trade[i].tradeAccepted));
                 //
                 //       }else{
                 //         TP2=message.substring(0,message.indexOf('SL'));
                 //
                 //         message=message.substring(message.indexOf('SL')+2);
                 //         SL=message.substring(0);
                 //         FLM.add(Forex_List_Model(buy_sell, title, EP, SL, TP1, TP2, TP3,
                 //             copyTradeModel.trade[i].id, copyTradeModel.trade[i].expireAt, copyTradeModel.trade[i].tradeAccepted));
                 //
                 //       }
                 //     }
                 //
                 //     else{
                 //       setState(() {
                 //         TP1=message.substring(0,message.indexOf('SL'));
                 //
                 //         message=message.substring(message.indexOf('SL')+2);
                 //         SL=message.substring(0);
                 //         FLM.add(Forex_List_Model(buy_sell, title, EP, SL, TP1, TP2, TP3,
                 //             copyTradeModel.trade[i].id, copyTradeModel.trade[i].expireAt, copyTradeModel.trade[i].tradeAccepted));
                 //
                 //       });
                 //     }

                 //
                 //
                 //
                 //   });
                 //
                 // }else{
                 //   setState(() {
                 //     buy_sell=str.substring(0,3);
                 //
                 //     message=message.substring(3);
                 //
                 //     title=message.substring(0,message.indexOf('Entryprice'));
                 //
                 //     message=message.substring(message.indexOf('Entryprice')+10);
                 //
                 //     EP=message.substring(0,message.indexOf('TP1'));
                 //
                 //     message=message.substring(message.indexOf('TP1')+3);
                 //     if(message.contains("TP2")){
                 //       setState(() {
                 //         TP1=message.substring(0,message.indexOf('TP2'));
                 //
                 //         message=message.substring(message.indexOf('TP2')+3);
                 //       });
                 //       if(message.contains("TP3")){
                 //         TP2=message.substring(0,message.indexOf('TP3'));
                 //
                 //         message=message.substring(message.indexOf('TP3')+3);
                 //         TP3=message.substring(0,message.indexOf('SL'));
                 //
                 //         message=message.substring(message.indexOf('SL')+2);
                 //         SL=message.substring(0);
                 //         FLM.add(Forex_List_Model(buy_sell, title, EP, SL, TP1, TP2, TP3,
                 //             copyTradeModel.trade[i].id, copyTradeModel.trade[i].expireAt, copyTradeModel.trade[i].tradeAccepted));
                 //
                 //       }else{
                 //         TP2=message.substring(0,message.indexOf('SL'));
                 //
                 //         message=message.substring(message.indexOf('SL')+2);
                 //         SL=message.substring(0);
                 //         FLM.add(Forex_List_Model(buy_sell, title, EP, SL, TP1, TP2, TP3,
                 //             copyTradeModel.trade[i].id, copyTradeModel.trade[i].expireAt, copyTradeModel.trade[i].tradeAccepted));
                 //
                 //       }
                 //     }else{
                 //       setState(() {
                 //         TP1=message.substring(0,message.indexOf('SL'));
                 //
                 //         message=message.substring(message.indexOf('SL')+2);
                 //         SL=message.substring(0);
                 //         FLM.add(Forex_List_Model(buy_sell, title, EP, SL, TP1, TP2, TP3,
                 //             copyTradeModel.trade[i].id, copyTradeModel.trade[i].expireAt, copyTradeModel.trade[i].tradeAccepted));
                 //
                 //       });
                 //     }
                 //
                 //   });
                 // }
               });
              }
              else if(copyTradeModel.trade[i].category=="Short Traddle"){
                setState(() {
                  shortStraddle_list.add(copyTradeModel.trade[i]);
                  var tempObj = copyTradeModel.trade[i];
                  SSM.add(shortStraddleListModel(tempObj.buySell, tempObj.scriptName, tempObj.entryPrice, tempObj.sl, tempObj.id, tempObj.expireAt, tempObj.tradeAccepted, tempObj.publishDate, tempObj.tradeFixedDuration, tempObj.notes,false));


                  // var buy_sell;
                  // var title;
                  // var EP;
                  // var TP;
                  // var SL;
                  // var TP1='0';
                  // var TP2='0';
                  // var TP3='0';
                  // var str="${copyTradeModel.trade[i].message.toString()}";
                  // var message=str.replaceAll(' ', '');
                  // //print(message);
                  // if(message.contains("SELL")){
                  //   setState(() {
                  //     buy_sell=str.substring(0,4);
                  //     message=message.substring(4);
                  //
                  //     title=message.substring(0,message.indexOf('Entryprice'));
                  //
                  //     message=message.substring(message.indexOf('Entryprice')+10);
                  //
                  //     EP=message.substring(0,message.indexOf('TP1'));
                  //
                  //     message=message.substring(message.indexOf('TP1')+3);
                  //     if(message.contains("TP2")){
                  //       setState(() {
                  //         TP1=message.substring(0,message.indexOf('TP2'));
                  //
                  //         message=message.substring(message.indexOf('TP2')+3);
                  //       });
                  //       if(message.contains("TP3")){
                  //         TP2=message.substring(0,message.indexOf('TP3'));
                  //
                  //         message=message.substring(message.indexOf('TP3')+3);
                  //         TP3=message.substring(0,message.indexOf('SL'));
                  //
                  //         message=message.substring(message.indexOf('SL')+2);
                  //         SL=message.substring(0);
                  //         FLM.add(Forex_List_Model(buy_sell, title, EP, SL, TP1, TP2, TP3,
                  //             copyTradeModel.trade[i].id, copyTradeModel.trade[i].expireAt, copyTradeModel.trade[i].tradeAccepted));
                  //
                  //       }else{
                  //         TP2=message.substring(0,message.indexOf('SL'));
                  //
                  //         message=message.substring(message.indexOf('SL')+2);
                  //         SL=message.substring(0);
                  //         FLM.add(Forex_List_Model(buy_sell, title, EP, SL, TP1, TP2, TP3,
                  //             copyTradeModel.trade[i].id, copyTradeModel.trade[i].expireAt, copyTradeModel.trade[i].tradeAccepted));
                  //
                  //       }
                  //     }
                  //
                  //     else{
                  //       setState(() {
                  //         TP1=message.substring(0,message.indexOf('SL'));
                  //
                  //         message=message.substring(message.indexOf('SL')+2);
                  //         SL=message.substring(0);
                  //         FLM.add(Forex_List_Model(buy_sell, title, EP, SL, TP1, TP2, TP3,
                  //             copyTradeModel.trade[i].id, copyTradeModel.trade[i].expireAt, copyTradeModel.trade[i].tradeAccepted));
                  //
                  //       });
                  //     }

                  //
                  //
                  //
                  //   });
                  //
                  // }else{
                  //   setState(() {
                  //     buy_sell=str.substring(0,3);
                  //
                  //     message=message.substring(3);
                  //
                  //     title=message.substring(0,message.indexOf('Entryprice'));
                  //
                  //     message=message.substring(message.indexOf('Entryprice')+10);
                  //
                  //     EP=message.substring(0,message.indexOf('TP1'));
                  //
                  //     message=message.substring(message.indexOf('TP1')+3);
                  //     if(message.contains("TP2")){
                  //       setState(() {
                  //         TP1=message.substring(0,message.indexOf('TP2'));
                  //
                  //         message=message.substring(message.indexOf('TP2')+3);
                  //       });
                  //       if(message.contains("TP3")){
                  //         TP2=message.substring(0,message.indexOf('TP3'));
                  //
                  //         message=message.substring(message.indexOf('TP3')+3);
                  //         TP3=message.substring(0,message.indexOf('SL'));
                  //
                  //         message=message.substring(message.indexOf('SL')+2);
                  //         SL=message.substring(0);
                  //         FLM.add(Forex_List_Model(buy_sell, title, EP, SL, TP1, TP2, TP3,
                  //             copyTradeModel.trade[i].id, copyTradeModel.trade[i].expireAt, copyTradeModel.trade[i].tradeAccepted));
                  //
                  //       }else{
                  //         TP2=message.substring(0,message.indexOf('SL'));
                  //
                  //         message=message.substring(message.indexOf('SL')+2);
                  //         SL=message.substring(0);
                  //         FLM.add(Forex_List_Model(buy_sell, title, EP, SL, TP1, TP2, TP3,
                  //             copyTradeModel.trade[i].id, copyTradeModel.trade[i].expireAt, copyTradeModel.trade[i].tradeAccepted));
                  //
                  //       }
                  //     }else{
                  //       setState(() {
                  //         TP1=message.substring(0,message.indexOf('SL'));
                  //
                  //         message=message.substring(message.indexOf('SL')+2);
                  //         SL=message.substring(0);
                  //         FLM.add(Forex_List_Model(buy_sell, title, EP, SL, TP1, TP2, TP3,
                  //             copyTradeModel.trade[i].id, copyTradeModel.trade[i].expireAt, copyTradeModel.trade[i].tradeAccepted));
                  //
                  //       });
                  //     }
                  //
                  //   });
                  // }
                });
              }
              else{
                print("Nothing to add");
              }
            }
        }


    }else{
      
      print('fail');

    }
    setState(() {
      page_loaded=true;
    });
  }
  void refreshTrade()
  {

   trade_message__list();
  }

GlobalKey<ScaffoldState> scaffold_state = new GlobalKey<ScaffoldState>();
@override
  void initState() {
    // TODO: implement initState
  _tabController = new TabController(length: 2, vsync: this);
    super.initState();
    trade_message__list();
    _refreshTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      print("hi");
      refreshTrade();

    });
  }
  bool page_loaded=false;


@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _refreshTimer.cancel();
    _tabController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // Full screen width and height
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

// Height (without SafeArea)
    var padding = MediaQuery.of(context).padding;
    double height1 = height - padding.top - padding.bottom;

// Height (without status bar)
    double height2 = height - padding.top;

// Height (without status and toolbar)
    double height3 = height - padding.top - kToolbarHeight - padding.bottom;
    return Scaffold(
        key: scaffold_state,
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: selectiontabbg,
          title:  Center(child: Text('Algo Trade',style: TextStyle(color: Colors.white,fontFamily: 'Poppins-Semibold',fontSize: 18,letterSpacing: 1.5),)),
          automaticallyImplyLeading: false,
          titleSpacing: 0,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width/1.3,
                child: TabBar(

                  controller: _tabController,
                  indicatorColor: accent,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: [
                    Tab(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("Stocks", style: TextStyle(
                            color: accent
                        ),),
                      ),
                    ),
                    Tab(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("Forex", style: TextStyle(
                            color: accent
                        ),),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          page_loaded==false?Container(
                              width: width,
                              height: height3,
                              child: Center(child: CircularProgressIndicator())):
                          SLM.length==0&&SSM.length==0?
                              Container(
                                  width: width,
                                  height: height3-200,child: Center(child: Text('No Records Found',style: TextStyle(color: accent,fontFamily: 'Poppins-Bold',fontSize: 18),))):
                          Column(
                            children: [
                              SLM.length==0?Container():
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top:15.0,left: 28),
                                    child: Row(
                                      children: [
                                        Text('Stock Suggestion',style: TextStyle(color: accent,fontFamily: 'Poppins-Bold',fontSize: 18),),
                                      ],
                                    ),
                                  ),
                                  ListView.builder(
                                    itemCount:SLM.length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index){
                                    return  Padding(
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
                                                                  Text('${SLM[index].title}',style: TextStyle(color: Colors.white,fontFamily: 'Poppins-Semibold',
                                                                      fontSize: 14),),
                                                                  SizedBox(height: 5,),
                                                                  Row(

                                                                    children: [
                                                                      SLM[index].buy_sell.toString().toLowerCase()=="buy"?
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
                                                                          Text(('Published on : ${SLM[index].publish_date}').substring(0,34),style: TextStyle(color: Color(0xff888888),fontFamily: 'Poppins-Semibold',
                                                                              fontSize: 8),),
                                                                          Text('Trade Duration : ${SLM[index].trade_duration}',style: TextStyle(color: Color(0xff888888),fontFamily: 'Poppins-Semibold',
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
                                                                  Text((SLM[index].expire == "Expired")?"Expired":convertToDayHoursMin(int.parse(SLM[index].expire)),style: TextStyle(color: Colors.white,fontFamily: 'Poppins-Semibold',
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

                                                                      Text('${SLM[index].EP}',style: TextStyle(color: Colors.white,fontFamily: 'Poppins-Semibold',
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

                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text('Target Price',style: TextStyle(color: Color(0xffA8A8A8),fontFamily: 'Poppins-Semibold',
                                                                      fontSize: 9),),
                                                                  SizedBox(height: 5,),
                                                                  Row(

                                                                    children: [

                                                                      Text('${SLM[index].TP}',style: TextStyle(color: Colors.white,fontFamily: 'Poppins-Semibold',
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

                                                                      Text('${SLM[index].SL}',style: TextStyle(color: Colors.white,fontFamily: 'Poppins-Semibold',
                                                                          fontSize: 12),),

                                                                    ],
                                                                  )
                                                                ],
                                                              )

                                                            ],
                                                          ),
                                                          SizedBox(height: 26,),
                                                          Divider(
                                                            color: Color(0xff4A4A4A,),
                                                            thickness: 1.5,
                                                          ),
                                                          SizedBox(height: 27,),
                                                          (SLM[index].expire == "Expired")?InkWell(
                                                            onTap: (){
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(builder: (context) => AlgoDetail(
                                                                    buy_sell: SLM[index].buy_sell,
                                                                    title: SLM[index].title,EP: SLM[index].EP,SL: SLM[index].SL,
                                                                    TP: SLM[index].TP,id: SLM[index].id,expire: SLM[index].expire,
                                                                    tade_accept: SLM[index].tade_accept,publish_date: SLM[index].publish_date,
                                                                    trade_duration: SLM[index].trade_duration,notes: SLM[index].notes
                                                                )),
                                                              );
                                                              /* show_alet(SLM[index].buy_sell,
                                                                SLM[index].id, SLM[index].expire,
                                                                SLM[index].tade_accept, SLM[index].title,
                                                                SLM[index].EP, SLM[index].SL, SLM[index].TP,index);*/

                                                            },
                                                            child: Container(height: 24,width: 167,
                                                              decoration: BoxDecoration(color: Colors.red,
                                                                  borderRadius: BorderRadius.all(Radius.circular(4))),
                                                              child: Center(
                                                                child: Text('Expired',style: TextStyle(color: Colors.black,fontFamily: 'Poppins-Semibold',
                                                                    fontSize: 8),),
                                                              ),
                                                            ),
                                                          ):InkWell(
                                                            onTap: (){
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(builder: (context) => AlgoDetail(
                                                                  buy_sell: SLM[index].buy_sell,
                                                                    title: SLM[index].title,EP: SLM[index].EP,SL: SLM[index].SL,
                                                                    TP: SLM[index].TP,id: SLM[index].id,expire: SLM[index].expire,
                                                                    tade_accept: SLM[index].tade_accept,publish_date: SLM[index].publish_date,
                                                                    trade_duration: SLM[index].trade_duration,notes: SLM[index].notes
                                                                )),
                                                              );
                                                           /* show_alet(SLM[index].buy_sell,
                                                                SLM[index].id, SLM[index].expire,
                                                                SLM[index].tade_accept, SLM[index].title,
                                                                SLM[index].EP, SLM[index].SL, SLM[index].TP,index);*/

                                                            },
                                                            child:
                                                            SLM[index].tade_accept==false?
                                                            Container(height: 24,width: 167,
                                                              decoration: BoxDecoration(color: accent,
                                                                  borderRadius: BorderRadius.all(Radius.circular(4))),
                                                              child: Center(
                                                                child: Text('Accept Order',style: TextStyle(color: Colors.black,fontFamily: 'Poppins-Semibold',
                                                                    fontSize: 8),),
                                                              ),
                                                            ):Container(height: 24,width: 167,
                                                              decoration: BoxDecoration(color: Colors.red,
                                                                  borderRadius: BorderRadius.all(Radius.circular(4))),
                                                              child: Center(
                                                                child: Text('Cancel Order',style: TextStyle(color: Colors.white,fontFamily: 'Poppins-Semibold',
                                                                    fontSize: 8),),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(height: 10,),
                                                          ExpansionTile(

                                                            title: Text("View Details", style: TextStyle(
                                                              color: accent,
                                                              fontSize: 14
                                                            ),),
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets.symmetric(horizontal: 15),
                                                                child: Row(
                                                                  children: [
                                                                    Text(SLM[index].notes, style: TextStyle(
                                                                      color: Colors.white,
                                                                      fontSize: 12,

                                                                    ),),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(height:15)
                                                            ],
                                                            trailing: SLM[index].isxpand==true?Icon(Icons.keyboard_arrow_up,color: accent,)
                                                            :Icon(Icons.keyboard_arrow_down,color: accent,),
                                                            onExpansionChanged: (val){
                                                              setState(() {
                                                                SLM[index].isxpand=val;
                                                              });
                                                            },

                                                            //iconColor: accent,
                                                            //collapsedIconColor: accent,
                                                          )
                                                        ],
                                                      ),

                                                    ),

                                                  ],
                                                ),

                                              ),
                                            ),

                                          ],
                                        )
                                    );
                                  }, scrollDirection: Axis.vertical,)
                                ],
                              ),

                              SSM.length==0?Container():
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top:15.0,left: 28),
                                    child: Row(
                                      children: [
                                        Text('Short Straddle',style: TextStyle(color: accent,fontFamily: 'Poppins-Bold',fontSize: 18),),
                                      ],
                                    ),
                                  ),
                                  ListView.builder(
                                    itemCount:SSM.length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index){
                                      return  Padding(
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
                                                                    Text('${SSM[index].title}',style: TextStyle(color: Colors.white,fontFamily: 'Poppins-Semibold',
                                                                        fontSize: 14),),
                                                                    SizedBox(height: 5,),
                                                                    Row(

                                                                      children: [
                                                                        SSM[index].buy_sell.toString().toLowerCase()=="buy"?
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
                                                                            Text(('Published on : ${SSM[index].publish_date}').substring(0,34),style: TextStyle(color: Color(0xff888888),fontFamily: 'Poppins-Semibold',
                                                                                fontSize: 8),),
                                                                            Text('Trade Duration : ${SSM[index].trade_duration}',style: TextStyle(color: Color(0xff888888),fontFamily: 'Poppins-Semibold',
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
                                                                    SizedBox(height: 5,),
                                                                    Text((SSM[index].expire == "Expired")?"Expired":convertToDayHoursMin(int.parse(SSM[index].expire)),style: TextStyle(color: Colors.white,fontFamily: 'Poppins-Semibold',
                                                                        fontSize: 9),),

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

                                                                        Text('${SSM[index].EP}',style: TextStyle(color: Colors.white,fontFamily: 'Poppins-Semibold',
                                                                            fontSize: 12),),

                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text('Stop Loss',style: TextStyle(color: Color(0xffA8A8A8),fontFamily: 'Poppins-Semibold',
                                                                        fontSize: 9),),
                                                                    SizedBox(height: 5,),
                                                                    Row(

                                                                      children: [

                                                                        Text('${SSM[index].SL}',style: TextStyle(color: Colors.white,fontFamily: 'Poppins-Semibold',
                                                                            fontSize: 12),),

                                                                      ],
                                                                    )
                                                                  ],
                                                                )

                                                              ],
                                                            ),
                                                            SizedBox(height: 20,),
                                                            (SSM[index].expire == "Expired")?InkWell(
                                                              onTap: (){
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(builder: (context) => AlgoDetail(
                                                                      buy_sell: SSM[index].buy_sell,
                                                                      title: SSM[index].title,EP: SSM[index].EP,SL: SSM[index].SL,
                                                                      TP: '0',id: SSM[index].id,expire: SSM[index].expire,
                                                                      tade_accept: SSM[index].tade_accept,publish_date: SSM[index].publish_date,
                                                                      trade_duration: SSM[index].trade_duration,notes: SSM[index].notes
                                                                  )),
                                                                );
                                                                /* show_alet(SLM[index].buy_sell,
                                                                SLM[index].id, SLM[index].expire,
                                                                SLM[index].tade_accept, SLM[index].title,
                                                                SLM[index].EP, SLM[index].SL, SLM[index].TP,index);*/

                                                              },
                                                              child: Container(height: 24,width: 167,
                                                                decoration: BoxDecoration(color: Colors.red,
                                                                    borderRadius: BorderRadius.all(Radius.circular(4))),
                                                                child: Center(
                                                                  child: Text('Expired',style: TextStyle(color: Colors.black,fontFamily: 'Poppins-Semibold',
                                                                      fontSize: 8),),
                                                                ),
                                                              ),
                                                            ):InkWell(
                                                              onTap: (){
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(builder: (context) => AlgoDetail(
                                                                      buy_sell: SSM[index].buy_sell,
                                                                      title: SSM[index].title,EP: SSM[index].EP,SL: SSM[index].SL,
                                                                      TP: '0',id: SSM[index].id,expire: SSM[index].expire,
                                                                      tade_accept: SSM[index].tade_accept,publish_date: SSM[index].publish_date,
                                                                      trade_duration: SSM[index].trade_duration,notes: SSM[index].notes
                                                                  )),
                                                                );
                                                                /* show_alet(SLM[index].buy_sell,
                                                                SLM[index].id, SLM[index].expire,
                                                                SLM[index].tade_accept, SLM[index].title,
                                                                SLM[index].EP, SLM[index].SL, SLM[index].TP,index);*/

                                                              },
                                                              child:
                                                              SSM[index].tade_accept==false?
                                                              Container(height: 24,width: 167,
                                                                decoration: BoxDecoration(color: accent,
                                                                    borderRadius: BorderRadius.all(Radius.circular(4))),
                                                                child: Center(
                                                                  child: Text('Accept Order',style: TextStyle(color: Colors.black,fontFamily: 'Poppins-Semibold',
                                                                      fontSize: 8),),
                                                                ),
                                                              ):Container(height: 24,width: 167,
                                                                decoration: BoxDecoration(color: Colors.red,
                                                                    borderRadius: BorderRadius.all(Radius.circular(4))),
                                                                child: Center(
                                                                  child: Text('Cancel Order',style: TextStyle(color: Colors.white,fontFamily: 'Poppins-Semibold',
                                                                      fontSize: 8),),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(height: 20,),
                                                            ExpansionTile(
                                                              title: Text("View Details", style: TextStyle(
                                                                  color: accent,
                                                                  fontSize: 14
                                                              ),),
                                                              children: [
                                                                Container(
                                                                  margin: EdgeInsets.symmetric(horizontal: 15),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(SSM[index].notes, style: TextStyle(
                                                                        color: Colors.white,
                                                                        fontSize: 12,

                                                                      ),),
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(height:15)
                                                              ],
                                                              trailing: SSM[index].isxpand==true?Icon(Icons.keyboard_arrow_up,color: accent,)
                                                                  :Icon(Icons.keyboard_arrow_down,color: accent,),
                                                              onExpansionChanged: (val){
                                                                setState(() {
                                                                  SSM[index].isxpand=val;
                                                                });
                                                              },

                                                              // iconColor: accent,
                                                              //collapsedIconColor: accent,
                                                            )
                                                          ],
                                                        ),

                                                      ),

                                                    ],
                                                  ),

                                                ),
                                              ),

                                            ],
                                          )
                                      );
                                    }, scrollDirection: Axis.vertical,)
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 40,),



                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FLM.length==0?Container(
                              width: width,
                              height: height3-200,child: Center(child: Text('No Records Found',style: TextStyle(color: accent,fontFamily: 'Poppins-Bold',fontSize: 18),))):
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top:15.0,left: 28),
                                child: Row(
                                  children: [
                                    Text('Forex',style: TextStyle(color: accent,fontFamily: 'Poppins-Bold',fontSize: 18),),
                                  ],
                                ),
                              ),
                              ListView.builder(
                                itemCount:FLM.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index){
                                  return  Padding(
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
                                                                Text('${FLM[index].title}',style: TextStyle(color: Colors.white,fontFamily: 'Poppins-Semibold',
                                                                    fontSize: 14),),
                                                                SizedBox(height: 5,),
                                                                Row(

                                                                  children: [
                                                                    FLM[index].buy_sell.toString().toLowerCase()=="buy"?
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
                                                                        Text(('Published on : ${FLM[index].publish_date}').substring(0,34),style: TextStyle(color: Color(0xff888888),fontFamily: 'Poppins-Semibold',
                                                                            fontSize: 8),),
                                                                        Text('Trade Duration : ${FLM[index].trade_duration}',style: TextStyle(color: Color(0xff888888),fontFamily: 'Poppins-Semibold',
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
                                                                SizedBox(height: 5,),
                                                                Text((FLM[index].expire == "Expired")?"Expired":convertToDayHoursMin(int.parse(FLM[index].expire)),style: TextStyle(color: Colors.white,fontFamily: 'Poppins-Semibold',
                                                                    fontSize: 9),),
                                                                /* SizedBox(height: 5,),
                                                                    Row(

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

                                                                    Text('${FLM[index].EP}',style: TextStyle(color: Colors.white,fontFamily: 'Poppins-Semibold',
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

                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text('TP1',style: TextStyle(color: Color(0xffA8A8A8),fontFamily: 'Poppins-Semibold',
                                                                    fontSize: 9),),
                                                                SizedBox(height: 5,),
                                                                Row(

                                                                  children: [

                                                                    Text('${FLM[index].TP1}',style: TextStyle(color: Colors.white,fontFamily: 'Poppins-Semibold',
                                                                        fontSize: 12),),

                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                            SizedBox(width: 45,),
                                                            FLM[index].TP3=='0'?Container():
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text('TP3',style: TextStyle(color: Color(0xffA8A8A8),fontFamily: 'Poppins-Semibold',
                                                                    fontSize: 9),),
                                                                SizedBox(height: 5,),
                                                                Row(

                                                                  children: [

                                                                    Text('${FLM[index].TP3}',style: TextStyle(color: Colors.white,fontFamily: 'Poppins-Semibold',
                                                                        fontSize: 12),),

                                                                  ],
                                                                )
                                                              ],
                                                            ),


                                                          ],
                                                        ),
                                                        SizedBox(height: 15,),
                                                        Row(
                                                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            FLM[index].TP2=='0'?Container():

                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text('TP2',style: TextStyle(color: Color(0xffA8A8A8),fontFamily: 'Poppins-Semibold',
                                                                    fontSize: 9),),
                                                                SizedBox(height: 5,),
                                                                Row(

                                                                  children: [

                                                                    Text('${FLM[index].TP2}',style: TextStyle(color: Colors.white,fontFamily: 'Poppins-Semibold',
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

                                                                    Text('${FLM[index].SL}',style: TextStyle(color: Colors.white,fontFamily: 'Poppins-Semibold',
                                                                        fontSize: 12),),

                                                                  ],
                                                                )
                                                              ],
                                                            )

                                                          ],
                                                        ),
                                                        SizedBox(height: 18,),
                                                        Divider(
                                                          color: Color(0xff4A4A4A,),
                                                          thickness: 1.5,
                                                        ),
                                                        /* InkWell(
                                                              onTap: (){
                                                                //show_alet();

                                                              },
                                                              child: Container(height: 24,width: 167,
                                                                decoration: BoxDecoration(color: accent,
                                                                    borderRadius: BorderRadius.all(Radius.circular(4))),
                                                                child: Center(
                                                                  child: Text('Execute',style: TextStyle(color: Colors.black,fontFamily: 'Poppins-Semibold',
                                                                      fontSize: 8),),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(height: 32,),*/
                                                        ExpansionTile(
                                                          title: Text("View Details", style: TextStyle(
                                                              color: accent,
                                                              fontSize: 14
                                                          ),),
                                                          children: [
                                                            Container(
                                                              margin: EdgeInsets.symmetric(horizontal: 15),
                                                              child: Row(
                                                                children: [
                                                                  Text(FLM[index].notes, style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 12,

                                                                  ),),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(height:15)
                                                          ],
                                                          trailing: FLM[index].isxpand==true?Icon(Icons.keyboard_arrow_up,color: accent,)
                                                              :Icon(Icons.keyboard_arrow_down,color: accent,),
                                                          onExpansionChanged: (val){
                                                            setState(() {
                                                              FLM[index].isxpand=val;
                                                            });
                                                          },
                                                          //iconColor: accent,
                                                          //collapsedIconColor: accent,
                                                        )
                                                      ],
                                                    ),

                                                  ),

                                                ],
                                              ),

                                            ),
                                          ),

                                        ],
                                      )
                                  );
                                }, scrollDirection: Axis.vertical,)
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
String convertToDayHoursMin(int seconds)
{
  var d = Duration(seconds:seconds);
  List<String> parts = d.toString().split(':');
  print(d.toString());

  return'${parts[0]}hours ${parts[1]}minutes';
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

}

class Forex_List_Model {
  var buy_sell,id,expire,tade_accept;
  var title;
  var EP;
  var SL;
  var TP1,TP2,TP3;
  var publish_date;
  var trade_duration;
  var notes;
  var isxpand;

  Forex_List_Model(this.buy_sell, this.title, this.EP,this.SL, this.TP1, this.TP2, this.TP3,this.id,this.expire,this.tade_accept,this.publish_date, this.trade_duration, this.notes,this.isxpand);
}
class Stock_List_Model {
  var buy_sell,id,expire,tade_accept;
  var title;
  var EP;
  var SL;
  var TP;
  var publish_date;
  var trade_duration;
  var notes;
  var isxpand;

  Stock_List_Model(this.buy_sell, this.title, this.EP,this.SL, this.TP,this.id,this.expire,this.tade_accept, this.publish_date, this.trade_duration, this.notes,this.isxpand);
}
class shortStraddleListModel {
  var buy_sell,id,expire,tade_accept;
  var title;
  var EP;
  var SL;
  var publish_date;
  var trade_duration;
  var notes;
  var isxpand;

  shortStraddleListModel(this.buy_sell, this.title, this.EP,this.SL, this.id,this.expire,this.tade_accept, this.publish_date, this.trade_duration, this.notes,this.isxpand);
}

