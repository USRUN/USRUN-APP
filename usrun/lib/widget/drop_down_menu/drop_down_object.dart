import 'package:flutter/cupertino.dart';

class DropDownObject<T> {
  T value;
  String text;
  String imageURL;

  DropDownObject({
    @required this.value,
    this.text = "",
    this.imageURL = "",
  }) : assert(text != null && imageURL != null);
}
