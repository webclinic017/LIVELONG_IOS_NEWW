/*
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:in_app_purchase/in_app_purchase.dart';


import 'consumable_store.dart';





const bool _kAutoConsume = false;

const String _kConsumableIdMonthly =  'monthly_subscription';
const String _kConsumableIdYearly =  'yearly_subscription';
const List<String> _kProductIds = <String>[
  _kConsumableIdMonthly,
  _kConsumableIdYearly,
  'lifetime_subscription'
];
class PurchasePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

          fontFamily: 'workSans'
      ),
      home: purchasePage(),
    );
  }
}
class purchasePage extends StatefulWidget {
  @override
  _purchasePageState createState() => _purchasePageState();
}

class _purchasePageState extends State<purchasePage> {

  final InAppPurchaseConnection _connection = InAppPurchaseConnection.instance;
  StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = [];
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  List<String> _consumables = [];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String _queryProductError;
  DateTime today= DateTime.now();
  bool isdone = false;
  @override
  void initState() {
    Stream purchaseUpdated =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
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
    super.initState();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _connection.isAvailable();
    if (!isAvailable) {
      setState(() {
        print('HIIIIIIII');
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
    await _connection.queryProductDetails(_kProductIds.toSet());
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

    final QueryPurchaseDetailsResponse purchaseResponse =
    await _connection.queryPastPurchases();
    if (purchaseResponse.error != null) {
      // handle query past purchase error..
    }
    final List<PurchaseDetails> verifiedPurchases = [];
    for (PurchaseDetails purchase in purchaseResponse.pastPurchases) {
      if (await _verifyPurchase(purchase)) {
        verifiedPurchases.add(purchase);
      }
    }
    List<String> consumables = await ConsumableStore.load();
    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _purchases = verifiedPurchases;
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






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,

      ),
      extendBodyBehindAppBar: true,
      body:_products.length!=0? WillPopScope(
        // ignore: missing_return
        onWillPop: (){

        },
        child: isdone == false? SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 115,
                  width: 115,

                ),
                Text("Why Milion Pro", style: TextStyle(
                    fontSize: 18
                ),),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Icon(Icons.check_circle_outline,),
                    Text(" Get more than 2+ Signals",),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Icon(Icons.check_circle_outline),
                    Expanded(child: Text(" Hate Ads? No problem, no ads in pro version.",)),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Icon(Icons.check_circle_outline),
                    Text(" Proper risk management",),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Icon(Icons.check_circle_outline),
                    Text(" Money management",),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.check_circle_outline),
                    Expanded(child: Text(" \nAll upcoming features are included (Stock Market Signals and Options Trading Signals",)),
                  ],
                ),
                SizedBox(height: 20,),
                Text("Hate subscription? Subscribe to Lifetime and get rid of subscription. All currently & upcoming features are included free for lifetime.", style: TextStyle(
                    color: Colors.grey
                ),),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Choose a plan!", style: TextStyle(
                        fontSize: 18
                    ),)
                  ],
                ),
                SizedBox(height: 20,),
                InkWell(
                  onTap: (){
                    print(_products[1].id);
                    PurchaseParam purchaseParam = PurchaseParam(
                        productDetails: _products[1],
                        applicationUserName: null,
                        sandboxTesting: true);
                    if (_products[1].id == _kConsumableIdMonthly) {
                      _connection.buyConsumable(
                          purchaseParam: purchaseParam,
                          autoConsume: _kAutoConsume);
                    } else {
                      _connection.buyNonConsumable(
                          purchaseParam: purchaseParam);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: BoxDecoration(

                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Center(
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("1 Month", style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black
                                      ),),
                                      Text("\$10", style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black
                                      ),),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Total \$10", style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black
                                      ),),
                                      Text("You Pay", style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black
                                      ),),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Icon(Icons.chevron_right, color: Colors.black,),
                          ],
                        )
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                InkWell(
                  onTap: (){
                    print(_products[2].id);
                    PurchaseParam purchaseParam = PurchaseParam(
                        productDetails: _products[2],
                        applicationUserName: null,
                        sandboxTesting: true);
                    if (_products[2].id == _kConsumableIdYearly) {
                      _connection.buyConsumable(
                          purchaseParam: purchaseParam,
                          autoConsume: _kAutoConsume);
                    } else {
                      _connection.buyNonConsumable(
                          purchaseParam: purchaseParam);
                    }

                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: BoxDecoration(

                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Center(
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("12 Months", style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black
                                      ),),
                                      Text("\$70", style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black
                                      ),),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text("Total \$100 - 30% Discount", style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black
                                        ),),
                                      ),
                                      Text("You Pay", style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black
                                      ),),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Icon(Icons.chevron_right, color: Colors.black,),
                          ],
                        )
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                InkWell(
                  onTap: (){

                    print(_products[0].id);
                    PurchaseParam purchaseParam = PurchaseParam(
                        productDetails: _products[0],
                        applicationUserName: null,
                        sandboxTesting: true);
                    if (_products[0].id == 'lifetime_subscription') {

                      _connection.buyNonConsumable(
                          purchaseParam: purchaseParam);

                    } else {
                      _connection.buyConsumable(
                          purchaseParam: purchaseParam,
                          autoConsume: _kAutoConsume);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                    //  color: yellow,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Center(
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Life Time", style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black
                                      ),),
                                      Text("\$134", style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black
                                      ),),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(child:  Text("Total \$1341 - 90% Discount", style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black
                                      ),),),

                                      Text("You Pay", style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black
                                      ),),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Icon(Icons.chevron_right, color: Colors.black,),
                          ],
                        )
                    ),
                  ),
                ),
              ],
            ),
          ),
        ):Center(
          child: Container(
            color: Colors.grey[300],
            width: 70.0,
            height: 70.0,
            child: new Padding(padding: const EdgeInsets.all(5.0),child: new Center(child: new CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(Colors.red)))),
          ),
        ),
      ):Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(Colors.red)),),
    );
  }


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

  void deliverProduct(PurchaseDetails purchaseDetails) async {


    // IMPORTANT!! Always verify a purchase purchase details before delivering the product.
    if (purchaseDetails.productID == _kConsumableIdMonthly || purchaseDetails.productID == _kConsumableIdYearly) {
      await ConsumableStore.save(purchaseDetails.purchaseID);
      if(purchaseDetails.productID == _kConsumableIdMonthly){



      }else{


      }
      List<String> consumables = await ConsumableStore.load();
      setState(() {
        _purchasePending = false;
        _consumables = consumables;
      });
    } else {


      setState(() {
        _purchases.add(purchaseDetails);
        _purchasePending = false;
      });

    }
  }

  void handleError(IAPError error) {
    setState(() {
      _purchasePending = false;
    });
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
      await InAppPurchaseConnection.instance.completePurchase(purchaseDetails);
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
        if (Platform.isAndroid) {
          if (_kAutoConsume && purchaseDetails.productID == _kConsumableIdMonthly || (_kAutoConsume && purchaseDetails.productID == _kConsumableIdYearly)) {
            await InAppPurchaseConnection.instance
                .consumePurchase(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchaseConnection.instance
              .completePurchase(purchaseDetails);
        }
      }
    });
    */
/* for (var p in purchaseDetailsList) {

      // Code to validate the payment

      if (!p.pendingCompletePurchase) continue;
      // if (_isConsumable(p.productID)) continue; // Determine if the item is consumable. If so do not consume it

      var result = await InAppPurchaseConnection.instance.completePurchase(p);

      if (result.responseCode != BillingResponse.ok) {
        print("result: ${result.responseCode} (${result.debugMessage})");
      }
    }*//*

  }

}
*/
