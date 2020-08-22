import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/manager/team_manager.dart';
import 'package:usrun/model/response.dart';
import 'package:usrun/page/team/team_activity_item.dart';
import 'package:usrun/widget/activity_timeline.dart';
import 'package:usrun/widget/custom_gradient_app_bar.dart';
import 'package:usrun/widget/loading_dot.dart';

class TeamActivityPage extends StatefulWidget {
  final int perPage = 10;
  final int teamId;
  final int totalActivity;

  TeamActivityPage({@required this.teamId, @required this.totalActivity});

  @override
  _TeamActivityPageState createState() => _TeamActivityPageState();
}

class _TeamActivityPageState extends State<TeamActivityPage> {
  bool _isLoading;
  bool _isKM;
  List _activityTimelineList;
  List _photos;
  bool _remainingResults;
  int _curPage;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _isKM = true;
    _curPage = 0;
    _remainingResults = true;

    _activityTimelineList = List();
    _photos = List();

    WidgetsBinding.instance
        .addPostFrameCallback((_) => getProfileActivityData());
  }

  getProfileActivityData() async {
    if (!_isLoading) {
      setState(
        () {
          _isLoading = true;
        },
      );
    }

    if (!_remainingResults) return;
    _remainingResults = false;

    Response<dynamic> response = await TeamManager.getTeamActivityByTeamId(
        widget.teamId, _curPage, widget.perPage);

    if (response.success && (response.object as List).isNotEmpty) {
      List<TeamActivityItem> toAdd = response.object;
      List newPhotos = toAdd.map((e) => e.photos).toList();
      setState(() {
        _photos.addAll(newPhotos);
        _activityTimelineList.addAll(toAdd);
        _curPage += 1;
        _remainingResults = true;
      });
    }

    setState(
      () {
        _isLoading = !_isLoading;
      },
    );
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
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: R.colors.appBackground,
        appBar: CustomGradientAppBar(title: R.strings.activities),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
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
                R.strings.personalActivities + ": ${widget.totalActivity}",
                style: R.styles.shadowLabelStyle,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: (_isLoading
                    ? Container(
                        padding: EdgeInsets.only(
                          top: R.appRatio.appSpacing15,
                        ),
                        child: LoadingIndicator(),
                      )
                    : _renderList()),
              ),
            ),
          ],
        ));
  }

  Widget _renderList() {
    return Container(
      padding: EdgeInsets.only(
        left: R.appRatio.appSpacing10,
        right: R.appRatio.appSpacing10,
      ),
      child: AnimationLimiter(
        child: ListView.builder(
          padding: EdgeInsets.all(0),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: _activityTimelineList.length,
          itemBuilder: (BuildContext ctxt, int index) {
            dynamic item = _activityTimelineList[index];

            if (index == _activityTimelineList.length - 1) {
              return GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy >= -10.0) return;
                  getProfileActivityData();
                },
                child: _renderActivityTimeline(item),
              );
            }
            return _renderActivityTimeline(item);
          },
        ),
      ),
    );
  }

  Widget _renderActivityTimeline(TeamActivityItem item) {
    return ActivityTimeline(
      activityID: customToString(item.userActivityId),
      dateTime: DateFormat("dd/mm/yyyy hh:mm:ss").format(item.createTime),
      title: item.title,
      calories: customToString(item.calories),
      distance:
          (_isKM ? item.totalDistance.toDouble() : (item.totalDistance * 1000)),
      isKM: _isKM,
      elevation: customToString(item.elevGain),
      pace: customToString(item.avgPace),
      time: item.totalTime.toString(),
      isLoved: false,
      loveNumber: item.totalLove,
      enableScrollBackgroundColor: true,
      pressActivityFunction: this._pressActivityFunction,
      pressLoveFunction: this._pressLoveFunction,
      pressCommentFunction: this._pressCommentFunction,
      pressShareFunction: this._pressShareFunction,
      pressInteractionFunction: this._pressInteractionFunction,
    );
  }

  String customToString(dynamic input) {
    if (input == -1 || input == "") {
      return "N/A";
    }
    return input.toString();
  }
}
