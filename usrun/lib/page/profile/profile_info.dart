import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/manager/event_manager.dart';
import 'package:usrun/widget/event_list/event_list.dart';
import 'package:usrun/widget/follower_following_list/follower_following_list.dart';
import 'package:usrun/widget/loading_dot.dart';

// Demo data
import 'package:usrun/demo_data.dart';
import 'package:usrun/widget/team_list/team_list.dart';

class ProfileInfo extends StatefulWidget {
  @override
  _ProfileInfoState createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  bool _isLoading;
  int _followingNumber;
  int _followerNumber;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _followingNumber = DemoData().ffItemList.length;
    _followerNumber = DemoData().ffItemList.length;
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
//                enableLabelShadow: true,
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
//                enableLabelShadow: true,
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
                items: EventManager.userEvents,
                labelTitle: R.strings.personalEvents,
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
                labelTitle: R.strings.personalTeams,
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
                labelTitle: R.strings.personalTeamPlans,
                enableLabelShadow: true,
                enableScrollBackgroundColor: true,
                pressItemFunction: _pressTeamPlanItemFunction,
              ),
              */
            ],
          ));
  }
}
