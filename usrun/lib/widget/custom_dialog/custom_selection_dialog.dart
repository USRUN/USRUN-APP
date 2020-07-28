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

  _CustomSelectionDialog(
    this.objects,
    this.title,
    this.description,
    this.selectedIndex,
  ) : assert(objects != null &&
            objects.length != 0 &&
            selectedIndex != null &&
            selectedIndex < objects.length);

  @override
  _CustomSelectionDialogState createState() => _CustomSelectionDialogState();
}

class _CustomSelectionDialogState extends State<_CustomSelectionDialog> {
  final double _radius = 7.0;
  final double _spacing = 15.0;
  final double _buttonHeight = 50.0;

  int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _changeSelected(int index) {
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              filterItem.name,
              overflow: TextOverflow.ellipsis,
              textScaleFactor: 1.0,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                color: Colors.black,
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
    List<Widget> listItemWidgets = List<Widget>();
    int size = widget.objects.length;
    for (int i = 0; i < size; i++) {
      listItemWidgets.add(_renderRow(i, _selectedIndex == i));
      if (i < size - 1) {
        listItemWidgets.add(
          Divider(
            color: R.colors.blurMajorOrange,
            height: 2,
            thickness: 0.4,
          ),
        );
      }
    }

    return Padding(
      padding: EdgeInsets.only(
        left: _spacing,
        right: _spacing,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: listItemWidgets,
      ),
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
          fontSize: 15,
          color: Colors.black,
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
          fontSize: 18,
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
              color: Colors.white,
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
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
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
              color: Colors.white,
            ),
            child: FlatButton(
              onPressed: () {
                pop(context, object: _selectedIndex);
              },
              padding: EdgeInsets.all(0.0),
              splashColor: R.colors.lightBlurMajorOrange,
              textColor: Colors.white,
              child: Text(
                R.strings.yes.toUpperCase(),
                textScaleFactor: 1.0,
                style: TextStyle(
                  fontSize: 14,
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

  @override
  Widget build(BuildContext context) {
    Widget _buildElement = Container(
      constraints: BoxConstraints(maxWidth: 320, maxHeight: 500),
      margin: EdgeInsets.only(
        left: _spacing,
        right: _spacing,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(_radius)),
        color: Colors.white,
      ),
      child: SingleChildScrollView(
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
            // Languages
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

Future<T> showCustomSelectionDialog<T>(
    BuildContext context, List<ObjectFilter> listObjects, int selectedIndex,
    {String title, String description}) async {
  return await showGeneralDialog(
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
            listObjects,
            title,
            description,
            selectedIndex,
          ),
        ),
      );
    },
  );
}
