// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    this.user,
    this.message,
    this.status,
    this.statusCode,
  });

  User user;
  String message;
  bool status;
  String statusCode;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    user: User.fromJson(json["user"]),
    message: json["message"],
    status: json["status"],
    statusCode: json["status_code"],
  );

  Map<String, dynamic> toJson() => {
    "user": user.toJson(),
    "message": message,
    "status": status,
    "status_code": statusCode,
  };
}

class User {
  User({
    this.id,
    this.name,
    this.email,
    this.address,
    this.phone,
    this.otpVerified,
  });

  String id;
  String name;
  String email;
  String address;
  String phone;
  String otpVerified;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    address: json["address"],
    phone: json["phone"],
    otpVerified: json["otp_verified"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "address": address,
    "phone": phone,
    "otp_verified": otpVerified,
  };
}
