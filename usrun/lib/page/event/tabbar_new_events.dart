import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/define.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/model/event.dart';
import 'package:usrun/model/object_filter.dart';
import 'package:usrun/model/team.dart';
import 'package:usrun/widget/custom_dialog/custom_alert_dialog.dart';
import 'package:usrun/widget/custom_dialog/custom_loading_dialog.dart';
import 'package:usrun/widget/custom_dialog/custom_selection_dialog.dart';
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
    // + The value of "joined" variable must be "false".
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
        eventName: "US Racing for Health 2022",
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
        eventName: "US Racing for Health 2023",
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

  Future<Team> _chooseATeam() async {
    // TODO: API get team list of users
    List<Team> teamListOfUser = [
      Team(
        id: 1,
        teamName: "Trường Đại học Khoa học Tự nhiên",
        thumbnail: R.images.avatarQuocTK,
      ),
      Team(
        id: 2,
        teamName: "Công ty Cổ phần Tự Nghĩa",
        thumbnail: R.images.avatarHuyTA,
      ),
      Team(
        id: 3,
        teamName: "ABCOL Corporation",
        thumbnail: R.images.avatarNgocVTT,
      ),
    ];

    List<ObjectFilter> objFilterList = List();
    teamListOfUser.forEach((element) {
      objFilterList.add(ObjectFilter(
        name: element.teamName,
        iconURL: element.thumbnail,
        iconSize: 20,
        value: element,
      ));
    });

    int selectedIndex = await showCustomSelectionDialog(
      context,
      objFilterList,
      -1,
      title: R.strings.chooseTeamTitle,
      description: R.strings.chooseTeamDescription,
      enableObjectIcon: true,
      enableScrollBar: true,
      alwaysShowScrollBar: true,
    );

    return selectedIndex == null || selectedIndex < 0
        ? null
        : teamListOfUser[selectedIndex];
  }

  Future<void> _handleRegisterAnEvent(int arrayIndex) async {
    Team userTeam = await _chooseATeam();
    if (userTeam == null) return null;

    showCustomLoadingDialog(
      context,
      text: R.strings.processing,
    );

    // TODO: Put your code here
    // result: true (Registering successfully), false (Registering fail)
    bool result = await Future.delayed(Duration(milliseconds: 2500), () {
      print("[EVENT_INFO_LINE] Finish processing about registering an event");
      return true;
    });

    pop(context);

    if (result) {
      String message = R.strings.registerEventSuccessfully;
      message = message.replaceAll(
        "@@@",
        _currentEventList[arrayIndex].eventName,
      );
      message = message.replaceAll("###", userTeam.teamName);

      showCustomAlertDialog(
        context,
        title: R.strings.announcement,
        content: message,
        firstButtonText: R.strings.close.toUpperCase(),
        firstButtonFunction: () {
          pop(context);
          setState(() {
            _currentEventList.removeAt(arrayIndex);
          });
        },
      );
    } else {
      showCustomAlertDialog(
        context,
        title: R.strings.error,
        content: R.strings.errorOccurred,
        firstButtonText: R.strings.ok.toUpperCase(),
        firstButtonFunction: () => pop(context),
      );
    }
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
            registerCallback: () => _handleRegisterAnEvent(index),
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
