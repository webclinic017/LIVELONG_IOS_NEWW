// To parse this JSON data, do
//
//     final videoListModel = videoListModelFromJson(jsonString);

import 'dart:convert';

VideoListModel videoListModelFromJson(String str) => VideoListModel.fromJson(json.decode(str));

String videoListModelToJson(VideoListModel data) => json.encode(data.toJson());

class VideoListModel {
  VideoListModel({
    this.module,
    this.message,
    this.status,
    this.statusCode,
  });

  List<Module> module;
  String message;
  bool status;
  String statusCode;

  factory VideoListModel.fromJson(Map<String, dynamic> json) => VideoListModel(
    module: List<Module>.from(json["module"].map((x) => Module.fromJson(x))),
    message: json["message"],
    status: json["status"],
    statusCode: json["status_code"],
  );

  Map<String, dynamic> toJson() => {
    "module": List<dynamic>.from(module.map((x) => x.toJson())),
    "message": message,
    "status": status,
    "status_code": statusCode,
  };
}

class Module {
  Module({
    this.id,
    this.title,
    this.description,
    this.videoUrl,
    this.image,
  });

  String id;
  String title;
  String description;
  String videoUrl;
  String image;

  factory Module.fromJson(Map<String, dynamic> json) => Module(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    videoUrl: json["video_url"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "video_url": videoUrl,
    "image": image,
  };
}
