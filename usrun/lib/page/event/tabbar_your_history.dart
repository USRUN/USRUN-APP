import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/define.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/model/event.dart';
import 'package:usrun/page/event/register_leave_event_util.dart';
import 'package:usrun/widget/custom_dialog/custom_alert_dialog.dart';
import 'package:usrun/widget/custom_dialog/custom_loading_dialog.dart';
import 'package:usrun/widget/event_list/event_info_line.dart';

class HistoryEventTabBar extends StatefulWidget {
  @override
  _HistoryEventTabBarState createState() => _HistoryEventTabBarState();
}

class _HistoryEventTabBarState extends State<HistoryEventTabBar> {
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

    // TODO: Calling API here to get data, and use the variable "_page"
    // + Sorting elements by 2 factors: Ongoing -> Opening -> Ended startTime (current to the oldest)
    // + If user LEAVES any ongoing/opening events in this tabbar, this event won't be displayed in this tab anymore,
    // it will be moved to the "new events tab".
    // + The value of "joined" variable must be "true".
    List<Event> result = [
      Event(
        eventId: 1,
        eventName: "US Racing for Health 2021",
        subtitle:
            "Chạy bộ nào các bạn trẻ ơi, siêng năng chăm chỉ tập luyện vì sức khỏe của bạn :D",
        thumbnail: R.images.avatar,
        status: EventStatus.OnGoing,
        poweredBy: "Powered by Trường Đại học Khoa học Tự nhiên",
        totalParticipant: 44284,
        totalTeamParticipant: 456,
        joined: true,
        startTime: DateTime.now().subtract(Duration(days: 7)),
        endTime: DateTime.now().subtract(Duration(days: 5)),
      ),
      Event(
        eventId: 2,
        eventName: "US Racing for Health 2022",
        subtitle:
            "Chạy bộ nào các bạn trẻ ơi, siêng năng chăm chỉ tập luyện vì sức khỏe của bạn :D",
        thumbnail: R.images.avatar,
        status: EventStatus.Ended,
        poweredBy: "Powered by Trường Đại học Khoa học Tự nhiên",
        totalParticipant: 194729,
        totalTeamParticipant: 1048,
        joined: true,
        startTime: DateTime.now().subtract(Duration(days: 7)),
        endTime: DateTime.now().subtract(Duration(days: 5)),
      ),
      Event(
        eventId: 3,
        eventName: "US Racing for Health 2023",
        subtitle:
            "Chạy bộ nào các bạn trẻ ơi, siêng năng chăm chỉ tập luyện vì sức khỏe của bạn :D",
        thumbnail: R.images.avatar,
        status: EventStatus.Ended,
        poweredBy: "Powered by Trường Đại học Khoa học Tự nhiên",
        totalParticipant: 194729,
        totalTeamParticipant: 1048,
        joined: true,
        startTime: DateTime.now().subtract(Duration(days: 7)),
        endTime: DateTime.now().subtract(Duration(days: 5)),
      ),
    ];

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

  Widget _renderBodyContent() {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.all(0.0),
      itemCount: _currentEventList.length,
      itemBuilder: (context, index) {
//        TODO: Open this code after adding "API codes"
//        if (index == _currentEventList.length - 1) {
//          _loadData();
//        }

        double marginBottom = 0;
        if (index != _currentEventList.length - 1) {
          marginBottom = R.appRatio.appSpacing15;
        }

        Event event = _currentEventList[index];
        bool enableActionButton = false;
        if (_currentEventList[index].status.index != EventStatus.Ended.index) {
          enableActionButton = true;
        }

        return Container(
          key: Key(event.eventId.toString()),
          margin: EdgeInsets.only(
            bottom: marginBottom,
          ),
          child: EventInfoLine(
            eventItem: event,
            enableActionButton: enableActionButton,
            leaveCallback: () async {
              bool result = await RegisterLeaveEventUtil.handleLeaveAnEvent(
                context: context,
                arrayIndex: index,
                eventList: _currentEventList,
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
