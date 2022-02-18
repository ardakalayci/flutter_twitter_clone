import 'package:flutter/material.dart';
import 'package:routy/model/user.dart';
import 'package:routy/state/authState.dart';
import 'package:routy/ui/page/settings/widgets/headerWidget.dart';
import 'package:routy/ui/page/settings/widgets/settingsAppbar.dart';
import 'package:routy/ui/page/settings/widgets/settingsRowWidget.dart';
import 'package:routy/ui/theme/theme.dart';
import 'package:provider/provider.dart';

class DirectMessagesPage extends StatelessWidget {
  const DirectMessagesPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<AuthState>(context).userModel ?? UserModel();
    return Scaffold(
      backgroundColor: RoutyColor.white,
      appBar: SettingsAppBar(
        title: 'Mesajlar',
        subtitle: user.userName,
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          HeaderWidget(
            'Mesajlar',
            secondHeader: true,
          ),
          SettingRowWidget(
            "Receive message requests",
            navigateTo: null,
            showDivider: false,
            visibleSwitch: true,
            vPadding: 20,
            subtitle:
                "Routy'deki herkesten, onları takip etmeseniz bile Direkt Mesaj istekleri alabileceksiniz.",
          ),
          SettingRowWidget(
            "Show read receipts",
            navigateTo: null,
            showDivider: false,
            visibleSwitch: true,
            subtitle:
                'Biri size bir mesaj gönderdiğinde, görüşmedeki kişiler onu gördüğünüzü bilecek. Bu ayarı kapatırsanız, diğerlerinden okundu bilgisi göremezsiniz.',
          ),
        ],
      ),
    );
  }
}
