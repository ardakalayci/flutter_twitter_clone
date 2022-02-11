import 'package:flutter/material.dart';
import 'package:routy/helper/customRoute.dart';
import 'package:routy/helper/utility.dart';
import 'package:routy/ui/page/profile/profilePage.dart';
import 'package:routy/ui/page/profile/widgets/circular_image.dart';
import 'package:routy/ui/theme/theme.dart';

class ProfileImageView extends StatelessWidget {
  const ProfileImageView({Key key, this.avatar}) : super(key: key);
  final String avatar;
  static Route<T> getRoute<T>(String avatar) {
    return SlideLeftRoute<T>(
        builder: (BuildContext context) => ProfileImageView(avatar: avatar));
  }

  @override
  Widget build(BuildContext context) {
    const List<Choice> choices = const <Choice>[
      const Choice(
          title: 'Paylaş', icon: Icons.share, isEnable: true),
      const Choice(
          title: 'Aç',
          icon: Icons.open_in_browser,
          isEnable: true),
      const Choice(title: 'Kaydet', icon: Icons.save),
    ];
    // var authstate = Provider.of<AuthState>(context, listen: false);
    return Scaffold(
      backgroundColor: RoutyColor.white,
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton<Choice>(
            onSelected: (d) {
              switch (d.title) {
                case "Paylaş":
                  Utility.share(avatar);
                  break;
                case "Aç":
                  Utility.launchURL(avatar);
                  break;
                case "Kaydet":
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return choices.map((Choice choice) {
                return PopupMenuItem<Choice>(
                    value: choice,
                    child: Text(choice.title,
                        style: TextStyles.textStyle14.copyWith(
                          color: choice.isEnable
                              ? AppColor.secondary.withOpacity(.9)
                              : AppColor.lightGrey,
                        )));
              }).toList();
            },
          ),
        ],
      ),
      body: Center(
        child: InteractiveViewer(
          child: Container(
            alignment: Alignment.center,
            width: context.width,
            // height: context.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: customAdvanceNetworkImage(avatar),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
