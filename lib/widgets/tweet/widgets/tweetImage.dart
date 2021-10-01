import 'package:flutter/material.dart';
import 'package:routy/helper/enum.dart';
import 'package:routy/model/feedModel.dart';
import 'package:routy/state/feedState.dart';
import 'package:routy/widgets/cache_image.dart';
import 'package:routy/ui/theme/theme.dart';
import 'package:provider/provider.dart';

class PostImage extends StatelessWidget {
  const PostImage(
      {Key key, this.model, this.type, this.isRepostImage = false})
      : super(key: key);

  final FeedModel model;
  final PostType type;
  final bool isRepostImage;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      alignment: Alignment.centerRight,
      child: model.imagePath == null
          ? SizedBox.shrink()
          : Padding(
              padding: EdgeInsets.only(
                top: 8,
              ),
              child: InkWell(
                borderRadius: BorderRadius.all(
                  Radius.circular(isRepostImage ? 0 : 20),
                ),
                onTap: () {
                  if (type == PostType.ParentPost) {
                    return;
                  }
                  var state = Provider.of<FeedState>(context, listen: false);
                  state.getpostDetailFromDatabase(model.key);
                  state.setPostToReply = model;
                  Navigator.pushNamed(context, '/ImageViewPge');
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(isRepostImage ? 0 : 20),
                  ),
                  child: Container(
                    width:
                        context.width * (type == PostType.Detail ? .95 : .8) -
                            8,
                    decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                    ),
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
                      child:
                          CacheImage(path: model.imagePath, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
