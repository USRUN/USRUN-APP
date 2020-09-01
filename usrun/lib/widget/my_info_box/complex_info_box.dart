import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/util/image_cache_manager.dart';

class ComplexInfoBox extends StatelessWidget {
  final String id;
  final String boxTitle;
  final String dataTitle;
  final String unitTitle;
  final Function pressBox;
  final double boxRadius;
  final String boxIconURL;
  final double boxIconSize;

  final bool enableCircleStyle;
  final double circleSize;
  final bool enableImageStyle;
  final String imageURL;

  final Color _boxBackgroundColor = Color(0xFFFFE2C7);

  /*
    + This widget has some displayed styles with the priority as below:
      1. circleStyle
      2. imageURLStyle
      3. None of above
  */

  ComplexInfoBox({
    @required this.id,
    @required this.boxTitle,
    this.dataTitle = "",
    this.unitTitle = "",
    this.pressBox(id),
    this.boxRadius = 20,
    this.boxIconURL,
    this.boxIconSize = 16,
    this.enableCircleStyle = false,
    this.circleSize = 70,
    this.enableImageStyle = false,
    this.imageURL,
  });

  @override
  Widget build(BuildContext context) {
    Function callbackFunc;
    if (this.pressBox != null) {
      callbackFunc = () => this.pressBox(this.id);
    }

    return GestureDetector(
      onTap: callbackFunc,
      child: Container(
        width: R.appRatio.appWidth140,
        decoration: BoxDecoration(
          color: this._boxBackgroundColor,
          borderRadius: BorderRadius.all(
            Radius.circular(this.boxRadius),
          ),
          boxShadow: [R.styles.boxShadowRB],
        ),
        padding: EdgeInsets.all(
          R.appRatio.appSpacing15,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                    boxTitle,
                    maxLines: 2,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: R.appRatio.appFontSize14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: 4),
                ImageCacheManager.getImage(
                  url: this.boxIconURL,
                  width: this.boxIconSize,
                  height: this.boxIconSize,
                  fit: BoxFit.contain,
                ),
              ],
            ),
            SizedBox(
              height: R.appRatio.appSpacing15,
            ),
            Container(
              alignment: Alignment.center,
              child: (this.enableCircleStyle
                  ? Container(
                      width: this.circleSize,
                      height: this.circleSize,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: R.colors.majorOrange,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.all(
                            Radius.circular(this.circleSize / 2)),
                        color: Colors.transparent,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            this.dataTitle,
                            style: TextStyle(
                              color: R.colors.majorOrange,
                              fontWeight: FontWeight.bold,
                              fontSize: R.appRatio.appFontSize18,
                              shadows: [
                                BoxShadow(
                                  blurRadius: 2.0,
                                  offset: Offset(1.0, 1.0),
                                  color: Color.fromRGBO(0, 0, 0, 0.25),
                                ),
                              ],
                            ),
                          ),
                          (this.unitTitle.length != 0
                              ? Padding(
                                  padding: EdgeInsets.only(top: 4),
                                  child: Text(
                                    this.unitTitle,
                                    style: TextStyle(
                                      color: R.colors.gray808080,
                                      fontWeight: FontWeight.w600,
                                      fontSize: R.appRatio.appFontSize12,
                                    ),
                                  ),
                                )
                              : Container()),
                        ],
                      ),
                    )
                  : (this.enableImageStyle
                      ? ImageCacheManager.getImage(
                          url: this.imageURL,
                          fit: BoxFit.cover,
                          width: R.appRatio.appWidth120,
                          height: R.appRatio.appHeight50,
                        )
                      : Container())),
            ),
            (this.enableCircleStyle == false
                ? Container(
                    width: R.appRatio.appWidth120,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        (this.enableImageStyle
                            ? SizedBox(
                                height: R.appRatio.appSpacing15,
                              )
                            : Container()),
                        FittedBox(
                          child: Text(
                            this.dataTitle,
                            style: TextStyle(
                              color: R.colors.majorOrange,
                              fontWeight: FontWeight.bold,
                              fontSize: R.appRatio.appFontSize18,
                              shadows: [
                                BoxShadow(
                                  blurRadius: 2.0,
                                  offset: Offset(1.0, 1.0),
                                  color: Color.fromRGBO(0, 0, 0, 0.25),
                                ),
                              ],
                            ),
                          ),
                        ),
                        (this.unitTitle.length != 0
                            ? Padding(
                                padding: EdgeInsets.only(top: 4),
                                child: Text(
                                  this.unitTitle,
                                  style: TextStyle(
                                    color: R.colors.gray808080,
                                    fontWeight: FontWeight.w600,
                                    fontSize: R.appRatio.appFontSize12,
                                  ),
                                ),
                              )
                            : Container()),
                      ],
                    ),
                  )
                : Container()),
          ],
        ),
      ),
    );
  }
}
