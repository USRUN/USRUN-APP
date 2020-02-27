import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';

class InputField extends StatefulWidget {
  final String labelTitle;
  final bool enableLabelShadow;
  final bool enableFullWidth;
  final bool enableMaxLines;
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final String errorText;
  final TextInputType textInputType;
  final bool enableSearchFeature;
  final Function searchFunction;
  final Function clearTextFunction;
  final String suffixText;

  InputField({
    this.labelTitle = "",
    this.enableLabelShadow = false,
    this.enableFullWidth = true,
    this.enableMaxLines = false,
    @required this.controller,
    this.hintText,
    this.obscureText = false,
    this.textInputType = TextInputType.text,
    this.errorText = "",
    this.enableSearchFeature = false,
    this.searchFunction,
    this.clearTextFunction,
    this.suffixText = "",
  });

  @override
  _InputFieldState createState() => new _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  String _capitalizeTheFirstLetter(String str) {
    return (str[0].toUpperCase() + str.substring(1).toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (widget.enableFullWidth
          ? R.appRatio.appWidth381
          : R.appRatio.appWidth181),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: (widget.labelTitle.length == 0
                ? null
                : Text(
                    widget.labelTitle,
                    style: (widget.enableLabelShadow
                        ? R.styles.shadowLabelStyle
                        : R.styles.labelStyle),
                  )),
          ),
          TextField(
            controller: widget.controller,
            obscureText: widget.obscureText,
            keyboardType: widget.textInputType,
            textInputAction:
                (widget.enableMaxLines ? TextInputAction.none : null),
            maxLines: (widget.enableMaxLines ? null : 1),
            style: TextStyle(
                color: R.colors.contentText,
                fontSize: R.appRatio.appFontSize18),
            decoration: InputDecoration(
              suffixIcon: (widget.enableSearchFeature
                  ? Container(
                      width: R.appRatio.appWidth80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          // Clear Text Button
                          GestureDetector(
                            onTap: () {
                              if (widget.clearTextFunction != null) {
                                widget.clearTextFunction();
                              }
                            },
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
                            onTap: () {
                              if (widget.searchFunction != null) {
                                widget.searchFunction();
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  right: R.appRatio.appSpacing10),
                              child: Image.asset(
                                R.myIcons.tabBarSearchBtn,
                                width: R.appRatio.appIconSize20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : (widget.suffixText.length != 0
                      ? Container(
                          width: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              SizedBox(
                                child: Text(
                                  widget.suffixText,
                                  style: TextStyle(
                                    color: R.colors.blurMajorOrange,
                                    fontSize: R.appRatio.appFontSize18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : null)),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: R.colors.majorOrange)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: R.colors.majorOrange)),
              border: UnderlineInputBorder(),
              hintText: widget.hintText,
              hintStyle: TextStyle(fontSize: R.appRatio.appFontSize18),
              errorText: (widget.errorText.length == 0
                  ? null
                  : this._capitalizeTheFirstLetter(widget.errorText)),
              errorStyle: TextStyle(
                color: Colors.red,
                fontStyle: FontStyle.italic,
                fontSize: R.appRatio.appFontSize14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
