import 'package:flutter/material.dart';

class IntroBoxStyle {
  double width;
  double height;
  BoxDecoration boxDecoration;
  EdgeInsets margin;
  EdgeInsets padding;
  Alignment alignment;
  bool enableSplashColor;
  ShapeBorder shapeBorder;

  IntroBoxStyle({
    this.width = 110,
    this.height = 40,
    this.boxDecoration,
    this.alignment = Alignment.center,
    this.padding = const EdgeInsets.all(0.0),
    this.margin = const EdgeInsets.all(0.0),
    this.enableSplashColor = true,
    this.shapeBorder,
  });
}

class IntroButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final IntroBoxStyle decoration;

  const IntroButton({
    Key key,
    this.onPressed,
    this.decoration,
    @required this.child,
  }) : super(key: key);

  IntroBoxStyle _getDecoration() {
    if (this.decoration != null) {
      return this.decoration;
    } else {
      return IntroBoxStyle();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentDecoration = _getDecoration();
    final enableSplashColor = currentDecoration.enableSplashColor;

    return Container(
      decoration: currentDecoration.boxDecoration,
      margin: currentDecoration.margin,
      padding: currentDecoration.padding,
      child: FlatButton(
        onPressed: onPressed,
        padding: EdgeInsets.all(0.0),
        textColor: (enableSplashColor ? Colors.white : Colors.transparent),
        splashColor: (enableSplashColor
            ? Color.fromRGBO(0, 0, 0, 0.1)
            : Colors.transparent),
        highlightColor: (enableSplashColor ? null : Colors.transparent),
        shape: currentDecoration.shapeBorder ??
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2.0),
            ),
        child: Container(
          alignment: currentDecoration.alignment,
          width: currentDecoration.width,
          height: currentDecoration.height,
          child: child,
        ),
      ),
    );
  }
}
