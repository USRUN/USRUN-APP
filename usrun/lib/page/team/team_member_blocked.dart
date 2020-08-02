import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/define.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/manager/team_manager.dart';
import 'package:usrun/model/response.dart';
import 'package:usrun/model/user.dart';
import 'package:usrun/util/team_member_util.dart';
import 'package:usrun/util/validator.dart';
import 'package:usrun/widget/avatar_view.dart';
import 'package:usrun/widget/custom_cell.dart';
import 'package:usrun/widget/custom_dialog/custom_alert_dialog.dart';

class BlockedMemberPage extends StatefulWidget {
  final int teamId;
  final TeamMemberType teamMemberType;
  final int resultPerPage = 10;

  BlockedMemberPage({@required this.teamId, @required this.teamMemberType});

  @override
  _BlockedMemberPageState createState() => _BlockedMemberPageState();
}

class _BlockedMemberPageState extends State<BlockedMemberPage>
    with SingleTickerProviderStateMixin {
  List<User> items = List();
  int _curPage;
  bool _remainingResults;
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  @override
  void initState() {
    super.initState();

    _curPage = 1;
    _remainingResults = true;
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void loadMoreData() async {
    if (!_remainingResults) {
      _refreshController.loadNoData();
      return;
    }
    if (!_remainingResults) return;
    _remainingResults = false;

    Response<dynamic> response = await TeamManager.getTeamMemberByType(
        widget.teamId,
        TeamMemberType.Blocked.index,
        _curPage,
        widget.resultPerPage);

    if (response.success && (response.object as List).isNotEmpty) {
      List<User> toAdd = response.object;

      if (!mounted) return;
      setState(
        () {
          items.addAll(toAdd);
          _remainingResults = true;
          _curPage += 1;
          _refreshController.loadComplete();
        },
      );
    }

    _refreshController.loadNoData();
  }

  _reloadItems() {
    items = List();
    _curPage = 1;
    _remainingResults = true;
    loadMoreData();
    _refreshController.refreshCompleted();
  }

  _pressAvatar(index) {
    // TODO: Implement function here
    print("Pressing avatar image");
  }

  _pressUserInfo(index) {
    // TODO: Implement function here
    print("Pressing info");
  }

  _releaseFromBlock(index) {
    changeMemberRole(index, TeamMemberType.Pending.index);
  }

  void changeMemberRole(int index, int newMemberType) async {
    if (!mounted) return;

    Response<dynamic> response = await TeamManager.updateTeamMemberRole(
        widget.teamId, items[index].userId, newMemberType);
    if (response.success) {
      setState(() {
        _reloadItems();
      });
    } else {
      showCustomAlertDialog(
        context,
        title: R.strings.notice,
        content: response.errorMessage,
        firstButtonText: R.strings.ok.toUpperCase(),
        firstButtonFunction: () => pop(this.context),
      );
    }
  }

  Widget _buildEmptyList() {
    String emptyList;
    String emptyListSubtitle;

    if (TeamMemberUtil.authorizeHigherLevel(
        TeamMemberType.Member, widget.teamMemberType)) {
      emptyList = R.strings.noResult;
      emptyListSubtitle = R.strings.noResultSubtitle;
    } else {
      emptyList = R.strings.memberOnly;
      emptyListSubtitle = R.strings.memberOnlySubtitle;
    }

    return Center(
        child: RefreshConfiguration(
      maxOverScrollExtent: 50,
      headerTriggerDistance: 50,
      child: SmartRefresher(
        enablePullDown: true,
        controller: _refreshController,
        onRefresh: _reloadItems,
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
                emptyList,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: R.colors.contentText,
                  fontSize: R.appRatio.appFontSize18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                emptyListSubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: R.colors.contentText,
                  fontSize: R.appRatio.appFontSize14,
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (checkListIsNullOrEmpty(items)) {
      return _buildEmptyList();
    }

    return AnimationLimiter(
      child: RefreshConfiguration(
        maxOverScrollExtent: 50,
        headerTriggerDistance: 50,
        child: SmartRefresher(
          enablePullDown: true,
          controller: _refreshController,
          onRefresh: _reloadItems,
          enablePullUp: true,
          onLoading: loadMoreData,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 400),
                child: SlideAnimation(
                  verticalOffset: 100.0,
                  child: FadeInAnimation(
                    child: Container(
                      padding: EdgeInsets.only(
                        top: (index == 0 ? R.appRatio.appSpacing15 : 0),
                        bottom: R.appRatio.appSpacing15,
                        left: R.appRatio.appSpacing15,
                        right: R.appRatio.appSpacing15,
                      ),
                      child: _renderCustomCell(index),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _renderCustomCell(int index) {
    if (checkListIsNullOrEmpty(items)) return Container();
    String avatarImageURL = items[index].avatar;
    String name = items[index].name;

    return CustomCell(
      avatarView: AvatarView(
        avatarImageURL: avatarImageURL,
        avatarImageSize: R.appRatio.appWidth60,
        avatarBoxBorder: Border.all(
          width: 1,
          color: R.colors.majorOrange,
        ),
        pressAvatarImage: () {
          _pressAvatar(index);
        },
      ),
      // Content
      title: name,
      titleStyle: TextStyle(
        fontSize: R.appRatio.appFontSize16,
        color: R.colors.contentText,
        fontWeight: FontWeight.w500,
      ),
      enableAddedContent: false,
      pressInfo: () {
        _pressUserInfo(index);
      },
      centerVerticalSuffix: true,
      enableCloseButton: true,
      pressCloseButton: () {
        _releaseFromBlock(index);
      },
    );
  }
}
