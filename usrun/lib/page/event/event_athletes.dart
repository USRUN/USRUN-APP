import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/define.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/manager/event_manager.dart';
import 'package:usrun/manager/user_manager.dart';
import 'package:usrun/model/event.dart';
import 'package:usrun/model/event_athlete.dart';
import 'package:usrun/model/response.dart';
import 'package:usrun/model/team.dart';
import 'package:usrun/model/user.dart';
import 'package:usrun/page/event/register_leave_event_util.dart';
import 'package:usrun/page/profile/profile_page.dart';
import 'package:usrun/page/record/timer.dart';
import 'package:usrun/page/team/team_info.dart';
import 'package:usrun/page/team/team_search_item.dart';
import 'package:usrun/util/validator.dart';
import 'package:usrun/widget/avatar_view.dart';
import 'package:usrun/widget/custom_cell.dart';
import 'package:usrun/widget/custom_gradient_app_bar.dart';
import 'package:usrun/widget/event_list/event_info_line.dart';
import 'package:usrun/widget/input_field.dart';
import 'package:usrun/widget/loading_dot.dart';

class EventAthleteSearchPage extends StatefulWidget {
  final int eventId;

  EventAthleteSearchPage({@required this.eventId});

  @override
  _EventAthleteSearchPageState createState() => _EventAthleteSearchPageState();
}

class _EventAthleteSearchPageState extends State<EventAthleteSearchPage> {
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _textSearchController = TextEditingController();

  final StreamController _searchStream = StreamController<String>();
  final int _pageSize = 15;
  int _currentPage = 1;
  String _currentSearchKey = "";
  bool _allowLoadMore = true;

  bool _isLoading;
  List<EventAthlete> _originalList;

  final int _interval = 1;
  TimerService _timerService;

  @override
  void initState() {
    super.initState();
    _timerService = TimerService(0, (int second) {
      _timerService.stop();
      _searchStream.sink.add(_textSearchController.text);
    });

    _isLoading = false;
    _originalList = List();
    _listenTextChanged();
    _delayRequestFocus();
    _searchFunction("");
  }

  @override
  void dispose() async {
    _searchStream?.close();
    _timerService?.stop();
    super.dispose();
  }

  void _delayRequestFocus() {
    Future.delayed(Duration(milliseconds: 400), () {
      _searchFocusNode.requestFocus();
    });
  }

  void _listenTextChanged() async {
    await for (String key in _searchStream.stream) {
      await _searchFunction(key);
    }
  }

  Future<List<EventAthlete>> _callSearchApi() async {
    List<EventAthlete> result = List();

    Response<dynamic> response = await EventManager.getEventAthlete(
        widget.eventId, _currentSearchKey, _currentPage, _pageSize);

    if (response.success && (response.object as List).isNotEmpty) {
      result = response.object;
    }

    return result;
  }

  void _loadMoreData() async {
    if (!_allowLoadMore) return;

    List<EventAthlete> result = await _callSearchApi();

    if (result == null || result.length == 0) {
      _allowLoadMore = false;
    } else {
      if (!mounted) return;
      setState(() {
        _currentPage += 1;
        _originalList.insertAll(
          _originalList.length,
          result,
        );
      });
    }
  }

  Future<void> _searchFunction(String key) async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _originalList = List();
    });

    _currentSearchKey = key;
    if (_currentSearchKey != null) {
      _currentSearchKey = _currentSearchKey.trim();
    }
    _currentPage = 1;
    _allowLoadMore = true;

    List<EventAthlete> result = await _callSearchApi();

    if (result == null || result.length == 0) {
      _allowLoadMore = false;
    }

    if (!mounted) return;
    setState(() {
      _isLoading = false;
      if (result != null && result.length != 0) {
        _currentPage += 1;
        _originalList.addAll(result);
      }
    });
  }

  void _onSearchTextChanged(data) async {
    if (!mounted) return;
    _timerService.stop();
    _timerService.start(interval: _interval);
  }

  void _onSubmittedFunction(data) {
    if (!mounted) return;
    String key = data.toString();
    if (key.length == 0 || key.compareTo(_currentSearchKey) == 0) {
      return;
    }
    _timerService.stop();
    _searchStream.sink.add(key);
  }

  void _delayPop() {
    if (!_searchFocusNode.hasFocus) {
      pop(context);
    }

    _searchFocusNode.unfocus();
    Future.delayed(Duration(milliseconds: 200), () {
      pop(context);
    });
  }

  Widget _renderEventList() {
    if (checkListIsNullOrEmpty(_originalList)) {
      return Container();
    }

    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.all(0.0),
      itemCount: _originalList.length,
      itemBuilder: (context, index) {
        if (index == _originalList.length - 1) {
          _loadMoreData();
        }

        EventAthlete athlete = _originalList[index];
        bool isLastElement = index == _originalList.length - 1;

        return Column(
          key: Key(athlete.userId.toString()),
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomCell(
              padding: EdgeInsets.only(
                top: R.appRatio.appSpacing15 - 2,
                bottom: R.appRatio.appSpacing15 - 2,
                left: R.appRatio.appSpacing15,
                right: R.appRatio.appSpacing15,
              ),
              avatarView: AvatarView(
                avatarImageURL: athlete.avatar,
                avatarImageSize: R.appRatio.appWidth60,
                avatarBoxBorder: Border.all(
                  width: 1,
                  color: R.colors.majorOrange,
                ),
              ),
              // Content
              title: athlete.name,
              titleStyle: TextStyle(
                fontSize: R.appRatio.appFontSize16,
                color: R.colors.contentText,
                fontWeight: FontWeight.w500,
              ),
              enableAddedContent: false,
              subTitle: R.strings.provinces[athlete.province],
              enableSplashColor: false,
              subTitleStyle: TextStyle(
                fontSize: R.appRatio.appFontSize14,
                color: R.colors.contentText,
              ),
              pressInfo: () async {
                Response<dynamic> response = await UserManager.getUserInfo(athlete.userId);
                User user = response.object;

                pushPage(context, ProfilePage(userInfo: user,enableAppBar: true));
              },
              centerVerticalSuffix: true,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildElement = Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: R.colors.appBackground,
      appBar: CustomGradientAppBar(
        leadingFunction: _delayPop,
        titleWidget: InputField(
          controller: _textSearchController,
          focusNode: _searchFocusNode,
          cursorColor: Colors.white,
          hintText: R.strings.search,
          hintStyle: TextStyle(
            fontSize: R.appRatio.appFontSize18,
            color: Colors.white.withOpacity(0.5),
          ),
          contentStyle: TextStyle(
            color: Colors.white,
            fontSize: R.appRatio.appFontSize18,
            fontWeight: FontWeight.w500,
          ),
          bottomUnderlineColor: Colors.white,
          enableBottomUnderline: true,
          isDense: true,
          textInputAction: TextInputAction.search,
          onSubmittedFunction: _onSubmittedFunction,
          onChangedFunction: _onSearchTextChanged,
        ),
      ),
      body: (_isLoading ? LoadingIndicator() : _renderEventList()),
    );

    return NotificationListener<OverscrollIndicatorNotification>(
      child: _buildElement,
      onNotification: (overScroll) {
        overScroll.disallowGlow();
        return false;
      },
    );
  }
}
