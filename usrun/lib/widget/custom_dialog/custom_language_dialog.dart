import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/util/image_cache_manager.dart';

class _CustomLanguageDialog extends StatefulWidget {
  @override
  _CustomLanguageDialogState createState() => _CustomLanguageDialogState();
}

class _CustomLanguageDialogState extends State<_CustomLanguageDialog> {
  final double _radius = 5.0;
  final double _spacing = 15.0;
  final double _buttonHeight = 50.0;

  int _languageIndex;

  /*
    Language:
      + 0: Tiếng Việt
      + 1: Tiếng Anh
      + 2: Tiếng Nhật
  */

  @override
  void initState() {
    super.initState();
    _languageIndex = _getLanguageIndex(R.currentAppLanguage);
  }

  int _getLanguageIndex(String appLang) {
    switch (appLang) {
      case "vi":
        return 0;
      case "en":
        return 1;
      default:
        return 0;
    }
  }

  String _getLanguageString(int langIndex) {
    switch (langIndex) {
      case 0:
        return "vi";
      case 1:
        return "en";
      default:
        return "vi";
    }
  }

  void _changeLanguageIndex(String appLang) {
    if (!mounted) return;
    setState(() {
      _languageIndex = _getLanguageIndex(appLang);
    });
  }

  Widget _renderRow(String content, bool isSelected) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          content,
          overflow: TextOverflow.ellipsis,
          textScaleFactor: 1.0,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal,
            color: R.colors.contentText,
          ),
        ),
        (isSelected
            ? ImageCacheManager.getImage(
                url: R.myIcons.appBarCheckBtn,
                width: 18,
                height: 18,
                color: R.colors.majorOrange,
              )
            : Container()),
      ],
    );
  }

  Widget _renderLanguages() {
    return Padding(
      padding: EdgeInsets.only(
        left: _spacing,
        right: _spacing,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Vietnamese
          Container(
            height: 50,
            child: FlatButton(
              padding: EdgeInsets.all(0.0),
              splashColor: R.colors.lightBlurMajorOrange,
              textColor: Colors.white,
              onPressed: () {
                _changeLanguageIndex("vi");
              },
              child: _renderRow(
                R.strings.vietnamese,
                (_languageIndex == 0),
              ),
            ),
          ),
          Divider(
            color: R.colors.blurMajorOrange,
            height: 2,
            thickness: 0.4,
          ),
          // English
          Container(
            height: 50,
            child: FlatButton(
              padding: EdgeInsets.all(0.0),
              splashColor: R.colors.lightBlurMajorOrange,
              textColor: Colors.white,
              onPressed: () {
                _changeLanguageIndex("en");
              },
              child: _renderRow(
                R.strings.english,
                (_languageIndex == 1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderDescription() {
    return Container(
      margin: EdgeInsets.only(
        left: _spacing,
        right: _spacing,
        top: 10.0,
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        R.strings.chooseLanguageDescription,
        textScaleFactor: 1.0,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.justify,
        maxLines: 2,
        style: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 15,
          color: R.colors.contentText,
        ),
      ),
    );
  }

  Widget _renderTitle() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(_spacing),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(_radius),
          topRight: Radius.circular(_radius),
        ),
        color: R.colors.majorOrange,
      ),
      child: Text(
        R.strings.chooseLanguageTitle,
        textScaleFactor: 1.0,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _renderButton() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            height: _buttonHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(_radius),
              ),
              color: R.colors.dialogBackground,
            ),
            child: FlatButton(
              onPressed: () => pop(context, object: null),
              padding: EdgeInsets.all(0.0),
              splashColor: R.colors.lightBlurMajorOrange,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(_radius),
                ),
              ),
              child: Text(
                R.strings.cancel.toUpperCase(),
                textScaleFactor: 1.0,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: R.colors.secondButtonDialogColor,
                ),
              ),
            ),
          ),
        ),
        Container(
          width: 1,
          height: _buttonHeight,
          child: VerticalDivider(
            color: R.colors.blurMajorOrange,
            thickness: 1.0,
          ),
        ),
        Expanded(
          child: Container(
            height: _buttonHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(_radius),
              ),
              color: R.colors.dialogBackground,
            ),
            child: FlatButton(
              onPressed: () {
                String appLang = _getLanguageString(_languageIndex);
                if (appLang.compareTo(R.currentAppLanguage) == 0) return;
                pop(context, object: appLang);
              },
              padding: EdgeInsets.all(0.0),
              splashColor: R.colors.lightBlurMajorOrange,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(_radius),
                ),
              ),
              child: Text(
                R.strings.yes.toUpperCase(),
                textScaleFactor: 1.0,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: R.colors.firstButtonDialogColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 320),
      margin: EdgeInsets.only(
        left: _spacing,
        right: _spacing,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(_radius)),
        color: R.colors.dialogBackground,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Title
          _renderTitle(),
          // Description
          _renderDescription(),
          // Languages
          _renderLanguages(),
          // Horizontal divider
          Divider(
            color: R.colors.blurMajorOrange,
            height: 1,
            thickness: 1.0,
          ),
          // Button
          _renderButton(),
        ],
      ),
    );
  }
}

Future<T> showCustomLanguageDialog<T>(BuildContext context) async {
  return await showGeneralDialog(
    context: context,
    barrierLabel: "Label",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 300),
    transitionBuilder: (context, anim1, anim2, child) {
      return ScaleTransition(
        scale: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: anim1,
            curve: Curves.fastOutSlowIn,
          ),
        ),
        child: child,
      );
    },
    pageBuilder: (context, anim1, anim2) {
      return Material(
        type: MaterialType.transparency,
        child: Align(
          alignment: Alignment.center,
          child: _CustomLanguageDialog(),
        ),
      );
    },
  );
}
