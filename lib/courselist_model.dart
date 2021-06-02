// To parse this JSON data, do
//
//     final courseListModel = courseListModelFromJson(jsonString);

import 'dart:convert';

CourseListModel courseListModelFromJson(String str) => CourseListModel.fromJson(json.decode(str));

String courseListModelToJson(CourseListModel data) => json.encode(data.toJson());

class CourseListModel {
  CourseListModel({
    this.courses,
    this.message,
    this.status,
    this.statusCode,
  });

  List<Course> courses;
  String message;
  bool status;
  String statusCode;

  factory CourseListModel.fromJson(Map<String, dynamic> json) => CourseListModel(
    courses: List<Course>.from(json["courses"].map((x) => Course.fromJson(x))),
    message: json["message"],
    status: json["status"],
    statusCode: json["status_code"],
  );

  Map<String, dynamic> toJson() => {
    "courses": List<dynamic>.from(courses.map((x) => x.toJson())),
    "message": message,
    "status": status,
    "status_code": statusCode,
  };
}

class Course {
  Course({
    this.id,
    this.name,
    this.image,
    this.amount,
    this.description,
    this.payment,
  });

  String id;
  String name;
  String image;
  String amount;
  String description;
  String payment;

  factory Course.fromJson(Map<String, dynamic> json) => Course(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    amount: json["amount"],
    description: json["description"],
    payment: json["payment"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "amount": amount,
    "description": description,
    "payment": payment,
  };
}
