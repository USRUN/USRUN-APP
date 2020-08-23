import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';

class _CustomAlertDialog extends StatelessWidget {
  const _CustomAlertDialog({
    Key key,
    @required this.title,
    @required this.content,
    @required this.firstButtonText,
    @required this.firstButtonFunction,
    this.secondButtonText = "",
    this.secondButtonFunction,
  })  : assert(title != null &&
      content != null &&
      firstButtonText != null &&
      firstButtonFunction != null &&
      secondButtonText != null),
        assert(title.length != 0 &&
            content.length != 0 &&
            firstButtonText.length != 0),
        super(key: key);

  final String title;
  final String content;
  final String firstButtonText;
  final Function firstButtonFunction;
  final String secondButtonText;
  final Function secondButtonFunction;

  final double _radius = 10;
  final double _spacing = 15.0;
  final double _buttonHeight = 50.0;

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
        this.title,
        textScaleFactor: 1.0,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: R.appRatio.appFontSize20,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _renderContent() {
    return Container(
      margin: EdgeInsets.only(
        left: _spacing + 5,
        right: _spacing + 5,
        top: _spacing * 1.25,
        bottom: _spacing * 1.25,
      ),
      child: Text(
        this.content,
        textScaleFactor: 1.0,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        softWrap: true,
        maxLines: 100,
        style: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: R.appRatio.appFontSize16,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _renderButton(bool _existSecondButton) {
    return Row(
      children: <Widget>[
        // Second button
        (_existSecondButton
            ? Expanded(
          child: Container(
            height: _buttonHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(_radius),
              ),
              color: Colors.white,
            ),
            child: FlatButton(
              onPressed: () => this.secondButtonFunction(),
              padding: EdgeInsets.all(0.0),
              splashColor: R.colors.lightBlurMajorOrange,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(_radius),
                ),
              ),
              child: Text(
                this.secondButtonText,
                textScaleFactor: 1.0,
                style: TextStyle(
                  fontSize: R.appRatio.appFontSize16,
                  fontWeight: FontWeight.bold,
                  color: R.colors.gray515151,
                ),
              ),
            ),
          ),
        )
            : Container()),
        // Vertical Divider
        (_existSecondButton
            ? Container(
          width: 1,
          height: _buttonHeight,
          child: VerticalDivider(
            color: R.colors.blurMajorOrange,
            thickness: 1.0,
          ),
        )
            : Container()),
        // First button
        Expanded(
          child: Container(
            height: _buttonHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: (!_existSecondButton
                    ? Radius.circular(_radius)
                    : Radius.circular(0.0)),
                bottomRight: Radius.circular(_radius),
              ),
              color: Colors.white,
            ),
            child: FlatButton(
              onPressed: () => this.firstButtonFunction(),
              padding: EdgeInsets.all(0.0),
              splashColor: R.colors.lightBlurMajorOrange,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: (!_existSecondButton
                      ? Radius.circular(_radius)
                      : Radius.circular(0.0)),
                  bottomRight: Radius.circular(_radius),
                ),
              ),
              child: Text(
                this.firstButtonText,
                textScaleFactor: 1.0,
                style: TextStyle(
                  fontSize: R.appRatio.appFontSize16,
                  fontWeight: FontWeight.bold,
                  color: R.colors.majorOrange,
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
    bool _existSecondButton = false;
    if (this.secondButtonText.length != 0 &&
        this.secondButtonFunction != null) {
      _existSecondButton = true;
    }

    return Container(
      constraints: BoxConstraints(maxWidth: 280),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(_radius)),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Title
          _renderTitle(),
          // Content
          _renderContent(),
          // Horizontal divider
          Divider(
            color: R.colors.blurMajorOrange,
            height: 1,
            thickness: 1.0,
          ),
          // Button
          _renderButton(_existSecondButton),
        ],
      ),
    );
  }
}

Future<T> showCustomAlertDialog<T>(
    BuildContext context, {
      Key key,
      @required title,
      @required content,
      @required firstButtonText,
      @required firstButtonFunction,
      secondButtonText = "",
      secondButtonFunction,
    }) async {

  return await showGeneralDialog(
    context: context,
    barrierLabel: "Label",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 500),
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
          child: _CustomAlertDialog(
            title: title,
            content: content,
            firstButtonText: firstButtonText,
            firstButtonFunction: firstButtonFunction,
            secondButtonText: secondButtonText,
            secondButtonFunction: secondButtonFunction,
          ),
        ),
      );
    },
  );
}
