import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';

class NormalInfoBox extends StatelessWidget {
  final String id;
  final String firstTitleLine;
  final String dataLine;
  final String secondTitleLine;
  final Function pressBox;
  final double boxSize;
  final double boxRadius;
  final bool disableGradientLine;
  final bool disableBoxShadow;
  final BoxShadow boxShadow;
  final Border border;

  final Color _titleColor = R.colors.contentText.withOpacity(0.5);
  final double _gradientLineHeight = R.appRatio.appHeight10;

  NormalInfoBox({
    @required this.id,
    this.firstTitleLine = "",
    this.dataLine = "",
    this.secondTitleLine = "",
    this.pressBox(id),
    this.boxSize = 100,
    this.boxRadius = 10,
    this.disableGradientLine = false,
    this.disableBoxShadow = true,
    BoxShadow boxShadow,
    this.border,
  }) : boxShadow = boxShadow ?? R.styles.boxShadowAll;

  @override
  Widget build(BuildContext context) {
    Function callbackFunc;
    if (this.pressBox != null) {
      callbackFunc = () => this.pressBox(this.id);
    }

    return Container(
      decoration: BoxDecoration(
        color: R.colors.boxBackground,
        borderRadius: BorderRadius.all(
          Radius.circular(this.boxRadius),
        ),
        border: this.border,
        boxShadow: (disableBoxShadow ? null : [boxShadow]),
      ),
      child: FlatButton(
        onPressed: callbackFunc,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(this.boxRadius),
          ),
        ),
        padding: EdgeInsets.all(0),
        splashColor: R.colors.lightBlurMajorOrange,
        textColor: Colors.white,
        child: Center(
          child: Container(
            width: this.boxSize,
            height: this.boxSize,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                (!disableGradientLine
                    ? Container(
                        height: _gradientLineHeight,
                        decoration: BoxDecoration(
                          gradient: R.colors.uiGradient,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(this.boxRadius),
                            bottomRight: Radius.circular(this.boxRadius),
                          ),
                        ),
                      )
                    : Container()),
                Container(
                  height: this.boxSize,
                  padding: EdgeInsets.only(
                    left: 2,
                    right: 2,
                    bottom: (!disableGradientLine ? _gradientLineHeight : 0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      (firstTitleLine.length != 0
                          ? Text(
                              firstTitleLine.toUpperCase(),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: R.appRatio.appFontSize12,
                                fontWeight: FontWeight.w500,
                                color: _titleColor,
                              ),
                            )
                          : Container()),
                      SizedBox(
                        height: R.appRatio.appSpacing5 + 1,
                      ),
                      (dataLine.length != 0
                          ? FittedBox(
                              child: Text(
                                dataLine.toUpperCase(),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: R.appRatio.appFontSize20,
                                  fontWeight: FontWeight.bold,
                                  color: R.colors.contentText,
                                ),
                              ),
                            )
                          : Container()),
                      SizedBox(
                        height: R.appRatio.appSpacing5 + 3,
                      ),
                      (secondTitleLine.length != 0
                          ? Text(
                              secondTitleLine.toUpperCase(),
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: R.appRatio.appFontSize12,
                                fontWeight: FontWeight.w500,
                                color: _titleColor,
                              ),
                            )
                          : Container()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
