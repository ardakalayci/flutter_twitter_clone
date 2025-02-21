import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:routy/helper/enum.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:routy/model/chatModel.dart';
import 'package:routy/helper/utility.dart';
import 'package:routy/model/user.dart';
import 'package:routy/state/appState.dart';

class ChatState extends AppState {
  bool setIsChatScreenOpen;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  List<ChatMessage> _messageList;
  List<ChatMessage> _chatUserList;
  UserModel _chatUser;
  String serverToken = "<FCM SERVER KEY>";

  /// Get FCM server key from firebase project settings
  UserModel get chatUser => _chatUser;
  set setChatUser(UserModel model) {
    _chatUser = model;
  }

  String _channelName;
  Query messageQuery;

  /// Contains list of chat messages on main chat screen
  /// List is sortBy mesage timeStamp
  /// Last message will be display on the bottom of screen
  List<ChatMessage> get messageList {
    if (_messageList == null) {
      return null;
    } else {
      _messageList.sort((x, y) => DateTime.parse(y.createdAt)
          .toLocal()
          .compareTo(DateTime.parse(x.createdAt).toLocal()));
      return _messageList;
    }
  }

  /// Contain list of users who have chat history with logged in user
  List<ChatMessage> get chatUserList {
    if (_chatUserList == null) {
      return null;
    } else {
      return List.from(_chatUserList);
    }
  }

  void databaseInit(String userId, String myId) async {
    _messageList = null;
    if (_channelName == null) {
      getChannelName(userId, myId);
    }
    kDatabase
        .child("chatUsers")
        .child(myId)
        .onChildAdded
        .listen(_onChatUserAdded);
    if (messageQuery == null || _channelName != getChannelName(userId, myId)) {
      messageQuery = kDatabase.child("chats").child(_channelName);
      messageQuery.onChildAdded.listen(_onMessageAdded);
      messageQuery.onChildChanged.listen(_onMessageChanged);
    }
  }

  void getFCMServerKey() async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    await remoteConfig.fetchAndActivate();
    // await remoteConfig.
    var data = remoteConfig.getString('FcmServerKey');
    if (data != null && data.isNotEmpty) {
      serverToken = jsonDecode(data)["key"];
    } else {
      cprint("Please configure Remote config in firebase",
          errorIn: "getFCMServerKey");
    }
  }

  /// Fetch users list to who have ever engaged in chat message with logged-in user
  void getUserchatList(String userId) {
    try {
      kDatabase
          .child('chatUsers')
          .child(userId)
          .once()
          .then((DataSnapshot snapshot) {
        _chatUserList = <ChatMessage>[];
        if (snapshot.value != null) {
          var map = snapshot.value;
          if (map != null) {
            map.forEach((key, value) {
              var model = ChatMessage.fromJson(value);
              model.key = key;
              _chatUserList.add(model);
            });
          }
          _chatUserList.sort((x, y) {
            if (x.createdAt != null && y.createdAt != null) {
              return DateTime.parse(y.createdAt)
                  .compareTo(DateTime.parse(x.createdAt));
            } else {
              if (x.createdAt != null) {
                return 0;
              } else {
                return 1;
              }
            }
          });
        } else {
          _chatUserList = null;
        }
        notifyListeners();
      });
    } catch (error) {
      cprint(error);
    }
  }

  /// Fetch chat  all chat messages
  /// `_channelName` is used as primary key for chat message table
  /// `_channelName` is created from  by combining first 5 letters from user ids of two users
  void getchatDetailAsync() async {
    try {
      kDatabase
          .child('chats')
          .child(_channelName)
          .once()
          .then((DataSnapshot snapshot) {
        _messageList = <ChatMessage>[];
        if (snapshot.value != null) {
          var map = snapshot.value;
          if (map != null) {
            map.forEach((key, value) {
              var model = ChatMessage.fromJson(value);
              model.key = key;
              _messageList.add(model);
            });
          }
        } else {
          _messageList = null;
        }
        notifyListeners();
      });
    } catch (error) {
      cprint(error);
    }
  }

  /// Send message to other user
  void onMessageSubmitted(ChatMessage message,
      {UserModel myUser, UserModel secondUser}) {
    print(chatUser.userId);
    try {
      // if (_messageList == null || _messageList.length < 1) {
      kDatabase
          .child('chatUsers')
          .child(message.senderId)
          .child(message.receiverId)
          .set(message.toJson());

      kDatabase
          .child('chatUsers')
          .child(chatUser.userId)
          .child(message.senderId)
          .set(message.toJson());

      kDatabase.child('chats').child(_channelName).push().set(message.toJson());
      sendAndRetrieveMessage(message);
      Utility.logEvent('send_message');
    } catch (error) {
      cprint(error);
    }
  }

  /// Channel name is like a room name
  /// which save messages of two user uniquely in database
  String getChannelName(String user1, String user2) {
    user1 = user1.substring(0, 5);
    user2 = user2.substring(0, 5);
    List<String> list = [user1, user2];
    list.sort();
    _channelName = '${list[0]}-${list[1]}';
    // cprint(_channelName); //2RhfE-5kyFB
    return _channelName;
  }

  /// Method will trigger every time when you send/recieve  from/to someone messgae.
  void _onMessageAdded(Event event) {
    if (_messageList == null) {
      _messageList = <ChatMessage>[];
    }
    if (event.snapshot.value != null) {
      var map = event.snapshot.value;
      if (map != null) {
        var model = ChatMessage.fromJson(map);
        model.key = event.snapshot.key;
        if (_messageList.length > 0 &&
            _messageList.any((x) => x.key == model.key)) {
          return;
        }
        _messageList.add(model);
      }
    } else {
      _messageList = null;
    }
    notifyListeners();
  }

  void _onMessageChanged(Event event) {
    if (_messageList == null) {
      _messageList = <ChatMessage>[];
    }
    if (event.snapshot.value != null) {
      var map = event.snapshot.value;
      if (map != null) {
        var model = ChatMessage.fromJson(map);
        model.key = event.snapshot.key;
        if (_messageList.length > 0 &&
            _messageList.any((x) => x.key == model.key)) {
          return;
        }
        _messageList.add(model);
      }
    } else {
      _messageList = null;
    }
    notifyListeners();
  }

  void _onChatUserAdded(Event event) {
    if (_chatUserList == null) {
      _chatUserList = <ChatMessage>[];
    }
    if (event.snapshot.value != null) {
      var map = event.snapshot.value;
      if (map != null) {
        var model = ChatMessage.fromJson(map);
        model.key = event.snapshot.key;
        if (_chatUserList.length > 0 &&
            _chatUserList.any((x) => x.key == model.key)) {
          return;
        }
        _chatUserList.add(model);
      }
    } else {
      _chatUserList = null;
    }
    notifyListeners();
  }

  // update last message on chat user list screen when manin chat screen get closed.
  void onChatScreenClosed() {
    if (_chatUserList != null &&
        _chatUserList.isNotEmpty &&
        _chatUserList.any((element) => element.key == chatUser.userId)) {
      var user = _chatUserList.firstWhere((x) => x.key == chatUser.userId);
      if (_messageList != null) {
        user.message = _messageList.first.message;
        user.createdAt = _messageList.first.createdAt; //;
        _messageList = null;
        notifyListeners();
      }
    }
  }

  /// Push notification will be sent to other user when you send him a message in chat.
  /// To send push notification make sure you have FCM `serverToken`
  void sendAndRetrieveMessage(ChatMessage model) async {
    // await firebaseMessaging.requestNotificationPermissions(
    //   const IosNotificationSettings(
    //       sound: true, badge: true, alert: true, provisional: false),
    // );
    if (chatUser.fcmToken == null) {
      return;
    }

    var body = jsonEncode(<String, dynamic>{
      'notification': <String, dynamic>{
        'body': model.message,
        'title': "Message from ${model.senderName}"
      },
      'priority': 'high',
      'data': <String, dynamic>{
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done',
        "type": NotificationType.Message.toString(),
        "senderId": model.senderId,
        "receiverId": model.receiverId,
        "title": "title",
        "body": model.message,
      },
      'to': chatUser.fcmToken
    });
    var response =
        await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'key=$serverToken',
            },
            body: body);
    if (response.reasonPhrase.contains("INVALID_KEY")) {
      cprint(
        "You are using Invalid FCM key",
        errorIn: "sendAndRetrieveMessage",
      );
      return;
    }
    cprint(response.body.toString());
  }
}
