import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:routy/helper/utility.dart';
import 'package:routy/state/authState.dart';
import 'package:routy/ui/page/Auth/widget/googleLoginButton.dart';
import 'package:routy/ui/theme/theme.dart';
import 'package:routy/widgets/customFlatButton.dart';
import 'package:routy/widgets/customWidgets.dart';
import 'package:routy/widgets/newWidget/customLoader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class FormLogin extends StatefulWidget {
  final VoidCallback loginCallback;

  const FormLogin({
    Key key,
    this.loginCallback
  }) : super(key: key);

  @override
  _FormLoginState createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> with SingleTickerProviderStateMixin {
  CustomLoader loader;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var tweenLeft = Tween<Offset>(begin: Offset.zero, end: Offset(-1.1, 0)).chain(CurveTween(curve: Curves.ease));
  var tweenRight = Tween<Offset>(begin: Offset(1.1, 0), end: Offset(0, 0)).chain(CurveTween(curve: Curves.ease));

  AnimationController _animationController;
  final _formKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _registerEmailTextController = TextEditingController();
  final _registerPasswordTextController = TextEditingController();
  final _nameTextController = TextEditingController();

  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  final _focusRegisterEmail = FocusNode();
  final _focusName = FocusNode();
  final _focusRegisterPassword = FocusNode();

  bool _isProcessing = false;
  bool _isVisible = true;
  var _isMoved = false;
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    loader = CustomLoader();

    try {
      _controller = VideoPlayerController.network('https://firebasestorage.googleapis.com/v0/b/routyapp-a3468.appspot.com/o/final_613b1065142fc9002ff33cae_171904.mp4?alt=media&token=226d679c-2993-4db3-ba36-a9173ac0c2f3')
        ..initialize().then((_) {
          print("hadi da");
          _controller.seekTo(Duration(seconds: 0));

          _controller.setVolume(0);
          _controller.play();
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {
            _isVisible = true;
          });
        });
    } catch (e) {
      print("hataa");
      print(e.toString());
    }
    _controller.addListener(() {
      if(_controller.value.isPlaying ==false){
        setState(() {
          _isVisible=false;
        });
      }
    });
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Flexible(
            flex: 2,
            child: Stack(
              fit: StackFit.loose,
              children: <Widget>[
                Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height,
                ),


                Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height / 2.2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.blue, Colors.blueAccent],
                      //colors: [Color(0xFFfe5c4f), Color(0xFFf37520)],
                    ),
                  ),
                ),
                _isVisible ? Center(
                    child: OverflowBox(
                      minHeight: MediaQuery
                          .of(context)
                          .size
                          .height,
                      maxWidth: _controller.value.aspectRatio * MediaQuery
                          .of(context)
                          .size
                          .height,
                      maxHeight: MediaQuery
                          .of(context)
                          .size
                          .height + 22,
                      child: VideoPlayer(_controller),
                    )
                ) : Container(),
                Positioned(
                    right: 30,
                    top: 60,
                    child: GestureDetector(
                      child: Icon(
                        Icons.refresh,
                        size: 24,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      onTap: () {
                        setState(() {
                          _isVisible = !_isVisible;
                        });
                      },
                      /*onTap: () =>
                      Navigator.push(context, SizeRoute(page: HomeScreen()))*/
                    )),
                // Logo Section
                Positioned(
                  top: MediaQuery
                      .of(context)
                      .size
                      .height / 6,
                  left: 0,
                  right: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/logo.png",
                        scale: 5,
                      ),
                    ],
                  ),
                ),

                // Login Screen
                SlideTransition(
                  position: _animationController.drive(tweenRight),
                  child: Stack(fit: StackFit.loose, clipBehavior: Clip.none, children: [
                    _registerScreen(context),
                  ]),
                ),
                SlideTransition(
                  position: _animationController.drive(tweenLeft),
                  child: Stack(fit: StackFit.loose, clipBehavior: Clip.none, children: [
                    _loginScreen(context),
                  ]),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Positioned _registerScreen(BuildContext context) {
    return Positioned(
      left: 0,
      top: MediaQuery
          .of(context)
          .size
          .height / 3.3,
      child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          child: Card(
            color: Colors.white.withOpacity(1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            margin: EdgeInsets.all(20.0),
            elevation: 0.7,
            child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Lets make a generic input widget
                    InputWidget(
                      focus: _focusName,
                      controller: _nameTextController,

                      prefixIcon: AntDesign.user,

                      // topLabel: "Email",

                      hintText: "İsminiz",
                      // prefixIcon: FlutterIcons.chevron_left_fea,
                    ), InputWidget(
                      focus: _focusRegisterEmail,
                      controller: _registerEmailTextController,

                      prefixIcon: AntDesign.mail,

                      // topLabel: "Email",

                      hintText: "E-Posta",
                      // prefixIcon: FlutterIcons.chevron_left_fea,
                    ), InputWidget(
                      focus: _focusRegisterPassword,
                      controller: _registerPasswordTextController,

                      prefixIcon: MaterialCommunityIcons.textbox_password,

                      // topLabel: "Email",
                      obscureText: true,

                      hintText: "Şifre",
                      // prefixIcon: FlutterIcons.chevron_left_fea,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Center(
                      child: Wrap(
                        runAlignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            "—— veya ——",
                            style: GoogleFonts.openSans(fontSize: 14, fontWeight: FontWeight.w300, color: kGreyColor),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    AppButton(
                      type: ButtonType.PRIMARY,
                      text: "Kaydol",
                      onPressed: () async {

                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),

                    Center(
                      child: Wrap(
                        runAlignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.0),
                          ),
                          ConstrainedBox(
                              constraints: BoxConstraints.tightFor( height: 48),
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      FlutterIcons.google_ant,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    Text(
                                      'Google ile Kaydol',
                                      style: TextStyle(color: Colors.white),
                                      textScaleFactor: 1,
                                    )
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),

                    Text(
                      'Kampanyalardan haberdar olmak için Elektronik İleti almak istiyorum.',
                      style: GoogleFonts.openSans(
                        fontSize: 12.0,
                        color: Color.fromRGBO(64, 74, 106, 1),
                      ),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),

                    Center(
                      child: Wrap(
                        runAlignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            "Üye misin?",
                            style: GoogleFonts.openSans(
                              fontSize: 14.0,
                              color: Color.fromRGBO(64, 74, 106, 1),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              if (_isMoved) {
                                _animationController.reverse();
                              } else {
                                _animationController.forward();
                              }
                              _isMoved = !_isMoved;
                            },
                            child: Text(
                              "Giriş Yap",
                              style: GoogleFonts.openSans(
                                fontWeight: FontWeight.w400,
                                fontSize: 14.0,
                                color: Constants.primaryColor,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )),
          )),
    );
  }

  Positioned _loginScreen(BuildContext context) {
    return Positioned(
        top: MediaQuery
            .of(context)
            .size
            .height / 3.3,
        child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: Container(
              child: Card(
                color: Colors.white.withOpacity(1),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                margin: EdgeInsets.all(20.0),
                elevation: 0.7,
                child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        InputWidget(focus: _focusEmail, controller: _emailTextController, prefixIcon: AntDesign.mail, hintText: "E-posta"),
                        InputWidget(
                          focus: _focusPassword,
                          controller: _passwordTextController,
                          prefixIcon: MaterialCommunityIcons.alphabetical,
                          hintText: "Şifre",
                          obscureText: true,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            "Şifremi Unuttum",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Constants.primaryColor,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        AppButton(
                          type: ButtonType.PRIMARY,
                          text: "Giriş Yap",
                          onPressed: (){
                            _focusEmail.unfocus();
                            _focusPassword.unfocus();
_emailLogin();

                          },
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Center(
                          child: Wrap(
                            runAlignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                "Diğer Giriş Seçenekleri",
                                style: GoogleFonts.openSans(fontSize: 14, fontWeight: FontWeight.w300, color: kGreyColor),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Image.asset("assets/images/google.png"),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),

                            GestureDetector(
                              onTap: () {},
                              child: Image.asset("assets/images/facebook.png"),
                            ),
                          ],
                        ),
                        Center(
                          child: Wrap(
                            runAlignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                "Üye değil misin?",
                                style: GoogleFonts.openSans(
                                  fontSize: 14.0,
                                  color: Color.fromRGBO(64, 74, 106, 1),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (_isMoved) {
                                    _animationController.reverse();
                                  } else {
                                    _animationController.forward();
                                  }
                                  _isMoved = !_isMoved;
                                },
                                child: Text(
                                  "Üye Ol",
                                  style: GoogleFonts.openSans(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.0,
                                    color: Constants.primaryColor,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
            )));
  }
  void _emailLogin() {
    var state = Provider.of<AuthState>(context, listen: false);
    if (state.isbusy) {
      return;
    }
    loader.showLoader(context);
    var isValid = Utility.validateCredentials(
        _scaffoldKey, _emailTextController.text, _passwordTextController.text);
    if (isValid) {
      state
          .signIn(_emailTextController.text, _passwordTextController.text,
          scaffoldKey: _scaffoldKey)
          .then((status) {
        if (state.user != null) {
         loader.hideLoader();
          Navigator.pop(context);
          widget.loginCallback();
        } else {
          cprint('Unable to login', errorIn: '_emailLoginButton');loader.hideLoader();
        }
      });
    } else {
      loader.hideLoader();
    }
  }
}
class Constants {
  static final Color primaryColor = Colors.blue;
}

const kBlackColor = Color(0xFF3A3A3A);
const kGreyColor = Color(0xFF8A959E);
class InputWidget extends StatelessWidget {
  final String hintText;
  final IconData prefixIcon;
  final double height;
  final String topLabel;
  final bool obscureText;
  final TextEditingController controller;
  final FocusNode focus;

  InputWidget({
    this.hintText,
    this.prefixIcon,
    this.height = 48.0,
    this.topLabel = "",
    this.obscureText = false,
    this.controller,
    this.focus,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      //crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(this.topLabel),
        SizedBox(height: 0.0),
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: Color(0xFFFAFAFA),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: this.obscureText,
            focusNode:focus ,
            decoration: InputDecoration(
              prefixIcon:Icon(
                this.prefixIcon,
                color: Color.fromRGBO(105, 108, 121, 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromRGBO(74, 77, 84, 0.2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFe3e3e3),
                ),
              ),
              hintText: this.hintText,
              hintStyle: TextStyle(
                fontSize: 14.0,
                color: Color.fromRGBO(105, 108, 121, 0.7),
              ),
            ),
          ),
        )
      ],
    );
  }
}
enum ButtonType { PRIMARY, PLAIN }

class AppButton extends StatelessWidget {
  final ButtonType type;
  final VoidCallback onPressed;
  final String text;

  AppButton({this.type, this.onPressed, this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.onPressed,
      child: Container(
        width: double.infinity,
        height: 44,
        decoration: BoxDecoration(
            color: getButtonColor(type),
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(color: getBorderColor(type), width: 1)),
        child: Center(
          child: Text(
            this.text,
            textScaleFactor: 1,
            style: GoogleFonts.openSans(
              color: getTextColor(type),
              fontSize: 16.0,
              fontWeight: FontWeight.w500,

            ),
          ),
        ),
      ),
    );
  }
}

Color getButtonColor(ButtonType type) {
  switch (type) {
    case ButtonType.PRIMARY:
      return Constants.primaryColor;
    case ButtonType.PLAIN:
      return Colors.white;
    default:
      return Constants.primaryColor;
  }
}

Color getTextColor(ButtonType type) {
  switch (type) {
    case ButtonType.PLAIN:
      return kBlackColor;
    case ButtonType.PRIMARY:
      return Colors.white;
    default:
      return Colors.white;
  }
}

Color getBorderColor(ButtonType type) {
  switch (type) {
    case ButtonType.PLAIN:
      return kBlackColor;
    case ButtonType.PRIMARY:
      return Colors.transparent;
    default:
      return Colors.white;
  }
}
