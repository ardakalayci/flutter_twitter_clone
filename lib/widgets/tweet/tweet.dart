import 'package:flutter/material.dart';
import 'package:routy/helper/enum.dart';
import 'package:routy/helper/utility.dart';
import 'package:routy/model/feedModel.dart';
import 'package:routy/state/feedState.dart';
import 'package:routy/ui/page/feed/feedPostDetail.dart';
import 'package:routy/ui/page/profile/profilePage.dart';
import 'package:routy/ui/page/profile/widgets/circular_image.dart';
import 'package:routy/ui/theme/theme.dart';
import 'package:routy/widgets/newWidget/title_text.dart';
import 'package:routy/widgets/tweet/widgets/parentTweet.dart';
import 'package:routy/widgets/tweet/widgets/tweetIconsRow.dart';
import 'package:routy/widgets/url_text/customUrlText.dart';
import 'package:routy/widgets/url_text/custom_link_media_info.dart';
import 'package:provider/provider.dart';
import 'package:timeline_node/timeline_node.dart';

import '../customWidgets.dart';
import 'widgets/retweetWidget.dart';
import 'widgets/tweetImage.dart';

class Post extends StatelessWidget {
  final FeedModel model;
  final Widget trailing;
  final PostType type;
  final bool isDisplayOnProfile;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const Post({
    Key key,
    this.model,
    this.trailing,
    this.type = PostType.Post,
    this.isDisplayOnProfile = false,
    this.scaffoldKey,
  }) : super(key: key);

  void onLongPressedPost(BuildContext context) {
    if (type == PostType.Detail || type == PostType.ParentPost) {
      Utility.copyToClipBoard(scaffoldKey: scaffoldKey, text: model.description ?? "", message: "Tweet copy to clipboard");
    }
  }

  void onTapTweet(BuildContext context) {
    var feedstate = Provider.of<FeedState>(context, listen: false);
    if (type == PostType.Detail || type == PostType.ParentPost) {
      return;
    }
    if (type == PostType.Post && !isDisplayOnProfile) {
      feedstate.clearAllDetailAndReplyTweetStack();
    }
    feedstate.getpostDetailFromDatabase(null, model: model);
    Navigator.push(context, FeedPostDetail.getRoute(model.key));
  }

  @override
  Widget build(BuildContext context) {
    return !model.is_route
        ? Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              /// Left vertical bar of a tweet
              type != PostType.ParentPost
                  ? SizedBox.shrink()
                  : Positioned.fill(
                      child: Container(
                        margin: EdgeInsets.only(
                          left: 38,
                          top: 75,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(width: 2.0, color: Colors.grey.shade400),
                          ),
                        ),
                      ),
                    ),
              InkWell(
                onLongPress: () {
                  onLongPressedPost(context);
                },
                onTap: () {
                  onTapTweet(context);
                },
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                          top: type == PostType.Post || type == PostType.Reply ? 12 : 0,
                        ),
                        child: type == PostType.Post || type == PostType.Reply
                            ? _TweetBody(
                                isDisplayOnProfile: isDisplayOnProfile,
                                model: model,
                                trailing: trailing,
                                type: type,
                              )
                            : _TweetDetailBody(
                                isDisplayOnProfile: isDisplayOnProfile,
                                model: model,
                                trailing: trailing,
                                type: type,
                              ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: PostImage(
                          model: model,
                          type: type,
                        ),
                      ),
                      model.childRetwetkey == null
                          ? SizedBox.shrink()
                          : RetweetWidget(
                              childRetwetkey: model.childRetwetkey,
                              type: type,
                              isImageAvailable: model.imagePath != null && model.imagePath.isNotEmpty,
                            ),
                      type == PostType.Post || type == PostType.Reply
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Text(
                                    "1. The Colosseum and its murderous games",
                                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Image.network("https://www.voyagetips.com/wp-content/uploads/2017/05/colisee-rome-840x486.jpg"),
                                  ),
                                  Text(
                                    "The visit isn’t free and you will probably have to wait for a few hours before getting there if you are going in high season.",
                                    style: TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Divider(height: 40,),
                                  Text(
                                    "2. The Roman Forum",
                                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Image.network("https://www.voyagetips.com/wp-content/uploads/2017/05/forum-romain-rome-840x630.jpg"),
                                  ),
                                  Text(
                                    "The ticket purchased at the Colosseum also includes access to the Roman Forum and the Palatine Hill (I will talk about it just below), so it would be a shame to miss them, as the 3 touristic sites are linked together.",
                                    style: TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Divider(height: 40,),
                                  Text(
                                    "3. The Palatine Hill",
                                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Image.network("https://www.voyagetips.com/wp-content/uploads/2017/05/mont-palatin-rome-840x473.jpg"),
                                  ),
                                  Text(
                                    "Palatine Hill, one of the 7 hills of Rome, is according to mythology the place where the city was founded by Romulus and Remus. As you might know, they are the two twins who would have been found and suckled by a wolf in a cave.",
                                    style: TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                      Padding(
                        padding: EdgeInsets.only(left: type == PostType.Detail ? 10 : 60),
                        child: TweetIconsRow(
                          type: type,
                          model: model,
                          isTweetDetail: type == PostType.Detail,
                          iconColor: Theme.of(context).textTheme.caption.color,
                          iconEnableColor: RoutyColor.ceriseRed,
                          size: 20,
                        ),
                      ),
                      type == PostType.ParentPost ? SizedBox.shrink() : Divider(height: .5, thickness: .5)
                    ],
                  ),
                ),
              ),
            ],
          )
        : Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              /// Left vertical bar of a tweet
              type != PostType.ParentPost
                  ? SizedBox.shrink()
                  : Positioned.fill(
                      child: Container(
                        margin: EdgeInsets.only(
                          left: 38,
                          top: 75,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(width: 2.0, color: Colors.grey.shade400),
                          ),
                        ),
                      ),
                    ),
              InkWell(
                onLongPress: () {
                  onLongPressedPost(context);
                },
                onTap: () {
                  onTapTweet(context);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                        top: type == PostType.Post || type == PostType.Reply ? 12 : 0,
                      ),
                      child: type == PostType.Post || type == PostType.Reply
                          ? _TweetBodyRoute(
                              isDisplayOnProfile: isDisplayOnProfile,
                              model: model,
                              trailing: trailing,
                              type: type,
                            )
                          : _TweetDetailBody(
                              isDisplayOnProfile: isDisplayOnProfile,
                              model: model,
                              trailing: trailing,
                              type: type,
                            ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: PostImage(
                        model: model,
                        type: type,
                      ),
                    ),
                    model.childRetwetkey == null
                        ? SizedBox.shrink()
                        : RetweetWidget(
                            childRetwetkey: model.childRetwetkey,
                            type: type,
                            isImageAvailable: model.imagePath != null && model.imagePath.isNotEmpty,
                          ),
                    Padding(
                      padding: EdgeInsets.only(left: type == PostType.Detail ? 10 : 60),
                      child: TweetIconsRow(
                        type: type,
                        model: model,
                        isTweetDetail: type == PostType.Detail,
                        iconColor: Theme.of(context).textTheme.caption.color,
                        iconEnableColor: RoutyColor.ceriseRed,
                        size: 20,
                      ),
                    ),
                    type == PostType.ParentPost ? SizedBox.shrink() : Divider(height: .5, thickness: .5)
                  ],
                ),
              ),
            ],
          );
  }
}

class _TweetBody extends StatelessWidget {
  final FeedModel model;
  final Widget trailing;
  final PostType type;
  final bool isDisplayOnProfile;

  const _TweetBody({Key key, this.model, this.trailing, this.type, this.isDisplayOnProfile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double descriptionFontSize = type == PostType.Post
        ? 15
        : type == PostType.Detail || type == PostType.ParentPost
            ? 18
            : 14;
    FontWeight descriptionFontWeight = type == PostType.Post || type == PostType.Post ? FontWeight.w400 : FontWeight.w400;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: 10),
        Container(
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () {
              // If tweet is displaying on someone's profile then no need to navigate to same user's profile again.
              if (isDisplayOnProfile) {
                return;
              }
              Navigator.push(context, ProfilePage.getRoute(profileId: model.userId));
            },
            child: CircularImage(path: model.user.profilePic),
          ),
        ),
        SizedBox(width: 20),
        Container(
          width: context.width - 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        ConstrainedBox(
                          constraints: BoxConstraints(minWidth: 0, maxWidth: context.width * .5),
                          child: TitleText(model.user.displayName, fontSize: 16, fontWeight: FontWeight.w800, overflow: TextOverflow.ellipsis),
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
                        customText('· ${Utility.getChatTime(model.createdAt)}', style: TextStyles.userNameStyle),
                      ],
                    ),
                  ),
                  Container(child: trailing == null ? SizedBox() : trailing),
                ],
              ),
              model.description == null
                  ? SizedBox()
                  : UrlText(
                      text: model.description.removeSpaces,
                      onHashTagPressed: (tag) {
                        cprint(tag);
                      },
                      style: TextStyle(color: Colors.black, fontSize: descriptionFontSize, fontWeight: descriptionFontWeight),
                      urlStyle: TextStyle(color: Colors.blue, fontSize: descriptionFontSize, fontWeight: descriptionFontWeight),
                    ),
              if (model.imagePath == null && model.description != null) CustomLinkMediaInfo(text: model.description),
            ],
          ),
        ),
        SizedBox(width: 10),
      ],
    );
  }
}

class _TweetBodyRoute extends StatelessWidget {
  final FeedModel model;
  final Widget trailing;
  final PostType type;
  final bool isDisplayOnProfile;

  const _TweetBodyRoute({Key key, this.model, this.trailing, this.type, this.isDisplayOnProfile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double descriptionFontSize = type == PostType.Post
        ? 15
        : type == PostType.Detail || type == PostType.ParentPost
            ? 18
            : 14;
    FontWeight descriptionFontWeight = type == PostType.Post || type == PostType.Post ? FontWeight.w400 : FontWeight.w400;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: 10),
        Container(
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () {
              // If tweet is displaying on someone's profile then no need to navigate to same user's profile again.
              if (isDisplayOnProfile) {
                return;
              }
              Navigator.push(context, ProfilePage.getRoute(profileId: model.userId));
            },
            child: CircularImage(path: model.user.profilePic),
          ),
        ),
        SizedBox(width: 20),
        Container(
          width: context.width - 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        ConstrainedBox(
                          constraints: BoxConstraints(minWidth: 0, maxWidth: context.width * .5),
                          child: TitleText(model.user.displayName, fontSize: 16, fontWeight: FontWeight.w800, overflow: TextOverflow.ellipsis),
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
                        customText('· ${Utility.getChatTime(model.createdAt)}', style: TextStyles.userNameStyle),
                      ],
                    ),
                  ),
                  Container(child: trailing == null ? SizedBox() : trailing),
                ],
              ),
              model.description == null
                  ? SizedBox()
                  : Container(
                      height: MediaQuery.of(context).size.height * .37,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: model.route_map.length,
                          itemBuilder: (context, index) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Card(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(
                                              (index + 1).toString() + ". " + model.route_map[index]["name"],
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                            ),
                                          ),
                                          Container(
                                            height: MediaQuery.of(context).size.height * .25,
                                            width: MediaQuery.of(context).size.height * .25,
                                            child: Image.network(
                                              model.route_map[index]["image"],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.height * .25,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(model.route_map[index]["description"].toString().length > 90
                                            ? model.route_map[index]["description"].toString().substring(0, 100) + "..."
                                            : model.route_map[index]["description"].toString() + "..."),
                                      ),
                                    )
                                  ],
                                ),
                                Icon(Icons.arrow_right_alt)
                              ],
                            );
                          }),
                    ),
              if (model.imagePath == null && model.description != null) CustomLinkMediaInfo(text: model.description),
            ],
          ),
        ),
        SizedBox(width: 10),
      ],
    );
  }
}

class _TweetDetailBody extends StatelessWidget {
  final FeedModel model;
  final Widget trailing;
  final PostType type;
  final bool isDisplayOnProfile;

  const _TweetDetailBody({Key key, this.model, this.trailing, this.type, this.isDisplayOnProfile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double descriptionFontSize = type == PostType.Post
        ? context.getDimention(context, 15)
        : type == PostType.Detail
            ? context.getDimention(context, 18)
            : type == PostType.ParentPost
                ? context.getDimention(context, 14)
                : 10;

    FontWeight descriptionFontWeight = type == PostType.Post || type == PostType.Post ? FontWeight.w300 : FontWeight.w400;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        model.parentkey != null && model.childRetwetkey == null && type != PostType.ParentPost
            ? ParentPostWidget(childRePostkey: model.parentkey, isImageAvailable: false, trailing: trailing)
            : SizedBox.shrink(),
        Container(
          width: context.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                leading: GestureDetector(
                  onTap: () {
                    Navigator.push(context, ProfilePage.getRoute(profileId: model.userId));
                  },
                  child: CircularImage(path: model.user.profilePic),
                ),
                title: Row(
                  children: <Widget>[
                    ConstrainedBox(
                      constraints: BoxConstraints(minWidth: 0, maxWidth: context.width * .5),
                      child: TitleText(model.user.displayName, fontSize: 16, fontWeight: FontWeight.w800, overflow: TextOverflow.ellipsis),
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
                  ],
                ),
                subtitle: customText('${model.user.userName}', style: TextStyles.userNameStyle),
                trailing: trailing,
              ),
              model.description == null
                  ? SizedBox()
                  : Padding(
                      padding: type == PostType.ParentPost ? EdgeInsets.only(left: 80, right: 16) : EdgeInsets.symmetric(horizontal: 16),
                      child: UrlText(
                        text: model.description.removeSpaces,
                        onHashTagPressed: (tag) {
                          cprint(tag);
                        },
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: descriptionFontSize,
                          fontWeight: descriptionFontWeight,
                        ),
                        urlStyle: TextStyle(
                          color: Colors.blue,
                          fontSize: descriptionFontSize,
                          fontWeight: descriptionFontWeight,
                        ),
                      ),
                    ),
              if (model.imagePath == null && model.description != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomLinkMediaInfo(text: model.description),
                )
            ],
          ),
        ),
      ],
    );
  }
}
