import 'package:flutter/material.dart';
import 'package:routy/helper/enum.dart';
import 'package:routy/model/feedModel.dart';
import 'package:routy/ui/theme/theme.dart';

class UnavailablePost extends StatelessWidget {
  const UnavailablePost({Key key, this.snapshot, this.type}) : super(key: key);

  final AsyncSnapshot<FeedModel> snapshot;
  final PostType type;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 16),
      margin: EdgeInsets.only(
          right: 16,
          top: 5,
          left: type == PostType.Post || type == PostType.ParentPost
              ? 70
              : 16),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: AppColor.extraLightGrey.withOpacity(.3),
        border: Border.all(color: AppColor.extraLightGrey, width: .5),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: snapshot.connectionState == ConnectionState.waiting
          ? SizedBox(
              height: 2,
              child: LinearProgressIndicator(
                backgroundColor: AppColor.extraLightGrey,
                valueColor: AlwaysStoppedAnimation(
                  AppColor.darkGrey.withOpacity(.3),
                ),
              ),
            )
          : Text('This Tweet is unavailable', style: TextStyles.userNameStyle),
    );
  }
}
