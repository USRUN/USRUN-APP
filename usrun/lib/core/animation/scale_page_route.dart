import 'package:flutter/material.dart';

class ScalePageRoute extends PageRouteBuilder {
  final Widget page;
  final Curve curve;

  /*
    + Reference: https://medium.com/flutter-community/everything-you-need-to-know-about-flutter-page-route-transition-9ef5c1b32823
  */

  ScalePageRoute({this.page, this.curve})
      : assert(page != null),
        super(
            pageBuilder: (context, animation, secondaryAnimation) => page,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var begin = 0.0;
              var end = 1.0;
              var myCurve = curve ?? Curves.fastOutSlowIn;

              return ScaleTransition(
                scale: Tween<double>(
                  begin: begin,
                  end: end,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: myCurve,
                  ),
                ),
                child: child,
              );
            });
}
