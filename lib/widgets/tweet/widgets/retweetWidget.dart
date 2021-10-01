import 'package:flutter/material.dart';
import 'package:routy/helper/enum.dart';
import 'package:routy/helper/utility.dart';
import 'package:routy/model/feedModel.dart';
import 'package:routy/state/feedState.dart';
import 'package:routy/ui/page/feed/feedPostDetail.dart';
import 'package:routy/ui/page/profile/widgets/circular_image.dart';
import 'package:routy/ui/theme/theme.dart';
import 'package:routy/widgets/customWidgets.dart';
import 'package:routy/widgets/newWidget/rippleButton.dart';
import 'package:routy/widgets/newWidget/title_text.dart';
import 'package:routy/widgets/tweet/widgets/tweetImage.dart';
import 'package:routy/widgets/tweet/widgets/unavailableTweet.dart';
import 'package:routy/widgets/url_text/customUrlText.dart';
import 'package:provider/provider.dart';

class RetweetWidget extends StatelessWidget {
  const RetweetWidget(
      {Key key, this.childRetwetkey, this.type, this.isImageAvailable = false})
      : super(key: key);

  final String childRetwetkey;
  final bool isImageAvailable;
  final PostType type;

  Widget _tweet(BuildContext context, FeedModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          width: context.width - 12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                width: 20,
                height: 20,
                child: CircularImage(path: model.user.profilePic),
              ),
              SizedBox(width: 10),
              ConstrainedBox(
                constraints:
                    BoxConstraints(minWidth: 0, maxWidth: context.width * .5),
                child: TitleText(
                  model.user.displayName,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 3),
              model.user.isVerified
                  ? customIcon(
                      context,
                      icon: AppIcon.blueTick,
                      iscustomIcon: true,
                      iconColor: AppColor.primary,
                      size: 13,
                      paddingIcon: 3,
                    )
                  : SizedBox(width: 0),
              SizedBox(
                width: model.user.isVerified ? 5 : 0,
              ),
              Flexible(
                child: customText(
                  '${model.user.userName}',
                  style: TextStyles.userNameStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 4),
              customText('· ${Utility.getChatTime(model.createdAt)}',
                  style: TextStyles.userNameStyle),
            ],
          ),
        ),
        model.description == null
            ? SizedBox()
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: UrlText(
                  text: model.description.takeOnly(150),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  urlStyle: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.w400),
                ),
              ),
        SizedBox(height: model.imagePath == null ? 8 : 0),
        PostImage(model: model, type: type, isRepostImage: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var feedstate = Provider.of<FeedState>(context, listen: false);
    return FutureBuilder(
      future: feedstate.fetchTweet(childRetwetkey),
      builder: (context, AsyncSnapshot<FeedModel> snapshot) {
        if (snapshot.hasData) {
          return Container(
            margin: EdgeInsets.only(
                left: type == PostType.Post || type == PostType.ParentPost
                    ? 70
                    : 12,
                right: 16,
                top: isImageAvailable ? 8 : 5),
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.extraLightGrey, width: .5),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: RippleButton(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              onPressed: () {
                feedstate.getpostDetailFromDatabase(null, model: snapshot.data);
                Navigator.push(
                    context, FeedPostDetail.getRoute(snapshot.data.key));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                child: _tweet(context, snapshot.data),
              ),
            ),
          );
        }
        if ((snapshot.connectionState == ConnectionState.done ||
                snapshot.connectionState == ConnectionState.waiting) &&
            !snapshot.hasData) {
          return UnavailablePost(
            snapshot: snapshot,
            type: type,
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
