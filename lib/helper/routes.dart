import 'package:flutter/material.dart';
import 'package:routy/ui/page/Auth/selectAuthMethod.dart';
import 'package:routy/ui/page/Auth/verifyEmail.dart';
import 'package:routy/ui/page/common/splash.dart';
import 'package:routy/ui/page/feed/composePost/composePost.dart';
import 'package:routy/ui/page/feed/composePost/state/composeTweetState.dart';
import 'package:routy/ui/page/message/conversationInformation/conversationInformation.dart';
import 'package:routy/ui/page/message/newMessagePage.dart';
import 'package:routy/ui/page/profile/follow/followerListPage.dart';
import 'package:routy/ui/page/profile/follow/followingListPage.dart';
import 'package:routy/ui/page/search/SearchPage.dart';
import 'package:routy/ui/page/settings/accountSettings/about/aboutTwitter.dart';
import 'package:routy/ui/page/settings/accountSettings/accessibility/accessibility.dart';
import 'package:routy/ui/page/settings/accountSettings/accountSettingsPage.dart';
import 'package:routy/ui/page/settings/accountSettings/contentPrefrences/contentPreference.dart';
import 'package:routy/ui/page/settings/accountSettings/contentPrefrences/trends/trendsPage.dart';
import 'package:routy/ui/page/settings/accountSettings/dataUsage/dataUsagePage.dart';
import 'package:routy/ui/page/settings/accountSettings/displaySettings/displayAndSoundPage.dart';
import 'package:routy/ui/page/settings/accountSettings/notifications/notificationPage.dart';
import 'package:routy/ui/page/settings/accountSettings/privacyAndSafety/directMessage/directMessage.dart';
import 'package:routy/ui/page/settings/accountSettings/privacyAndSafety/privacyAndSafetyPage.dart';
import 'package:routy/ui/page/settings/accountSettings/proxy/proxyPage.dart';
import 'package:routy/ui/page/settings/settingsAndPrivacyPage.dart';
import 'package:provider/provider.dart';

import '../helper/customRoute.dart';
import '../ui/page/Auth/forgetPasswordPage.dart';
import '../ui/page/Auth/signin.dart';
import '../ui/page/Auth/signup.dart';
import '../ui/page/feed/feedPostDetail.dart';
import '../ui/page/feed/imageViewPage.dart';
import '../ui/page/message/chatScreenPage.dart';
import '../ui/page/profile/EditProfilePage.dart';
import '../ui/page/profile/profilePage.dart';
import '../widgets/customWidgets.dart';

class Routes {
  static dynamic route() {
    return {
      'SplashPage': (BuildContext context) => SplashPage(),
    };
  }

  static void sendNavigationEventToFirebase(String path) {
    if (path != null && path.isNotEmpty) {
      print(path);
      print("-*-*-**--**--*");
      // analytics.setCurrentScreen(screenName: path);
    }
  }

  static Route onGenerateRoute(RouteSettings settings) {
    print(settings.name);
    print("-*-*-**--**--*");
    final List<String> pathElements = settings.name.split('/');
    if (pathElements[0] != '' || pathElements.length == 1) {
      return null;
    }
    switch (pathElements[1]) {
      case "ComposeTweetPage":
        bool isRepost = false;
        bool isPost = false;
        if (pathElements.length == 3 && pathElements[2].contains('repost')) {
          isRepost = true;
        } else if (pathElements.length == 3 &&
            pathElements[2].contains('post')) {
          isPost = true;
        }
        return CustomRoute<bool>(
            builder: (BuildContext context) =>
                ChangeNotifierProvider<ComposeTweetState>(
                  create: (_) => ComposeTweetState(),
                  child:
                      ComposePostPage(isRetweet: isRepost, isTweet: isPost),
                ));
      case "FeedPostDetail":
        var postId = pathElements[2];
        return SlideLeftRoute<bool>(
            builder: (BuildContext context) => FeedPostDetail(
                  postId: postId,
                ),
            settings: RouteSettings(name: 'FeedPostDetail'));
      case "ProfilePage":
        String profileId;
        if (pathElements.length > 2) {
          profileId = pathElements[2];
        }
        return CustomRoute<bool>(
            builder: (BuildContext context) => ProfilePage(
                  profileId: profileId,
                ));
      case "CreateFeedPage":
        return CustomRoute<bool>(
            builder: (BuildContext context) =>
                ChangeNotifierProvider<ComposeTweetState>(
                  create: (_) => ComposeTweetState(),
                  child: ComposePostPage(isRetweet: false, isTweet: true),
                ));
      case "WelcomePage":
        return CustomRoute<bool>(
            builder: (BuildContext context) => WelcomePage());
      case "SignIn":
        return CustomRoute<bool>(builder: (BuildContext context) => SignIn());
      case "SignUp":
        return CustomRoute<bool>(builder: (BuildContext context) => Signup());
      case "ForgetPasswordPage":
        return CustomRoute<bool>(
            builder: (BuildContext context) => ForgetPasswordPage());
      case "SearchPage":
        return CustomRoute<bool>(
            builder: (BuildContext context) => SearchPage());
      case "ImageViewPge":
        return CustomRoute<bool>(
            builder: (BuildContext context) => ImageViewPge());
      case "ChatScreenPage":
        return CustomRoute<bool>(
            builder: (BuildContext context) => ChatScreenPage());
      case "NewMessagePage":
        return CustomRoute<bool>(
          builder: (BuildContext context) => NewMessagePage(),
        );
      case "SettingsAndPrivacyPage":
        return CustomRoute<bool>(
          builder: (BuildContext context) => SettingsAndPrivacyPage(),
        );
      case "AccountSettingsPage":
        return CustomRoute<bool>(
          builder: (BuildContext context) => AccountSettingsPage(),
        );
      case "AccountSettingsPage":
        return CustomRoute<bool>(
          builder: (BuildContext context) => AccountSettingsPage(),
        );
      case "PrivacyAndSaftyPage":
        return CustomRoute<bool>(
          builder: (BuildContext context) => PrivacyAndSaftyPage(),
        );
      case "NotificationPage":
        return CustomRoute<bool>(
          builder: (BuildContext context) => NotificationPage(),
        );
      case "ContentPrefrencePage":
        return CustomRoute<bool>(
          builder: (BuildContext context) => ContentPrefrencePage(),
        );
      case "DisplayAndSoundPage":
        return CustomRoute<bool>(
          builder: (BuildContext context) => DisplayAndSoundPage(),
        );
      case "DirectMessagesPage":
        return CustomRoute<bool>(
          builder: (BuildContext context) => DirectMessagesPage(),
        );
      case "TrendsPage":
        return CustomRoute<bool>(
          builder: (BuildContext context) => TrendsPage(),
        );
      case "DataUsagePage":
        return CustomRoute<bool>(
          builder: (BuildContext context) => DataUsagePage(),
        );
      case "AccessibilityPage":
        return CustomRoute<bool>(
          builder: (BuildContext context) => AccessibilityPage(),
        );
      case "ProxyPage":
        return CustomRoute<bool>(
          builder: (BuildContext context) => ProxyPage(),
        );
      case "AboutPage":
        return CustomRoute<bool>(
          builder: (BuildContext context) => AboutPage(),
        );
      case "ConversationInformation":
        return CustomRoute<bool>(
          builder: (BuildContext context) => ConversationInformation(),
        );
      case "FollowingListPage":
        return CustomRoute<bool>(
          builder: (BuildContext context) => FollowingListPage(),
        );
      case "FollowerListPage":
        return CustomRoute<bool>(
          builder: (BuildContext context) => FollowerListPage(),
        );
      case "VerifyEmailPage":
        return CustomRoute<bool>(
          builder: (BuildContext context) => VerifyEmailPage(),
        );
      default:
        return onUnknownRoute(RouteSettings(name: '/Feature'));
    }
  }

  static Route onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: customTitleText(settings.name.split('/')[1]),
          centerTitle: true,
        ),
        body: Center(
          child: Text('${settings.name.split('/')[1]} Comming soon..'),
        ),
      ),
    );
  }
}
