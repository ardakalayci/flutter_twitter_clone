import 'package:flutter/material.dart';
import 'package:routy/model/user.dart';
import 'package:routy/state/authState.dart';
import 'package:routy/ui/page/profile/profilePage.dart';
import 'package:routy/ui/page/profile/widgets/circular_image.dart';
import 'package:routy/ui/theme/theme.dart';
import 'package:routy/widgets/customWidgets.dart';
import 'package:routy/widgets/newWidget/rippleButton.dart';
import 'package:routy/widgets/newWidget/title_text.dart';
import 'package:provider/provider.dart';

class UserListWidget extends StatelessWidget {
  final List<UserModel> list;
  final String emptyScreenText;
  final String emptyScreenSubTileText;
  UserListWidget({
    Key key,
    this.list,
    this.emptyScreenText,
    this.emptyScreenSubTileText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AuthState>(context, listen: false);
    String myId = state.userModel.key;
    return ListView.separated(
      itemBuilder: (context, index) {
        return UserTile(
          user: list[index],
          myId: myId,
        );
      },
      separatorBuilder: (context, index) {
        return Divider(
          height: 0,
        );
      },
      itemCount: list.length,
    );
    // : LinearProgressIndicator();
  }
}

class UserTile extends StatelessWidget {
  const UserTile({Key key, this.user, this.myId}) : super(key: key);
  final UserModel user;
  final String myId;

  /// Return empty string for default bio
  /// Max length of bio is 100
  String getBio(String bio) {
    if (bio != null && bio.isNotEmpty && bio != "Bionu düzenle") {
      if (bio.length > 100) {
        bio = bio.substring(0, 100) + '...';
        return bio;
      } else {
        return bio;
      }
    }
    return null;
  }

  /// Check if user followerlist contain your or not
  /// If your id exist in follower list it mean you are following him
  bool isFollowing() {
    if (user.followersList != null &&
        user.followersList.any((x) => x == myId)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isFollow = isFollowing();
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      color: RoutyColor.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            onTap: () {
              Navigator.push(
                  context, ProfilePage.getRoute(profileId: user.userId));
            },
            leading: RippleButton(
              onPressed: () {
                Navigator.push(
                    context, ProfilePage.getRoute(profileId: user.userId));
              },
              borderRadius: BorderRadius.all(Radius.circular(60)),
              child: CircularImage(path: user.profilePic, height: 55),
            ),
            title: Row(
              children: <Widget>[
                ConstrainedBox(
                  constraints:
                      BoxConstraints(minWidth: 0, maxWidth: context.width * .4),
                  child: TitleText(user.displayName,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      overflow: TextOverflow.ellipsis),
                ),
                SizedBox(width: 3),
                user.isVerified
                    ? customIcon(
                        context,
                        icon: AppIcon.blueTick,
                        iscustomIcon: true,
                        iconColor: AppColor.primary,
                        size: 13,
                        paddingIcon: 3,
                      )
                    : SizedBox(width: 0),
              ],
            ),
            subtitle: Text(user.userName),
            trailing: RippleButton(
              onPressed: () {},
              splashColor: RoutyColor.dodgetBlue_50.withAlpha(100),
              borderRadius: BorderRadius.circular(25),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isFollow ? 15 : 20,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color:
                      isFollow ? RoutyColor.dodgetBlue : RoutyColor.white,
                  border: Border.all(color: RoutyColor.dodgetBlue, width: 1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  isFollow ? 'Takip ediliyor' : 'Takip et',
                  style: TextStyle(
                    color: isFollow ? RoutyColor.white : Colors.blue,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          getBio(user.bio) == null
              ? SizedBox.shrink()
              : Padding(
                  padding: EdgeInsets.only(left: 90),
                  child: Text(
                    getBio(user.bio),
                  ),
                )
        ],
      ),
    );
  }
}
