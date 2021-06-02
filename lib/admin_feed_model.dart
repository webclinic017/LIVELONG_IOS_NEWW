// To parse this JSON data, do
//
//     final adminFeedModel = adminFeedModelFromJson(jsonString);

import 'dart:convert';

AdminFeedModel adminFeedModelFromJson(String str) => AdminFeedModel.fromJson(json.decode(str));

String adminFeedModelToJson(AdminFeedModel data) => json.encode(data.toJson());

class AdminFeedModel {
  AdminFeedModel({
    this.feeds,
    this.message,
    this.status,
    this.statusCode,
  });

  List<Feed> feeds;
  String message;
  bool status;
  String statusCode;

  factory AdminFeedModel.fromJson(Map<String, dynamic> json) => AdminFeedModel(
    feeds: List<Feed>.from(json["feeds"].map((x) => Feed.fromJson(x))),
    message: json["message"],
    status: json["status"],
    statusCode: json["status_code"],
  );

  Map<String, dynamic> toJson() => {
    "feeds": List<dynamic>.from(feeds.map((x) => x.toJson())),
    "message": message,
    "status": status,
    "status_code": statusCode,
  };
}

class Feed {
  Feed({
    this.id,
    this.title,
    this.description,
    this.publishDate,
    this.image,
  });

  String id;
  String title;
  String description;
  DateTime publishDate;
  String image;

  factory Feed.fromJson(Map<String, dynamic> json) => Feed(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    publishDate: DateTime.parse(json["publish_date"]),
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "publish_date": "${publishDate.year.toString().padLeft(4, '0')}-${publishDate.month.toString().padLeft(2, '0')}-${publishDate.day.toString().padLeft(2, '0')}",
    "image": image,
  };
}
