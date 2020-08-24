import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/widget/custom_dialog/checkbox_item.dart';
import 'package:usrun/widget/input_field.dart';

typedef OnPressedCheckBoxFunction = void Function(int index, bool isSelected);

class _ComplexDialog extends StatefulWidget {
  final double maxWidth;
  final double maxHeight;
  final String headerContent;
  final String descriptionContent;
  final List<InputField> inputFieldList;
  final String checkBoxHeader;
  final List<CheckBoxItem> checkBoxList;
  final OnPressedCheckBoxFunction onPressedCheckBox;
  final String firstButtonText;
  final Function firstButtonFunction;
  final String secondButtonText;
  final Function secondButtonFunction;

  _ComplexDialog({
    this.maxWidth = 320,
    this.maxHeight = 450,
    @required this.headerContent,
    this.descriptionContent = "",
    this.inputFieldList,
    this.checkBoxHeader = "",
    this.checkBoxList,
    this.onPressedCheckBox,
    @required this.firstButtonText,
    @required this.firstButtonFunction,
    this.secondButtonText = "",
    this.secondButtonFunction,
  }) : assert(maxWidth != null &&
            maxWidth > 0 &&
            maxHeight != null &&
            maxHeight > 0 &&
            headerContent != null);

  @override
  _ComplexDialogState createState() => _ComplexDialogState();
}

class _ComplexDialogState extends State<_ComplexDialog> {
  List<CheckBoxItem> boxList = List<CheckBoxItem>();
  final double radius = 10;
  final double _buttonHeight = 50.0;

  @override
  void initState() {
    super.initState();
    boxList = widget.checkBoxList;
  }

  Widget _renderHeader() {
    return Container(
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
    );
  }

  Widget _renderDescription() {
    if (widget.descriptionContent == null ||
        widget.descriptionContent.length == 0) {
      return Container();
    }

    return Container(
      padding: EdgeInsets.all(
        R.appRatio.appSpacing15,
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
    );
  }

  Widget _renderInputFields() {
    if (widget.inputFieldList == null || widget.inputFieldList.length == 0) {
      return Container();
    }

    int length = widget.inputFieldList.length;
    List<Widget> widgetList = List();
    for (int i = 0; i < length; ++i) {
      widgetList.add(
        Container(
          padding: EdgeInsets.only(
            bottom: R.appRatio.appSpacing25,
            left: R.appRatio.appSpacing15,
            right: R.appRatio.appSpacing15,
          ),
          child: widget.inputFieldList[i],
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: widgetList,
    );
  }

  Widget _renderCheckBoxes() {
    if (this.boxList == null || this.boxList.length == 0) {
      return Container();
    }

    Widget checkBoxHeader = Container();
    if (widget.checkBoxHeader.length != 0) {
      checkBoxHeader = Container(
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
      );
    }

    return Container(
      padding: EdgeInsets.only(
        bottom: R.appRatio.appSpacing15,
        left: R.appRatio.appSpacing15,
        right: R.appRatio.appSpacing15,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Checkbox header
          checkBoxHeader,
          // Checkbox list
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.all(0.0),
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            itemCount: this.boxList.length,
            itemBuilder: (BuildContext ctxt, int index) {
              double pad = 0;
              if (index != this.boxList.length - 1) {
                pad = R.appRatio.appSpacing10;
              }

              return Container(
                padding: EdgeInsets.only(bottom: pad),
                child: _renderCheckBoxInfo(
                  index,
                  this.boxList[index],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _renderCheckBoxInfo(int index, CheckBoxItem boxItem) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        // Checkbox
        Container(
          width: R.appRatio.appWidth30,
          height: R.appRatio.appWidth30,
          child: Checkbox(
            value: boxItem.isSelected,
            activeColor: R.colors.majorOrange,
            onChanged: (bool value) {
              if (widget.onPressedCheckBox != null) {
                widget.onPressedCheckBox(index, value);
              }

              if (!mounted) return;
              setState(() {
                this.boxList[index].isSelected = value;
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
            boxItem.content,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black,
              fontSize: R.appRatio.appFontSize16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _renderButtons() {
    bool _existSecondButton = false;
    if (widget.secondButtonText.length != 0 &&
        widget.secondButtonFunction != null) {
      _existSecondButton = true;
    }

    return Row(
      children: <Widget>[
        // Second button
        (_existSecondButton
            ? Expanded(
                child: SizedBox(
                  height: _buttonHeight,
                  child: FlatButton(
                    onPressed: () => widget.secondButtonFunction(),
                    padding: EdgeInsets.all(0.0),
                    splashColor: R.colors.lightBlurMajorOrange,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(radius),
                      ),
                    ),
                    child: Text(
                      widget.secondButtonText,
                      textScaleFactor: 1.0,
                      style: TextStyle(
                        fontSize: R.appRatio.appFontSize16,
                        fontWeight: FontWeight.bold,
                        color: R.colors.gray515151,
                      ),
                    ),
                  ),
                ),
              )
            : Container()),
        // Vertical Divider
        (_existSecondButton
            ? Container(
                width: 1,
                height: _buttonHeight,
                child: VerticalDivider(
                  color: R.colors.blurMajorOrange,
                  thickness: 1.0,
                ),
              )
            : Container()),
        // First button
        Expanded(
          child: SizedBox(
            height: _buttonHeight,
            child: FlatButton(
              onPressed: () => widget.firstButtonFunction(),
              padding: EdgeInsets.all(0.0),
              splashColor: R.colors.lightBlurMajorOrange,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: (!_existSecondButton
                      ? Radius.circular(radius)
                      : Radius.circular(0.0)),
                  bottomRight: Radius.circular(radius),
                ),
              ),
              child: Text(
                widget.firstButtonText,
                textScaleFactor: 1.0,
                style: TextStyle(
                  fontSize: R.appRatio.appFontSize16,
                  fontWeight: FontWeight.bold,
                  color: R.colors.majorOrange,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _renderContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Description
        _renderDescription(),
        // InputField
        _renderInputFields(),
        // CheckBox
        _renderCheckBoxes(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildElement = Container(
      constraints: BoxConstraints(
        maxWidth: widget.maxWidth,
        maxHeight: widget.maxHeight,
      ),
      margin: EdgeInsets.only(
        top: R.appRatio.appSpacing35,
        bottom: R.appRatio.appSpacing15,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        color: Colors.white,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Header
            _renderHeader(),
            // Content
            _renderContent(),
            // Horizontal divider
            Divider(
              color: R.colors.blurMajorOrange,
              height: 1,
              thickness: 1.0,
            ),
            // Button (Discard & Submit)
            _renderButtons(),
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
}

Future<T> showCustomComplexDialog<T>(
  BuildContext context, {
  double maxWidth = 320,
  double maxHeight = 450,
  @required String headerContent,
  String descriptionContent = "",
  List<InputField> inputFieldList,
  String checkBoxHeader = "",
  List<CheckBoxItem> checkBoxList,
  OnPressedCheckBoxFunction onPressedCheckBox,
  @required firstButtonText,
  @required firstButtonFunction,
  secondButtonText = "",
  secondButtonFunction,
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
        child: Container(
          alignment: Alignment.center,
          margin: MediaQuery.of(context).viewInsets,
          child: _ComplexDialog(
            headerContent: headerContent,
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            descriptionContent: descriptionContent,
            inputFieldList: inputFieldList,
            checkBoxHeader: checkBoxHeader,
            checkBoxList: checkBoxList,
            onPressedCheckBox: onPressedCheckBox,
            firstButtonText: firstButtonText,
            firstButtonFunction: firstButtonFunction,
            secondButtonText: secondButtonText,
            secondButtonFunction: secondButtonFunction,
          ),
        ),
      );
    },
  );
}
