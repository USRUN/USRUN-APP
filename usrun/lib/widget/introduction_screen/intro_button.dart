import 'package:flutter/material.dart';

class IntroBoxStyle {
  double width;
  double height;
  BoxDecoration boxDecoration;
  EdgeInsets margin;
  Alignment alignment;

  IntroBoxStyle({
    this.width = 110,
    this.height = 40,
    this.boxDecoration,
    this.alignment = Alignment.center,
    this.margin = const EdgeInsets.all(0.0),
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
    final _currentDecoration = _getDecoration();

    return Container(
      width: _currentDecoration.width,
      height: _currentDecoration.height,
      decoration: _currentDecoration.boxDecoration,
      margin: _currentDecoration.margin,
      alignment: _currentDecoration.alignment,
      child: FlatButton(
        onPressed: onPressed,
        padding: EdgeInsets.all(0.0),
        textColor: Colors.white,
        splashColor: Color.fromRGBO(0, 0, 0, 0.1),
        child: child,
      ),
    );
  }
}
