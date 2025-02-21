import 'package:flutter/material.dart';
import 'package:routy/model/feedModel.dart';
import 'package:routy/model/user.dart';
import 'package:routy/state/feedState.dart';
import 'package:routy/state/notificationState.dart';
import 'package:routy/ui/page/feed/feedPostDetail.dart';
import 'package:routy/ui/page/profile/profilePage.dart';
import 'package:routy/ui/page/profile/widgets/circular_image.dart';
import 'package:routy/ui/theme/theme.dart';
import 'package:routy/widgets/customWidgets.dart';
import 'package:routy/widgets/newWidget/title_text.dart';
import 'package:routy/widgets/url_text/customUrlText.dart';
import 'package:provider/provider.dart';

class PostLikeTile extends StatelessWidget {
  final FeedModel model;
  const PostLikeTile({Key key, this.model}) : super(key: key);
  Widget _userList(BuildContext context, List<String> list) {
    // List<String> names = [];
    var length = list.length;
    List<Widget> avaterList = [];
    final int noOfUser = list.length;
    var state = Provider.of<NotificationState>(context);
    if (list != null && list.length > 5) {
      list = list.take(5).toList();
    }
    avaterList = list.map((userId) {
      return _userAvater(userId, state, (name) {
        // names.add(name);
      });
    }).toList();
    if (noOfUser > 5) {
      avaterList.add(
        Text(
          " +${noOfUser - 5}",
          style: TextStyles.subtitleStyle.copyWith(fontSize: 16),
        ),
      );
    }

    var col = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(width: 20),
            customIcon(context,
                icon: AppIcon.heartFill,
                iconColor: RoutyColor.ceriseRed,
                iscustomIcon: true,
                size: 25),
            SizedBox(width: 10),
            Row(children: avaterList),
          ],
        ),
        // names.length > 0 ? Text(names[0]) : SizedBox(),
        Padding(
          padding: EdgeInsets.only(left: 60, bottom: 5, top: 5),
          child: TitleText(
            '$length kişi beğendi',
            fontSize: 18,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
    return col;
  }

  Widget _userAvater(
      String userId, NotificationState state, ValueChanged<String> name) {
    return FutureBuilder(
      future: state.getuserDetail(userId),
      //  initialData: InitialData,
      builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
        if (snapshot.hasData) {
          name(snapshot.data.displayName);
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 3),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    ProfilePage.getRoute(profileId: snapshot.data?.userId));
              },
              child: CircularImage(path: snapshot.data.profilePic, height: 30),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String description = "";
    if (model.description != null) {
      description = model.description.length > 150
          ? model.description.substring(0, 150) + '...'
          : model.description;
    }
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          color: RoutyColor.white,
          child: ListTile(
            onTap: () {
              var state = Provider.of<FeedState>(context, listen: false);
              state.getpostDetailFromDatabase(null, model: model);

              Navigator.push(context, FeedPostDetail.getRoute(model.key));
            },
            title: _userList(context, model.likeList),
            subtitle: Padding(
              padding: EdgeInsets.only(left: 60),
              child: UrlText(
                text: description,
                style: TextStyle(
                  color: AppColor.darkGrey,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
        Divider(height: 0, thickness: .6)
      ],
    );
  }
}
