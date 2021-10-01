import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:routy/ui/page/route_create/route_create_page.dart';
import 'package:routy/ui/theme/theme.dart';
import 'package:routy/widgets/customWidgets.dart';
import 'package:google_place/google_place.dart';
import 'package:image_picker/image_picker.dart';

class ComposeBottomIconWidget extends StatefulWidget {
  final TextEditingController textEditingController;
  final Function(File) onImageIconSelcted;
  final Function(DetailsResult) setRoute;

  ComposeBottomIconWidget({Key key, this.textEditingController, this.onImageIconSelcted,this.setRoute}) : super(key: key);

  @override
  _ComposeBottomIconWidgetState createState() => _ComposeBottomIconWidgetState();
}

class _ComposeBottomIconWidgetState extends State<ComposeBottomIconWidget> {
  bool reachToWarning = false;
  bool reachToOver = false;
  Color wordCountColor;
  String tweet = '';


  @override
  void initState() {
    wordCountColor = Colors.blue;
    widget.textEditingController.addListener(updateUI);
    super.initState();
  }

  void updateUI() {
    setState(() {
      tweet = widget.textEditingController.text;
      if (widget.textEditingController.text != null && widget.textEditingController.text.isNotEmpty) {
        if (widget.textEditingController.text.length > 259 && widget.textEditingController.text.length < 280) {
          wordCountColor = Colors.orange;
        } else if (widget.textEditingController.text.length >= 280) {
          wordCountColor = Theme.of(context).errorColor;
        } else {
          wordCountColor = Colors.blue;
        }
      }
    });
  }

  Widget _bottomIconWidget() {
    return Container(
      width: context.width,
      height: 50,
      decoration: BoxDecoration(border: Border(top: BorderSide(color: Theme.of(context).dividerColor)), color: Theme.of(context).backgroundColor),
      child: Row(
        children: <Widget>[
          IconButton(
              onPressed: () {
                setImage(ImageSource.gallery);
              },
              icon: customIcon(context, icon: AppIcon.image, iscustomIcon: true, iconColor: AppColor.primary)),
          IconButton(
              onPressed: () {
                setImage(ImageSource.camera);
              },
              icon: customIcon(context, icon: AppIcon.camera, iscustomIcon: true, iconColor: AppColor.primary)),
          Expanded(
            child: IconButton(
                onPressed: () async {
                  var route = await Navigator.push(context, MaterialPageRoute(builder: (context) => RouteCreatePage()));

                },
                icon: customIcon(context, icon: FontAwesome5Solid.route, size: 20, iscustomIcon: true, iconColor: AppColor.primary)),
          ),
          Expanded(
              child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                child: tweet != null && tweet.length > 289
                    ? Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: customText('${280 - tweet.length}', style: TextStyle(color: Theme.of(context).errorColor)),
                      )
                    : Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(
                            value: getTweetLimit(),
                            backgroundColor: Colors.grey,
                            valueColor: AlwaysStoppedAnimation<Color>(wordCountColor),
                          ),
                          tweet.length > 259
                              ? customText('${280 - tweet.length}', style: TextStyle(color: wordCountColor))
                              : customText('', style: TextStyle(color: wordCountColor))
                        ],
                      )),
          ))
        ],
      ),
    );
  }

  void setImage(ImageSource source) {
    ImagePicker().pickImage(source: source, imageQuality: 20).then((XFile file) {
      setState(() {
        // _image = file;
        widget.onImageIconSelcted(File(file.path));
      });
    });
  }

  void setRoute(DetailsResult result) {
setState(() {
  print(result.name);
  print("aaa");
  widget.setRoute(result);

});
  }

  double getTweetLimit() {
    if (tweet == null || tweet.isEmpty) {
      return 0.0;
    }
    if (tweet.length > 280) {
      return 1.0;
    }
    var length = tweet.length;
    var val = length * 100 / 28000.0;
    return val;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _bottomIconWidget(),
    );
  }
}
