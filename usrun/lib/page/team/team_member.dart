import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/define.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/manager/team_manager.dart';
import 'package:usrun/model/response.dart';
import 'package:usrun/page/team/team_member_all.dart';
import 'package:usrun/page/team/team_member_blocked.dart';
import 'package:usrun/page/team/team_member_pending.dart';
import 'package:usrun/util/image_cache_manager.dart';
import 'package:usrun/util/team_member_util.dart';
import 'package:usrun/widget/custom_dialog/custom_alert_dialog.dart';
import 'package:usrun/widget/custom_dialog/custom_complex_dialog.dart';
import 'package:usrun/widget/custom_gradient_app_bar.dart';
import 'package:usrun/widget/custom_popup_menu/custom_popup_item.dart';
import 'package:usrun/widget/custom_tab_bar.dart';
import 'package:usrun/widget/input_field.dart';

import 'member_search_page.dart';

class TeamMemberPage extends StatefulWidget {
  final adminTabBarItems = [
    R.strings.all,
    R.strings.requesting,
    R.strings.blocking,
  ];

  final tabBarItems = [R.strings.all];

  final int teamId;
  final TeamMemberType teamMemberType;
  final int resultPerPage = 10;

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

  final List<List<PopupItem>> adminOptions = [
    [],
    [],
    [
      popUpMenu[0],
      popUpMenu[1],
    ],
  ];

  final List<List<PopupItem>> ownerOptions = [
    [],
    [
      popUpMenu[0],
      popUpMenu[1],
      popUpMenu[3],
    ],
    popUpMenu.sublist(0, 3),
  ];

  final List memberTypes = [
    'Owner',
    'Admin',
    'Member',
    'Pending',
    'Invited',
    'Blocked',
    'Guest'
  ];

  TeamMemberPage({@required this.teamId, @required this.teamMemberType});

  @override
  _TeamMemberPageState createState() => _TeamMemberPageState();
}

class _TeamMemberPageState extends State<TeamMemberPage>
    with SingleTickerProviderStateMixin {
  int _selectedTabIndex;
  List<String> tabItems;
  List options = List();
  TabController _tabController;
  final TextEditingController _nameController = TextEditingController();

  final String _nameLabel = "User Code or Email";

  @override
  void initState() {
    super.initState();

    _selectedTabIndex = 0;
    _tabController = TabController(length: 3, vsync: this);

    switch (widget.teamMemberType) {
      case TeamMemberType.Owner:
        options = List<List<PopupItem>>();
        options = widget.ownerOptions;
        break;
      case TeamMemberType.Admin:
        options = widget.adminOptions;
        break;
      default:
        options = null;
        break;
    }

    if (TeamMemberUtil.authorizeHigherLevel(
        TeamMemberType.Admin, widget.teamMemberType)) {
      tabItems = widget.adminTabBarItems;
    } else {
      tabItems = widget.tabBarItems;
    }
  }

  void _inviteMember(dynamic data) async {
    Response<dynamic> res =
        await TeamManager.inviteNewMember(widget.teamId, data);

    _nameController.clear();

    if (res.success) {
      pop(this.context);
      showCustomAlertDialog(
        context,
        title: R.strings.notice,
        content: "Invitation sent",
        firstButtonText: R.strings.ok.toUpperCase(),
        firstButtonFunction: () => pop(this.context),
      );
    } else {
      pop(this.context);
      showCustomAlertDialog(
        context,
        title: R.strings.error,
        content: res.errorMessage,
        firstButtonText: R.strings.ok.toUpperCase(),
        firstButtonFunction: () => pop(this.context),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildElement = Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: R.colors.appBackground,
      appBar: CustomGradientAppBar(
        title: R.strings.teamMember,
        actions: <Widget>[
          Container(
            width: 50,
            child: (TeamMemberUtil.authorizeHigherLevel(
                    TeamMemberType.Member, widget.teamMemberType))
                ? FlatButton(
                    onPressed: () {
                      _showCustomDialog(0);
                    },
                    padding: EdgeInsets.all(0.0),
                    splashColor: R.colors.lightBlurMajorOrange,
                    textColor: Colors.white,
                    child: ImageCacheManager.getImage(
                      url: R.myIcons.addIcon02ByTheme,
                      width: R.appRatio.appAppBarIconSize,
                      height: R.appRatio.appAppBarIconSize,
                      color: Colors.white,
                    ),
                  )
                : Container(),
          ),
          Container(
            width: 50,
            child: (TeamMemberUtil.authorizeHigherLevel(
                    TeamMemberType.Member, widget.teamMemberType))
                ? FlatButton(
                    onPressed: () {
                      pushPage(
                        context,
                        //MEMBER SEARCH PAGE
                        MemberSearchPage(
                          autoFocusInput: true,
                          tabItems: tabItems,
                          selectedTab: _selectedTabIndex,
                          teamId: widget.teamId,
                          options: options,
                        ),
                      );
                    },
                    padding: EdgeInsets.all(0.0),
                    splashColor: R.colors.lightBlurMajorOrange,
                    textColor: Colors.white,
                    child: ImageCacheManager.getImage(
                      url: R.myIcons.appBarSearchBtn,
                      width: R.appRatio.appAppBarIconSize,
                      height: R.appRatio.appAppBarIconSize,
                      color: Colors.white,
                    ))
                : Container(),
          ),
        ],
      ),
      body: CustomTabBarStyle03(
        tabBarTitleList: tabItems,
        tabController: _tabController,
        tabBarViewList: [
          AllMemberPage(
            teamId: widget.teamId,
            teamMemberType: widget.teamMemberType,
            options: options,
          ),
          PendingMemberPage(
              teamId: widget.teamId, teamMemberType: widget.teamMemberType),
          BlockedMemberPage(
              teamId: widget.teamId, teamMemberType: widget.teamMemberType),
        ],
      ),
    );

    return NotificationListener<OverscrollIndicatorNotification>(
      child: _buildElement,
      onNotification: (overScroll) {
        overScroll.disallowGlow();
        return false;
      },
    );
  }

  final FocusNode _testInvite = FocusNode();

  void _showCustomDialog(index) async {
    switch (index) {
      case 0: // Invite
        await showCustomComplexDialog(
            context: context,
            headerContent: R.strings.inviteNewMember,
            descriptionContent: R.strings.inviteNewMemberContent,
            inputFieldList: [
              InputField(
                controller: _nameController,
                enableFullWidth: true,
                labelTitle: _nameLabel,
                hintText: _nameLabel,
                focusNode: _testInvite,
              ),
            ],
            firstButtonText: R.strings.invite.toUpperCase(),
            firstButtonFunction: () {
              _inviteMember(_nameController.text);
            },
            secondButtonText: R.strings.cancel.toUpperCase(),
            secondButtonFunction: () {
              pop(context);
            });
        break;
      default:
        break;
    }
  }
}
