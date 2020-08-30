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
  final double _tabIconSize = R.appRatio.appIconSize30;

  final int selectedTabIndex;
  final List<String> items;
  final Function pressTab;

  CustomTabBarStyle01({
    @required this.selectedTabIndex,
    @required this.items,
    this.pressTab,
  })  : assert(items != null &&
            items.length > 0 &&
            items.length <= R.constants.maxProfileTabBarNumber),
        assert(selectedTabIndex != null);

  Widget _renderButton(String iconURL, int index) {
    Color overlayColor = Colors.transparent;
    if (this.selectedTabIndex == index) {
      overlayColor = Color.fromRGBO(255, 255, 255, 0.2);
    }

    return FlatButton(
      textColor: Colors.white,
      padding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(0),
        ),
      ),
      onPressed: () {
        if (this.pressTab != null) {
          this.pressTab(index);
        }
      },
      child: Container(
        color: overlayColor,
        alignment: Alignment.center,
        child: ImageCacheManager.getImage(
          url: iconURL,
          width: _tabIconSize,
          height: _tabIconSize,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  List<Widget> _renderTabBar() {
    List<Widget> tabBar = List();

    for (int i = 0; i < this.items.length; ++i) {
      tabBar.add(
        Expanded(
          child: _renderButton(this.items[i], i),
        ),
      );
    }

    return tabBar;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: R.colors.redPink,
      height: R.appRatio.appHeight50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _renderTabBar(),
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
  final double _tabFontSize = R.appRatio.appFontSize16;

  final int selectedTabIndex;
  final List<String> items;
  final Function pressTab;

  CustomTabBarStyle02({
    @required this.selectedTabIndex,
    @required this.items,
    this.pressTab,
  })  : assert(items != null &&
            items.length > 0 &&
            items.length <= R.constants.maxProfileTabBarNumber),
        assert(selectedTabIndex != null);

  Widget _renderButton(String data, int index) {
    double borderWidth = 1;
    Color btnColor = R.colors.grayABABAB;
    if (this.selectedTabIndex == index) {
      borderWidth = 2;
      btnColor = R.colors.majorOrange;
    }

    if (data == null) data = "";
    data = data.toUpperCase();

    return FlatButton(
      textColor: Colors.white,
      splashColor: R.colors.lightBlurMajorOrange,
      padding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(0),
        ),
      ),
      onPressed: () {
        if (this.pressTab != null) {
          this.pressTab(index);
        }
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: borderWidth,
              color: btnColor,
            ),
          ),
        ),
        child: Text(
          data,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: _tabFontSize,
            color: btnColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  List<Widget> _renderTabBar() {
    List<Widget> tabBar = List();

    for (int i = 0; i < this.items.length; ++i) {
      tabBar.add(
        Expanded(
          child: _renderButton(this.items[i], i),
        ),
      );
    }

    return tabBar;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: R.appRatio.appHeight50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _renderTabBar(),
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
        boxShadow: [R.styles.boxShadowB],
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
