import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/manager/user_manager.dart';
import 'package:usrun/widget/event_badge_list/event_badge_list.dart';
import 'package:usrun/widget/loading_dot.dart';
import 'package:usrun/widget/activity_timeline.dart';

import 'package:usrun/widget/photo_list.dart';

// Demo data
import 'package:usrun/demo_data.dart';

class ProfileActivity extends StatefulWidget {
  @override
  _ProfileActivityState createState() => _ProfileActivityState();
}

class _ProfileActivityState extends State<ProfileActivity> {
  bool _isLoading;
  bool _isKM;
  List _activityTimelineList;
  int _activityTimelineListOffset = 0;
  bool _allowLoadMore = true;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _isKM = true;
    _activityTimelineList = List();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _getProfileActivityData());
  }

  _getProfileActivityData() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
    }

    var futures = List<Future>();

    // Function: Get activityTimeline data
    futures.add(UserManager.getActivityTimelineList(
      R.constants.activityTimelineNumber,
      _activityTimelineListOffset,
    ));

    // Function: Get eventBadges data
    // TODO: Code here

    // Function: Get photos data
    // TODO: Code here

    Future.wait(futures).then((resultList) {
      if (!mounted) return;

      List<dynamic> activityTimelineResult = resultList[0];
      if (activityTimelineResult != null) {
        _activityTimelineListOffset += 1;
        _activityTimelineList.insertAll(
            _activityTimelineList.length, activityTimelineResult);
      }

      setState(() {
        _isLoading = !_isLoading;
      });
    });
  }

  _loadMoreActivityTimelineItems() async {
    await UserManager.getActivityTimelineList(
      R.constants.activityTimelineNumber,
      _activityTimelineListOffset,
    ).then((value) {
      if (value != null) {
        _activityTimelineListOffset += 1;
        _allowLoadMore = true;
        setState(() {
          _activityTimelineList.insertAll(_activityTimelineList.length, value);
        });
      } else {
        _allowLoadMore = false;
      }
    });
  }

  _changeKM() {
    // TODO: Implement function here
    setState(() {
      _isKM = !_isKM;
    });
  }

  void _pressEventBadge(data) {
    // TODO: Implement function here
    print("[EventBadgesWidget] This is pressed with data $data");
  }

  void _pressActivityFunction(actID) {
    // TODO: Implement function here
    print(
        "[ActivityTimelineWidget] 'Activity' icon of activity id '$actID' is pressed");
  }

  void _pressLoveFunction(actID) {
    // TODO: Implement function here
    print(
        "[ActivityTimelineWidget] 'Love' icon of activity id '$actID' is pressed");
  }

  void _pressCommentFunction(actID) {
    // TODO: Implement function here
    print(
        "[ActivityTimelineWidget] 'Comment' icon of activity id '$actID' is pressed");
  }

  void _pressShareFunction(actID) {
    // TODO: Implement function here
    print(
        "[ActivityTimelineWidget] 'Share' icon of activity id '$actID' is pressed");
  }

  void _pressInteractionFunction(actID) {
    // TODO: Implement function here
    print(
        "[ActivityTimelineWidget] 'Interaction' icon of activity id '$actID' is pressed");
  }

  @override
  Widget build(BuildContext context) {
    return (_isLoading
        ? LoadingIndicator()
        : Column(
            children: <Widget>[
              // Event Badges
              EventBadgeList(
                items: DemoData().eventBadgeList,
                labelTitle: R.strings.personalEventBadges,
                enableLabelShadow: true,
                enableScrollBackgroundColor: true,
                pressItemFunction: _pressEventBadge,
              ),
              SizedBox(
                height: R.appRatio.appSpacing20,
              ),
              // Photo
              PhotoList(
                items: DemoData().photoItemList,
                labelTitle: R.strings.personalPhotos,
                enableLabelShadow: true,
                enableScrollBackgroundColor: true,
              ),
              SizedBox(
                height: R.appRatio.appSpacing20,
              ),
              // Activity Timeline
              Container(
                padding: EdgeInsets.only(
                  left: R.appRatio.appSpacing15,
                  bottom: R.appRatio.appSpacing15,
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  R.strings.personalActivities +
                      ": ${_activityTimelineList.length}",
                  style: R.styles.shadowLabelStyle,
                ),
              ),
              ListView.builder(
                padding: EdgeInsets.all(0),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _activityTimelineList.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  dynamic item = _activityTimelineList[index];

                  if (index == _activityTimelineList.length - 1) {
                    return GestureDetector(
                      onVerticalDragUpdate: (details) {
                        if (details.delta.dy >= -10.0) return;
                        if (_allowLoadMore) {
                          _allowLoadMore = false;
                          _loadMoreActivityTimelineItems();
                        }
                      },
                      child: _renderActivityTimeline(item),
                    );
                  }

                  return _renderActivityTimeline(item);
                },
              ),
            ],
          ));
  }

  Widget _renderActivityTimeline(dynamic item) {
    return ActivityTimeline(
      activityID: item['activityID'],
      dateTime: item['dateTime'],
      title: item['title'],
      calories: item['calories'],
      distance: (_isKM ? item['distance'] : item['distance'] * 1000),
      isKM: _isKM,
      elevation: item['elevation'],
      pace: item['pace'],
      time: item['time'],
      isLoved: item['isLoved'],
      loveNumber: item['loveNumber'],
      enableScrollBackgroundColor: true,
      pressActivityFunction: this._pressActivityFunction,
      pressLoveFunction: this._pressLoveFunction,
      pressCommentFunction: this._pressCommentFunction,
      pressShareFunction: this._pressShareFunction,
      pressInteractionFunction: this._pressInteractionFunction,
    );
  }
}
