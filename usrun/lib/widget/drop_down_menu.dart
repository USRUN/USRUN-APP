import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/util/image_cache_manager.dart';

class DropDownMenu extends StatefulWidget {
  final String labelTitle;
  final String hintText;
  final bool enableLabelShadow;
  final bool enableHorizontalLabelTitle;
  final bool enableFullWidth;
  final Function onChanged;
  final List items;
  final String errorEmptyData;
  final Widget underline;
  final bool isDense;
  final int elevation;

  /*
    Structure of the "items" variable: 
    [
      {
        "value": "0",                   [This field must have NUMBER value as string]
        "text": "Male",                 
        "imageURL": "https://..."       [This field is OPTIONAL]
      },
      ...
    ]
  */

  DropDownMenu({
    Key key,
    this.labelTitle = "",
    this.hintText = "",
    this.enableLabelShadow = false,
    this.enableHorizontalLabelTitle = false,
    this.enableFullWidth = true,
    @required this.onChanged,
    @required this.items,
    @required this.errorEmptyData,
    this.underline,
    this.isDense = false,
    this.elevation = 2,
  }) : super(key: key);

  @override
  _DropDownMenuState createState() => new _DropDownMenuState();
}

class _DropDownMenuState extends State<DropDownMenu> {
  String _selectedValue;
  bool _itemsHasImageURL = false;
  Widget _underline;

  @override
  void initState() {
    super.initState();
    _selectedValue = '0';
    _initUnderlineWidget();
  }

  @override
  Widget build(BuildContext context) {
    // EMPTY items
    if (widget.items == null || widget.items.length == 0) {
      return this._emptyDropDownBtn();
    }

    // CHECK items has "imageURL" field or not
    for (int i = 0; i < widget.items.length; ++i) {
      if (widget.items[i].containsKey('imageURL')) {
        _itemsHasImageURL = true;
        break;
      }
    }

    // RENDER drop down button
    return Container(
      width: (widget.enableFullWidth
          ? R.appRatio.appWidth381
          : R.appRatio.appWidth181),
      child: (widget.enableHorizontalLabelTitle
          ? this._horizontalObjects()
          : this._verticalObjects()),
    );
  }

  void _initUnderlineWidget() {
    _underline = widget.underline;
    if (widget.underline == null) {
      _underline = Container(
        height: 1,
        color: R.colors.majorOrange,
      );
    }
  }

  Widget _emptyDropDownBtn() {
    return Container(
      width: (widget.enableFullWidth
          ? R.appRatio.appWidth381
          : R.appRatio.appWidth181),
      child: (widget.enableHorizontalLabelTitle
          ? Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
                Container(
                  height: 25,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(
                      left: (widget.labelTitle.length == 0
                          ? 0
                          : R.appRatio.appSpacing15)),
                  child: Text(
                    widget.errorEmptyData,
                    style: TextStyle(
                      fontSize: R.appRatio.appFontSize18,
                      color: R.colors.normalNoteText,
                    ),
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
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
                Container(
                  height: 50,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.errorEmptyData,
                    style: TextStyle(
                      fontSize: R.appRatio.appFontSize18,
                      color: R.colors.normalNoteText,
                    ),
                  ),
                )
              ],
            )),
    );
  }

  List<DropdownMenuItem<String>> _createMenuItemList() {
    List<DropdownMenuItem<String>> menuItemList = [];

    for (int i = 0; i < widget.items.length; ++i) {
      dynamic element = widget.items[i];

      DropdownMenuItem<String> menuItem = DropdownMenuItem(
        value: element['value'],
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                    right:
                        (this._itemsHasImageURL ? R.appRatio.appSpacing10 : 0)),
                child: (this._itemsHasImageURL
                    ? ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        child: ImageCacheManager.getImage(
                          url: element['imageURL'],
                          width: R.appRatio.appDropDownImageSquareSize,
                          height: R.appRatio.appDropDownImageSquareSize,
                          fit: BoxFit.cover,
                        ))
                    : null),
              ),
              Text(
                element['text'],
              )
            ],
          ),
        ),
      );

      menuItemList.add(menuItem);
    }

    return menuItemList;
  }

  Widget _verticalObjects() {
    return Column(
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
        DropdownButton<String>(
          icon: Icon(Icons.arrow_drop_down),
          iconEnabledColor: R.colors.majorOrange,
          iconSize: R.appRatio.appDropDownArrowIconSize,
          style: TextStyle(
            color: R.colors.contentText,
            fontSize: R.appRatio.appFontSize18,
          ),
          underline: Container(
            height: 1.0,
            color: Colors.transparent,
          ),
          hint: Text(
            (widget.hintText.length != 0) ? widget.hintText : "",
            style: TextStyle(
              color: R.colors.normalNoteText,
              fontSize: R.appRatio.appFontSize18,
            ),
          ),
          onChanged: (newValue) {
            if (widget.onChanged != null) {
              widget.onChanged(newValue);
            }
            setState(() {
              this._selectedValue = newValue;
            });
          },
          value: _selectedValue,
          items: this._createMenuItemList(),
          isExpanded: true,
          elevation: widget.elevation,
          isDense: widget.isDense,
        ),
        this._underline,
      ],
    );
  }

  Widget _horizontalObjects() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                  right: (widget.labelTitle.length == 0
                      ? 0
                      : R.appRatio.appSpacing15)),
              child: (widget.labelTitle.length == 0
                  ? null
                  : Text(
                      widget.labelTitle,
                      style: (widget.enableLabelShadow
                          ? R.styles.shadowLabelStyle
                          : R.styles.labelStyle),
                    )),
            ),
            Expanded(
              child: DropdownButton<String>(
                items: this._createMenuItemList(),
                onChanged: (newValue) {
                  if (widget.onChanged != null) {
                    widget.onChanged(newValue);
                  }
                  setState(() {
                    this._selectedValue = newValue;
                  });
                },
                icon: Icon(Icons.arrow_drop_down),
                iconEnabledColor: R.colors.majorOrange,
                iconSize: R.appRatio.appDropDownArrowIconSize,
                style: TextStyle(
                  color: R.colors.contentText,
                  fontSize: R.appRatio.appFontSize18,
                ),
                underline: Container(
                  height: 1.0,
                  color: Colors.transparent,
                ),
                hint: Text(
                  (widget.hintText.length != 0) ? widget.hintText : "",
                  style: TextStyle(
                    color: R.colors.normalNoteText,
                    fontSize: R.appRatio.appFontSize18,
                  ),
                ),
                value: _selectedValue,
                isExpanded: true,
                elevation: widget.elevation,
                isDense: widget.isDense,
              ),
            ),
          ],
        ),
        this._underline,
      ],
    );
  }
}
