import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/define.dart';
import 'package:usrun/manager/event_manager.dart';
import 'package:usrun/manager/user_manager.dart';
import 'package:usrun/model/event.dart';
import 'package:usrun/model/response.dart';
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
  int userId;

  @override
  void initState() {
    super.initState();
    userId = UserManager.currentUser.userId;
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
        eventName: "US Racing for Health 2021",
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
        eventName: "US Racing for Health 2021",
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

    Response<dynamic> response = await EventManager.getUserEventsPaged(userId, _page, 10);
    if(response.success){
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

        return Container(
          margin: EdgeInsets.only(
            bottom: marginBottom,
          ),
          child: EventInfoLine(
            eventItem: _currentEventList[index],
            enableActionButton: false,
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
