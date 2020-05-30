import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/util/image_cache_manager.dart';

/*
  -> ----------------------------
  -> This is CustomTabBarStyle01
  -> ----------------------------
*/
class CustomTabBarStyle01 extends StatelessWidget {
  final int selectedTabIndex;
  final List items;
  final Function pressTab;

  static double _tabIconSize = R.appRatio.appIconSize30;
  static double _tabBarWidth = R.appRatio.deviceWidth;
  static double _tabWidth = 0;
  static double _lastTabWidth = 0;

  /*
    Structure of the "items" variable: 
    [
      {
        "iconURL": "...",              [This must be value of ASSET]
      },
      ...
    ]
  */

  CustomTabBarStyle01({
    @required this.selectedTabIndex,
    @required this.items,
    this.pressTab,
  })  : assert(items != null &&
            items.length > 0 &&
            items.length <= R.constants.maxProfileTabBarNumber),
        assert(selectedTabIndex != null);

  void _computeTabBarWidth() {
    int _itemsSize = this.items.length;
    _tabWidth = (_tabBarWidth / _itemsSize).roundToDouble();
    _lastTabWidth = _tabBarWidth - (_tabWidth * (_itemsSize - 1));
  }

  @override
  Widget build(BuildContext context) {
    // Compute tab bar width
    _computeTabBarWidth();

    // Render tab bar
    return Container(
      color: R.colors.redPink,
      height: R.appRatio.appHeight50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          for (var i = 0; i < this.items.length; ++i)
            GestureDetector(
              onTap: () {
                if (this.pressTab != null) {
                  this.pressTab(i);
                }
              },
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    width: (i == this.items.length - 1
                        ? _lastTabWidth
                        : _tabWidth),
                    child: ImageCacheManager.getImage(
                      url: (this.items[i].containsKey('iconURL')
                          ? this.items[i]['iconURL']
                          : null),
                      width: _tabIconSize,
                      height: _tabIconSize,
                      fit: BoxFit.contain,
                    ),
                  ),
                  (this.selectedTabIndex == i
                      ? Container(
                          width: (i == this.items.length - 1
                              ? _lastTabWidth
                              : _tabWidth),
                          color: Color.fromRGBO(255, 255, 255, 0.2),
                        )
                      : Container()),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/*
  -> ----------------------------
  -> This is CustomTabBarStyle02
  -> ----------------------------
*/
class CustomTabBarStyle02 extends StatelessWidget {
  final int selectedTabIndex;
  final List items;
  final Function pressTab;

  static double _tabFontSize = R.appRatio.appFontSize16;
  static double _tabBarWidth = R.appRatio.deviceWidth;
  static double _tabWidth = 0;
  static double _lastTabWidth = 0;

  /*
    Structure of the "items" variable: 
    [
      {
        "tabName": "...",              
      },
      ...
    ]
  */

  CustomTabBarStyle02({
    @required this.selectedTabIndex,
    @required this.items,
    this.pressTab,
  })  : assert(items != null &&
            items.length > 0 &&
            items.length <= R.constants.maxProfileTabBarNumber),
        assert(selectedTabIndex != null);

  void _computeTabBarWidth() {
    int _itemsSize = this.items.length;
    _tabWidth = (_tabBarWidth / _itemsSize).roundToDouble();
    _lastTabWidth = _tabBarWidth - (_tabWidth * (_itemsSize - 1));
  }

  @override
  Widget build(BuildContext context) {
    // Compute tab bar width
    _computeTabBarWidth();

    // Render tab bar
    return Container(
      height: R.appRatio.appHeight40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          for (var i = 0; i < this.items.length; ++i)
            GestureDetector(
              onTap: () {
                if (this.pressTab != null) {
                  this.pressTab(i);
                }
              },
              child: Container(
                width: (i == this.items.length - 1 ? _lastTabWidth : _tabWidth),
                padding: EdgeInsets.only(
                  bottom: R.appRatio.appSpacing10,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: (this.selectedTabIndex == i ? 2 : 1),
                      color: (this.selectedTabIndex == i
                          ? R.colors.majorOrange
                          : R.colors.grayABABAB),
                    ),
                  ),
                ),
                child: Text(
                  (this.items[i].containsKey('tabName')
                      ? this.items[i]['tabName'].toString().toUpperCase()
                      : ""),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: _tabFontSize,
                    color: (this.selectedTabIndex == i
                        ? R.colors.majorOrange
                        : R.colors.grayABABAB),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/*
  -> ----------------------------
  -> This is CustomTabBarStyle03
  -> ----------------------------
*/

class CustomTabBarStyle03 extends StatelessWidget {
  final int selectedTabIndex;
  final List items;
  final Function pressTab;

  static double _tabFontSize = R.appRatio.appFontSize16;
  static double _tabWidth = R.appRatio.appWidth120;
  static double _tabHeight = R.appRatio.appHeight40;

  /*
    Structure of the "items" variable: 
    [
      {
        "tabName": "...",              
      },
      ...
    ]
  */

  CustomTabBarStyle03({
    @required this.selectedTabIndex,
    @required this.items,
    this.pressTab,
  })  : assert(items != null && items.length > 0),
        assert(selectedTabIndex != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: R.appRatio.appHeight50,
      decoration: BoxDecoration(
        color: R.colors.boxBackground,
        boxShadow: [
          BoxShadow(
            blurRadius: 2.0,
            offset: Offset(0.0, 1.0),
            color: R.colors.btnShadow,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (var i = 0; i < this.items.length; ++i)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // Tab
                  GestureDetector(
                    onTap: () {
                      if (this.pressTab != null) {
                        this.pressTab(i);
                      }
                    },
                    child: Container(
                      width: _tabWidth,
                      height: _tabHeight,
                      alignment: Alignment.center,
                      color: (this.selectedTabIndex == i
                          ? R.colors.tabLayer
                          : null),
                      child: Text(
                        (this.items[i].containsKey('tabName')
                            ? this.items[i]['tabName'].toString().toUpperCase()
                            : ""),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: R.colors.majorOrange,
                          fontSize: _tabFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Divider
                  (i != this.items.length - 1
                      ? Container(
                          width: R.appRatio.appSpacing15,
                          height: _tabHeight,
                          alignment: Alignment.center,
                          child: Container(
                            width: 1,
                            color: R.colors.majorOrange,
                          ),
                        )
                      : Container()),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/*
  -> ----------------------------
  -> This is CustomTabBarStyle04
  -> ----------------------------
*/
