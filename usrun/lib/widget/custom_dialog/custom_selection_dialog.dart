import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/model/object_filter.dart';
import 'package:usrun/util/image_cache_manager.dart';

class _CustomSelectionDialog extends StatefulWidget {
  final List<ObjectFilter> objects;
  final String title;
  final String description;
  final int selectedIndex;
  final bool enableObjectIcon;
  final bool enableScrollBar;
  final bool alwaysShowScrollBar;

  _CustomSelectionDialog(
    this.objects,
    this.title,
    this.description,
    this.selectedIndex,
    this.enableObjectIcon,
    this.enableScrollBar,
    this.alwaysShowScrollBar,
  ) : assert(objects != null &&
            objects.length != 0 &&
            selectedIndex != null &&
            selectedIndex < objects.length);

  @override
  _CustomSelectionDialogState createState() => _CustomSelectionDialogState();
}

class _CustomSelectionDialogState extends State<_CustomSelectionDialog> {
  final double _radius = 5.0;
  final double _spacing = 15.0;
  final double _buttonHeight = 50.0;
  final ScrollController _scrollController = ScrollController();

  int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _changeSelected(int index) {
    if (!mounted) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _renderRow(int index, bool isSelected) {
    ObjectFilter filterItem = widget.objects[index];
    return Container(
      height: 50,
      child: FlatButton(
        padding: EdgeInsets.all(0.0),
        splashColor: R.colors.lightBlurMajorOrange,
        textColor: Colors.white,
        onPressed: () {
          _changeSelected(index);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  (widget.enableObjectIcon
                      ? Container(
                          margin: EdgeInsets.only(right: 10),
                          child: ImageCacheManager.getImage(
                            url: filterItem.iconURL,
                            width: filterItem.iconSize,
                            height: filterItem.iconSize,
                          ),
                        )
                      : Container()),
                  Expanded(
                    child: Text(
                      filterItem.name,
                      overflow: TextOverflow.ellipsis,
                      textScaleFactor: 1.0,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: R.appRatio.appFontSize16,
                        fontWeight: FontWeight.normal,
                        color: R.colors.contentText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            (isSelected
                ? ImageCacheManager.getImage(
                    url: R.myIcons.appBarCheckBtn,
                    width: 18,
                    height: 18,
                    color: R.colors.majorOrange,
                  )
                : Container()),
          ],
        ),
      ),
    );
  }

  Widget _renderObjects() {
    int size = widget.objects.length;
    Widget _buildElement = ListView.builder(
      shrinkWrap: true,
      itemCount: size,
      controller: _scrollController,
      padding: EdgeInsets.only(
        left: _spacing,
        right: _spacing,
      ),
      itemBuilder: (context, index) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _renderRow(index, _selectedIndex == index),
            (index < size - 1
                ? Divider(
                    color: R.colors.blurMajorOrange,
                    height: 1,
                    thickness: 0.4,
                  )
                : Container()),
          ],
        );
      },
    );

    double extendRightPadding = 0;
    if (widget.enableScrollBar) {
      extendRightPadding = 4;
      _buildElement = CupertinoScrollbar(
        isAlwaysShown: widget.alwaysShowScrollBar,
        controller: _scrollController,
        child: _buildElement,
      );
    }

    return Container(
      constraints: BoxConstraints(maxHeight: 250),
      padding: EdgeInsets.only(right: extendRightPadding),
      child: _buildElement,
    );
  }

  Widget _renderDescription() {
    return Container(
      margin: EdgeInsets.only(
        left: _spacing,
        right: _spacing,
        top: 10.0,
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        widget.description ?? "",
        textScaleFactor: 1.0,
        textAlign: TextAlign.justify,
        style: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: R.appRatio.appFontSize16,
          color: R.colors.contentText,
        ),
      ),
    );
  }

  Widget _renderTitle() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(_spacing),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(_radius),
          topRight: Radius.circular(_radius),
        ),
        color: R.colors.majorOrange,
      ),
      child: Text(
        widget.title ?? "",
        textScaleFactor: 1.0,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: R.appRatio.appFontSize20,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _renderButton() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            height: _buttonHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(_radius),
              ),
              color: R.colors.dialogBackground,
            ),
            child: FlatButton(
              onPressed: () => pop(context, object: null),
              padding: EdgeInsets.all(0.0),
              splashColor: R.colors.lightBlurMajorOrange,
              textColor: Colors.white,
              child: Text(
                R.strings.cancel.toUpperCase(),
                textScaleFactor: 1.0,
                style: TextStyle(
                  fontSize: R.appRatio.appFontSize16,
                  fontWeight: FontWeight.bold,
                  color: R.colors.secondButtonDialogColor,
                ),
              ),
            ),
          ),
        ),
        Container(
          width: 1,
          height: _buttonHeight,
          child: VerticalDivider(
            color: R.colors.blurMajorOrange,
            thickness: 1.0,
          ),
        ),
        Expanded(
          child: Container(
            height: _buttonHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(_radius),
              ),
              color: R.colors.dialogBackground,
            ),
            child: FlatButton(
              onPressed: () {
                if (_selectedIndex == widget.selectedIndex) return;
                pop(context, object: _selectedIndex);
              },
              padding: EdgeInsets.all(0.0),
              splashColor: R.colors.lightBlurMajorOrange,
              textColor: Colors.white,
              child: Text(
                R.strings.yes.toUpperCase(),
                textScaleFactor: 1.0,
                style: TextStyle(
                  fontSize: R.appRatio.appFontSize16,
                  fontWeight: FontWeight.bold,
                  color: R.colors.firstButtonDialogColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildElement = Container(
      constraints: BoxConstraints(maxWidth: R.appRatio.appWidth360, maxHeight: 600),
      margin: EdgeInsets.only(
        left: _spacing,
        right: _spacing,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(_radius)),
        color: R.colors.dialogBackground,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Title
          _renderTitle(),
          // Description
          _renderDescription(),
          SizedBox(
            height: 8,
          ),
          // Objects
          _renderObjects(),
          // Horizontal divider
          Divider(
            color: R.colors.blurMajorOrange,
            height: 1,
            thickness: 1.0,
          ),
          // Button
          _renderButton(),
        ],
      ),
    );

    return NotificationListener<OverscrollIndicatorNotification>(
      child: _buildElement,
      onNotification: (overScroll) {
        overScroll.disallowGlow();
        return false;
      },
    );
  }
}

Future<T> showCustomSelectionDialog<T>(
  BuildContext context,
  List<ObjectFilter> objectFilterList,
  int selectedIndex, {
  String title,
  String description,
  bool enableObjectIcon: false,
  bool enableScrollBar: false,
  bool alwaysShowScrollBar: false,
}) async {
  if (enableObjectIcon == null) {
    enableObjectIcon = false;
  }

  if (enableScrollBar == null) {
    enableScrollBar = false;
  }

  if (alwaysShowScrollBar == null) {
    alwaysShowScrollBar = false;
  }

  return await showGeneralDialog<T>(
    context: context,
    barrierLabel: "Label",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 300),
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
          child: _CustomSelectionDialog(
            objectFilterList,
            title,
            description,
            selectedIndex,
            enableObjectIcon,
            enableScrollBar,
            alwaysShowScrollBar,
          ),
        ),
      );
    },
  );
}
