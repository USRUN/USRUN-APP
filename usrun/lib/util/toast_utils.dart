import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:usrun/core/R.dart';

void showToastDefault({
  @required String msg,
  ToastGravity gravity = ToastGravity.BOTTOM,
  Toast toastLength = Toast.LENGTH_SHORT,
}) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: toastLength,
    gravity: gravity,
    backgroundColor: Color(0xFF666666),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
