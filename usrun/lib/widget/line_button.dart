import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/widget/ui_button.dart';
import 'package:usrun/widget/lite_rolling_switch.dart';

class LineButton extends StatelessWidget {
  final String mainText;
  final double mainTextFontSize;
  final String subText;
  final double subTextFontSize;
  final String resultText;
  final double resultTextFontSize;
  final bool enableTextMaxLines;
  final bool enableSuffixIcon;
  final String suffixIconImageURL;
  final double suffixIconSize;
  final Function lineFunction;

  final bool enableBottomUnderline;
  final bool enableTopUnderline;
  final double spacingUnderlineAndMainText;

  final bool enableSwitchButton;
  final String switchButtonOnTitle;
  final String switchButtonOffTitle;
  final bool initSwitchStatus;
  final Function switchFunction;

  final bool enableBoxButton;
  final String boxButtonTitle;
  final Function boxButtonFuction;

  static bool _privateSwitchStatus = false;

  /*
    + The priority of enabling suffix things (Highest to Lowest)
    when all fields are "true":
      1/ enableSuffixIcon
      2/ enableSwitchButton
      3/ enableBoxButton

    + Noting that, if your mainText, subText or resultText contains lots of
    contents, you have to enable "MaxLines". Otherwise, contents will be 
    display as "...".
  */

  LineButton({
    @required this.mainText,
    this.mainTextFontSize = 14,
    this.subText = "",
    this.subTextFontSize = 12,
    this.resultText = "",
    this.resultTextFontSize = 12,
    this.enableTextMaxLines = true,
    this.enableSuffixIcon = false,
    this.suffixIconImageURL = "",
    this.suffixIconSize = 12,
    this.lineFunction,
    this.enableBottomUnderline = false,
    this.enableTopUnderline = false,
    this.spacingUnderlineAndMainText = 3,
    this.enableSwitchButton = false,
    this.switchButtonOnTitle = "",
    this.switchButtonOffTitle = "",
    this.initSwitchStatus = false,
    this.switchFunction(state),
    this.enableBoxButton = false,
    this.boxButtonTitle = "",
    this.boxButtonFuction,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (this.enableSuffixIcon == true && this.lineFunction != null) {
          this.lineFunction();
        } else {
          if (this.enableSuffixIcon == false &&
              this.enableSwitchButton == false &&
              this.enableBoxButton == false &&
              this.lineFunction != null) {
            this.lineFunction();
          }
        }
      },
      child: Container(
        width: R.appRatio.deviceWidth,
        color: R.colors.appBackground,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Top underline
            (this.enableTopUnderline
                ? Container(
                    height: 1,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: R.colors.blurMajorOrange,
                      ),
                    ),
                  )
                : Container()),
            // Content (Text & Suffix things)
            Container(
              padding: EdgeInsets.only(
                left: R.appRatio.appSpacing15,
                top: (this.enableTopUnderline ? R.appRatio.appSpacing15 : 0),
                right: R.appRatio.appSpacing15,
                bottom:
                    (this.enableBottomUnderline ? R.appRatio.appSpacing15 : 0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // Text
                  Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            this.mainText,
                            textAlign: TextAlign.left,
                            overflow: (this.enableTextMaxLines
                                ? null
                                : TextOverflow.ellipsis),
                            maxLines: (this.enableTextMaxLines ? null : 1),
                            style: TextStyle(
                                fontSize: this.mainTextFontSize,
                                color: R.colors.contentText),
                          ),
                          (this.subText.length != 0
                              ? Container(
                                  padding: EdgeInsets.only(
                                    top: R.appRatio.appSpacing5,
                                  ),
                                  child: Text(
                                    this.subText,
                                    textAlign: TextAlign.left,
                                    overflow: (this.enableTextMaxLines
                                        ? null
                                        : TextOverflow.ellipsis),
                                    maxLines:
                                        (this.enableTextMaxLines ? null : 1),
                                    style: TextStyle(
                                        fontSize: this.subTextFontSize,
                                        color: R.colors.normalNoteText),
                                  ),
                                )
                              : Container()),
                          (this.resultText.length != 0
                              ? Container(
                                  padding: EdgeInsets.only(
                                    top: R.appRatio.appSpacing5,
                                  ),
                                  child: Text(
                                    this.resultText,
                                    textAlign: TextAlign.left,
                                    overflow: (this.enableTextMaxLines
                                        ? null
                                        : TextOverflow.ellipsis),
                                    maxLines:
                                        (this.enableTextMaxLines ? null : 1),
                                    style: TextStyle(
                                        fontSize: this.resultTextFontSize,
                                        color: R.colors.orangeNoteText),
                                  ),
                                )
                              : Container()),
                        ],
                      ),
                    ),
                  ),
                  // Suffix things
                  (this.enableSuffixIcon
                      ? Container(
                          padding: EdgeInsets.only(
                            left: R.appRatio.appSpacing15,
                          ),
                          child: Image.asset(
                            this.suffixIconImageURL,
                            width: this.suffixIconSize,
                            height: this.suffixIconSize,
                          ),
                        )
                      : (this.enableSwitchButton
                          ? Container(
                              padding: EdgeInsets.only(
                                left: R.appRatio.appSpacing15,
                              ),
                              child: LiteRollingSwitch(
                                value: this.initSwitchStatus,
                                textOn: this.switchButtonOnTitle,
                                textOff: this.switchButtonOffTitle,
                                colorOn: R.colors.majorOrange,
                                colorOff: R.colors.grayABABAB,
                                iconOn: Icons.check_circle_outline,
                                iconOff: Icons.remove_circle_outline,
                                textSize: R.appRatio.appFontSize14,
                                onTap: () {
                                  if (this.switchFunction != null) {
                                    this.switchFunction(_privateSwitchStatus);
                                  }
                                },
                                onChanged: (bool state) {
                                  _privateSwitchStatus = state;
                                },
                              ))
                          : (this.enableBoxButton
                              ? Container(
                                  padding: EdgeInsets.only(
                                    left: R.appRatio.appSpacing15,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (this.boxButtonFuction != null) {
                                        this.boxButtonFuction();
                                      }
                                    },
                                    child: UIButton(
                                      color: R.colors.appBackground,
                                      radius: 5,
                                      width: R.appRatio.appWidth70,
                                      height: R.appRatio.appHeight40,
                                      textColor: R.colors.majorOrange,
                                      textSize: R.appRatio.appFontSize14,
                                      fontWeight: FontWeight.bold,
                                      border: Border.all(
                                        color: R.colors.majorOrange,
                                        width: 1,
                                      ),
                                      text: this.boxButtonTitle,
                                      onTap: this.boxButtonFuction,
                                    ),
                                  ),
                                )
                              : Container()))),
                ],
              ),
            ),
            // Bottom underline
            (this.enableBottomUnderline
                ? Container(
                    height: 1,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: R.colors.blurMajorOrange,
                      ),
                    ),
                  )
                : Container()),
          ],
        ),
      ),
    );
  }
}
