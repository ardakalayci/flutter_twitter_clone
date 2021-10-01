import 'package:flutter/material.dart';
import 'package:routy/model/user.dart';
import 'package:routy/ui/page/profile/profilePage.dart';
import 'package:routy/ui/page/profile/widgets/circular_image.dart';
import 'package:routy/ui/page/settings/widgets/headerWidget.dart';
import 'package:routy/ui/page/settings/widgets/settingsRowWidget.dart';
import 'package:routy/state/chats/chatState.dart';
import 'package:routy/ui/theme/theme.dart';
import 'package:routy/widgets/customAppBar.dart';
import 'package:routy/widgets/customWidgets.dart';
import 'package:routy/widgets/url_text/customUrlText.dart';
import 'package:routy/widgets/newWidget/rippleButton.dart';
import 'package:provider/provider.dart';

class ConversationInformation extends StatelessWidget {
  const ConversationInformation({Key key}) : super(key: key);

  Widget _header(BuildContext context, UserModel user) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 25),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: SizedBox(
                height: 80,
                width: 80,
                child: RippleButton(
                  onPressed: () {
                    Navigator.push(
                        context, ProfilePage.getRoute(profileId: user.userId));
                  },
                  borderRadius: BorderRadius.circular(40),
                  child: CircularImage(path: user.profilePic, height: 80),
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              UrlText(
                text: user.displayName,
                style: TextStyles.onPrimaryTitleText.copyWith(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                width: 3,
              ),
              user.isVerified
                  ? customIcon(
                      context,
                      icon: AppIcon.blueTick,
                      iscustomIcon: true,
                      iconColor: AppColor.primary,
                      size: 18,
                      paddingIcon: 3,
                    )
                  : SizedBox(width: 0),
            ],
          ),
          customText(
            user.userName,
            style: TextStyles.onPrimarySubTitleText.copyWith(
              color: Colors.black54,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<ChatState>(context).chatUser ?? UserModel();
    return Scaffold(
      backgroundColor: RoutyColor.white,
      appBar: CustomAppBar(
        isBackButton: true,
        title: customTitleText(
          'Conversation information',
        ),
      ),
      body: ListView(
        children: <Widget>[
          _header(context, user),
          HeaderWidget('Notifications'),
          SettingRowWidget(
            "Mute conversation",
            visibleSwitch: true,
          ),
          Container(
            height: 15,
            color: RoutyColor.mystic,
          ),
          SettingRowWidget(
            "Block ${user.userName}",
            textColor: RoutyColor.dodgetBlue,
            showDivider: false,
          ),
          SettingRowWidget("Report ${user.userName}",
              textColor: RoutyColor.dodgetBlue, showDivider: false),
          SettingRowWidget("Delete conversation",
              textColor: RoutyColor.ceriseRed, showDivider: false),
        ],
      ),
    );
  }
}
