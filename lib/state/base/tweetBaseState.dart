import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:routy/helper/enum.dart';
import 'package:routy/helper/utility.dart';
import 'package:routy/model/feedModel.dart';
import 'package:routy/state/appState.dart';

class TweetBaseState extends AppState {
  /// get [Tweet Detail] from firebase realtime kDatabase
  /// If model is null then fetch tweet from firebase
  /// [getpostDetailFromDatabase] is used to set prepare Tweetr to display Tweet detail
  /// After getting tweet detail fetch tweet coments from firebase
  Future<FeedModel> getpostDetailFromDatabase(String postID) async {
    try {
      FeedModel post;

      // Fetch post data from firebase
      return await kDatabase
          .child('post')
          .child(postID)
          .once()
          .then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          var map = snapshot.value;
          post = FeedModel.fromJson(map);
          post.key = snapshot.key;
        }
        return post;
      });
    } catch (error) {
      cprint(error, errorIn: 'getpostDetailFromDatabase');
      return null;
    }
  }

  Future<List<FeedModel>> getTweetsComments(FeedModel post) async {
    List<FeedModel> _commentlist;
    // Check if parent tweet has reply tweets or not
    if (post.replyPostKeyList != null && post.replyPostKeyList.length > 0) {
      post.replyPostKeyList.forEach((x) async {
        if (x == null) {
          return;
        }
      });
      _commentlist = [];
      for (var replyTweetId in post.replyPostKeyList) {
        if (replyTweetId != null) {
          await kDatabase
              .child('post')
              .child(replyTweetId)
              .once()
              .then((DataSnapshot snapshot) {
            if (snapshot.value != null) {
              var commentmodel = FeedModel.fromJson(snapshot.value);
              var key = snapshot.key;
              commentmodel.key = key;

              /// add comment tweet to list if tweet is not present in [comment tweet ]list
              /// To reduce duplicacy
              if (!_commentlist.any((x) => x.key == key)) {
                _commentlist.add(commentmodel);
              }
            } else {}
            if (replyTweetId == post.replyPostKeyList.last) {
              /// Sort comment by time
              /// It helps to display newest Tweet first.
              _commentlist.sort((x, y) => DateTime.parse(y.createdAt)
                  .compareTo(DateTime.parse(x.createdAt)));
            }
          });
        }
      }
    }
    return _commentlist;
  }

  /// [Delete tweet] in Firebase kDatabase
  /// Remove Tweet if present in home page Tweet list
  /// Remove Tweet if present in Tweet detail page or in comment
  bool deleteTweet(String tweetId, PostType type, {String parentkey}) {
    try {
      /// Delete tweet if it is in nested tweet detail page
      kDatabase.child('post').child(tweetId).remove();
      return true;
    } catch (error) {
      cprint(error, errorIn: 'deletePost');
      return false;
    }
  }

  /// [update] tweet
  void updateTweet(FeedModel model) async {
    await kDatabase.child('post').child(model.key).set(model.toJson());
  }

  /// Add/Remove like on a Tweet
  /// [postId] is tweet id, [userId] is user's id who like/unlike Tweet
  void addLikeToTweet(FeedModel tweet, String userId) {
    try {
      if (tweet.likeList != null &&
          tweet.likeList.length > 0 &&
          tweet.likeList.any((id) => id == userId)) {
        // If user wants to undo/remove his like on tweet
        tweet.likeList.removeWhere((id) => id == userId);
        tweet.likeCount -= 1;
      } else {
        // If user like Tweet
        if (tweet.likeList == null) {
          tweet.likeList = [];
        }
        tweet.likeList.add(userId);
        tweet.likeCount += 1;
      }
      // update likelist of a tweet
      kDatabase
          .child('post')
          .child(tweet.key)
          .child('likeList')
          .set(tweet.likeList);

      // Sends notification to user who created tweet
      // UserModel owner can see notification on notification page
      kDatabase.child('notification').child(tweet.userId).child(tweet.key).set({
        'type': tweet.likeList.length == 0
            ? null
            : NotificationType.Like.toString(),
        'updatedAt': tweet.likeList.length == 0
            ? null
            : DateTime.now().toUtc().toString(),
      });
    } catch (error) {
      cprint(error, errorIn: 'addLikeToPost');
    }
  }

  /// Add new [tweet]
  /// Returns new tweet id
  String createPost(FeedModel tweet) {
    var json = tweet.toJson();
    var refence = kDatabase.child('post').push();
    refence.set(json);
    return refence.key;
  }

  /// upload [file] to firebase storage and return its  path url
  Future<String> uploadFile(File file) async {
    try {
      // isBusy = true;
      notifyListeners();
      var storageReference = FirebaseStorage.instance
          .ref()
          .child("tweetImage")
          .child(Path.basename(DateTime.now().toIso8601String() + file.path));
      await storageReference.putFile(file);

      var url = await storageReference.getDownloadURL();
      if (url != null) {
        return url;
      }
      return null;
    } catch (error) {
      cprint(error, errorIn: 'uploadFile');
      return null;
    }
  }
}
