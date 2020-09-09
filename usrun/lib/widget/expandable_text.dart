import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/util/image_cache_manager.dart';

class ExpandableText extends StatefulWidget {
  final String text;

  ExpandableText(this.text);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;
  bool longText = false;

  @override
  void initState() {
    super.initState();
    checkLongText();
  }

  checkLongText() {
    if (widget.text.length >= 150) {
      if (!mounted) return;
      setState(() {
        longText = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!longText || !mounted) return;
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            constraints:
                isExpanded ? BoxConstraints() : BoxConstraints(maxHeight: 50.0),
            child: Text(
              widget.text,
              softWrap: true,
              textAlign: TextAlign.center,
              overflow: TextOverflow.fade,
              style: TextStyle(
                color: R.colors.contentText,
                fontSize: R.appRatio.appFontSize16,
              ),
            ),
          ),
          (longText && !isExpanded
              ? SizedBox(
                  height: R.appRatio.appSpacing15,
                )
              : Container()),
          (longText
              ? Transform.rotate(
                  angle: (!isExpanded ? 90 * pi / 180 : 270 * pi / 180),
                  child: ImageCacheManager.getImage(
                    url: R.myIcons.nextIconByTheme,
                    width: R.appRatio.appIconSize20,
                    height: R.appRatio.appIconSize20,
                    fit: BoxFit.cover,
                  ))
              : Container()),
        ],
      ),
    );
  }
}
