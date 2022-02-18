import 'package:flutter/material.dart';
import 'package:routy/ui/page/settings/widgets/headerWidget.dart';
import 'package:routy/ui/page/settings/widgets/settingsRowWidget.dart';
import 'package:routy/ui/theme/theme.dart';
import 'package:routy/widgets/customAppBar.dart';
import 'package:routy/widgets/customWidgets.dart';
import 'package:routy/widgets/newWidget/title_text.dart';

class DataUsagePage extends StatelessWidget {
  const DataUsagePage({Key key}) : super(key: key);

  void openBottomSheet(
    BuildContext context,
    double height,
    Widget child,
  ) async {
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          height: height,
          decoration: BoxDecoration(
            color: RoutyColor.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: child,
        );
      },
    );
  }

  void openDarkModeSettings(BuildContext context) {
    openBottomSheet(
      context,
      250,
      Column(
        children: <Widget>[
          SizedBox(height: 5),
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: RoutyColor.paleSky50,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: TitleText('Data preference'),
          ),
          Divider(height: 0),
          _row("Mobile data & Wi-Fi"),
          Divider(height: 0),
          _row("Wi-Fi only"),
          Divider(height: 0),
          _row("Never"),
        ],
      ),
    );
  }

  void openDarkModeAppearanceSettings(BuildContext context) {
    openBottomSheet(
      context,
      190,
      Column(
        children: <Widget>[
          SizedBox(height: 5),
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: RoutyColor.paleSky50,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: TitleText('Dark mode appearance'),
          ),
          Divider(height: 0),
          _row("Dim"),
          Divider(height: 0),
          _row("Light out"),
        ],
      ),
    );
  }

  Widget _row(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
      child: RadioListTile(
        value: false,
        groupValue: true,
        onChanged: (val) {},
        title: Text(text),
        controlAffinity: ListTileControlAffinity.trailing,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RoutyColor.white,
      appBar: CustomAppBar(
        isBackButton: true,
        title: customTitleText(
          'Data Usage',
        ),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          HeaderWidget('Data Saver'),
          SettingRowWidget(
            "Data saver",
            showCheckBox: true,
            vPadding: 15,
            showDivider: false,
            subtitle:
                'Etkinleştirildiğinde, video otomatik olarak oynatılmaz ve daha düşük kaliteli görüntüler yüklenir. Bu, bu cihazdaki tüm Routy hesapları için veri kullanımınızı otomatik olarak azaltır.',
          ),
          Divider(height: 0),
          HeaderWidget('Images'),
          SettingRowWidget(
            "Yüksek kaliteli görüntüler",
            subtitle:
                'Mobil veri ve Wi-Fi \n\nYüksek kaliteli resimlerin ne zaman yükleneceğini seçin.',
            vPadding: 15,
            onPressed: () {
              openDarkModeSettings(context);
            },
            showDivider: false,
          ),
          HeaderWidget(
            'Video',
            secondHeader: true,
          ),
          SettingRowWidget(
            "High-quality video",
            subtitle:
                'Wi-Fi only \n\nSelect when the highest quality available should play.',
            vPadding: 15,
            onPressed: () {
              openDarkModeSettings(context);
            },
          ),
          SettingRowWidget(
            "Video autoplay",
            subtitle:
                'Wi-Fi only \n\nSelect when video should play automatically.',
            vPadding: 15,
            onPressed: () {
              openDarkModeSettings(context);
            },
          ),
          HeaderWidget(
            'Data sync',
            secondHeader: true,
          ),
          SettingRowWidget(
            "Sync data",
            showCheckBox: true,
          ),
          SettingRowWidget(
            "Sync interval",
            subtitle: 'Daily',
          ),
          SettingRowWidget(
            null,
            subtitle:
                'Allow Routy to sync data in the background to enhance your experience.',
            vPadding: 10,
          ),
        ],
      ),
    );
  }
}
