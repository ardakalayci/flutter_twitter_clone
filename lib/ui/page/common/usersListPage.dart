import 'package:flutter/material.dart';
import 'package:routy/model/user.dart';
import 'package:routy/state/searchState.dart';
import 'package:routy/ui/page/common/widget/userListWidget.dart';
import 'package:routy/ui/theme/theme.dart';
import 'package:routy/widgets/customAppBar.dart';
import 'package:routy/widgets/customWidgets.dart';
import 'package:routy/widgets/newWidget/emptyList.dart';
import 'package:provider/provider.dart';

class UsersListPage extends StatelessWidget {
  UsersListPage({
    Key key,
    this.pageTitle = "",
    this.appBarIcon,
    this.emptyScreenText,
    this.emptyScreenSubTileText,
    this.userIdsList,
  }) : super(key: key);

  final String pageTitle;
  final String emptyScreenText;
  final String emptyScreenSubTileText;
  final IconData appBarIcon;
  final List<String> userIdsList;

  @override
  Widget build(BuildContext context) {
    List<UserModel> userList;
    return Scaffold(
      backgroundColor: RoutyColor.mystic,
      appBar: CustomAppBar(
          isBackButton: true,
          title: customTitleText(pageTitle),
          icon: appBarIcon),
      body: Consumer<SearchState>(
        builder: (context, state, child) {
          if (userIdsList != null && userIdsList.isNotEmpty) {
            userList = state.getuserDetail(userIdsList);
          }
          return !(userList != null && userList.isNotEmpty)
              ? Container(
                  width: context.width,
                  padding: EdgeInsets.only(top: 0, left: 30, right: 30),
                  child: NotifyText(
                    title: emptyScreenText,
                    subTitle: emptyScreenSubTileText,
                  ),
                )
              : UserListWidget(
                  list: userList,
                  emptyScreenText: emptyScreenText,
                  emptyScreenSubTileText: emptyScreenSubTileText,
                );
        },
      ),
    );
  }
}
