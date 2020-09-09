import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:usrun/core/R.dart';

class InputField extends StatefulWidget {
  final String labelTitle;
  final bool enableFullWidth;
  final int maxLines;
  final bool enableBottomUnderline;
  final Color bottomUnderlineColor;
  final TextInputFormatter formatter;
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
    this.enableFullWidth = true,
    this.maxLines,
    this.enableBottomUnderline = true,
    this.formatter,
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
  FocusNode _focusNode;

  String _capitalizeTheFirstLetter(String str) {
    return (str[0].toUpperCase() + str.substring(1).toLowerCase());
  }

  @override
  void initState() {
    super.initState();
    _initFocusNode();
  }

  void _initFocusNode() {
    if (widget.focusNode == null) {
      _focusNode = FocusNode();
    } else {
      _focusNode = widget.focusNode;
    }

    if (!widget.autoFocus) return;
    Future.delayed(Duration(milliseconds: 400), () {
      _focusNode.requestFocus();
    });
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
                    style: R.styles.labelStyle,
                  )),
          ),
          TextField(
            focusNode: _focusNode,
            controller: widget.controller,
            obscureText: widget.obscureText,
            keyboardType: widget.textInputType ?? TextInputType.text,
            autofocus: false,
            cursorColor: widget.cursorColor ?? R.colors.majorOrange,
            inputFormatters:
                (widget.formatter == null ? [] : [widget.formatter]),
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
            textInputAction: widget.textInputAction,
            maxLines: widget.maxLines,
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
                    fontWeight: FontWeight.normal,
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
