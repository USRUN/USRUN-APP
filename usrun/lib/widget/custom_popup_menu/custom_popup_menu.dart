import "package:flutter/material.dart";
import 'package:usrun/util/image_cache_manager.dart';

import 'custom_popup_item.dart';

class CustomPopupMenu<T> extends StatefulWidget {
  final List<PopupItem<T>> items;
  final Function onSelected;
  final Function onCancel;
  final Widget popupIcon;
  final T initialValue;
  final bool enableChild;
  final Widget popupChild;
  final bool fullPopupWidth;
  final ShapeBorder shapeBorder;
  final double elevation;
  final bool enable;
  final Color popupColor;

  CustomPopupMenu({
    Key key,
    @required this.items,
    @required this.onSelected(index),
    this.onCancel,
    this.popupIcon,
    this.initialValue,
    this.enableChild = false,
    this.popupChild,
    this.fullPopupWidth = false,
    this.shapeBorder,
    this.elevation = 4.0,
    this.enable = true,
    this.popupColor,
  }) : super(key: key);

  @override
  _CustomPopupMenuState<T> createState() => _CustomPopupMenuState<T>();
}

class _CustomPopupMenuState<T> extends State<CustomPopupMenu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      padding: EdgeInsets.all(0),
      elevation: widget.elevation,
      shape: widget.shapeBorder,
      enabled: widget.enable,
      color: widget.popupColor ?? Theme.of(context).cardColor,
      initialValue: widget.initialValue,
      onSelected: widget.onSelected,
      onCanceled: widget.onCancel,
      icon: (!widget.enableChild ? widget.popupIcon : null),
      child: (widget.enableChild ? widget.popupChild : null),
      itemBuilder: (BuildContext context) {
        List<PopupMenuEntry<T>> popupList = List<PopupMenuEntry<T>>();

        for (int i = 0; i < widget.items.length; ++i) {
          PopupItem element = widget.items[i];

          double iconSize = element.iconSize;
          if (iconSize <= 2.0) {
            iconSize = 15.0;
          }

          bool hasIcon = element.iconURL.length != 0;
          Widget leftIcon = Container();
          if (hasIcon) {
            leftIcon = Container(
              width: iconSize,
              height: iconSize,
              margin: element.padding,
              alignment: Alignment.centerLeft,
              child: ImageCacheManager.getImage(
                url: element.iconURL,
                width: iconSize,
                height: iconSize,
                fit: BoxFit.contain,
              ),
            );
          }

          popupList.add(
            PopupMenuItem<T>(
              value: element.value,
              child: Container(
                width: (widget.fullPopupWidth ? double.maxFinite : null),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    leftIcon,
                    Text(
                      element.title,
                      textScaleFactor: 1.0,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: element.titleStyle ??
                          TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return popupList;
      },
    );
  }
}
