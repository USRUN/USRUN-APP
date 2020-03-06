import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/util/image_cache_manager.dart';

/*
  -> ----------------------------
  -> This is StatsSectionStyle01
  -> ----------------------------
*/
class _StatsBoxStyle01 extends StatelessWidget {
  final String title;
  final String data;
  final String unit;
  final String iconURL;
  final bool isSuffixIcon;
  final bool enableBottomBorder;
  final bool enableMarginBottom;

  _StatsBoxStyle01({
    this.title = "N/A",
    this.data = "N/A",
    this.unit = "",
    this.iconURL,
    this.isSuffixIcon = false,
    this.enableBottomBorder = false,
    this.enableMarginBottom = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: R.appRatio.appWidth150,
            height: R.appRatio.appHeight60,
            decoration: BoxDecoration(
              border: (this.enableBottomBorder
                  ? Border(
                      bottom: BorderSide(
                      color: R.colors.contentText,
                      width: 1,
                    ))
                  : null),
            ),
            child: Row(
              mainAxisAlignment: (this.isSuffixIcon == false
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.end),
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                (this.isSuffixIcon == false
                    ? ImageCacheManager.getImage(
                        url: this.iconURL,
                        fit: BoxFit.cover,
                        width: R.appRatio.appIconSize20,
                        height: R.appRatio.appIconSize20,
                      )
                    : Container()),
                (this.isSuffixIcon == false
                    ? SizedBox(
                        width: R.appRatio.appSpacing10,
                      )
                    : Container()),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: (this.isSuffixIcon == false
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end),
                  children: <Widget>[
                    Text(
                      this.title.toUpperCase(),
                      style: TextStyle(
                        color: R.colors.contentText,
                        fontSize: R.appRatio.appFontSize16,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          this.data.toUpperCase(),
                          style: TextStyle(
                            fontSize: R.appRatio.appFontSize16,
                            color: R.colors.majorOrange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        (this.unit.length != 0
                            ? Padding(
                                padding: EdgeInsets.only(
                                  bottom: 0.8,
                                ),
                                child: Text(
                                  this.unit.toLowerCase(),
                                  style: TextStyle(
                                    fontSize: R.appRatio.appFontSize12,
                                    color: R.colors.majorOrange,
                                  ),
                                ),
                              )
                            : Container())
                      ],
                    ),
                  ],
                ),
                (this.isSuffixIcon == true
                    ? SizedBox(
                        width: R.appRatio.appSpacing10,
                      )
                    : Container()),
                (this.isSuffixIcon == true
                    ? ImageCacheManager.getImage(
                        url: this.iconURL,
                        fit: BoxFit.cover,
                        width: R.appRatio.appIconSize20,
                        height: R.appRatio.appIconSize20,
                      )
                    : Container()),
              ],
            ),
          ),
          (this.enableMarginBottom
              ? SizedBox(
                  height: R.appRatio.appSpacing15,
                )
              : Container()),
        ],
      ),
    );
  }
}

class StatsSectionStyle01 extends StatelessWidget {
  final String labelTitle;
  final bool enableLabelShadow;
  final List items;

  static double _verticalDividerHeight = 300;

  /*
    + When rendering, the items in this list will be divided into 2 parts (2 columns).
    + Structure of the "items" variable: 
    [
      {
        "title": "Average Pace",
        "data": "8:71",
        "unit": "/km",
        "iconURL": R.myIcons.paceStatsIconByTheme,
        "enableBottomBorder": true,
        "isSuffixIcon": true,
      },
      ...
    ]
  */

  StatsSectionStyle01({
    this.labelTitle = "",
    this.enableLabelShadow = false,
    @required this.items,
  });

  @override
  Widget build(BuildContext context) {
    // Empty item list
    if (this._isEmptyList()) {
      return this._buildEmptyList();
    }

    // Render item list
    return this._buildList();
  }

  bool _isEmptyList() {
    return ((this.items == null || this.items.length == 0) ? true : false);
  }

  Widget _buildEmptyList() {
    String systemNoti = "Nothing to show";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        (this.labelTitle.length == 0
            ? Container()
            : Container(
                padding: EdgeInsets.only(
                  bottom: R.appRatio.appSpacing15,
                ),
                child: Text(
                  this.labelTitle,
                  style: (this.enableLabelShadow
                      ? R.styles.shadowLabelStyle
                      : R.styles.labelStyle),
                ),
              )),
        Text(
          systemNoti,
          style: TextStyle(
            fontSize: R.appRatio.appFontSize18,
            color: R.colors.normalNoteText,
          ),
        ),
      ],
    );
  }

  Widget _renderStatsBoxStyle01(dynamic item, bool isLastItem) {
    return _StatsBoxStyle01(
      data: (item.containsKey('data') ? item['data'] : "N/A"),
      title: (item.containsKey('title') ? item['title'] : "N/A"),
      unit: (item.containsKey('unit') ? item['unit'] : ""),
      enableBottomBorder: (item.containsKey('enableBottomBorder')
          ? item['enableBottomBorder']
          : false),
      iconURL: (item.containsKey('iconURL') ? item['iconURL'] : null),
      isSuffixIcon:
          (item.containsKey('isSuffixIcon') ? item['isSuffixIcon'] : false),
      enableMarginBottom: (isLastItem
          ? false
          : (item.containsKey('enableMarginBottom')
              ? item['enableMarginBottom']
              : false)),
    );
  }

  Widget _buildList() {
    // Compute some data
    int _seperatedPoint = (this.items.length / 2).round();
    _verticalDividerHeight = R.appRatio.appHeight60 * _seperatedPoint +
        R.appRatio.appSpacing15 * (_seperatedPoint - 1);
    _verticalDividerHeight = _verticalDividerHeight.roundToDouble();

    // Render result
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        (this.labelTitle.length == 0
            ? Container()
            : Container(
                padding: EdgeInsets.only(
                  bottom: R.appRatio.appSpacing15,
                ),
                child: Text(
                  this.labelTitle,
                  style: (this.enableLabelShadow
                      ? R.styles.shadowLabelStyle
                      : R.styles.labelStyle),
                ),
              )),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                for (int i = 0; i < _seperatedPoint; ++i)
                  _renderStatsBoxStyle01(
                      this.items[i], (i == _seperatedPoint - 1))
              ],
            ),
            SizedBox(
              width: R.appRatio.appSpacing15,
            ),
            Container(
              width: 1,
              height: _verticalDividerHeight,
              child: VerticalDivider(
                color: R.colors.contentText,
                thickness: 1,
              ),
            ),
            SizedBox(
              width: R.appRatio.appSpacing15,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                for (int i = _seperatedPoint; i < this.items.length; ++i)
                  _renderStatsBoxStyle01(
                      this.items[i], (i == this.items.length - 1))
              ],
            ),
          ],
        ),
      ],
    );
  }
}

/*
  -> ----------------------------
  -> This is StatsSectionStyle02
  -> ----------------------------
*/
