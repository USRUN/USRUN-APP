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
  final bool beAlwaysBlackShadow;
  final bool disableGradientLine;
  final bool disableBoxShadow;
  final Border border;

  static double _gradientLineHeight = R.appRatio.appHeight10;

  NormalInfoBox({
    @required this.id,
    this.firstTitleLine = "",
    this.dataLine = "",
    this.secondTitleLine = "",
    this.pressBox(id),
    this.boxSize = 100,
    this.boxRadius = 10,
    this.beAlwaysBlackShadow = false,
    this.disableGradientLine = false,
    this.disableBoxShadow = false,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    Function callbackFunc;
    if (this.pressBox != null) {
      callbackFunc = () => this.pressBox(this.id);
    }

    return Container(
      decoration: BoxDecoration(
        color: R.colors.boxBackground,
        borderRadius: BorderRadius.all(Radius.circular(this.boxRadius)),
        border: this.border,
        boxShadow: [
          disableBoxShadow
              ? BoxShadow(blurRadius: 0, color: Colors.transparent)
              : BoxShadow(
                  blurRadius: 4.0,
                  offset: Offset(0.0, 0.0),
                  color: (this.beAlwaysBlackShadow
                      ? Color.fromRGBO(0, 0, 0, 0.25)
                      : R.colors.textShadow),
                ),
        ],
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
                !disableGradientLine
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
                    : Container(),
                Container(
                  height: this.boxSize,
                  padding: EdgeInsets.only(
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
                                fontSize: R.appRatio.appFontSize14,
                                fontWeight: FontWeight.w500,
                                color: R.colors.contentText,
                              ),
                            )
                          : Container()),
                      SizedBox(
                        height: R.appRatio.appSpacing10,
                      ),
                      (dataLine.length != 0
                          ? FittedBox(
                              child: Text(
                                dataLine.toUpperCase(),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: R.appRatio.appFontSize22,
                                  fontWeight: FontWeight.bold,
                                  color: R.colors.contentText,
                                ),
                              ),
                            )
                          : Container()),
                      SizedBox(
                        height: R.appRatio.appSpacing10,
                      ),
                      (secondTitleLine.length != 0
                          ? Text(
                              secondTitleLine.toUpperCase(),
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: R.appRatio.appFontSize14,
                                fontWeight: FontWeight.w500,
                                color: R.colors.contentText,
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
