import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/page/event/tabbar_current_event.dart';
import 'package:usrun/page/event/tabbar_history_event.dart';
import 'package:usrun/widget/custom_tab_bar.dart';

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<String> _tabItems;
  List<Widget> _tabBarViewItems;

  @override
  void initState() {
    super.initState();
    _initTabBarData();
  }

  void _initTabBarData() {
    _tabItems = [
      R.strings.currentEvents,
      R.strings.eventHistory,
    ];

    _tabController = TabController(
      length: _tabItems.length,
      vsync: this,
    );

    _tabBarViewItems = [
      CurrentEventTabBar(),
      HistoryEventTabBar(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return CustomTabBarStyle03(
      tabBarTitleList: _tabItems,
      tabController: _tabController,
      tabBarViewList: _tabBarViewItems,
    );
  }
}
