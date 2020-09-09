import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/manager/event_manager.dart';
import 'package:usrun/manager/team_manager.dart';
import 'package:usrun/manager/user_manager.dart';
import 'package:usrun/model/event.dart';
import 'package:usrun/model/response.dart';
import 'package:usrun/model/team.dart';
import 'package:usrun/page/event/event_info.dart';
import 'package:usrun/page/team/team_info.dart';
import 'package:usrun/util/validator.dart';
import 'package:usrun/widget/event_list/event_list.dart';
import 'package:usrun/widget/follower_following_list/follower_following_list.dart';
import 'package:usrun/widget/loading_dot.dart';

// Demo data
import 'package:usrun/demo_data.dart';
import 'package:usrun/widget/team_list/team_item.dart';
import 'package:usrun/widget/team_list/team_list.dart';

class ProfileInfo extends StatefulWidget {
  final int userId;

  ProfileInfo({@required this.userId, Key key}) : super(key: key);

  @override
  ProfileInfoState createState() => ProfileInfoState();
}

class ProfileInfoState extends State<ProfileInfo> {
  bool _isLoading;
  int _followingNumber;
  int _followerNumber;
  List<TeamItem> _teamList;
  List<Event> _events;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _teamList = List();
    _events = List();
    _followingNumber = DemoData().ffItemList.length;
    _followerNumber = DemoData().ffItemList.length;
    WidgetsBinding.instance.addPostFrameCallback((_) => updateLoading());
    WidgetsBinding.instance.addPostFrameCallback((_) => loadUserTeams());
    WidgetsBinding.instance.addPostFrameCallback((_) => loadUserEvents());
  }

  void loadUserEvents() async {
    if (widget.userId == UserManager.currentUser.userId &&
        !checkListIsNullOrEmpty(EventManager.userEvents)) {
      _events = EventManager.userEvents;
      return;
    }

    Response<dynamic> events = await EventManager.getUserEvents(widget.userId);
    if (events.success && events.errorCode == -1) {
      _events = events.object;
    }
  }

  void loadUserTeams() async {
    Response<dynamic> response =
        await TeamManager.getJoinedTeamByUser(widget.userId);

    if (response.success && (response.object as List).isNotEmpty) {
      List<TeamItem> toAdd = List();

      response.object.forEach((Team t) => {toAdd.add(new TeamItem.from(t))});

      if (mounted) {
        setState(() {
          _teamList.addAll(toAdd);
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _teamList = List();
        });
      }
    }
  }

  void setLoading() {
    _isLoading = true;
  }

  void updateLoading() {
    Future.delayed(Duration(milliseconds: 1000), () {
      if (!mounted) return;
      setState(() {
        _isLoading = !_isLoading;
      });
    });
  }

  void _pressFollowFunction(data) {
    // TODO: Implement function here
    print("[FFWidget] Follow this athlete with data $data");
  }

  void _pressUnFollowFunction(data) {
    // TODO: Implement function here
    print("[FFWidget] Unfollow this athlete with data $data");
  }

  void _pressProfileFunction(userCode) {
    // TODO: Implement function here
    print("[FFWidget] Direct to this athlete profile with user code $userCode");
  }

  void _pressEventItemFunction(data) {
    pushPage(
      context,
      EventInfoPage(
        eventId: data.eventId,
        joined: data.joined ?? false,
      ),
    );
  }

  void _pressTeamItemFunction(data) {
    pushPage(
      context,
      TeamInfoPage(
        teamId: data.teamId,
      ),
    );
  }

  void _pressTeamPlanItemFunction(data) {
    // TODO: Implement function here
    print("[TeamPlanWidget] Press team plan with data $data");
  }

  @override
  Widget build(BuildContext context) {
    return (_isLoading
        ? LoadingIndicator()
        : Column(
            children: <Widget>[
              // Following
//              FollowerFollowingList(
//                items: DemoData().ffItemList,
//                enableFFButton: true,
//                labelTitle: R.strings.personalFollowing,
//                subTitle: "$_followingNumber " + R.strings.personalFollowingNotice,
//                enableSubtitleShadow: true,
//                enableScrollBackgroundColor: true,
//                isFollowingList: true,
//                pressFollowFunction: _pressFollowFunction,
//                pressUnfollowFunction: _pressUnFollowFunction,
//                pressProfileFunction: _pressProfileFunction,
//              ),
//              SizedBox(
//                height: R.appRatio.appSpacing20,
//              ),
//              // Followers
//              FollowerFollowingList(
//                items: DemoData().ffItemList,
//                enableFFButton: true,
//                labelTitle: R.strings.personalFollowers,
//                subTitle: "$_followerNumber " + R.strings.personalFollowersNotice,
//                enableSubtitleShadow: true,
//                enableScrollBackgroundColor: true,
//                isFollowingList: false,
//                pressFollowFunction: _pressFollowFunction,
//                pressUnfollowFunction: _pressUnFollowFunction,
//                pressProfileFunction: _pressProfileFunction,
//              ),
//              SizedBox(
//                height: R.appRatio.appSpacing20,
//              ),
              // Events
              EventList(
                items: _events,
                labelTitle: R.strings.personalEvents,
                enableScrollBackgroundColor: true,
                pressItemFunction: _pressEventItemFunction,
              ),
              SizedBox(
                height: R.appRatio.appSpacing20,
              ),
              // Teams
              TeamList(
                items: _teamList,
                labelTitle: R.strings.personalTeams,
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
                labelTitle: R.strings.personalTeamPlans,
                enableScrollBackgroundColor: true,
                pressItemFunction: _pressTeamPlanItemFunction,
              ),
              */
            ],
          ));
  }
}
