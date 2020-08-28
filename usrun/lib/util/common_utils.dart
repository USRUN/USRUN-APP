import 'package:flutter/cupertino.dart';

class CommonUtils {
  static void delayRequestFocusNode({
    int miliseconds: 400,
    @required FocusNode focusNode,
  }) {
    if (miliseconds <= 0) return;
    Future.delayed(Duration(milliseconds: miliseconds), () {
      focusNode.requestFocus();
    });
  }

  static void delayUnFocusNode({
    int miliseconds: 200,
    @required FocusNode focusNode,
  }) {
    if (miliseconds <= 0) return;
    Future.delayed(Duration(milliseconds: miliseconds), () {
      focusNode.unfocus();
    });
  }
}
