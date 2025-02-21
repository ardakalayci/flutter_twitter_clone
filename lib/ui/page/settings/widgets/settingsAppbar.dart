import 'package:flutter/material.dart';
import 'package:routy/ui/theme/theme.dart';
import 'package:routy/widgets/customWidgets.dart';

class SettingsAppBar extends StatelessWidget implements PreferredSizeWidget {
  SettingsAppBar({Key key, this.title, this.subtitle}) : super(key: key);
  final String title, subtitle;
  final Size appBarHeight = Size.fromHeight(60.0);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 5),
          customTitleText(
            title,
          ),
          Text(
            subtitle ?? '',
            style: TextStyle(color: AppColor.darkGrey, fontSize: 18),
          )
        ],
      ),
      iconTheme: IconThemeData(color: Colors.blue),
      backgroundColor: Colors.white,
    );
  }

  @override
  Size get preferredSize => appBarHeight;
}
