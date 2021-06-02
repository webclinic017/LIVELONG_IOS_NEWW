// To parse this JSON data, do
//
//     final registerModel = registerModelFromJson(jsonString);

import 'dart:convert';

RegisterModel registerModelFromJson(String str) => RegisterModel.fromJson(json.decode(str));

String registerModelToJson(RegisterModel data) => json.encode(data.toJson());

class RegisterModel {
  RegisterModel({
    this.statusCode,
    this.status,
    this.userId,
    this.message,
  });

  String statusCode;
  bool status;
  int userId;
  String message;

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
    statusCode: json["status_code"],
    status: json["status"],
    userId: json["user_id"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status": status,
    "user_id": userId,
    "message": message,
  };
}
