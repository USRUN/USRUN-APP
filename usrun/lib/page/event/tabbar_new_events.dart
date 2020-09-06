import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/manager/event_manager.dart';
import 'package:usrun/model/event.dart';
import 'package:usrun/model/response.dart';
import 'package:usrun/page/event/register_leave_event_util.dart';
import 'package:usrun/util/validator.dart';
import 'package:usrun/widget/event_list/event_info_line.dart';

class NewEventTabBar extends StatefulWidget {
  @override
  _NewEventTabBarState createState() => _NewEventTabBarState();
}

class _NewEventTabBarState extends State<NewEventTabBar> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<Event> _currentEventList;
  int _page;
  bool _allowLoadMore;

  @override
  void initState() {
    super.initState();
    _getNecessaryData();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    if (!_allowLoadMore) return;

    List<Event> result = List();

    Response<dynamic> response = await EventManager.getNewEventsPaged(_page, 5);
    if (response.success && (response.object as List).isNotEmpty) {
      result = response.object;
    }

    if (!mounted) return;
    if (result != null && result.length != 0) {
      setState(() {
        _currentEventList.insertAll(_currentEventList.length, result);
        _page += 1;
      });
    } else {
      setState(() {
        _allowLoadMore = false;
      });
    }
  }

  Future<void> _getNecessaryData() async {
    setState(() {
      _currentEventList = List();
      _page = 0;
      _allowLoadMore = true;
    });
    await _loadData();
    _refreshController.refreshCompleted();
  }

  Widget _buildEmptyList() {
    String systemNoti = R.strings.emptyMemberList;

    return Center(
      child: Container(
        padding: EdgeInsets.only(
          left: R.appRatio.appSpacing25,
          right: R.appRatio.appSpacing25,
        ),
        child: Text(
          systemNoti,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: R.colors.contentText,
            fontSize: R.appRatio.appFontSize16,
          ),
        ),
      ),
    );
  }

  Widget _renderBodyContent() {
    if (checkListIsNullOrEmpty(_currentEventList)) {
      return _buildEmptyList();
    }

    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.all(0.0),
      itemCount: _currentEventList.length,
      itemBuilder: (context, index) {
        if (index == _currentEventList.length - 1) {
          _loadData();
        }

        Event event = _currentEventList[index];
        double marginBottom = 0;
        if (index != _currentEventList.length - 1) {
          marginBottom = R.appRatio.appSpacing15;
        }

        return Container(
          key: Key(event.eventId.toString()),
          margin: EdgeInsets.only(
            bottom: marginBottom,
          ),
          child: EventInfoLine(
            eventItem: event,
            enableActionButton: true,
            registerCallback: () async {
              bool result = await RegisterLeaveEventUtil.handleRegisterAnEvent(
                context: context,
                eventName: _currentEventList[index].eventName,
                eventId: _currentEventList[index].eventId,
              );

              if (result != null && result) {
                setState(() {
                  _currentEventList.removeAt(index);
                });
              }
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullUp: false,
      controller: _refreshController,
      child: _renderBodyContent(),
      physics: BouncingScrollPhysics(),
      footer: null,
      onRefresh: () => _getNecessaryData(),
      onLoading: () async {
        await Future.delayed(Duration(milliseconds: 200));
      },
    );
  }
}
