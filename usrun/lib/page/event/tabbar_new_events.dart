import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/define.dart';
import 'package:usrun/manager/event_manager.dart';
import 'package:usrun/model/event.dart';
import 'package:usrun/model/response.dart';
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
    
    // + TODO: Calling API here to get data, and use the variable "_page".
    // + Sorting elements by 2 factors: Ongoing -> Opening & startTime (current to the farthest)
    // + If user REGISTERS any events in this tabbar, this event won't be displayed in this tab anymore,
    // it will be moved to the "history tab".
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
        joined: false,
        startTime: DateTime.now().subtract(Duration(days: 4)),
        endTime: DateTime.now().add(Duration(days: 5)),
      ),
      Event(
        eventId: 2,
        eventName: "US Racing for Health 2021",
        subtitle:
            "Chạy bộ nào các bạn trẻ ơi, siêng năng chăm chỉ tập luyện vì sức khỏe của bạn :D",
        thumbnail: R.images.avatar,
        status: EventStatus.OnGoing,
        poweredBy: "Powered by Trường Đại học Khoa học Tự nhiên",
        totalParticipant: 194729,
        totalTeamParticipant: 1048,
        joined: false,
        startTime: DateTime.now().subtract(Duration(days: 1)),
        endTime: DateTime.now().add(Duration(days: 6)),
      ),
      Event(
        eventId: 3,
        eventName: "US Racing for Health 2021",
        subtitle:
        "Chạy bộ nào các bạn trẻ ơi, siêng năng chăm chỉ tập luyện vì sức khỏe của bạn :D",
        thumbnail: R.images.avatar,
        status: EventStatus.Opening,
        poweredBy: "Powered by Trường Đại học Khoa học Tự nhiên",
        totalParticipant: 194729,
        totalTeamParticipant: 1048,
        joined: false,
        startTime: DateTime.now(),
        endTime: DateTime.now().add(Duration(days: 5)),
      ),
    ];

    Response<dynamic> response = await EventManager.getNewEventsPaged(_page, 10);
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

// TODO (Code ko sử dụng): Khởi tạo biến ----------------------------------
//  int perPage = 10;
//  bool _isLoading;
//  List<dynamic> _myTeamOptions;
//  int _curPage;
//  bool _hasMoreResult;
//  User currentUser = UserManager.currentUser;
// TODO (Code ko sử dụng): [InitState] ----------------------------------
//    _curPage = 0;
//    _hasMoreResult = true;
//    _events = List();
//    _myTeamOptions = List();
// TODO (Code ko sử dụng): [Các hàm sử dụng] -------------------------------------------------------------------------------------------
//  void _updateLoading() {
//    Future.delayed(Duration(milliseconds: 1000), () {
//      if (!mounted) return;
//      setState(() {
//        _isLoading = !_isLoading;
//      });
//    });
//  }
//
//  _reloadData() async {
//    _isLoading = true;
//    _curPage = 0;
//    _hasMoreResult = true;
//    _events = List();
//
//    _loadMoreEvent();
//    _updateLoading();
//    _refreshController.refreshCompleted();
//  }
//
//  _getMyTeam() async {
//    Response<dynamic> response = await TeamManager.getMyTeam();
//    if (response.success && (response.object as List).isNotEmpty) {
//      response.object.forEach((Team t) => {
//            _myTeamOptions
//                .add(new DropDownObject(value: t.id, text: t.teamName))
//          });
//    }
//  }
//
//  _loadMoreEvent() async {
//    if (!_hasMoreResult) {
//      return;
//    }
//    _hasMoreResult = false;
//
//    Response<dynamic> response =
//        await EventManager.getAllEventsPaged(_curPage, widget.perPage);
//    if (response.success && (response.object as List).isNotEmpty) {
//      List<EventListItem> toAdd = List();
//      response.object
//          .forEach((Event e) => {toAdd.add(new EventListItem.fromEvent(e))});
//
//      setState(() {
//        _events.addAll(toAdd);
//      });
//      _hasMoreResult = true;
//    } else {
//      _hasMoreResult = false;
//    }
//  }
//
//  _handleLeave(int index) async {
//    Response<dynamic> response =
//        await EventManager.leaveEvent(_events[index].id, 0, currentUser.userId);
//
//    if (response.success) {
//      setState(() {
//        _events[index].joined = false;
//      });
//    } else {
//      await showCustomAlertDialog(
//        context,
//        title: R.strings.error,
//        content: response.errorMessage,
//        firstButtonText: R.strings.ok.toUpperCase(),
//        firstButtonFunction: () => pop(context),
//      );
//    }
//  }
//
//  _handleJoinButton(dynamic index) async {
//    if (_events[index].joined) {
//      // join complex dialog
//      // missing dropdown dialog
//    } else {
//      await showCustomAlertDialog(
//        context,
//        title: R.strings.notice,
//        content: R.strings.eventLeaveContent,
//        firstButtonText: R.strings.eventLeaveButton.toUpperCase(),
//        firstButtonFunction: _handleLeave(index),
//        secondButtonText: R.strings.cancel,
//        secondButtonFunction: () => pop(context),
//      );
//    }
//  }
// TODO: END UNUSED CODE ----------------------------------
