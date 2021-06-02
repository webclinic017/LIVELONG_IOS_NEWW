import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_platform_interface/in_app_purchase_platform_interface.dart';
import 'package:livelong/Home.dart';
import 'package:livelong/Login.dart';
import 'dart:async';
import 'package:livelong/colors.dart';
import 'package:http/http.dart'as http;
import 'package:livelong/consumable_store.dart';
import 'package:livelong/courselist_model.dart';
import 'package:livelong/videolist_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webfeed/domain/rss_feed.dart';

import 'RssModel.dart';
import 'admin_feed_model.dart';
import 'api_constants.dart';
import 'colors.dart';
import 'colors.dart';
import 'colors.dart';
import 'package:better_player/better_player.dart';
import 'package:in_app_purchase_ios/in_app_purchase_ios.dart';

import 'newsModel.dart';
const bool _kAutoConsume = false;

const String _kConsumableIdMonthly =  'monthly_subscription';
const String _kConsumableIdYearly =  'yearly_subscription';
const List<String> _kProductIds = <String>[
  'Step1',
  'Step2',
  'Step3'
];

class Cources extends StatefulWidget {
  @override
  _CourcesState createState() => _CourcesState();
}

class _CourcesState extends State<Cources> with SingleTickerProviderStateMixin {
  final InAppPurchaseIosPlatform _iapIosPlatform =
  InAppPurchasePlatform.instance as InAppPurchaseIosPlatform;
  GlobalKey<ScaffoldState> scaffold_state = new GlobalKey<ScaffoldState>();
  bool play_video = false;
  bool isloaded = false;
  CourseListModel courseListModel;
  VideoListModel videoListModel;
  var userId;
  String video_title='';
  int courcelist_length = 0;
  int videolist_length = 0;
  String video_url;
  TextEditingController mobileController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  int uid;
  int cid;
  var dev_id;


  bool isLoggedIn=false;
  Future <String> cource_list() async {
    var base_url=APIS.base_url;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn= prefs.getBool('isLoggedIn') ?? false;
      show_step1=prefs.getBool("show_step1");
      show_step2=prefs.getBool("show_step2");
      show_step3=prefs.getBool("show_step3");
    });
   if( isLoggedIn==true){
     setState(() {
       userId = prefs.getString('user_id');
       dev_id=prefs.getString('dev_id');

       uid=int.parse(userId);
     });
   }else{
     setState(() {
       userId = '2940';
       dev_id= 'fb06ug-UQA6iAZi-bGJU5k:APA91bFX63kYjgpA3hvdFGUTtCP-38DTMF9M5-nyh0qvsM-nMgWerw5_YGJs63VM0fmmnZeYZD-1Mm1aZbIJnQHK5RtB74Vz4EQV4qpwRDo2YyURNX7EL21X8bhOau_U7oC5P_-yueVU';

       uid=int.parse(userId);
     });
   }

    var body = {
      'user_id' : '$userId',
      'device_id' : '$dev_id'
    };
    var url =
        '$base_url/api/httprequest/list_course';
    var response = await http.post(url, body: body);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if(response.body.contains('"status_code":"200"')){
      print('ssssssssssssss');
      setState(() {
        var convertPost = json.decode(response.body);
        courseListModel = CourseListModel.fromJson(convertPost);
        courcelist_length=courseListModel.courses.length;
      });


    }else{
      print('fail');

    }
  }

  Future <String> video_list(var cID) async {
    var base_url=APIS.base_url;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn= prefs.getBool('isLoggedIn') ?? false;
    });
    if( isLoggedIn==true){
      setState(() {
        userId = prefs.getString('user_id');
        dev_id=prefs.getString('dev_id');
      });
    }else{
     setState(() {
       userId = '2940';
       dev_id= 'fb06ug-UQA6iAZi-bGJU5k:APA91bFX63kYjgpA3hvdFGUTtCP-38DTMF9M5-nyh0qvsM-nMgWerw5_YGJs63VM0fmmnZeYZD-1Mm1aZbIJnQHK5RtB74Vz4EQV4qpwRDo2YyURNX7EL21X8bhOau_U7oC5P_-yueVU';

     });
    }

    var body = {
      'user_id' : '$userId',
      'device_id' : '$dev_id',
      'course_id' : '$cID'
    };
    var url =
        '$base_url/api/httprequest/video_module';
    var response = await http.post(url, body: body);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if(response.body.contains('"status_code":"200"')){
      print('ssssssssssssss');
      setState(() {
        var convertPost = json.decode(response.body);
        videoListModel = VideoListModel.fromJson(convertPost);
        videolist_length=videoListModel.module.length;
      });


    }else{
      print('fail');

    }




  }
  bool IsPaid=false;
  bool showvideo_list = false;

  String play_url ='';
  String play_head ='';
  var otp_verified;
  List<ProductDetails> products;
  BetterPlayerListVideoPlayerController _betterPlayerListVideoPlayerController;
  BetterPlayerController _betterPlayerController;

  Future<List<ProductDetails>> loadProductsForSale() async {
    print("koooooii");
    if(await isAppPurchaseAvailable()) {
      const Set<String> _kIds = {'Step1','Step2','Step3'};
      final ProductDetailsResponse response =
      await _iapIosPlatform.queryProductDetails(_kIds);
      if (response.notFoundIDs.isNotEmpty) {
        debugPrint(
            '#PurchaseService.loadProductsForSale() notFoundIDs: ${response
                .notFoundIDs}');
      // scaffold_state.currentState.showSnackBar(SnackBar(content: Text('#PurchaseService.loadProductsForSale() notFoundIDs: ${response
          //  .notFoundIDs}'),duration: Duration(seconds: 4),));

      }
      if (response.error != null) {
        //scaffold_state.currentState.showSnackBar(SnackBar(content: Text('#PurchaseService.loadProductsForSale() error: ${response.error.code + ' - ' + response.error.message}'),duration: Duration(seconds: 4),));
        debugPrint(
            '#PurchaseService.loadProductsForSale() error: ${response.error.code + ' - ' + response.error.message}');
      }
      products = response.productDetails;
      //scaffold_state.currentState.showSnackBar(SnackBar(content: Text('${products[0].description}'),duration: Duration(seconds: 4),));
      print('jjjjjjjjjj${products.length.toString()}');
      scaffold_state.currentState.showSnackBar(new SnackBar(duration: Duration(seconds: 3),backgroundColor: accent,
          content: new Text('products length(test1) : ${products.length.toString()}',style: TextStyle(
              color: Colors.black,fontWeight: FontWeight.bold
          ),)));
      return products;

    } else{
      debugPrint('#PurchaseService.loadProductsForSale() store not available');
      return null;
    }
  }Future<bool> isAppPurchaseAvailable() async {
    final bool available = await _iapIosPlatform.isAvailable();

    debugPrint('#PurchaseService.isAppPurchaseAvailable() => $available');

    return available;
    if (!available) {
      // The store cannot be reached or accessed. Update the UI accordingly.

      return false;
    }
  }
  
int iap_course_id;
  @override
  void initState() {
    cource_list();

    //initStoreInfo();
    loadProductsForSale();
    super.initState();
Stream purchaseUpdated =
    _iapIosPlatform.purchaseStream;
_subscription = purchaseUpdated.listen((purchaseDetailsList) {

  print('NEW PURCHASE');
  _listenToPurchaseUpdated(purchaseDetailsList);

}, onDone: () {
  print('CANCELLED');
  _subscription.cancel();
}, onError: (error) {
  print(error);
});
initStoreInfo();


  }
  bool show_step1=false;
  bool show_step2=false;
  bool show_step3=false;

 /* Restore_Purchases()async{

     print('yyyyyy');
    final QueryPurchaseDetailsResponse purchaseResponse =
    await _connection.queryPastPurchases();
    if (purchaseResponse.error != null) {
      _pastpurchases=purchaseResponse.pastPurchases;

      for(var i=0;i<=_pastpurchases.length;i++){
        if(_pastpurchases[i].productID=="Step1"){
          setState(() {
            show_step1=true;
          });
        }else if(_pastpurchases[i].productID=="Step2"){
          setState(() {
            show_step2=true;
          });
        } else if(_pastpurchases[i].productID=="Step3"){
          setState(() {
            show_step3=true;
          });
        }
      }

      // handle query past purchase error..
    }
     showDialog(
       context: context,
       barrierDismissible: false,
       builder: (BuildContext context) {
         return Dialog(
           child: Container(
             height: 50,width: 200,
             color: accent,
             child: new Row(
               mainAxisAlignment: MainAxisAlignment.center,
               crossAxisAlignment: CrossAxisAlignment.center,
               mainAxisSize: MainAxisSize.min,
               children: [
                 Container(
                     height: 20,width: 20,
                     child: new CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),)),
                 SizedBox(width: 20,),
                 new Text("Loading purchases...."),
               ],
             ),
           ),
         );
       },
     );
     new Future.delayed(new Duration(seconds: 3), () {
       Navigator.pop(context); //pop dialog
       if(_pastpurchases.length ==0){
         scaffold_state.currentState.showSnackBar(new SnackBar(duration: Duration(seconds: 3),backgroundColor: accent,
             content: new Text('Failed to restore purchases',style: TextStyle(
             color: Colors.black,fontWeight: FontWeight.bold
         ),)));
       }else{
         scaffold_state.currentState.showSnackBar(new SnackBar(duration: Duration(seconds: 3),backgroundColor: accent,content: new Text('Purchases restored successfully',style: TextStyle(
             color: Colors.black,fontWeight: FontWeight.bold
         ),)));

       }
     });

  }*/


  Future<void> initStoreInfo() async {
    final bool isAvailable = await _iapIosPlatform.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = [];
        _purchases = [];
        _notFoundIds = [];
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    ProductDetailsResponse productDetailResponse =
    await _iapIosPlatform.queryProductDetails(_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;

        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }
  /*  await _iapIosPlatform.restorePurchases().then((QueryPurchaseDetailsResponse purchaseResponse) {

    });*/
    //final QueryPurchaseDetailsResponse purchaseResponse =
    await _iapIosPlatform.restorePurchases();
   /* purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      //print("fffffffffffffffffffffffffffffffffffffffff"+purchaseDetails.verificationData.localVerificationData+"gggggggg"+purchaseDetails.verificationData.serverVerificationData);
      await _iapIosPlatform.completePurchase(purchaseDetails);}*/

  /*  if (purchaseResponse.error != null) {
      _pastpurchases=purchaseResponse.pastPurchases;

      for(var i=0;i<=_pastpurchases.length;i++){
        if(_pastpurchases[i].productID=="Step1"){
           setState(() {
             show_step1=true;
           });
        }else if(_pastpurchases[i].productID=="Step2"){
          setState(() {
            show_step2=true;
          });
        } else if(_pastpurchases[i].productID=="Step3"){
          setState(() {
            show_step3=true;
          });
        }
      }
      // handle query past purchase error..
    }
    final List<PurchaseDetails> verifiedPurchases = [];
    for (PurchaseDetails purchase in purchaseResponse.pastPurchases) {
      if (await _verifyPurchase(purchase)) {
        verifiedPurchases.add(purchase);
      }
    }*/
    List<String> consumables = await ConsumableStore.load();
    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
     // _purchases = verifiedPurchases;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = consumables;
      _purchasePending = false;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
  init()async{

  }

  DateTime currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      if(showvideo_list==true){
        setState(() {
          showvideo_list=false;
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
    return Scaffold(
      key: scaffold_state,
      backgroundColor: bg,
      body: showvideo_list?video():WillPopScope(
        onWillPop: onWillPop,
        child: SafeArea(


          child: Column(
            children: <Widget>[

              Padding(
                padding: const EdgeInsets.only(left:28.0,right: 28),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Image.asset('assets/images/Asset 34@4x.png',height: 20,),
                    InkWell(
                        onTap: (){
                          scaffold_state.currentState.showSnackBar(new SnackBar(duration: Duration(seconds: 3),backgroundColor: accent,
                              content: new Text('products length(test2) : ${_products.length.toString()}',style: TextStyle(
                                  color: Colors.black,fontWeight: FontWeight.bold
                              ),)));
                        },
                        child: Image.asset('assets/images/Exttended Logomark.png',height: 70,)),
                    //Image.asset('assets/images/Asset 33@4x.png',height: 20,),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:15.0,left: 28),
                child: Row(
                  children: [
                    Text('Courses',style: TextStyle(color: accent,fontFamily: 'Poppins-Bold',fontSize: 26),),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:28.0,right: 28,top: 10),
                child: Text("Completely new to the Stock Markets, need to learn it all from absolute basics starting from how markets work to how you could make use of the opportunities present in it.",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
              Padding(
                padding: const EdgeInsets.only(top:20.0,left: 28),
                child: Row(
                  children: [
                    Text('Access your courses',style: TextStyle(color: accent,fontFamily: 'Poppins-Bold',fontSize: 20),),
                  ],
                ),
              ),

              courcelist_length != 0?
              Expanded(
                child: ListView.builder(itemCount:courseListModel.courses.length,itemBuilder: (context, index){
                  return InkWell(
                    onTap: (){
                     /* if(courseListModel.courses[index].amount == '0.00' ||courseListModel.courses[index].payment == 'paid' ){
                        setState(() {
                          IsPaid=true;
                        });
                        setState(() {
                          iap_course_id=index-1;
                          print(iap_course_id.toString());
                        });
                        video_list('${courseListModel.courses[index].id}');
                        setState(() {
                          cid=int.parse('${courseListModel.courses[index].id}');

                          video_title=courseListModel.courses[index].name;
                          showvideo_list = true;

                        });
                      }else{
                        *//*for(var i=0;i<=_pastpurchases.length;i++){
                          if(_pastpurchases[i].productID=="Step1"){

                          }
                        }*//*
                        setState(() {
                          IsPaid=false;
                           cid=int.parse('${courseListModel.courses[index].id}');
                        });
                        setState(() {
                          iap_course_id=index-1;
                          print(iap_course_id.toString());
                        });
                        //isLoggedIn==true?
                        showpayDialog(context);
                        //showLoginDialog(context);
                      }
*/

                      if(courseListModel.courses[index].amount == '0.00' ||courseListModel.courses[index].payment == 'paid' ){
                        setState(() {
                          IsPaid=true;
                        });
                        setState(() {
                          iap_course_id=index-1;
                          print(iap_course_id.toString());
                        });
                        video_list('${courseListModel.courses[index].id}');
                        setState(() {
                          cid=int.parse('${courseListModel.courses[index].id}');

                          video_title=courseListModel.courses[index].name;
                          showvideo_list = true;

                        });
                      }else if(index==1 && show_step1==true){
                        setState(() {
                          IsPaid=true;
                        });
                        setState(() {
                          iap_course_id=index-1;
                          print(iap_course_id.toString());
                        });
                        video_list('${courseListModel.courses[index].id}');
                        setState(() {
                          cid=int.parse('${courseListModel.courses[index].id}');

                          video_title=courseListModel.courses[index].name;
                          showvideo_list = true;

                        });
                      }else  if(index==2 && show_step2==true){
                        setState(() {
                          IsPaid=true;
                        });
                        setState(() {
                          iap_course_id=index-1;
                          print(iap_course_id.toString());
                        });
                        video_list('${courseListModel.courses[index].id}');
                        setState(() {
                          cid=int.parse('${courseListModel.courses[index].id}');

                          video_title=courseListModel.courses[index].name;
                          showvideo_list = true;

                        });
                      }else  if(index==3 && show_step3==true){
                        setState(() {
                          IsPaid=true;
                        });
                        setState(() {
                          iap_course_id=index-1;
                          print(iap_course_id.toString());
                        });
                        video_list('${courseListModel.courses[index].id}');
                        setState(() {
                          cid=int.parse('${courseListModel.courses[index].id}');

                          video_title=courseListModel.courses[index].name;
                          showvideo_list = true;

                        });
                      }else{
                       setState(() {
                          IsPaid=false;
                          cid=int.parse('${courseListModel.courses[index].id}');
                          });
                        setState(() {
                        iap_course_id=index-1;
                        print(iap_course_id.toString());
                          });
                        //isLoggedIn==true?
                        showpayDialog(context);
                         //showLoginDialog(context);

                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top:18.0,left: 28,right: 28, bottom: 5),
                      child: Container(height: 60,decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),color:selectiontabbg ),
                        child: Padding(
                          padding: const EdgeInsets.only(left:18.0),
                          child: Row(
                            children: [
                              Center(child: Text(courseListModel.courses[index].name,style: TextStyle(fontSize: 16,fontFamily:'Poppins-SemiBold', color: activebody ),)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }, scrollDirection: Axis.vertical,),
              ):CircularProgressIndicator(),

               Padding(
                 padding: const EdgeInsets.only(left: 28,bottom: 10),
                 child: Row(
                   children: [
                     InkWell(
                       onTap: (){
                         initStoreInfo();
                       },
                       child: Container(

                         decoration: BoxDecoration(
                           color: accent,
                           borderRadius: BorderRadius.all(Radius.circular(10))
                         ),
                         child: Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Text(
                             'Restore Purchases',style:TextStyle(
                             color: Colors.black,fontWeight: FontWeight.bold,fontSize: 14
                           ) ,
                           ),
                         ),
                       ),
                     ),
                   ],
                 ),
               ),

            ],
          ),

        ),
      ),
    );
  }

  Widget video(){
    return  SafeArea(
      /*play_video?player(play_url, play_head):*/

      child: WillPopScope(
        onWillPop: onWillPop,
        child: Column(
          children: <Widget>[

            Padding(
              padding: const EdgeInsets.only(left:28.0,right: 28),
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
                  InkWell(
                      onTap:(){
                        setState(() {
                          IsPaid=false;
                          showvideo_list = false;
                        });
                      },
                      child: Icon(Icons.arrow_back,color: accent,size: 30,)),
                  SizedBox(width: 8,),
                  Text('$video_title',style: TextStyle(color: accent,fontFamily: 'Poppins-Bold',fontSize: 18),),

                ],
              ),
            ),
            videolist_length != 0?
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top:28.0,left: 28,right: 28,bottom: 10),
                child: GridView.builder(
                  itemCount: videoListModel.module.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:  2 ),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(onTap: ()async{
                      if(IsPaid==true){
                        setState(() {
                          play_url='${videoListModel.module[index].videoUrl}';
                          play_head ='${videoListModel.module[index].title}';
                          print('PPLLAYYYYYYYYYY:::::$play_url');

                        });


                        showAlertDialog(context);
                      }else{
                        isLoggedIn==true?
                        showpayDialog(context):
                        showLoginDialog(context);
                      }
                    },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)),
                              image: DecorationImage(image:videoListModel.module[index].image!=''&&videoListModel.module[index].image!=null? NetworkImage('${videoListModel.module[index].image}')
                                  :AssetImage('assets/images/noimg.jpg'),fit: BoxFit.fill)),
                          child: Column(mainAxisAlignment: MainAxisAlignment.end,children: [
                            Container(decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomRight: Radius.circular(15),bottomLeft: Radius.circular(15)),color: accent,),height: 40,
                              child: Center(child: Text('${videoListModel.module[index].description}'),),)
                          ],),

                        ),
                      ),
                    );
                  },
                ),
              ),
            ):Container(height: 400,
                width: 300,child: Center(child: CircularProgressIndicator())),




          ],
        ),
      ),

    );
  }

  showAlertDialog(BuildContext context)async {


    showDialog(
      // barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: BetterPlayerListVideoPlayer(

              BetterPlayerDataSource(
                BetterPlayerDataSourceType.network, play_url,),

              //key: Key(videoListData.hashCode.toString()),

              configuration: BetterPlayerConfiguration(autoPlay: true,
                fit: BoxFit.contain,

                overlay: Text('UserId : $userId',style: TextStyle(fontSize: 12),),


              ),
              betterPlayerListVideoPlayerController: BetterPlayerListVideoPlayerController(),
            ),


          ),
        );
      },
    );

  }



  static const snackBarDuration = Duration(seconds: 3);
  Future <String> verifyOtp() async {
    var base_url=APIS.base_url;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var body = {
      'user_id' : '$userId',
      'device_id' : '$dev_id',
      'mobile_number' : '${mobileController.text}',
      'otp' : otpController.text

    };
    var url =
        '$base_url/api/httprequest/verifyotp';
    var response = await http.post(url, body: body);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if(response.statusCode==200){

      prefs.setString('otp_verified','true');

    }


  }

  showpayDialog(BuildContext context) {



    Widget launchButton = FlatButton(
      child: Text("Purchase Now",style: TextStyle(color: accent,fontSize:18),),
      onPressed:  () {
        print('PPPPRPRPRPPPRPRPRP ${products.length}');
        var baseurl=APIS.base_url;
        Navigator.of(context, rootNavigator: true).pop();
        print(products[iap_course_id].id);

        PurchaseParam purchaseParam = PurchaseParam(
            productDetails: products[iap_course_id],
            applicationUserName: null,
            /*sandboxTesting: true*/);
        _iapIosPlatform.buyNonConsumable(
            purchaseParam: purchaseParam);

        /* Navigator.of(context, rootNavigator: true).pop();*/
      },
    );
    Widget notnowButton = FlatButton(
      child: Text("Not Now",style: TextStyle(color: accent,fontSize:18),),
      onPressed:  () {
        Navigator.of(context, rootNavigator: true).pop();

        /* Navigator.of(context, rootNavigator: true).pop();*/
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: bg,
      title: Text("Please purchase course to view module",style: TextStyle(color: activehead, ),),

      actions: [
        notnowButton,
        launchButton
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  showLoginDialog(BuildContext context) {



    Widget launchButton = FlatButton(
      child: Text("Login Now",style: TextStyle(color: accent,fontSize:18),),
      onPressed:  () {
        Navigator.of(context, rootNavigator: true).pop();
        setState(() {
          Home.index=1;
        });
        Navigator.of(context).pushAndRemoveUntil(

          MaterialPageRoute(
            builder: (BuildContext context) => LoginPage(),
          ),
              (Route route) => false,
        );

        /* Navigator.of(context, rootNavigator: true).pop();*/
      },
    );
    Widget notnowButton = FlatButton(
      child: Text("Not Now",style: TextStyle(color: accent,fontSize:18),),
      onPressed:  () {
        Navigator.of(context, rootNavigator: true).pop();

        /* Navigator.of(context, rootNavigator: true).pop();*/
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: bg,
      title: Text("Please login to view module",style: TextStyle(color: activehead, ),),

      actions: [
        notnowButton,
        launchButton
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
 // final InAppPurchaseConnection _connection = InAppPurchaseConnection.instance;
  StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = [];
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  List<PurchaseDetails> _pastpurchases = [];
  List<String> _consumables = [];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String _queryProductError;
  DateTime today= DateTime.now();
  bool isdone = false;
  Future<void> consume(String id) async {
    await ConsumableStore.consume(id);
    final List<String> consumables = await ConsumableStore.load();
    setState(() {
      _consumables = consumables;
    });
  }

  void showPendingUI() {
    setState(() {
      _purchasePending = true;
    });
  }

  Future <String> Payment_Success() async {
    var base_url=APIS.base_url;

    if(order_id==null){
      setState(() {
        order_id=123456;
      });
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userId = prefs.getString('user_id');
      dev_id=prefs.getString('dev_id');
    });

    var body = {
      'user_id' : '$userId',
      'course_id' : '$cid',
      'order_id' : '$order_id'
    };
    var url =
        'https://lledu.in/livelongwealth/api/httprequest/app_payment';
    var response = await http.post(url, body: body);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

  }

  var order_id;

  void deliverProduct(PurchaseDetails purchaseDetails) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      order_id=purchaseDetails.purchaseID.toString();
    });

   await Payment_Success();
    setState(() {
      Home.index=1;
    });
    if(purchaseDetails.productID=="Step1"){
      setState(() {
        show_step1=true;
        prefs.setBool("show_step1", true);
      });
    }else if(purchaseDetails.productID=="Step2"){
      setState(() {
        show_step2=true;
        prefs.setBool("show_step2", true);
      });
    } else if(purchaseDetails.productID=="Step3"){
      setState(() {
        show_step3=true;
        prefs.setBool("show_step3", true);
      });
    }
    Navigator.of(context).pushAndRemoveUntil(

      MaterialPageRoute(
        builder: (BuildContext context) => Home(),
      ),
          (Route route) => false,
    );
    // IMPORTANT!! Always verify a purchase purchase details before delivering the product.
    setState(() {
      _purchases.add(purchaseDetails);
      _purchasePending = false;
    });

  }

  void handleError(IAPError error) async{
    if(error.message.toLowerCase().contains('sandbox')||
        error.code.toLowerCase().contains('sandbox')||
        error.source.toString().toLowerCase().contains('sandbox')
    ){
      setState(() {
        order_id='1234applesandboxtest';
      });

      await Payment_Success();
      setState(() {
        Home.index=1;
      });
      Navigator.of(context).pushAndRemoveUntil(

        MaterialPageRoute(
          builder: (BuildContext context) => Home(),
        ),
            (Route route) => false,
      );
      setState(() {

        _purchasePending = false;
      });

    }else{
      setState(() {
        _purchasePending = false;
      });
    }
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.

    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async{

    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      //print("fffffffffffffffffffffffffffffffffffffffff"+purchaseDetails.verificationData.localVerificationData+"gggggggg"+purchaseDetails.verificationData.serverVerificationData);
        await _iapIosPlatform.completePurchase(purchaseDetails);
      if (purchaseDetails.status == PurchaseStatus.pending) {

        showPendingUI();
      } else {

        if (purchaseDetails.status == PurchaseStatus.error) {

          print(purchaseDetails.error.toString());
          print(purchaseDetails.error.message.toString());
          print(purchaseDetails.error.details.toString());
          print(purchaseDetails.error.code.toString());
          print(purchaseDetails.error.source.toString());
          handleError(purchaseDetails.error);
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          setState(() {
            isdone = true;
          });
          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {

            deliverProduct(purchaseDetails);
          } else {

            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }

      }
    });
    /* for (var p in purchaseDetailsList) {

      // Code to validate the payment

      if (!p.pendingCompletePurchase) continue;
      // if (_isConsumable(p.productID)) continue; // Determine if the item is consumable. If so do not consume it

      var result = await InAppPurchaseConnection.instance.completePurchase(p);

      if (result.responseCode != BillingResponse.ok) {
        print("result: ${result.responseCode} (${result.debugMessage})");
      }
    }*/
  }

}

