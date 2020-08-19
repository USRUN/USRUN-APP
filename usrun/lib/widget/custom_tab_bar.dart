import 'dart:ui';

import 'package:flutter/cupertino.dart';
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
  final List<String> items;
  final Function pressTab;

  static double _tabIconSize = R.appRatio.appIconSize30;
  static double _tabBarWidth = R.appRatio.deviceWidth;
  static double _tabWidth = 0;
  static double _lastTabWidth = 0;

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
                      url: (this.items[i] != null && this.items[i].length != 0
                          ? this.items[i]
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
  final List<String> items;
  final Function pressTab;

  static double _tabFontSize = R.appRatio.appFontSize16;
  static double _tabBarWidth = R.appRatio.deviceWidth;
  static double _tabWidth = 0;
  static double _lastTabWidth = 0;

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
                  (this.items[i] != null && this.items[i].length != 0
                      ? this.items[i].toUpperCase()
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
  final TabController tabController;
  final List<String> tabBarTitleList;
  final List<Widget> tabBarViewList;
  final void Function(int tabIndex) pressTab;

  final double _tabHeight = 45.0;

  CustomTabBarStyle03({
    @required this.tabController,
    @required this.tabBarTitleList,
    @required this.tabBarViewList,
    this.pressTab,
  })  : assert(tabBarTitleList != null && tabBarTitleList.length > 0),
        assert(tabBarViewList != null && tabBarViewList.length > 0),
        assert(tabBarTitleList.length == tabBarViewList.length);

  Widget _renderTabBar() {
    List<Tab> tabList = List();
    tabBarTitleList.forEach((element) {
      tabList.add(
        Tab(
          child: Text(
            element.toUpperCase(),
            textScaleFactor: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: R.colors.majorOrange,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    });

    return Container(
      height: _tabHeight,
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
      child: TabBar(
        controller: tabController,
        labelPadding: EdgeInsets.all(0),
        indicatorColor: R.colors.majorOrange,
        indicatorWeight: 2,
        indicatorPadding: EdgeInsets.all(0),
        onTap: (index) {
          if (this.pressTab != null) {
            this.pressTab(index);
          }
        },
        tabs: tabList,
      ),
    );
  }

  Widget _renderTabBarView() {
    return Padding(
      padding: EdgeInsets.only(top: _tabHeight),
      child: TabBarView(
        children: tabBarViewList,
        controller: tabController,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        _renderTabBarView(),
        _renderTabBar(),
      ],
    );
  }
}

/*
  -> ----------------------------
  -> This is CustomTabBarStyle04
  -> ----------------------------
*/
