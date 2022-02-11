import 'dart:convert';

import 'package:routy/model/user.dart';

class NotificationModel {
  String id;
  String tweetKey;
  String updatedAt;
  String createdAt;
  String type;
  Map<String, dynamic> data;

  NotificationModel(
      {this.id,
      this.tweetKey,
      this.type,
      this.createdAt,
      this.updatedAt,
      this.data});

  NotificationModel.fromJson(String postId, Map<dynamic, dynamic> map) {
    this.id = postId;
    final data = json.decode(json.encode(map["data"])) as Map<String, dynamic>;
    tweetKey = postId;
    this.updatedAt = map["updatedAt"];
    this.type = map["type"];
    this.createdAt = map["createdAt"];
    this.data = data;
  }

  Map<String, dynamic> toJson() => {
        "tweetKey": tweetKey == null ? null : tweetKey,
      };
}

extension NotificationModelHelper on NotificationModel {
  UserModel get user => UserModel.fromJson(this.data);
  DateTime get timeStamp => DateTime.tryParse(this.updatedAt ?? this.createdAt);
}
