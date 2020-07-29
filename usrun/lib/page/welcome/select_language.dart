import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/animation/slide_page_route.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/manager/data_manager.dart';
import 'package:usrun/page/welcome/welcome_page.dart';
import 'package:usrun/util/image_cache_manager.dart';
import 'package:usrun/widget/app_logo_heading.dart';

class SelectLanguagePage extends StatefulWidget {
  @override
  _SelectLanguagePageState createState() => _SelectLanguagePageState();
}

class _SelectLanguagePageState extends State<SelectLanguagePage>
    with SingleTickerProviderStateMixin {
  // Content variables
  // Language has one of these value: "en" or "vi".
  String _title = "";
  String _vietnamese = "";
  String _english = "";

  // Other variables
  final double _radius = 5;

  @override
  void initState() {
    super.initState();
    DataManager.removeAllData();
    _initDisplayContent();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _initDisplayContent() {
    String locale = Intl.systemLocale.split("_")[0];
    if (!mounted) return;
    switch (locale) {
      case "en":
        setState(() {
          _title = "Please select language for displaying";
          _vietnamese = "Vietnamese";
          _english = "English";
        });
        break;
      case "vi":
        setState(() {
          _title = "Hãy chọn một ngôn ngữ để hiển thị";
          _vietnamese = "Tiếng Việt";
          _english = "Tiếng Anh";
        });
        break;
      default:
        setState(() {
          _title = "Please select language for displaying";
          _vietnamese = "Vietnamese";
          _english = "English";
        });
    }
  }

  _selectLanguage(String locale) async {
    initDefaultLocale(locale);
    await setLanguage(Intl.defaultLocale.split("_")[0]);
    showPageWithRoute(
      context,
      SlidePageRoute(page: WelcomePage()),
    );
  }

  Widget _renderButton(String lang) {
    String iconUrl;
    String buttonContent;

    switch (lang) {
      case "en":
        buttonContent = _english;
        iconUrl = R.myIcons.englishColor;
        break;
      case "vi":
        buttonContent = _vietnamese;
        iconUrl = R.myIcons.vietnameseColor;
        break;
      default:
        buttonContent = _english;
        iconUrl = R.myIcons.englishColor;
    }

    return SizedBox(
      height: 45,
      width: double.infinity,
      child: FlatButton(
        onPressed: () => _selectLanguage(lang),
        splashColor: R.colors.lightBlurMajorOrange,
        textColor: Colors.white,
        color: R.colors.grayF2F2F2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
        ),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 12),
              child: Image.asset(
                iconUrl,
                width: 25,
                height: 25,
              ),
            ),
            Expanded(
              child: Text(
                buttonContent,
                textScaleFactor: 1.0,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderLanguageButtons() {
    List<Widget> list = List();

    list.add(Container(
      margin: EdgeInsets.only(bottom: 10),
      child: _renderButton("vi"),
    ));

    list.add(Container(
      margin: EdgeInsets.only(bottom: 10),
      child: _renderButton("en"),
    ));

    return Column(
      children: list,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        child: Container(),
        preferredSize: Size(0, 0),
      ),
      body: Container(
        height: R.appRatio.deviceHeight,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            ImageCacheManager.getImage(
              url: R.images.pageBackground,
            ),
            Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                        top: 24,
                        bottom: 24,
                      ),
                      child: AppLogoHeading(),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text(
                        _title + ":",
                        textScaleFactor: 1.0,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    _renderLanguageButtons(),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
