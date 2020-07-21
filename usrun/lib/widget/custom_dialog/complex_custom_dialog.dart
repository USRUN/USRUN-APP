import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/widget/input_field.dart';
import 'package:usrun/widget/ui_button.dart';

class _CustomDialog extends StatefulWidget {
  final String headerContent;
  final String descriptionContent;
  final List<InputField> inputFieldList;
  final String checkBoxHeader;
  final List<String> checkBoxList;
  final Function getCheckBoxResult;
  final String submitBtnContent;
  final Function submitBtnFunction;

  _CustomDialog({
    @required this.headerContent,
    this.descriptionContent = "",
    this.inputFieldList,
    this.checkBoxHeader = "",
    this.checkBoxList,
    this.getCheckBoxResult(List<bool> value),
    this.submitBtnContent = "Ok",
    this.submitBtnFunction,
  }) : assert(headerContent != null);

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<_CustomDialog> {
  List<bool> boxList = List<bool>();

  static double radius = 2;

  @override
  void initState() {
    super.initState();
    _initBoxList();
  }

  void _initBoxList() {
    if (widget.checkBoxList == null) return;
    for (int i = 0; i < widget.checkBoxList.length; ++i) {
      this.boxList.add(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildElement = SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Header
            Container(
              height: R.appRatio.appHeight60,
              decoration: BoxDecoration(
                gradient: R.colors.uiGradient,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(radius),
                  topRight: Radius.circular(radius),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                widget.headerContent.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: R.appRatio.appFontSize20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: R.appRatio.appSpacing15,
            ),
            // Description
            (widget.descriptionContent.length != 0
                ? Container(
                    padding: EdgeInsets.only(
                      bottom: R.appRatio.appSpacing15,
                      left: R.appRatio.appSpacing15,
                      right: R.appRatio.appSpacing15,
                    ),
                    child: Text(
                      widget.descriptionContent,
                      maxLines: null,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: R.colors.majorOrange,
                        fontSize: R.appRatio.appFontSize16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  )
                : Container()),
            // InputField
            for (int i = 0;
                widget.inputFieldList != null &&
                    i < widget.inputFieldList.length;
                ++i)
              Container(
                padding: EdgeInsets.only(
                  bottom: R.appRatio.appSpacing25,
                  left: R.appRatio.appSpacing15,
                  right: R.appRatio.appSpacing15,
                ),
                child: widget.inputFieldList[i],
              ),
            // CheckBoxList
            (this.boxList.length != 0 ? _renderBoxList() : Container()),
            // Button (Discard & Submit)
            _renderButtons()
          ],
        ),
      ),
    );

    return NotificationListener<OverscrollIndicatorNotification>(
        child: _buildElement,
        onNotification: (overScroll) {
          overScroll.disallowGlow();
          return false;
        });
  }

  Widget _renderBoxList() {
    return Container(
      // height: R.appRatio.appHeight100,
      padding: EdgeInsets.only(
        bottom: R.appRatio.appSpacing25,
        left: R.appRatio.appSpacing15,
        right: R.appRatio.appSpacing15,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Checkbox header
          (widget.checkBoxHeader.length != 0
              ? Container(
                  padding: EdgeInsets.only(
                    bottom: R.appRatio.appSpacing15,
                  ),
                  child: Text(
                    widget.checkBoxHeader,
                    style: TextStyle(
                      color: R.colors.majorOrange,
                      fontSize: R.appRatio.appFontSize18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Container()),
          // Checkbox list
          ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            itemCount: this.boxList.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return Container(
                padding: EdgeInsets.only(
                  bottom: (index != this.boxList.length - 1
                      ? R.appRatio.appSpacing10
                      : 0),
                ),
                child: _renderCheckBox(
                    index, widget.checkBoxList[index], this.boxList[index]),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _renderCheckBox(int index, String content, bool boolValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        // Checkbox
        Container(
          width: R.appRatio.appWidth30,
          height: R.appRatio.appWidth30,
          child: Checkbox(
            value: boolValue,
            activeColor: R.colors.majorOrange,
            onChanged: (bool value) {
              List<bool> copyList = this.boxList;
              copyList[index] = value;

              if (widget.getCheckBoxResult != null) {
                widget.getCheckBoxResult(copyList);
              }

              setState(() {
                this.boxList[index] = value;
              });
            },
          ),
        ),
        SizedBox(
          width: R.appRatio.appSpacing10,
        ),
        // Content of checkbox
        Expanded(
          child: Text(
            content,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.black, fontSize: R.appRatio.appFontSize16),
          ),
        ),
      ],
    );
  }

  void _handleCancel() {
    Navigator.pop(context);
  }

  Widget _renderButtons() {
    return Container(
      padding: EdgeInsets.only(
        top: R.appRatio.appSpacing15,
        left: R.appRatio.appSpacing15,
        right: R.appRatio.appSpacing15,
        bottom: R.appRatio.appSpacing25,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Cancel btn
          UIButton(
            width: R.appRatio.appWidth130,
            height: R.appRatio.appHeight50,
            color: R.colors.gray515151,
            text: R.strings.cancel.toUpperCase(),
            textSize: R.appRatio.appFontSize16,
            fontWeight: FontWeight.bold,
            onTap: _handleCancel,
          ),
          // Submit btn
          UIButton(
            width: R.appRatio.appWidth130,
            height: R.appRatio.appHeight50,
            gradient: R.colors.uiGradient,
            text: widget.submitBtnContent.toUpperCase(),
            textSize: R.appRatio.appFontSize16,
            fontWeight: FontWeight.bold,
            onTap: () {
              if (widget.submitBtnFunction != null) {
                widget.submitBtnFunction();
              }
            },
          ),
        ],
      ),
    );
  }
}

Future<void> showComplexCustomDialog({
  BuildContext context,
  @required String headerContent,
  String descriptionContent = "",
  List<InputField> inputFieldList,
  String checkBoxHeader = "",
  List<String> checkBoxList,
  Function getCheckBoxResult(List<bool> value),
  String submitBtnContent = "Ok",
  Function submitBtnFunction,
}) async {
  return await showGeneralDialog(
    context: context,
    barrierLabel: "Label",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 500),
    transitionBuilder: (context, anim1, anim2, child) {
      return ScaleTransition(
        scale: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: anim1,
            curve: Curves.fastOutSlowIn,
          ),
        ),
        child: child,
      );
    },
    pageBuilder: (context, anim1, anim2) {
      return Material(
        type: MaterialType.transparency,
        child: Align(
          alignment: Alignment.center,
          child: _CustomDialog(
            headerContent: headerContent,
            descriptionContent: descriptionContent,
            inputFieldList: inputFieldList,
            checkBoxHeader: checkBoxHeader,
            checkBoxList: checkBoxList,
            getCheckBoxResult: getCheckBoxResult,
            submitBtnContent: submitBtnContent,
            submitBtnFunction: submitBtnFunction,
          ),
        ),
      );
    },
  );
}
