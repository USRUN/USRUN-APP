import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';

class InputField extends StatelessWidget {
  final String labelTitle;
  final bool enableLabelShadow;
  final bool enableFullWidth;
  final TextEditingController controller;
  final bool enableMaxLines;
  final String hintText;
  final bool obscureText;
  final bool enableSearchBtn;

  InputField({
    this.labelTitle = "",
    this.enableLabelShadow = false,
    this.enableFullWidth = true,
    @required this.controller,
    this.enableMaxLines = false,
    this.hintText,
    this.obscureText = false,
    this.enableSearchBtn = false,
  });

  @override
  Widget build(BuildContext context) {
    // HAVING label Title
    if (this.labelTitle.length == 0) {
      return Container(
        width: (this.enableFullWidth
            ? R.appRatio.appWidth381
            : R.appRatio.appWidth181),
        child: TextField(
          controller: this.controller,
          obscureText: this.obscureText,
          maxLines: (this.enableMaxLines ? null : 1),
          style: TextStyle(color: R.colors.contentText),
          decoration: InputDecoration(
            suffixIcon: (this.enableSearchBtn
                ? Container(
                    width: R.appRatio.appWidth75,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        // Delete Button
                        GestureDetector(
                          // TODO: Function for clearing TextField content
                          // onTap: () => _yourFunction('yourParameter'),
                          child: Image.asset(
                            R.myIcons.tabBarCloseBtn,
                            width: R.appRatio.appIconSize18,
                          ),
                        ),
                        SizedBox(
                          width: R.appRatio.appSpacing20,
                        ),
                        // Search Button
                        GestureDetector(
                          // TODO: Function for searching athlete based on TextField content
                          // onTap: () => _yourFunction('yourParameter'),
                          child: Image.asset(
                            R.myIcons.tabBarSearchBtn,
                            width: R.appRatio.appIconSize18,
                          ),
                        ),
                      ],
                    ),
                  )
                : null),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: R.colors.majorOrange)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: R.colors.majorOrange)),
            border: UnderlineInputBorder(),
            hintText: this.hintText,
            hintStyle: TextStyle(fontSize: R.appRatio.appFontSize18),
          ),
        ),
      );
    }
    // DON'T have label Title
    else {
      return Container(
        width: (this.enableFullWidth
            ? R.appRatio.appWidth381
            : R.appRatio.appWidth181),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                this.labelTitle,
                style: (this.enableLabelShadow
                    ? R.styles.shadowLabelStyle
                    : R.styles.labelStyle),
              ),
              TextField(
                controller: this.controller,
                obscureText: this.obscureText,
                maxLines: (this.enableMaxLines ? null : 1),
                style: TextStyle(color: R.colors.contentText),
                decoration: InputDecoration(
                  suffixIcon: (this.enableSearchBtn
                      ? Container(
                          width: R.appRatio.appWidth75,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              // Delete Button
                              GestureDetector(
                                // TODO: Function for clearing TextField content
                                // onTap: () => _yourFunction('yourParameter'),
                                child: Image.asset(
                                  R.myIcons.tabBarCloseBtn,
                                  width: R.appRatio.appIconSize18,
                                ),
                              ),
                              SizedBox(
                                width: R.appRatio.appSpacing20,
                              ),
                              // Search Button
                              GestureDetector(
                                // TODO: Function for searching athlete based on TextField content
                                // onTap: () => _yourFunction('yourParameter'),
                                child: Image.asset(
                                  R.myIcons.tabBarSearchBtn,
                                  width: R.appRatio.appIconSize18,
                                ),
                              ),
                            ],
                          ),
                        )
                      : null),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: R.colors.majorOrange)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: R.colors.majorOrange)),
                  border: UnderlineInputBorder(),
                  hintText: this.hintText,
                  hintStyle: TextStyle(fontSize: R.appRatio.appFontSize18),
                ),
              ),
            ]),
      );
    }
  }
}
