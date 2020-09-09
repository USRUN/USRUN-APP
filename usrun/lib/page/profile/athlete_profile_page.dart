import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/define.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/manager/event_manager.dart';
import 'package:usrun/manager/data_manager.dart';
import 'package:usrun/widget/activity_timeline.dart';
import 'package:usrun/widget/avatar_view.dart';
import 'package:usrun/widget/custom_gradient_app_bar.dart';
import 'package:usrun/widget/event_badge_list/event_badge_list.dart';
import 'package:usrun/widget/event_list/event_list.dart';
import 'package:usrun/widget/follower_following_list/follower_following_list.dart';
import 'package:usrun/widget/loading_dot.dart';
import 'package:usrun/widget/photo_list/photo_list.dart';
import 'package:usrun/widget/stats_section/stats_section.dart';
import 'package:usrun/widget/team_list/team_list.dart';
import 'package:usrun/widget/ui_button.dart';

// Demo data
import 'package:usrun/demo_data.dart';

class AthleteProfilePage extends StatefulWidget {
  @override
  _AthleteProfilePageState createState() => _AthleteProfilePageState();
}

class _AthleteProfilePageState extends State<AthleteProfilePage> {
  String _avatarImageURL = R.images.avatarQuocTK;
  String _supportImageURL = R.images.avatarHuyTA;
  String _fullName = "Quốc Trần Kiến";
  String _userCode = "USR9381852";
  String _profileDescription =
      "I’m Student\n21 years old | Male | 172 cm | 52 kg\nViet Nam | Ho Chi Minh city | Binh Tan\nAlways smile <3\nAlways get high!!! YOLO :D";

  bool _isLoading;
  bool _enableUserCode;
  bool _enableProfileDescription;
  bool _enableFFButton;
  bool _isFollowingButton;
  RunningUnit _runningUnit;
  int _activityNumber;
  List _activityTimelineList;
  int _followingNumber;
  int _followerNumber;

  @override
  void initState() {
    _isLoading = true;
    _enableUserCode = true;
    _enableProfileDescription = true;
    _enableFFButton = true;
    _isFollowingButton = false;
    _runningUnit = DataManager.getUserRunningUnit();
    _activityNumber = DemoData().activityTimelineList.length;
    _activityTimelineList = DemoData().activityTimelineList;
    _followingNumber = DemoData().ffItemList.length;
    _followerNumber = DemoData().ffItemList.length;
    super.initState();

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

  void _changeUserCodeState() {
    if (!mounted) return;
    setState(() {
      _enableUserCode = !_enableUserCode;
    });
  }

  void _changeProfileDescriptionState() {
    if (!mounted) return;
    setState(() {
      _enableProfileDescription = !_enableProfileDescription;
    });
  }

  void _changeFFButtonState() {
    if (!mounted) return;
    setState(() {
      _enableFFButton = !_enableFFButton;
    });
  }

  void _changeFFButtonType() {
    if (!mounted) return;
    setState(() {
      _isFollowingButton = !_isFollowingButton;
    });
  }

  void _pressProfileFunction(data) {
    // TODO: Implement function here
    print("[FFWidget] Direct to this athlete profile with data $data");
  }

  void _pressEventItemFunction(data) {
    // TODO: Implement function here
    print("[EventWidget] Press event with data $data");
  }

  void _pressTeamItemFunction(data) {
    // TODO: Implement function here
    print("[TeamWidget] Press team with data $data");
  }

  void _pressTeamPlanItemFunction(data) {
    // TODO: Implement function here
    print("[TeamPlanWidget] Press team plan with data $data");
  }

  void _pressFFButton(String userCode) {
    // TODO: Implement function here
    print(
        "This Following & Followers (FF) button is pressed with the type ${_isFollowingButton ? 'Following' : 'Followers'} and athlete has user code with id $userCode");
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

//  _changeKM() {
//    // TODO: Implement function here
//    setState(() {
//      _isKM = !_isKM;
//    });
//  }

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
    Widget _buildElement = Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: R.colors.appBackground,
      appBar: CustomGradientAppBar(title: R.strings.athleteProfile),
      body: (_isLoading
          ? LoadingIndicator()
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: R.appRatio.appSpacing25,
                    ),
                    // Avatar view
                    AvatarView(
                      avatarImageURL: _avatarImageURL,
                      avatarImageSize: R.appRatio.appAvatarSize130,
                      supportImageURL: _supportImageURL,
                      avatarBoxBorder: Border.all(
                        color: R.colors.majorOrange,
                        width: 2,
                      ),
                    ),
                    SizedBox(
                      height: R.appRatio.appSpacing20,
                    ),
                    // Full name
                    Text(
                      _fullName,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: R.colors.contentText,
                        fontSize: R.appRatio.appFontSize20,
                      ),
                    ),
                    // User code
                    (_enableUserCode
                        ? Container(
                            margin: EdgeInsets.only(
                              top: R.appRatio.appSpacing5,
                            ),
                            child: Text(
                              _userCode,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: R.colors.contentText,
                                fontSize: R.appRatio.appFontSize18,
                              ),
                            ),
                          )
                        : Container()),
                    SizedBox(
                      height: R.appRatio.appSpacing15,
                    ),
                    // Profile description
                    (_enableProfileDescription
                        ? Center(
                            child: Container(
                              width: R.appRatio.appWidth300,
                              padding: EdgeInsets.only(
                                top: R.appRatio.appSpacing15,
                                bottom: R.appRatio.appSpacing20,
                              ),
                              decoration: BoxDecoration(
                                color: R.colors.appBackground,
                                border: Border(
                                  top: BorderSide(
                                    width: 1,
                                    color: R.colors.majorOrange,
                                  ),
                                  bottom: BorderSide(
                                    width: 1,
                                    color: R.colors.majorOrange,
                                  ),
                                ),
                              ),
                              child: Text(
                                _profileDescription,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    wordSpacing: 2.0,
                                    height: 1.5,
                                    color: R.colors.contentText,
                                    fontSize: R.appRatio.appFontSize14),
                              ),
                            ),
                          )
                        : Container()),
                    (_enableProfileDescription
                        ? SizedBox(
                            height: R.appRatio.appSpacing20,
                          )
                        : Container()),
                    (_enableFFButton
                        ? Center(
                            child: UIButton(
                              text: (_isFollowingButton
                                  ? R.strings.unFollow
                                  : R.strings.follow),
                              textColor: (_isFollowingButton
                                  ? R.colors.grayButtonColor
                                  : R.colors.majorOrange),
                              textSize: R.appRatio.appFontSize12,
                              radius: 0,
                              width: R.appRatio.appWidth80,
                              height: R.appRatio.appHeight30,
                              enableShadow: false,
                              border: Border.all(
                                width: 1,
                                color: (_isFollowingButton
                                    ? R.colors.grayButtonColor
                                    : R.colors.majorOrange),
                              ),
                              onTap: () {
                                if (this._pressFFButton != null) {
                                  this._pressFFButton(_userCode);
                                }
                              },
                            ),
                          )
                        : Container()),
                    SizedBox(
                      height: R.appRatio.appSpacing25,
                    ),
                    // Event Badges
                    EventBadgeList(
                      items: DemoData().eventBadgeList,
                      labelTitle: R.strings.athleteBadges,
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
                      labelTitle: R.strings.athletePhotos,
                      enableLabelShadow: true,
                      enableScrollBackgroundColor: true,
                    ),
                    SizedBox(
                      height: R.appRatio.appSpacing20,
                    ),
                    // Following
                    FollowerFollowingList(
                      items: DemoData().ffItemList,
                      enableFFButton: false,
                      labelTitle: R.strings.athleteFollowing,
                      enableLabelShadow: true,
                      subTitle: "$_followingNumber " +
                          R.strings.athleteFollowingNotice,
                      enableSubtitleShadow: true,
                      enableScrollBackgroundColor: true,
                      isFollowingList: true,
                      pressProfileFunction: _pressProfileFunction,
                    ),
                    SizedBox(
                      height: R.appRatio.appSpacing20,
                    ),
                    // Followers
                    FollowerFollowingList(
                      items: DemoData().ffItemList,
                      enableFFButton: false,
                      labelTitle: R.strings.athleteFollowers,
                      enableLabelShadow: true,
                      subTitle: "$_followerNumber " +
                          R.strings.athleteFollowersNotice,
                      enableSubtitleShadow: true,
                      enableScrollBackgroundColor: true,
                      isFollowingList: false,
                      pressProfileFunction: _pressProfileFunction,
                    ),
                    SizedBox(
                      height: R.appRatio.appSpacing20,
                    ),
                    // Events
                    EventList(
                      items: EventManager.userEvents,
                      labelTitle: R.strings.athleteEvents,
                      enableLabelShadow: true,
                      enableScrollBackgroundColor: true,
                      pressItemFunction: _pressEventItemFunction,
                    ),
                    SizedBox(
                      height: R.appRatio.appSpacing20,
                    ),
                    // Teams
                    TeamList(
                      items: DemoData().teamList,
                      labelTitle: R.strings.athleteTeams,
                      enableLabelShadow: true,
                      enableScrollBackgroundColor: true,
                      pressItemFunction: _pressTeamItemFunction,
                    ),
                    SizedBox(
                      height: R.appRatio.appSpacing20,
                    ),
                    // Team plans
                    /*
                    =======
                    UNUSED
                    =======
                    TeamPlanList(
                      items: DemoData().teamPlanList,
                      labelTitle: R.strings.athleteTeamPlans,
                      enableLabelShadow: true,
                      enableScrollBackgroundColor: true,
                      pressItemFunction: _pressTeamPlanItemFunction,
                    ),
                    SizedBox(
                      height: R.appRatio.appSpacing20,
                    ),
                    */
                    // Statistics in this year
                    Container(
                      padding: EdgeInsets.only(
                        left: R.appRatio.appSpacing15,
                      ),
                      child: StatsSection(
                        items: DemoData().statsListStyle01,
                        labelTitle: R.strings.athleteStatsInCurrentYear,
                        enableLabelShadow: true,
                      ),
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
                        R.strings.athleteActivities + ": $_activityNumber",
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
                          distance: switchDistanceUnit(item['distance']),
                          runningUnit: _runningUnit,
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
                          pressInteractionFunction:
                              this._pressInteractionFunction,
                        );
                      },
                    ),
                  ],
                ),
              ),
            )),
    );

    return NotificationListener<OverscrollIndicatorNotification>(
        child: _buildElement,
        onNotification: (overScroll) {
          overScroll.disallowGlow();
          return false;
        });
  }
}
