import 'package:flutter/material.dart';
part 'app_icons.dart';
part 'color/light_color.dart';
part 'text_styles.dart';
part 'extention.dart';

class AppTheme {
  static final ThemeData apptheme = ThemeData(
      primarySwatch: Colors.deepOrange,
      // fontFamily: 'HelveticaNeue',
      backgroundColor: RoutyColor.white,
      accentColor: RoutyColor.dodgetBlue,
      brightness: Brightness.light,
      primaryColor: AppColor.primary,
      cardColor: Colors.white,
      unselectedWidgetColor: Colors.grey,
      bottomAppBarColor: Colors.white,
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: AppColor.white),
      appBarTheme: AppBarTheme(
          brightness: Brightness.light,
          color: RoutyColor.white,
          iconTheme: IconThemeData(
            color: RoutyColor.dodgetBlue,
          ),
          elevation: 0,
          textTheme: TextTheme(
            headline5: TextStyle(
                color: Colors.black, fontSize: 26, fontStyle: FontStyle.normal),
          )),
      tabBarTheme: TabBarTheme(
        labelStyle:
            TextStyles.titleStyle.copyWith(color: RoutyColor.dodgetBlue),
        unselectedLabelColor: AppColor.darkGrey,
        unselectedLabelStyle:
            TextStyles.titleStyle.copyWith(color: AppColor.darkGrey),
        labelColor: RoutyColor.dodgetBlue,
        labelPadding: EdgeInsets.symmetric(vertical: 12),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: RoutyColor.dodgetBlue,
      ),
      colorScheme: ColorScheme(
          background: Colors.white,
          onPrimary: Colors.white,
          onBackground: Colors.black,
          onError: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.black,
          error: Colors.red,
          primary: Colors.deepOrange,
          primaryVariant: Colors.deepOrange,
          secondary: AppColor.secondary,
          secondaryVariant: AppColor.darkGrey,
          surface: Colors.white,
          brightness: Brightness.light));

  static List<BoxShadow> shadow = <BoxShadow>[
    BoxShadow(
        blurRadius: 10,
        offset: Offset(5, 5),
        color: AppTheme.apptheme.accentColor,
        spreadRadius: 1)
  ];
  static BoxDecoration softDecoration = BoxDecoration(boxShadow: <BoxShadow>[
    BoxShadow(
        blurRadius: 8,
        offset: Offset(5, 5),
        color: Color(0xffe2e5ed),
        spreadRadius: 5),
    BoxShadow(
        blurRadius: 8,
        offset: Offset(-5, -5),
        color: Color(0xffffffff),
        spreadRadius: 5)
  ], color: Color(0xfff1f3f6));
}

String get description {
  return '';
}
