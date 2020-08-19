import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';

class InputField extends StatefulWidget {
  final String labelTitle;
  final bool enableLabelShadow;
  final bool enableFullWidth;
  final bool enableMaxLines;
  final bool enableBottomUnderline;
  final Color bottomUnderlineColor;
  final TextEditingController controller;
  final TextStyle contentStyle;
  final bool isDense;
  final String hintText;
  final TextStyle hintStyle;
  final bool obscureText;
  final String errorText;
  final bool autoFocus;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final Function onSubmittedFunction;
  final Function onChangedFunction;
  final bool enableSearchFeature;
  final Function searchFunction;
  final Function clearTextFunction;
  final String suffixText;
  final FocusNode focusNode;
  final Color cursorColor;

  InputField({
    this.labelTitle = "",
    this.enableLabelShadow = false,
    this.enableFullWidth = true,
    this.enableMaxLines = false,
    this.enableBottomUnderline = true,
    this.bottomUnderlineColor,
    @required this.controller,
    this.contentStyle,
    this.isDense = false,
    this.hintText,
    this.hintStyle,
    this.obscureText = false,
    this.autoFocus = false,
    this.textInputType = TextInputType.text,
    this.textInputAction,
    this.errorText = "",
    this.onSubmittedFunction(data),
    this.onChangedFunction(data),
    this.enableSearchFeature = false,
    this.searchFunction,
    this.clearTextFunction,
    this.suffixText = "",
    this.focusNode,
    this.cursorColor,
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
        mainAxisAlignment: MainAxisAlignment.center,
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
            focusNode: widget.focusNode,
            controller: widget.controller,
            obscureText: widget.obscureText,
            keyboardType: widget.textInputType,
            autofocus: widget.autoFocus,
            cursorColor: widget.cursorColor ?? R.colors.majorOrange,
            onSubmitted: (data) {
              if (widget.onSubmittedFunction != null) {
                widget.onSubmittedFunction(data);
              }
            },
            onChanged: (data) {
              if (widget.onChangedFunction != null) {
                widget.onChangedFunction(data);
              }
            },
            textInputAction: widget.textInputAction ??
                (widget.enableMaxLines ? TextInputAction.none : null),
            maxLines: (widget.enableMaxLines ? null : 1),
            style: widget.contentStyle ??
                TextStyle(
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
              isDense: widget.isDense,
              enabledBorder: (widget.enableBottomUnderline
                  ? UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: (widget.bottomUnderlineColor ??
                            R.colors.majorOrange),
                      ),
                    )
                  : InputBorder.none),
              focusedBorder: (widget.enableBottomUnderline
                  ? UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: (widget.bottomUnderlineColor ??
                            R.colors.majorOrange),
                      ),
                    )
                  : InputBorder.none),
              border: (widget.enableBottomUnderline
                  ? UnderlineInputBorder()
                  : InputBorder.none),
              hintText: widget.hintText,
              hintStyle: (widget.hintStyle ??
                  TextStyle(
                    fontSize: R.appRatio.appFontSize18,
                    color: R.colors.grayABABAB,
                  )),
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
