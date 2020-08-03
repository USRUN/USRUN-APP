import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/model/user_activity.dart';
import 'package:usrun/widget/custom_gradient_app_bar.dart';
import 'package:usrun/widget/feed/full_user_activity_item.dart';

class UserActivityPage extends StatefulWidget {
  final UserActivity userActivity;

  UserActivityPage({
    @required this.userActivity,
  });

  @override
  _UserActivityPageState createState() => _UserActivityPageState();
}

class _UserActivityPageState extends State<UserActivityPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  UserActivity _userActivity;

  @override
  void initState() {
    super.initState();
    _userActivity = widget.userActivity;
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _reLoadData() async {
    // TODO: Reload user activity info
    print("Reload user activity info");

    _refreshController.refreshCompleted();
  }

  Widget _renderBodyContent() {
    return SingleChildScrollView(
      child: FullUserActivityItem(
        userActivity: _userActivity,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget smartRefresher = SmartRefresher(
      enablePullUp: false,
      controller: _refreshController,
      child: _renderBodyContent(),
      physics: BouncingScrollPhysics(),
      footer: null,
      onRefresh: () => _reLoadData(),
      onLoading: () async {
        await Future.delayed(Duration(milliseconds: 200));
      },
    );

    Widget refreshConfigs = RefreshConfiguration(
      child: smartRefresher,
      headerBuilder: () => WaterDropMaterialHeader(
        backgroundColor: R.colors.majorOrange,
      ),
      footerBuilder: null,
      shouldFooterFollowWhenNotFull: (state) {
        return false;
      },
      hideFooterWhenNotFull: true,
    );

    Widget _buildElement = Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: R.colors.appBackground,
      appBar: CustomGradientAppBar(
        title: R.strings.activity,
      ),
      body: refreshConfigs,
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
