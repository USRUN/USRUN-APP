import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/manager/event_manager.dart';
import 'package:usrun/manager/team_manager.dart';
import 'package:usrun/manager/user_manager.dart';
import 'package:usrun/model/event.dart';
import 'package:usrun/model/response.dart';
import 'package:usrun/model/team.dart';
import 'package:usrun/model/user.dart';
import 'package:usrun/page/event/event_list_item.dart';
import 'package:usrun/widget/custom_dialog/custom_alert_dialog.dart';
import 'package:usrun/widget/drop_down_menu/drop_down_object.dart';

class EventPage extends StatefulWidget {
  final int perPage = 10;

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  bool _isLoading;
  List<EventListItem> _events;
  List<dynamic> _myTeamOptions;
  int _curPage;
  bool _hasMoreResult;
  User currentUser = UserManager.currentUser;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _isLoading = true;

    _curPage = 0;
    _hasMoreResult = true;
    _events = List();
    _myTeamOptions = List();

    EventManager.getUserEvents();

    WidgetsBinding.instance.addPostFrameCallback((_) => _loadMoreEvent());
    WidgetsBinding.instance.addPostFrameCallback((_) => _getMyTeam());
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateLoading());
  }

  void _updateLoading() {
    Future.delayed(Duration(milliseconds: 1000), () {
      if (!mounted) return;
      setState(() {
        _isLoading = !_isLoading;
      });
    });
  }

  _reloadData() async {
    _isLoading = true;
    _curPage = 0;
    _hasMoreResult = true;
    _events = List();

    _loadMoreEvent();
    _updateLoading();
    _refreshController.refreshCompleted();
  }

  _getMyTeam() async {
    Response<dynamic> response = await TeamManager.getMyTeam();
    if (response.success && (response.object as List).isNotEmpty) {
      response.object.forEach((Team t) => {
            _myTeamOptions
                .add(new DropDownObject(value: t.id, text: t.teamName))
          });
    }
  }

  _loadMoreEvent() async {
    if (!_hasMoreResult) return;
    _hasMoreResult = false;

    Response<dynamic> response =
        await EventManager.getAllEventsPaged(_curPage, widget.perPage);
    if (response.success && (response.object as List).isNotEmpty) {
      List<EventListItem> toAdd = List();
      response.object
          .forEach((Event e) => {toAdd.add(new EventListItem.fromEvent(e))});

      setState(() {
        _events.addAll(toAdd);
      });
      _hasMoreResult = true;
    } else {
      _hasMoreResult = false;
    }
  }

  _handleLeave(int index) async {
    Response<dynamic> response =
        await EventManager.leaveEvent(_events[index].id, 0, currentUser.userId);

    if (response.success) {
      setState(() {
        _events[index].joined = false;
      });
    } else {
      await showCustomAlertDialog(context,
          title: R.strings.error,
          content: response.errorMessage,
          firstButtonText: R.strings.ok.toUpperCase(),
          firstButtonFunction: () => pop(context),
      );
    }
  }

  _handleJoinButton(dynamic index) async {
    if (_events[index].joined) {
      // join complex dialog
      // missing dropdown dialog
    } else {
      // confirm leave dialog
      await showCustomAlertDialog(
        context,
        title: "Confirmation",
        content: "Are you sure you want to leave this event?",
        firstButtonText: "LEAVE",
        firstButtonFunction: _handleLeave(index),
        secondButtonText: "Cancel",
        secondButtonFunction: () => pop(context),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(R.strings.events),
      ),
    );
  }
}
