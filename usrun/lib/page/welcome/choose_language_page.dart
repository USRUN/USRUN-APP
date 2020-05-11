import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/widget/ui_button.dart';

class EmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  Size get preferredSize => Size(0.0, 0.0);
}

class ChooseLanguagePage extends StatefulWidget {
  @override
  _ChooseLanguagePageState createState() => _ChooseLanguagePageState();
}

class _ChooseLanguagePageState extends State<ChooseLanguagePage>
    with SingleTickerProviderStateMixin {
  // Content variables
  // _selectedLanguage has one of these value: "en" or "vi".
  String _selectedLanguage;
  String _title;
  String _subTitle;
  String _vietnamese;
  String _english;
  String _next;

  // Animation
  AnimationController _controller;
  Animation _animation;

  // Other variables
  final double _borderRadius = 10;

  @override
  void initState() {
    super.initState();

    // Content variables
    _selectedLanguage = "vi";
    _title = "Ngôn ngữ";
    _subTitle = "Hãy chọn một ngôn ngữ để hiển thị";
    _vietnamese = "Tiếng Việt";
    _english = "English";
    _next = "Tiếp theo";

    // Animation
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
    Future.delayed(Duration(milliseconds: 500), () => _controller.forward());
  }

  @override
  dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _directToNextPage() {
    // TODO: Implement function here
    print("Directing to next page...");
  }

  _changeLanguage(String lang) {
    if (lang.compareTo(_selectedLanguage) == 0) return;
    switch (lang) {
      case "en":
        setState(() {
          _selectedLanguage = "en";
          _title = "Language";
          _subTitle = "Please select one for displaying";
          _next = "Next";
        });
        break;
      case "vi":
        setState(() {
          _selectedLanguage = "vi";
          _title = "Ngôn ngữ";
          _subTitle = "Hãy chọn một ngôn ngữ để hiển thị";
          _next = "Tiếp theo";
        });
        break;
      default:
        setState(() {
          _selectedLanguage = "en";
          _title = "Language";
          _subTitle = "Please select one for displaying";
          _next = "Next";
        });
    }
  }

  Widget _renderButton(String lang) {
    String buttonContent;

    switch (lang) {
      case "en":
        buttonContent = _english;
        break;
      case "vi":
        buttonContent = _vietnamese;
        break;
      default:
        buttonContent = _english;
    }

    return UIButton(
      width: R.appRatio.appWidth280,
      height: R.appRatio.appHeight60,
      radius: 100,
      color: (_selectedLanguage.compareTo(lang) != 0 ? Colors.white : null),
      gradient:
          (_selectedLanguage.compareTo(lang) == 0 ? R.colors.uiGradient : null),
      border: (_selectedLanguage.compareTo(lang) != 0
          ? Border.all(width: 2, color: R.colors.majorOrange)
          : null),
      textColor: (_selectedLanguage.compareTo(lang) != 0
          ? R.colors.majorOrange
          : Colors.white),
      text: buttonContent,
      enableShadow: false,
      textSize: R.appRatio.appFontSize22,
      onTap: () => _changeLanguage(lang),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      primary: false,
      appBar: EmptyAppBar(),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              width: R.appRatio.deviceWidth,
              height: R.appRatio.deviceHeight,
              decoration: BoxDecoration(
                gradient: R.colors.verticalUiGradient,
              ),
            ),
            Center(
              child: FadeTransition(
                opacity: _animation,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                    left: R.appRatio.appSpacing25,
                    right: R.appRatio.appSpacing25,
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.35),
                      borderRadius:
                          BorderRadius.all(Radius.circular(_borderRadius)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(
                            top: R.appRatio.appSpacing10,
                            bottom: R.appRatio.appSpacing10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(_borderRadius),
                              topRight: Radius.circular(_borderRadius),
                            ),
                          ),
                          child: Image.asset(
                            R.images.logoText,
                            width: R.appRatio.appWelcomPageLogoTextSize,
                          ),
                        ),
                        SizedBox(
                          height: R.appRatio.appSpacing40,
                        ),
                        Text(
                          _title.toUpperCase(),
                          style: TextStyle(
                            fontSize: R.appRatio.appFontSize24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: R.appRatio.appSpacing10,
                        ),
                        Text(
                          _subTitle[0].toUpperCase() +
                              _subTitle.substring(1).toLowerCase(),
                          style: TextStyle(
                            fontSize: R.appRatio.appFontSize18,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: R.appRatio.appSpacing40,
                        ),
                        _renderButton("vi"),
                        SizedBox(
                          height: R.appRatio.appSpacing25,
                        ),
                        _renderButton("en"),
                        SizedBox(
                          height: R.appRatio.appSpacing40,
                        ),
                        GestureDetector(
                          onTap: () => _directToNextPage(),
                          child: Text(
                            "> " + _next,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: R.appRatio.appFontSize18,
                              shadows: [
                                BoxShadow(
                                  blurRadius: 4.0,
                                  offset: Offset(2.0, 2.0),
                                  color: R.colors.textShadow,
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: R.appRatio.appSpacing25,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
