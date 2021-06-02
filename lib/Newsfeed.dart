import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_ios/in_app_purchase_ios.dart';
import 'package:livelong/api_constants.dart';
import 'dart:async';
import 'package:share/share.dart';
import 'package:livelong/colors.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webfeed/domain/rss_feed.dart';
import 'RssModel.dart';
import 'admin_feed_model.dart';
import 'colors.dart';
import 'colors.dart';
import 'colors.dart';
import 'colors.dart';
import 'newsModel.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsFeed extends StatefulWidget {
  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> with SingleTickerProviderStateMixin {

  TabController _tabController;
  List <RssModel> rss_feed =new List();
  List <NewsModel> news_feed =new List();
  List<String> rss_imageList = [];
  bool isloaded = false;
  NewsModel newsModel;
  String news;
  int list_length;
  int adminfeed_length =0;
  AdminFeedModel adminFeedModel;
  var userId;
  bool showDetail =false;

  int _activeTabIndex = 0;
  Future <String> getNews() async {

    var response = await http.get('https://newsapi.org/v2/top-headlines?country=in&category=business&apiKey=4d40c4f4fa5540fc8f2811711d7eeb65');

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    setState(() {

      news = response.body.toString();
      var convertPost = json.decode(response.body);
      newsModel = NewsModel.fromJson(convertPost);


    });


  }
  var dev_id;
  Future <String> adminFeed() async {
    var base_url=APIS.base_url;

    var body = {
      'user_id' : '2940',
      'device_id' : 'fb06ug-UQA6iAZi-bGJU5k:APA91bFX63kYjgpA3hvdFGUTtCP-38DTMF9M5-nyh0qvsM-nMgWerw5_YGJs63VM0fmmnZeYZD-1Mm1aZbIJnQHK5RtB74Vz4EQV4qpwRDo2YyURNX7EL21X8bhOau_U7oC5P_-yueVU'
    };
    var url =
        '$base_url/api/httprequest/feeds';
    var response = await http.post(url, body: body);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if(response.body.contains('"status_code":"200"')){
      print('ssssssssssssss');
      setState(() {
        var convertPost = json.decode(response.body);
        adminFeedModel = AdminFeedModel.fromJson(convertPost);
        adminfeed_length=adminFeedModel.feeds.length;
      });


    }else{
      print('fail');

    }




  }

  Money_feed() async {
    var client = http.Client();
    // RSS feed
    var response = await client
        .get('https://www.moneycontrol.com/rss/latestnews.xml');
    // print(response.body);
    var channel = RssFeed.parse(response.body);
    rss_feed = channel.items
        .map((item) => RssModel(
      title: item.title,
      description: item.description,
      guid: item.guid
      
    ))
        .toList();
    /* print(rss_feed[0].title);
    print(rss_feed[0].imageurl);
    print(rss_feed[0].description);
    print(rss_feed[3].title);*/
    rss_imageList.clear();
    for(var i = 0;i < rss_feed.length; i++){
      RegExp exp = new RegExp(r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");
      Iterable<RegExpMatch> matches = exp.allMatches(rss_feed[i].description);
      matches.forEach((match) {
        rss_imageList.add(rss_feed[i].description.substring(match.start,match.end));
        //print(rss_feed[i].description.substring(match.start, match.end));
      });
    }


    client.close();


    print(rss_feed.length);
    print(rss_imageList.length);
    setState(() {
      isloaded = true;
    });
  }
  var selected_title;
  var selected_description;
  var selected_image;
  var selected_link;
  @override
  void initState() {
    //InAppPurchaseConnection.enablePendingPurchases();
    InAppPurchaseIosPlatform.registerPlatform();
    init();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_setActiveTabIndex);
    super.initState();
  }
  void _setActiveTabIndex() {

    setState(() {
      _activeTabIndex = _tabController.index;

    });
  }
  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }
init()async{
    await getNews();
    await Money_feed();
    adminFeed();
    print('RESSULLLLTTT');
    print(rss_feed.length);
    print(newsModel.articles.length);
}
  GlobalKey<ScaffoldState> scaffold_state = new GlobalKey<ScaffoldState>();
DateTime currentBackPressTime;
  static const snackBarDuration = Duration(seconds: 3);
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      if(showDetail==true){
        setState(() {
          showDetail =false;
        });
      }else{
        scaffold_state.currentState.showSnackBar( SnackBar(
          backgroundColor:Colors.black ,
          content: Text('press back again to exit',style: TextStyle(color: Colors.white),),
          duration: snackBarDuration,
        ));
      }
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    int currentTab = 0;
    return Scaffold(
      key: scaffold_state,
      backgroundColor: bg,
      body: showDetail?detail():WillPopScope(
        onWillPop: onWillPop,
        child: SafeArea(


            child: Column(
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.only(left:28.0,right: 28),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     // Image.asset('assets/images/Asset 34@4x.png',height: 20,),
                      Image.asset('assets/images/Exttended Logomark.png',height: 70,),
                      //Image.asset('assets/images/Asset 33@4x.png',height: 20,),
                    ],
                  ),
                ),
                Column(children: [

                ],),
                Padding(
                  padding: const EdgeInsets.only(top:30),
                  child: Container(
                    padding: const EdgeInsets.all(0),

                    height: 45,

                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.only(
                       topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: TabBar(
                      onTap: (index) {

                        setState(() {
                          currentTab = index;
                          print(index);
                        });
                      },
                      controller: _tabController,
                      // give the indicator a decoration (color and border radius)
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),

                        ),
                        color: selectiontabbg,
                      ),
                      labelColor: activehead,
                      unselectedLabelColor: inactivehead,
                      tabs: [
                        // first tab [you can add an icon using the icon property]

                        Tab(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("News"),
                              Container(height: 2,width: (_activeTabIndex == 0)?60:0, color: accent,margin: EdgeInsets.only(top: 5),)
                            ],
                          ),
                        ),
                        Tab(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("News From Us"),
                              Container(height: 2,width: (_activeTabIndex == 1)?60:0, color: accent,margin: EdgeInsets.only(top: 5),)
                            ],
                          ),
                        ),
                        // second tab [you can add an icon using the icon property]
                        /*Tab(
                          text: 'Markets',
                        ),
                        Tab(
                          text: 'PaperTrading',
                        ),*/
                      ],
                    ),
                  ),
                ),
                 isloaded?
                 Expanded(
                child: TabBarView(
                controller: _tabController,
                 children: [

                   Container(
                     height: double.infinity,
                    width: double.infinity,
                    color:selectiontabbg ,
                     child: isloaded ? Container(
                   color:selectiontabbg ,
                    height: 110,
                    child: ListView.builder(itemCount:rss_feed.length,itemBuilder: (context, index){
                          return Padding(
                    padding: const EdgeInsets.only(left:18.0,right: 18,top: 18),
                    child: Column(

                      children: [
                        newsModel.articles[index].title!=null&&newsModel.articles[index].description!=null?
                        Container(
                          child:   newsModel.articles[index].title.toLowerCase().contains('covid')
                              ||newsModel.articles[index].title.toLowerCase().contains('corona')
                              ||newsModel.articles[index].title.toLowerCase().contains('pandemic')
                              ||newsModel.articles[index].title.toLowerCase().contains('vaccine')
                              ||newsModel.articles[index].description.toLowerCase().contains('covid')
                              ||newsModel.articles[index].description.toLowerCase().contains('corona')
                              ||newsModel.articles[index].description.toLowerCase().contains('pandemic')
                              ||newsModel.articles[index].description.toLowerCase().contains('vaccine')
                              ?Container():
                          InkWell(
                            onTap: (){
                              setState(() {
                                selected_title =newsModel.articles[index].title.toString();
                                selected_image = newsModel.articles[index].urlToImage;
                                selected_description = newsModel.articles[index].description.toString();
                                selected_link=newsModel.articles[index].url;
                                showDetail =true;
                              });
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                              child: Container(
                                height: MediaQuery.of(context).size.height*0.25,
                                width: MediaQuery.of(context).size.width*0.85,

                                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),
                                  image: DecorationImage(image:newsModel.articles[index].urlToImage!=null? NetworkImage('${newsModel.articles[index].urlToImage}',)
                                      :AssetImage('assets/images/noimg.jpg'),fit: BoxFit.cover,),

                                ),
                                child: Stack(

                                  children: [
                                    Container(
                                      height: MediaQuery.of(context).size.height*0.25,
                                      width: MediaQuery.of(context).size.width*0.85,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                        gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: [
                                              Colors.black.withOpacity(0.7),
                                              Colors.transparent
                                            ]
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.2),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0, 0), // changes position of shadow
                                          ),
                                        ],
                                      ),

                                    ),
                                    /*Container(

                                  child: Image.network(
                                    '${newsModel.articles[index].urlToImage}',
                                    fit: BoxFit.fill,
                                  ),
                                ),*/
                                    Positioned(
                                      bottom: 0,
                                      child: Container(
                                        width: 320,
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(newsModel.articles[index].title,style: TextStyle(fontSize: 15,color: activehead,fontWeight: FontWeight.bold),),

                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Container(
                                        child: Container(
                                            padding: EdgeInsets.all(10),
                                            child: Text("+", style: TextStyle(color: Colors.white, fontSize: 20),)
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ):Container(),

                        index > rss_imageList.length?Container():
                        Padding(
                          padding: const EdgeInsets.only(top:18.0),
                          child:rss_feed[index].title.toLowerCase().contains('covid')
                              ||rss_feed[index].title.toLowerCase().contains('corona')
                              ||rss_feed[index].title.toLowerCase().contains('pandemic')
                              ||rss_feed[index].title.toLowerCase().contains('vaccine')
                              ||rss_feed[index].description.toLowerCase().contains('covid')
                              ||rss_feed[index].description.toLowerCase().contains('corona')
                              ||rss_feed[index].description.toLowerCase().contains('pandemic')
                              ||rss_feed[index].description.toLowerCase().contains('vaccine')
                              ?Container(): InkWell(
                            onTap: (){
                              setState(() {
                                int startIndex = rss_feed[index].description.indexOf("/>");
                                selected_title = rss_feed[index].title.toString();
                                selected_description = rss_feed[index].description.substring(startIndex).replaceAll("/> ", "");
                                selected_link=rss_feed[index].guid;
                                selected_image = rss_imageList[index];
                                showDetail =true;
                              });
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                              child: Container(
                                height: MediaQuery.of(context).size.height*0.25,
                                width: MediaQuery.of(context).size.width*0.85,

                                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),
                                    image: DecorationImage(image:index < rss_imageList.length? NetworkImage('${rss_imageList[index]}')
                                        :AssetImage('assets/images/noimg.jpg'),fit: BoxFit.cover,)),
                                child: Stack(
                                  children: [
                                    Container(
                                      height: MediaQuery.of(context).size.height*0.25,
                                      width: MediaQuery.of(context).size.width*0.85,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                        gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: [
                                              Colors.black.withOpacity(0.7),
                                              Colors.transparent
                                            ]
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.2),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0, 0), // changes position of shadow
                                          ),
                                        ],
                                      ),

                                    ),
                                    /*Container(

                                    child: Image.network(
                                      '${newsModel.articles[index].urlToImage}',
                                      fit: BoxFit.fill,
                                    ),
                                  ),*/
                                    Positioned(
                                      bottom: 0,
                                      child: Container(
                                        width: 320,
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(rss_feed[index].title,style: TextStyle(fontSize: 15,color: activehead,fontWeight: FontWeight.bold),),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Container(
                                        child: Container(
                                            padding: EdgeInsets.all(10),
                                            child: Text("+", style: TextStyle(color: Colors.white, fontSize: 20),)
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                );
              }, scrollDirection: Axis.vertical,),
            ):Container(),
        ),
                   Container(
                     height: double.infinity,
                     width: double.infinity,
                     color:selectiontabbg ,
                     child: adminfeed_length != 0 ? Container(
                       color:selectiontabbg ,
                       height: 110,

                       child: ListView.builder(itemCount:adminFeedModel.feeds.length,itemBuilder: (context, index){
                         return Padding(
                             padding: const EdgeInsets.only(left:18.0,right: 18,top: 18),
                             child: Column(
                               children: [
                                 InkWell(
                                   onTap: (){
                                     setState(() {
                                       selected_title =adminFeedModel.feeds[index].title.toString();
                                       selected_image = adminFeedModel.feeds[index].image;
                                       selected_description = adminFeedModel.feeds[index].description.toString();
                                       showDetail =true;
                                     });
                                   },
                                   child: Card(
                                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                                     child: Container(
                                       height: MediaQuery.of(context).size.height*0.25,
                                       width: MediaQuery.of(context).size.width*0.85,
                                       decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),
                                           image: DecorationImage(image:adminFeedModel.feeds[index].image!=null? NetworkImage('${adminFeedModel.feeds[index].image}',):AssetImage('assets/images/noimg.jpg'),fit: BoxFit.fill)),
                                       child: Stack(

                                         children: [
                                           Container(
                                             height: MediaQuery.of(context).size.height*0.25,
                                             width: MediaQuery.of(context).size.width*0.85,
                                             decoration: BoxDecoration(
                                               borderRadius: BorderRadius.all(Radius.circular(20)),
                                               gradient: LinearGradient(
                                                   begin: Alignment.bottomCenter,
                                                   end: Alignment.topCenter,
                                                   colors: [
                                                     Colors.black.withOpacity(0.7),
                                                     Colors.transparent
                                                   ]
                                               ),
                                               boxShadow: [
                                                 BoxShadow(
                                                   color: Colors.black.withOpacity(0.2),
                                                   spreadRadius: 5,
                                                   blurRadius: 7,
                                                   offset: Offset(0, 0), // changes position of shadow
                                                 ),
                                               ],
                                             ),

                                           ),
                                           /*Container(

                                  child: Image.network(
                                    '${newsModel.articles[index].urlToImage}',
                                    fit: BoxFit.fill,
                                  ),
                                ),*/
                                           Positioned(
                                             bottom: 0,
                                             left: 0,
                                             right: 0,
                                             child: Container(
                                               width:320,
                                               padding: const EdgeInsets.all(8.0),
                                               child: Text(adminFeedModel.feeds[index].title,style: TextStyle(fontSize: 16,color: activehead,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                                             ),
                                           ),
                                           Positioned(
                                             top: 0,
                                             right: 0,
                                             child: Container(
                                               child: Container(
                                                   padding: EdgeInsets.all(10),
                                                   child: Text("+", style: TextStyle(color: Colors.white, fontSize: 20),)
                                               ),
                                             ),
                                           )
                                         ],
                                       ),
                                     ),
                                   ),
                                 ),

                               ],
                             )
                         );
                       }, scrollDirection: Axis.vertical,),
                     ):Container(),
                   ),

        /*Container(
            height: double.infinity,
            width: double.infinity,
            color:selectiontabbg ,
        ),
                   Container(
                     height: double.infinity,
                     width: double.infinity,
                     color:selectiontabbg ,
                   ),*/
    ],
  ),
):Container(height: 400,
                     width: 300,child: Center(child: CircularProgressIndicator()))




              ],
            ),

        ),
      ),
    );
  }
Widget detail(){
    return SingleChildScrollView(
      child: SafeArea(
        child: WillPopScope(
          onWillPop: onWillPop,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: InkWell(
                        onTap: (){
                          setState(() {
                            showDetail =false;
                          });
                        },
                        child: Icon(Icons.arrow_back,color: accent,size: 30,)),
                  ),
                  Row(
                    children: [
                      /*IconButton(
                        icon: Icon(Icons.add, color: accent, size: 30,),
                        onPressed: (){},
                      ),*/
                      Padding(
                        padding: const EdgeInsets.only(right:18.0),
                        child: InkWell(
                          onTap: (){
                            final RenderBox box = context.findRenderObject();
                            // Share.share('$selected_description');
                            Share.share( '$selected_title\n\n$selected_description',
                                subject: '$selected_title',
                                sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
                          },
                          child: Icon(Icons.share,color:accent ,),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left:18.0,right: 18, bottom: 30, top: 20),
                child: selected_title!=null?Text('$selected_title',style:
                TextStyle(fontSize: 22,color: accent),):Text(' '),
              ),
              Padding(
                padding: EdgeInsets.only(left:18.0,right: 18),
                child: Container(height: MediaQuery.of(context).size.height*.25,
                  decoration: BoxDecoration(
                      image: DecorationImage(image:selected_image!=null? NetworkImage('$selected_image',)
                          :AssetImage('assets/images/noimg.jpg'),fit: BoxFit.cover,)),),
              ),
               Padding(
                padding: const EdgeInsets.only(left:18.0,right: 18,top: 30),
                child:  Column(children: [
                  selected_description!=null?Text('$selected_description',style:
                  TextStyle(fontSize: 15,color: activehead),):Text(' '),
                  InkWell(onTap: (){
                    launch('$selected_link',forceSafariVC: true,
                      forceWebView: true,);
                  },child: Text('$selected_link',style: TextStyle(color: Colors.blue),))
                ],),
              ),



            ],
          ),
        ),
      ),
    );

}


  
}
