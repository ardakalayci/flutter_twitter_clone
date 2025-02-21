import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:routy/helper/utility.dart';
import 'package:routy/widgets/customFlatButton.dart';
import 'package:path_provider/path_provider.dart';

class ShareWidget extends StatefulWidget {
  const ShareWidget(
      {Key key, this.child, this.socialMetaTagParameters, this.id})
      : super(key: key);

  final SocialMetaTagParameters socialMetaTagParameters;
  final String id;
  static MaterialPageRoute getRoute(
      {Widget child,
      SocialMetaTagParameters socialMetaTagParameters,
      String id}) {
    return MaterialPageRoute(
      builder: (_) => ShareWidget(
          child: child,
          id: id,
          socialMetaTagParameters: socialMetaTagParameters),
    );
  }

  final Widget child;
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<ShareWidget> {
  GlobalKey _globalKey = new GlobalKey();
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  @override
  void dispose() {
    isLoading.dispose();
    super.dispose();
  }

  Future _capturePng() async {
    try {
      isLoading.value = true;
      RenderRepaintBoundary boundary =
          _globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      var path = await _localPath + "/${DateTime.now().toIso8601String()}.png";
      await writeToFile(byteData, path);

      var shareUrl = await Utility.createLinkToShare(context, widget.id,
          socialMetaTagParameters: widget.socialMetaTagParameters);
      var message =
          "*${widget.socialMetaTagParameters.title}*\n${widget.socialMetaTagParameters.description ?? " "}\n$shareUrl";
      Utility.shareFile([path], text: message);
      isLoading.value = false;
    } catch (e) {
      print(e);
    }
  }

  Future<File> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Paylaş'),
      ),
      body: SingleChildScrollView(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            RepaintBoundary(
                key: _globalKey,
                child: Container(
                  color: Theme.of(context).colorScheme.onPrimary,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: AbsorbPointer(
                    child: widget.child,
                  ),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: CustomFlatButton(
                label: "Paylaş",
                onPressed: _capturePng,
                isLoading: isLoading,
                labelStyle: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
