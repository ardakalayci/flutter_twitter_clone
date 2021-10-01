import 'package:flutter/material.dart';
import 'package:routy/model/user.dart';
import 'package:routy/ui/page/common/usersListPage.dart';
import 'package:routy/ui/theme/theme.dart';

class FollowerListPage extends StatelessWidget {
  FollowerListPage({Key key, this.userList, this.profile}) : super(key: key);
  final List<String> userList;
  final UserModel profile;

  static MaterialPageRoute getRoute(
      {List<String> userList, UserModel profile}) {
    return MaterialPageRoute(
      builder: (BuildContext context) {
        return FollowerListPage(
          profile: profile,
          userList: userList,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return UsersListPage(
      pageTitle: 'Takipçiler',
      userIdsList: userList,
      appBarIcon: AppIcon.follow,
      emptyScreenText: '${profile?.userName} henüz takipçisi yok',
      emptyScreenSubTileText:
          'Takip et sen görün',
    );
  }
}
