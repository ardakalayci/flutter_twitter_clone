import 'package:flutter/material.dart';
import 'package:routy/helper/utility.dart';
import 'package:routy/ui/page/settings/widgets/headerWidget.dart';
import 'package:routy/ui/page/settings/widgets/settingsRowWidget.dart';
import 'package:routy/ui/theme/theme.dart';
import 'package:routy/widgets/customAppBar.dart';
import 'package:routy/widgets/customWidgets.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RoutyColor.white,
      appBar: CustomAppBar(
        isBackButton: true,
        title: customTitleText(
          'Routy Hakkında',
        ),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          HeaderWidget(
            'Help',
            secondHeader: true,
          ),
          SettingRowWidget(
            "Help Centre",
            vPadding: 0,
            showDivider: false,
            onPressed: () {

            },
          ),
          HeaderWidget('Legal'),
          SettingRowWidget(
            "Terms of Service",
            showDivider: true,
          ),
          SettingRowWidget(
            "Privacy policy",
            showDivider: true,
          ),
          SettingRowWidget(
            "Cookie use",
            showDivider: true,
          ),
          SettingRowWidget(
            "Legal notices",
            showDivider: true,
            onPressed: () async {
              showLicensePage(
                context: context,
                applicationName: 'Routy',
                applicationVersion: '1.0.0',
                useRootNavigator: true,
              );
            },
          ),

        ],
      ),
    );
  }
}
