import 'package:flutter/material.dart';
import 'package:routy/helper/constant.dart';
import 'package:routy/state/authState.dart';
import 'package:routy/ui/page/profile/follow/followerListPage.dart';
import 'package:routy/ui/page/profile/profilePage.dart';
import 'package:routy/ui/page/profile/qrCode/scanner.dart';
import 'package:routy/ui/page/profile/widgets/circular_image.dart';
import 'package:routy/ui/theme/theme.dart';
import 'package:routy/widgets/customWidgets.dart';
import 'package:routy/widgets/url_text/customUrlText.dart';
import 'package:provider/provider.dart';

class SidebarMenu extends StatefulWidget {
  const SidebarMenu({Key key, this.scaffoldKey}) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;

  _SidebarMenuState createState() => _SidebarMenuState();
}

class _SidebarMenuState extends State<SidebarMenu> {
  Widget _menuHeader() {
    final state = context.watch<AuthState>();
    if (state.userModel == null) {
      return ConstrainedBox(
        constraints: BoxConstraints(minWidth: 200, minHeight: 100),
        child: Center(
          child: Text(
            'Login to continue',
            style: TextStyles.onPrimaryTitleText,
          ),
        ),
      ).ripple(() {
        _logOut();
        //  Navigator.of(context).pushNamed('/signIn');
      });
    } else {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 56,
              width: 56,
              margin: EdgeInsets.only(left: 17, top: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(28),
                image: DecorationImage(
                  image: customAdvanceNetworkImage(
                    state.userModel.profilePic ?? Constants.dummyProfilePic,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context,
                    ProfilePage.getRoute(profileId: state.userModel.userId));
              },
              title: Row(
                children: <Widget>[
                  UrlText(
                    text: state.userModel.displayName ?? "",
                    style: TextStyles.onPrimaryTitleText
                        .copyWith(color: Colors.black, fontSize: 20),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  state.userModel.isVerified ?? false
                      ? customIcon(context,
                          icon: AppIcon.blueTick,
                          iscustomIcon: true,
                          iconColor: AppColor.primary,
                          size: 18,
                          paddingIcon: 3)
                      : SizedBox(
                          width: 0,
                        ),
                ],
              ),
              subtitle: customText(
                state.userModel.userName,
                style: TextStyles.onPrimarySubTitleText
                    .copyWith(color: Colors.black54, fontSize: 15),
              ),
              trailing: customIcon(context,
                  icon: AppIcon.arrowDown,
                  iconColor: AppColor.primary,
                  paddingIcon: 20),
            ),
            Container(
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 17,
                  ),
                  _tappbleText(context, '${state.userModel.getFollower}',
                      ' Takipçiler', 'FollowerListPage'),
                  SizedBox(width: 10),
                  _tappbleText(context, '${state.userModel.getFollowing}',
                      ' Takip Edilenler', 'FollowingListPage'),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _tappbleText(
      BuildContext context, String count, String text, String navigateTo) {
    return InkWell(
      onTap: () {
        var authstate = context.read<AuthState>();
        List<String> usersList;
        authstate.getProfileUser();
        Navigator.pop(context);
        switch (navigateTo) {
          case "FollowerListPage":
            usersList = authstate.userModel.followersList;
            break;
          case "FollowingListPage":
            usersList = authstate.userModel.followingList;
            break;
          default:
        }
        Navigator.push(
            context,
            FollowerListPage.getRoute(
                profile: authstate.userModel, userList: usersList));
      },
      child: Row(
        children: <Widget>[
          customText(
            '$count ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          customText(
            '$text',
            style: TextStyle(color: AppColor.darkGrey, fontSize: 17),
          ),
        ],
      ),
    );
  }

  ListTile _menuListRowButton(String title,
      {Function onPressed, IconData icon, bool isEnable = false}) {
    return ListTile(
      onTap: () {
        if (onPressed != null) {
          onPressed();
        }
      },
      leading: icon == null
          ? null
          : Padding(
              padding: EdgeInsets.only(top: 5),
              child: customIcon(
                context,
                icon: icon,
                size: 25,
                iconColor: isEnable ? AppColor.darkGrey : AppColor.lightGrey,
              ),
            ),
      title: customText(
        title,
        style: TextStyle(
          fontSize: 20,
          color: isEnable ? AppColor.secondary : AppColor.lightGrey,
        ),
      ),
    );
  }

  Positioned _footer() {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Column(
        children: <Widget>[
          Divider(height: 0),
          Row(
            children: <Widget>[
              SizedBox(
                width: 10,
                height: 45,
              ),
              customIcon(context,
                  icon: AppIcon.bulbOn,
                  iscustomIcon: true,
                  size: 25,
                  iconColor: RoutyColor.dodgetBlue),
              Spacer(),
              TextButton(
                onPressed: () {
                 /* Navigator.push(
                      context,
                      ScanScreen.getRoute(
                          context.read<AuthState>().profileUserModel));*/
                },
                child: Image.asset(
                  "assets/images/qr.png",
                  height: 25,
                ),
              ),
              SizedBox(
                width: 0,
                height: 45,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _logOut() {
    final state = Provider.of<AuthState>(context, listen: false);
    Navigator.pop(context);
    state.logoutCallback();
  }

  void _navigateTo(String path) {
    Navigator.pop(context);
    Navigator.of(context).pushNamed('/$path');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 45),
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  Container(
                    child: _menuHeader(),
                  ),
                  Divider(),
                  _menuListRowButton('Profile',
                      icon: AppIcon.profile, isEnable: true, onPressed: () {
                    var state = context.read<AuthState>();
                    Navigator.push(
                        context, ProfilePage.getRoute(profileId: state.userId));
                  }),/*
                  _menuListRowButton('Lists', icon: AppIcon.lists),
                  _menuListRowButton('Bookmark', icon: AppIcon.bookmark),
                  _menuListRowButton('Moments', icon: AppIcon.moments),
                  _menuListRowButton('Fwitter ads', icon: AppIcon.twitterAds),
                  Divider(),*/
                  _menuListRowButton('Ayarlar', isEnable: true,
                      onPressed: () {
                    _navigateTo('SettingsAndPrivacyPage');
                  }),
                  //_menuListRowButton('Help Center'),
                  Divider(),
                  _menuListRowButton('Çıkış Yap',
                      icon: null, onPressed: _logOut, isEnable: true),
                ],
              ),
            ),
            _footer()
          ],
        ),
      ),
    );
  }
}
