import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/widget/loading_dot.dart';

class _CustomLoadingDialog extends StatelessWidget {
  final double _radius = 5.0;
  final double _spacing = 15.0;
  final double _dialogWidth = 160;
  final double _dialogHeight = 120;
  final String text;

  _CustomLoadingDialog({
    @required this.text,
  }) : assert(text.length != 0);

  @override
  Widget build(BuildContext context) {
    Widget _buildElement = Container(
      width: _dialogWidth,
      height: _dialogHeight,
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
          SizedBox(height: 10),
          LoadingIndicator(),
          SizedBox(height: 20),
          Text(
            this.text,
            textScaleFactor: 1.0,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: R.colors.contentText,
            ),
          ),
        ],
      ),
    );

    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: _buildElement,
    );
  }
}

Future<T> showCustomLoadingDialog<T>(BuildContext context,
    {String text: ""}) async {
  if (text == null || text.length == 0) {
    text = R.strings.loading;
  }

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
          child: _CustomLoadingDialog(text: text),
        ),
      );
    },
  );
}
