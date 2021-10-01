import 'package:routy/model/user.dart';

class FeedModel {
  String key;
  String parentkey;
  String childRetwetkey;
  String description;
  String userId;
  int likeCount;
  bool is_route;
  List<String> likeList;
  int commentCount;
  List route_map;
  int repostCount;
  String createdAt;
  String imagePath;
  List<String> tags;
  List<String> replyPostKeyList;
  UserModel user;
  FeedModel(
      {this.key,
      this.description,
      this.userId,
      this.likeCount,
      this.commentCount,
      this.repostCount,
      this.createdAt,
      this.imagePath,
      this.likeList,
      this.route_map,
      this.is_route,
      this.tags,
      this.user,
      this.replyPostKeyList,
      this.parentkey,
      this.childRetwetkey});
  toJson() {
    return {
      "userId": userId,
      "description": description,
      "likeCount": likeCount,
      "commentCount": commentCount ?? 0,
      "repostCount": repostCount ?? 0,
      "createdAt": createdAt,
      "imagePath": imagePath,
      "likeList": likeList,
      "tags": tags,
      "is_route":is_route,
      "route_map":route_map,
      "replyPostKeyList": replyPostKeyList,
      "user": user == null ? null : user.toJson(),
      "parentkey": parentkey,
      "childRetwetkey": childRetwetkey
    };
  }

  FeedModel.fromJson(Map<dynamic, dynamic> map) {
    key = map['key'];
    description = map['description'];
    userId = map['userId'];
    //  name = map['name'];
    //  profilePic = map['profilePic'];
    likeCount = map['likeCount'] ?? 0;
    commentCount = map['commentCount'];
    repostCount = map["repostCount"] ?? 0;
    imagePath = map['imagePath'];
    createdAt = map['createdAt'];
    is_route = map['is_route']==null?false:map['is_route'];
    route_map = map['route_map']==null?null:map['route_map'];
    imagePath = map['imagePath'];
    //  username = map['username'];
    user = UserModel.fromJson(map['user']);
    parentkey = map['parentkey'];
    childRetwetkey = map['childRetwetkey'];
    if (map['tags'] != null) {
      tags = <String>[];
      map['tags'].forEach((value) {
        tags.add(value);
      });
    }
    if (map["likeList"] != null) {
      likeList = <String>[];

      final list = map['likeList'];

      /// In new tweet db schema likeList is stored as a List<String>()
      ///
      if (list is List) {
        map['likeList'].forEach((value) {
          if (value is String) {
            likeList.add(value);
          }
        });
        likeCount = likeList.length ?? 0;
      }

      /// In old database tweet db schema likeList is saved in the form of map
      /// like list map is removed from latest code but to support old schema below code is required
      /// Once all user migrated to new version like list map support will be removed
      else if (list is Map) {
        list.forEach((key, value) {
          likeList.add(value["userId"]);
        });
        likeCount = list.length;
      }
    } else {
      likeList = [];
      likeCount = 0;
    }
    if (map['replyPostKeyList'] != null) {
      map['replyPostKeyList'].forEach((value) {
        replyPostKeyList = <String>[];
        map['replyPostKeyList'].forEach((value) {
          replyPostKeyList.add(value);
        });
      });
      commentCount = replyPostKeyList.length;
    } else {
      replyPostKeyList = [];
      commentCount = 0;
    }
  }

  bool get isValidPost {
    bool isValid = false;
    if (this.user != null &&
        this.user.userName != null &&
        this.user.userName.isNotEmpty) {
      isValid = true;
    } else {
      print("Invalid Post found. Id:- $key");
    }
    return isValid;
  }

  /// get tweet key to retweet.
  ///
  /// If tweet [TweetType] is [TweetType.Repost] and its description is null
  /// then its retweeted child tweet will be shared.
  String get getTweetKeyToRetweet {
    if (this.description == null &&
        this.imagePath == null &&
        this.childRetwetkey != null) {
      return this.childRetwetkey;
    } else {
      return this.key;
    }
  }
}
