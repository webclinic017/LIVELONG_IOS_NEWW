// To parse this JSON data, do
//
//     final copyTradeModel = copyTradeModelFromJson(jsonString);

import 'dart:convert';

CopyTradeModel copyTradeModelFromJson(String str) => CopyTradeModel.fromJson(json.decode(str));

String copyTradeModelToJson(CopyTradeModel data) => json.encode(data.toJson());

class CopyTradeModel {
  CopyTradeModel({
    this.trade,
    this.message,
    this.status,
    this.statusCode,
  });

  List<Trade> trade;
  String message;
  bool status;
  String statusCode;

  factory CopyTradeModel.fromJson(Map<String, dynamic> json) => CopyTradeModel(
    trade: List<Trade>.from(json["trade"].map((x) => Trade.fromJson(x))),
    message: json["message"],
    status: json["status"],
    statusCode: json["status_code"],
  );

  Map<String, dynamic> toJson() => {
    "trade": List<dynamic>.from(trade.map((x) => x.toJson())),
    "message": message,
    "status": status,
    "status_code": statusCode,
  };
}

class Trade {
  Trade({
    this.id,
    this.category,
    this.scriptName,
    this.buySell,
    this.entryPrice,
    this.tp1,
    this.tp2,
    this.tp3,
    this.sl,
    this.tradeDuration,
    this.expireAt,
    this.publishDate,
    this.tradeFixedDuration,
    this.tradeAccepted,
    this.notes,
  });

  String id;
  String category;
  String scriptName;
  String buySell;
  String entryPrice;
  String tp1;
  String tp2;
  String tp3;
  String sl;
  String tradeDuration;
  String expireAt;
  DateTime publishDate;
  String tradeFixedDuration;
  bool tradeAccepted;
  String notes;

  factory Trade.fromJson(Map<String, dynamic> json) => Trade(
    id: json["id"],
    category: json["category"],
    scriptName: json["script_name"],
    buySell: json["buy_sell"],
    entryPrice: json["entry_price"],
    tp1: json["tp1"],
    tp2: json["tp2"],
    tp3: json["tp3"],
    sl: json["sl"],
    tradeDuration: json["trade_duration"],
    expireAt: json["expire_at"].toString(),
    publishDate: DateTime.parse(json["publish_date"]),
    tradeFixedDuration : json['trade_fixed_duration'],
    tradeAccepted: json["trade_accepted"],
    notes:json['note'],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category": category,
    "script_name": scriptName,
    "buy_sell": buySell,
    "entry_price": entryPrice,
    "tp1": tp1,
    "tp2": tp2,
    "tp3": tp3,
    "sl": sl,
    "trade_duration": tradeDuration,
    "expire_at": expireAt,
    "publish_date": publishDate.toIso8601String(),
    "trade_fixed_duration":tradeFixedDuration,
    "trade_accepted": tradeAccepted,
    "notes":notes,
  };
}
