import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/define.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/manager/event_manager.dart';
import 'package:usrun/model/event.dart';
import 'package:usrun/model/response.dart';
import 'package:usrun/page/event/register_leave_event_util.dart';
import 'package:usrun/page/record/timer.dart';
import 'package:usrun/util/validator.dart';
import 'package:usrun/widget/custom_gradient_app_bar.dart';
import 'package:usrun/widget/event_list/event_info_line.dart';
import 'package:usrun/widget/input_field.dart';
import 'package:usrun/widget/loading_dot.dart';

class EventSearchPage extends StatefulWidget {
  @override
  _EventSearchPageState createState() => _EventSearchPageState();
}

class _EventSearchPageState extends State<EventSearchPage> {
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _textSearchController = TextEditingController();

  final StreamController _searchStream = StreamController<String>();
  final int _pageSize = 15;
  int _currentPage = 0;
  String _currentSearchKey = "";
  bool _allowLoadMore = true;

  bool _isLoading;
  List<Event> _originalList;

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
    _searchFunction("");
  }

  @override
  void dispose() async {
    _searchStream?.close();
    _timerService?.stop();
    super.dispose();
  }

  void _listenTextChanged() async {
    await for (String key in _searchStream.stream) {
      await _searchFunction(key);
    }
  }

  Future<List<Event>> _callSearchApi() async {
    List<Event> result = List();

    Response<dynamic> response = await EventManager.findEventByName(
        _currentSearchKey, _currentPage, _pageSize);

    if (response.success && (response.object as List).isNotEmpty) {
      result = response.object;
    }

    return result;
  }

  void _loadMoreData() async {
    if (!_allowLoadMore) return;

    List<Event> result = await _callSearchApi();

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

    List<Event> result = await _callSearchApi();

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

  Widget _buildEmptyList() {
    String systemNoti = R.strings.noResult;
    String systemNotiSub = R.strings.noResultSubtitle;

    return Center(
      child: Container(
        padding: EdgeInsets.only(
          left: R.appRatio.appSpacing25,
          right: R.appRatio.appSpacing25,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              systemNoti,
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: R.colors.contentText,
                fontSize: R.appRatio.appFontSize18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              systemNotiSub,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: R.colors.contentText,
                fontSize: R.appRatio.appFontSize14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderEventList() {
    if (checkListIsNullOrEmpty(_originalList)) {
      return _buildEmptyList();
    }

    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.all(0.0),
      itemCount: _originalList.length,
      itemBuilder: (context, index) {
        if (index == _originalList.length - 1) {
          _loadMoreData();
        }

        Event event = _originalList[index];
        bool isLastElement = index == _originalList.length - 1;
        bool enableActionButton = false;
        Function callback;

        if (event.status.index != EventStatus.Ended.index) {
          enableActionButton = true;
          if (!event.joined) {
            // Register function
            callback = () async {
              _searchFocusNode.unfocus();

              bool result = await RegisterLeaveEventUtil.handleRegisterAnEvent(
                context: context,
                eventName: _originalList[index].eventName,
                eventId: _originalList[index].eventId,
              );

              if (result != null && result) {
                if (!mounted) return;
                setState(() {
                  _originalList[index].joined = true;
                });
              }
            };
          } else {
            // Leave function
            callback = () async {
              _searchFocusNode.unfocus();

              bool result = await RegisterLeaveEventUtil.handleLeaveAnEvent(
                context: context,
                eventName: _originalList[index].eventName,
                eventId: _originalList[index].eventId,
              );

              if (result != null && result) {
                if (!mounted) return;
                setState(() {
                  _originalList[index].joined = false;
                });
              }
            };
          }
        }

        return Column(
          key: Key(event.eventId.toString()),
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            EventInfoLine(
              eventItem: event,
              enableActionButton: enableActionButton,
              registerCallback: callback,
              leaveCallback: callback,
              enableBoxShadow: false,
            ),
            (!isLastElement
                ? Divider(
                    color: R.colors.majorOrange,
                    thickness: 0.8,
                    height: 1,
                  )
                : Container()),
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
          autoFocus: true,
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
