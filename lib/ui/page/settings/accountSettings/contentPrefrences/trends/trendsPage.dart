import 'package:flutter/material.dart';
import 'package:routy/helper/enum.dart';
import 'package:routy/ui/page/settings/widgets/settingsRowWidget.dart';
import 'package:routy/state/searchState.dart';
import 'package:routy/ui/theme/theme.dart';
import 'package:routy/widgets/customAppBar.dart';
import 'package:routy/widgets/customWidgets.dart';
import 'package:routy/widgets/newWidget/title_text.dart';
import 'package:provider/provider.dart';

class TrendsPage extends StatelessWidget {
  TrendsPage({Key key}) : super(key: key);

  void openBottomSheet(
      BuildContext context, double height, Widget child) async {
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

  void openUserSortSettings(BuildContext context) {
    openBottomSheet(
      context,
      340,
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
            child: TitleText('Sort user list'),
          ),
          Divider(height: 0),
          _row(context, "Verified user", SortUser.Verified),
          Divider(height: 0),
          _row(context, "Alphabetically", SortUser.Alphabetically),
          Divider(height: 0),
          _row(context, "Newest user", SortUser.Newest),
          Divider(height: 0),
          _row(context, "Oldest user", SortUser.Oldest),
          Divider(height: 0),
          _row(context, "Popular User", SortUser.MaxFollower),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String text, SortUser sortBy) {
    final state = Provider.of<SearchState>(context, listen: false);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
      child: RadioListTile<SortUser>(
        value: sortBy,
        activeColor: RoutyColor.dodgetBlue,
        groupValue: state.sortBy,
        onChanged: (val) {
          context.read<SearchState>().updateUserSortPrefrence = val;
          Navigator.pop(context);
        },
        title: Text(text, style: TextStyles.subtitleStyle),
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
        title: customTitleText('Trends'),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          SettingRowWidget(
            "Filtre",
            subtitle:
                context.select((SearchState value) => value.selectedFilter),
            onPressed: () {
              openUserSortSettings(context);
            },
            showDivider: false,
          ),
          SettingRowWidget(
            "Yakınındaki Trendler",
            navigateTo: null,
            subtitle: 'New York',
            showDivider: false,
          ),
          SettingRowWidget(
            null,
            subtitle:
                'You can see what\'s trending in a specfic location by selecting which location appears in your Trending tab.',
            navigateTo: null,
            showDivider: false,
            vPadding: 12,
          ),
        ],
      ),
    );
  }
}
