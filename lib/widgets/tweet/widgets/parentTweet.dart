import 'package:flutter/material.dart';
import 'package:routy/helper/enum.dart';
import 'package:routy/model/feedModel.dart';
import 'package:routy/state/feedState.dart';
import 'package:routy/ui/page/feed/feedPostDetail.dart';
import 'package:routy/widgets/tweet/tweet.dart';
import 'package:routy/widgets/tweet/widgets/unavailableTweet.dart';
import 'package:provider/provider.dart';

class ParentPostWidget extends StatelessWidget {
  ParentPostWidget(
      {Key key,
      this.childRePostkey,
      this.type,
      this.isImageAvailable,
      this.trailing})
      : super(key: key);

  final String childRePostkey;
  final PostType type;
  final Widget trailing;
  final bool isImageAvailable;

  void onTweetPressed(BuildContext context, FeedModel model) {
    var feedstate = Provider.of<FeedState>(context, listen: false);
    feedstate.getpostDetailFromDatabase(null, model: model);
    Navigator.push(context, FeedPostDetail.getRoute(model.key));
  }

  @override
  Widget build(BuildContext context) {
    var feedstate = Provider.of<FeedState>(context, listen: false);
    return FutureBuilder(
      future: feedstate.fetchTweet(childRePostkey),
      builder: (context, AsyncSnapshot<FeedModel> snapshot) {
        if (snapshot.hasData) {
          return Post(
              model: snapshot.data,
              type: PostType.ParentPost,
              trailing: trailing);
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
