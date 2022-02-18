import 'package:flutter/material.dart';
import 'package:routy/state/authState.dart';
import 'package:routy/ui/page/common/usersListPage.dart';
import 'package:routy/ui/theme/theme.dart';
import 'package:provider/provider.dart';

class FollowingListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AuthState>(context);
    return UsersListPage(
        pageTitle: 'Takip ediliyor',
        userIdsList: state.profileUserModel.followingList,
        appBarIcon: AppIcon.follow,
        emptyScreenText:
            '${state?.profileUserModel?.userName ?? state.userModel.userName} kimseyi takip etmiyor',
        emptyScreenSubTileText: 'Yaptıkların burada listelenecekler');
  }
}
