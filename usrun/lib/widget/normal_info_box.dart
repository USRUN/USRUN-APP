import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';

class NormalInfoBox extends StatelessWidget {
  final String firstTitleLine;
  final String dataLine;
  final String secondTitleLine;
  final Function pressBox;
  final double boxSize;
  final double boxRadius;
  final bool beAlwaysBlackShadow;

  static double _gradientLineHeight = R.appRatio.appHeight10;

  NormalInfoBox({
    this.firstTitleLine = "",
    this.dataLine = "",
    this.secondTitleLine = "",
    this.pressBox,
    this.boxSize = 100,
    this.boxRadius = 10,
    this.beAlwaysBlackShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (this.pressBox != null) {
          this.pressBox();
        }
      },
      child: Center(
        child: Container(
          width: this.boxSize,
          height: this.boxSize,
          decoration: BoxDecoration(
            color: R.colors.boxBackground,
            borderRadius: BorderRadius.all(Radius.circular(this.boxRadius)),
            boxShadow: [
              BoxShadow(
                blurRadius: 5.0,
                offset: Offset(0.0, 0.0),
                color: (this.beAlwaysBlackShadow
                    ? Color.fromRGBO(0, 0, 0, 0.25)
                    : R.colors.textShadow),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Container(
                height: _gradientLineHeight,
                decoration: BoxDecoration(
                  gradient: R.colors.uiGradient,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(this.boxRadius),
                    bottomRight: Radius.circular(this.boxRadius),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: _gradientLineHeight,
                ),
                child: Container(
                  height: this.boxSize,
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
                                color: R.colors.contentText,
                              ),
                            )
                          : Container()),
                      SizedBox(
                        height: R.appRatio.appSpacing5,
                      ),
                      (dataLine.length != 0
                          ? Text(
                              dataLine.toUpperCase(),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: R.appRatio.appFontSize22,
                                color: R.colors.contentText,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : Container()),
                      SizedBox(
                        height: R.appRatio.appSpacing5,
                      ),
                      (secondTitleLine.length != 0
                          ? Text(
                              secondTitleLine.toUpperCase(),
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: R.appRatio.appFontSize12,
                                color: R.colors.contentText,
                              ),
                            )
                          : Container()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
