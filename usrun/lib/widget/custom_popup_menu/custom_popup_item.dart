import 'package:flutter/material.dart';

class PopupItem<T> {
  String iconURL;
  double iconSize;
  EdgeInsets iconPadding;
  String title;
  TextStyle titleStyle;
  T value;

  PopupItem({
    this.iconURL = "",
    this.iconSize = 15.0,
    this.title = "",
    this.titleStyle,
    this.value,
    this.iconPadding = const EdgeInsets.only(right: 15),
  }) : assert(iconURL != null &&
            iconSize != null &&
            iconSize > 0.0 &&
            title != null &&
            title.length != 0 &&
            iconPadding != null);
}
