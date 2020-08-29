import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/define.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/manager/team_manager.dart';
import 'package:usrun/manager/user_manager.dart';
import 'package:usrun/model/response.dart';
import 'package:usrun/model/user.dart';
import 'package:usrun/page/profile/profile_page.dart';
import 'package:usrun/util/team_member_util.dart';
import 'package:usrun/util/validator.dart';
import 'package:usrun/widget/avatar_view.dart';
import 'package:usrun/widget/custom_cell.dart';
import 'package:usrun/widget/custom_dialog/custom_alert_dialog.dart';
import 'package:usrun/widget/custom_popup_menu/custom_popup_item.dart';
import 'package:usrun/widget/custom_popup_menu/custom_popup_menu.dart';
import 'package:usrun/widget/loading_dot.dart';

class AllMemberPage extends StatefulWidget {
  static final popUpMenu = [
    PopupItem(
      iconURL: R.myIcons.closeIconByTheme,
      iconSize: R.appRatio.appIconSize15,
      title: R.strings.kickAMember,
      value: "Kick",
    ),
    PopupItem(
      iconURL: R.myIcons.blockIconByTheme,
      iconSize: R.appRatio.appIconSize15,
      title: R.strings.blockAPerson,
      value: "Block",
    ),
    PopupItem(
      iconURL: R.myIcons.starIconByTheme,
      iconSize: R.appRatio.appIconSize15,
      title: R.strings.promoteAPerson,
      value: "Promote",
    ),
    PopupItem(
      iconURL: R.myIcons.caloriesStatsIconByTheme,
      iconSize: R.appRatio.appIconSize15,
      title: R.strings.demoteAPerson,
      value: "Demote",
    ),
  ];

  final tabBarItems = [R.strings.all];

  final List memberTypes = [
    'Owner',
    'Admin',
    'Member',
    'Pending',
    'Invited',
    'Blocked',
    'Guest'
  ];

  final int teamId;
  final TeamMemberType teamMemberType;
  final int resultPerPage = 10;
  final List<List<PopupItem>> options;
  final bool renderAsMember;

  AllMemberPage({
    @required this.teamId,
    @required this.teamMemberType,
    @required this.options,
    @required this.renderAsMember,
    Key key,
  }) : super(key: key);

  @override
  AllMemberPageState createState() => AllMemberPageState();
}

class AllMemberPageState extends State<AllMemberPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  List<User> items = List();
  bool _isLoading;
  int _curPage;
  bool _remainingResults;
  List options = List();
  int callReload;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();

    _curPage = 1;
    callReload = -1;
    _remainingResults = true;
    _isLoading = false;
    reloadItems();

    options = checkListIsNullOrEmpty(widget.options) ? List() : widget.options;
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
    _remainingResults = false;

    Response<dynamic> response = await TeamManager.getAllTeamMemberPaged(
        widget.teamId, _curPage, widget.resultPerPage);

    if (mounted && response.success && (response.object as List).isNotEmpty) {
      setState(
        () {
          items.addAll(response.object);
          _curPage += 1;
          _remainingResults = true;
          _isLoading = false;
          _refreshController.loadComplete();
        },
      );
      return;
    }

    if (mounted) {
      setState(
        () {
          _isLoading = false;
        },
      );
    }

    _refreshController.loadNoData();
  }

  reloadItems() {
    items = List();
    _curPage = 1;
    _remainingResults = true;
    loadMoreData();
    _refreshController.refreshCompleted();
  }

  _onSelectMemberOption(int index, String value) {
    switch (value) {
      case "Follow":
        break;
      case "Block":
        changeMemberRole(index, TeamMemberType.Blocked.index, 2);
        break;
      case "Kick":
        changeMemberRole(index, TeamMemberType.Pending.index, 1);
        break;
      case "Promote":
        changeMemberRole(index, TeamMemberType.Admin.index, -1);
        break;
      case "Demote":
        changeMemberRole(index, TeamMemberType.Member.index, -1);
        break;
    }
  }

  _pressAvatar(index) async {
    Response<dynamic> response =
        await UserManager.getUserInfo(items[index].userId);
    User user = response.object;

    pushPage(context, ProfilePage(userInfo: user, enableAppBar: true));
  }

  _pressUserInfo(index) async {
    Response<dynamic> response =
        await UserManager.getUserInfo(items[index].userId);
    User user = response.object;

    pushPage(context, ProfilePage(userInfo: user, enableAppBar: true));
  }

  void changeMemberRole(int index, int newMemberType, int callReloadOn) async {
    if (!mounted || items[index] == null) return;
    setState(
      () {
        _isLoading = true;
      },
    );

    Response<dynamic> response = await TeamManager.updateTeamMemberRole(
        widget.teamId, items[index].userId, newMemberType);
    if (response.success && response.errorCode == -1) {
      reloadItems();
      callReload = callReloadOn;
    } else {
      showCustomAlertDialog(
        context,
        title: R.strings.notice,
        content: response.errorMessage,
        firstButtonText: R.strings.ok.toUpperCase(),
        firstButtonFunction: () {
          pop(this.context);
        },
      );
    }

    Future.delayed(
      Duration(milliseconds: 1000),
      () {
        if (mounted && _isLoading) {
          setState(
            () {
              _isLoading = false;
            },
          );
        }
      },
    );
  }

  Widget _buildEmptyList() {
    String emptyList;
    String emptyListSubtitle;

    if (TeamMemberUtil.authorizeHigherLevel(
        TeamMemberType.Member, widget.teamMemberType)) {
      emptyList = R.strings.noMemberInList;
      emptyListSubtitle = R.strings.noMemberInListSubtitle;
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
        onRefresh: reloadItems,
        footer: null,
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
    super.build(context);

    if (checkListIsNullOrEmpty(items)) {
      return _buildEmptyList();
    }

    return _isLoading
        ? LoadingIndicator()
        : (AnimationLimiter(
            child: RefreshConfiguration(
              maxOverScrollExtent: 50,
              headerTriggerDistance: 50,
              child: SmartRefresher(
                enablePullDown: true,
                controller: _refreshController,
                onRefresh: reloadItems,
                enablePullUp: true,
                onLoading: loadMoreData,
                footer: CustomFooter(
                    builder: (BuildContext context, LoadStatus mode) {
                  Widget body;
                  if (mode == LoadStatus.idle) {
                    body = Text(R.strings.teamFooterIdle);
                  } else if (mode == LoadStatus.loading) {
                    body = LoadingIndicator();
                  } else if (mode == LoadStatus.failed) {
                    body = Text(R.strings.teamFooterFailed);
                  } else if (mode == LoadStatus.canLoading) {
                    body = Text(R.strings.teamFooterCanLoading);
                  } else {
                    body = Text(R.strings.teamFooterNoMoreData);
                  }
                  return Container(
                    height: 55.0,
                    child: Center(child: body),
                  );
                }),
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
                            child: widget.renderAsMember
                                ? _renderMemberCustomCell(index)
                                : _renderCustomCell(index),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ));
  }

  Widget _renderMemberCustomCell(int index) {
    if (checkListIsNullOrEmpty(items)) return Container();

    int listMemberTypeIndex = items[index].teamMemberType - 1;
    String avatarImageURL = items[index].avatar;
    String name = items[index].name;
    String listTeamMemberType = widget.memberTypes[listMemberTypeIndex];
    bool enablePopUpMenu = false;
    Color textColor = items[index].userId == UserManager.currentUser.userId
        ? R.colors.majorOrange
        : R.colors.contentText;

    return CustomCell(
      padding: EdgeInsets.only(
        top: (index == 0 ? R.appRatio.appSpacing15 : 0),
        bottom: R.appRatio.appSpacing15,
        left: R.appRatio.appSpacing15,
        right: R.appRatio.appSpacing15,
      ),
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
        color: textColor,
        fontWeight: FontWeight.w500,
      ),
      enableSplashColor: false,
      enableAddedContent: false,
      subTitle: listTeamMemberType,
      subTitleStyle: TextStyle(
        fontSize: R.appRatio.appFontSize14,
        color: textColor,
      ),
      pressInfo: () {
        _pressUserInfo(index);
      },
      centerVerticalSuffix: true,
      enablePopupMenuButton: enablePopUpMenu,
    );
  }

  Widget _renderCustomCell(int index) {
    if (checkListIsNullOrEmpty(items)) return Container();

    int listMemberTypeIndex = items[index].teamMemberType - 1;
    String avatarImageURL = items[index].avatar;
    String name = items[index].name;
    String listTeamMemberType = R.strings.teamMemberTypes[listMemberTypeIndex];
    bool enablePopUpMenu =
        !checkListIsNullOrEmpty(options[listMemberTypeIndex]);
    List<PopupItem> popUpItems = options[listMemberTypeIndex];
    Color textColor = items[index].userId == UserManager.currentUser.userId
        ? R.colors.majorOrange
        : R.colors.contentText;

    return CustomCell(
      padding: EdgeInsets.only(
        top: (index == 0 ? R.appRatio.appSpacing15 : 0),
        bottom: R.appRatio.appSpacing15,
        left: R.appRatio.appSpacing15,
        right: R.appRatio.appSpacing15,
      ),
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
        color: textColor,
        fontWeight: FontWeight.w500,
      ),
      enableSplashColor: false,
      enableAddedContent: false,
      subTitle: listTeamMemberType,
      subTitleStyle: TextStyle(
        fontSize: R.appRatio.appFontSize14,
        color: textColor,
      ),
      pressInfo: () {
        _pressUserInfo(index);
      },
      centerVerticalSuffix: true,
      enablePopupMenuButton: enablePopUpMenu,
      customPopupMenu: CustomPopupMenu(
        items: popUpItems,
        onSelected: (option) {
          _onSelectMemberOption(index, option);
        },
        popupIcon: Image.asset(
          R.myIcons.popupMenuIconByTheme,
          width: R.appRatio.appIconSize15,
          height: R.appRatio.appIconSize15,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
