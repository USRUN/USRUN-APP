import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/util/image_cache_manager.dart';

class AboutUsBox extends StatelessWidget {
  static final double _spacing = 15.0;

  final String iconImageURL;
  final double iconSize;
  final String title;
  final String subtitle;
  final Function pressBox;

  AboutUsBox({
    @required this.iconImageURL,
    @required this.iconSize,
    this.title = "",
    this.subtitle = "",
    this.pressBox,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: R.colors.boxBackground,
        boxShadow: [
          BoxShadow(
            blurRadius: 4.0,
            offset: Offset(4.0, 4.0),
            color: R.colors.textShadow,
          ),
        ],
      ),
      child: FlatButton(
        onPressed: this.pressBox,
        textColor: Colors.white,
        splashColor: R.colors.lightBlurMajorOrange,
        padding: EdgeInsets.all(0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: _spacing,
            ),
            ImageCacheManager.getImage(
              url: this.iconImageURL,
              width: this.iconSize,
              height: this.iconSize,
            ),
            SizedBox(
              width: _spacing,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    this.title,
                    style: TextStyle(
                      color: R.colors.contentText,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    this.subtitle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      color: R.colors.orangeNoteText,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: _spacing,
            ),
          ],
        ),
      ),
    );
  }
}
