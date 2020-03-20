import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/widget/loading_dot.dart';
import 'package:usrun/widget/activity_timeline.dart';
import 'package:usrun/widget/event_badge_list.dart';
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
  int _activityNumber;
  List _activityTimelineList;

  @override
  void initState() {
    _isLoading = true;
    _isKM = true;
    _activityNumber = DemoData().activityTimelineList.length;
    _activityTimelineList = DemoData().activityTimelineList;
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateLoading());
  }

  void _updateLoading() {
    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        _isLoading = !_isLoading;
      });
    });
  }

  _addNewActivityTimeline() {
    // TODO: Implement function here

    dynamic newData = {
      "activityID": "-1",
      "dateTime": "April 04, 2020",
      "title": "Nothing special",
      "calories": "123",
      "distance": 21.24,
      "elevation": "75m",
      "pace": "8:45/km",
      "time": "2:25:47",
      "isLoved": false,
      "loveNumber": 758241,
    };

    setState(() {
      _activityTimelineList.insert(0, newData);
    });

    print("[System] Add new activity timeline successfully!");
  }

  _updateActivityNumber(int actNumber) {
    // TODO: Implement function here
    setState(() {
      _activityNumber = actNumber;
    });
  }

  _changeKM() {
    // TODO: Implement function here
    setState(() {
      _isKM = !_isKM;
    });
  }

  void _pressEventBadge(eventID) {
    // TODO: Implement function here
    print("[EventBadgesWidget] This is pressed by event id $eventID");
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
        ? LoadingDotStyle02()
        : Column(
            children: <Widget>[
              // Event Badges
              EventBadgeList(
                items: DemoData().eventBadgeList,
                labelTitle: "Event Badges",
                enableLabelShadow: true,
                enableScrollBackgroundColor: true,
                pressItemFuction: _pressEventBadge,
              ),
              SizedBox(
                height: R.appRatio.appSpacing20,
              ),
              // Photo
              PhotoList(
                items: DemoData().photoItemList,
                labelTitle: "Photos",
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
                  "Activities: $_activityNumber",
                  style: R.styles.shadowLabelStyle,
                ),
              ),
              ListView.builder(
                padding: EdgeInsets.all(0),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _activityNumber,
                itemBuilder: (BuildContext ctxt, int index) {
                  dynamic item = _activityTimelineList[index];

                  return ActivityTimeline(
                    activityID: item['activityID'],
                    dateTime: item['dateTime'],
                    title: item['title'],
                    calories: item['calories'],
                    distance:
                        (_isKM ? item['distance'] : item['distance'] * 1000),
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
                },
              ),
            ],
          ));
  }
}
