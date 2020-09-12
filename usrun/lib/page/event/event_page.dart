import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/page/event/tabbar_new_events.dart';
import 'package:usrun/page/event/tabbar_your_history.dart';
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
  GlobalKey<NewEventTabBarState> newEventTabBarPage = GlobalKey();
  GlobalKey<HistoryEventTabBarState> historyEventTabBarPage = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initTabBarData();
  }

  void _initTabBarData() {
    _tabItems = [
      R.strings.newEvents,
      R.strings.yourHistory,
    ];

    _tabController = TabController(
      length: _tabItems.length,
      vsync: this,
    );

    _tabBarViewItems = [
      NewEventTabBar(key: newEventTabBarPage),
      HistoryEventTabBar(key: historyEventTabBarPage),
    ];

    _tabController.addListener(() {
      switch (_tabController.previousIndex) {
        case 0:
          if (newEventTabBarPage.currentState.reloadOtherPage) {
            handleCallReload(1);
          }
          break;
        case 1:
          if (historyEventTabBarPage.currentState.reloadOtherPage) {
            handleCallReload(0);
          }
          break;
        default:
          break;
      }
    });
  }

  handleCallReload(int indexToReload) {
    if (indexToReload == 0) {
      if(newEventTabBarPage.currentState != null) {
        newEventTabBarPage.currentState.getNecessaryData();
      }
      historyEventTabBarPage.currentState.reloadOtherPage = false;
    } else {
      if(historyEventTabBarPage.currentState != null) {
        historyEventTabBarPage.currentState.getNecessaryData();
      }
      newEventTabBarPage.currentState.reloadOtherPage = false;
    }
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
