// import 'package:fancy_bottom_navigation/internal/tab_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:routy/state/appState.dart';
import 'package:routy/ui/theme/theme.dart';
import 'package:routy/widgets/bottomMenuBar/tabItem.dart';
import 'package:provider/provider.dart';

import '../customWidgets.dart';
// import 'customBottomNavigationBar.dart';

class BottomMenubar extends StatefulWidget {
  const BottomMenubar({this.pageController});

  final PageController pageController;

  _BottomMenubarState createState() => _BottomMenubarState();
}

class _BottomMenubarState extends State<BottomMenubar> {
  @override
  void initState() {
    super.initState();
  }

  Widget _iconRow() {
    var state = Provider.of<AppState>(
      context,
    );
    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: Theme.of(context).bottomAppBarColor, boxShadow: [BoxShadow(color: Colors.black12, offset: Offset(0, -.1), blurRadius: 0)]),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _icon(null, 0, icon: 0 == state.pageIndex ? AppIcon.homeFill : AppIcon.home, isCustomIcon: true),
          _icon(null, 1, icon: 1 == state.pageIndex ? AppIcon.searchFill : AppIcon.search, isCustomIcon: true),
          //_icon(null, 2, icon: 4 == state.pageIndex ? Icons.add :Icons.add, isCustomIcon: false),
          _icon(null, 3, icon: 3 == state.pageIndex ? AppIcon.messageFill : AppIcon.messageEmpty, isCustomIcon: true),
          _icon(null, 4, icon: 2 == state.pageIndex ? AppIcon.notificationFill : AppIcon.notification, isCustomIcon: true),

        ],
      ),
    );
  }

  Widget _icon(IconData iconData, int index, {bool isCustomIcon = false, IconData icon}) {
    var state = Provider.of<AppState>(
      context,
    );
    return Expanded(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        child: AnimatedAlign(
          duration: Duration(milliseconds: ANIM_DURATION),
          curve: Curves.easeIn,
          alignment: Alignment(0, ICON_ON),
          child: AnimatedOpacity(
            duration: Duration(milliseconds: ANIM_DURATION),
            opacity: ALPHA_ON,
            child: IconButton(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              padding: EdgeInsets.all(0),
              alignment: Alignment(0, 0),
              icon: isCustomIcon
                  ? customIcon(context, icon: icon, size: 22, iscustomIcon: true, isEnable: index == state.pageIndex)
                  : Icon(
                      icon,
                      color: index == state.pageIndex ? Theme.of(context).primaryColor : Theme.of(context).textTheme.caption.color,
                    ),
              onPressed: () {
                setState(() {
                  state.setpageIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _iconRow();
  }
}
