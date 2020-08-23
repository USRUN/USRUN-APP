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
  List<String> tabItems;
  List options = List();
  TabController _tabController;
  List<Widget> tabBarViewItems;
  bool renderAsMember;

  final String _nameLabel = "User Code or Email";

  @override
  void initState() {
    super.initState();

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
      renderAsMember = false;
      tabBarViewItems = [
        AllMemberPage(
          teamId: widget.teamId,
          teamMemberType: widget.teamMemberType,
          options: options,
          renderAsMember: renderAsMember,
        ),
        PendingMemberPage(
            teamId: widget.teamId, teamMemberType: widget.teamMemberType),
        BlockedMemberPage(
            teamId: widget.teamId, teamMemberType: widget.teamMemberType),
      ];
    } else {
      renderAsMember = true;
      tabBarViewItems = [
        AllMemberPage(
          teamId: widget.teamId,
          teamMemberType: widget.teamMemberType,
          options: options,
          renderAsMember: renderAsMember,
        )
      ];
      tabItems = widget.tabBarItems;

//      _tabController.addListener(() {
//        _selectedTabIndex = _tabController.index;
//      });
    }

    _tabController = TabController(length: tabItems.length, vsync: this);
  }

  void _inviteMember(dynamic data) async {
    Response<dynamic> res =
        await TeamManager.inviteNewMember(widget.teamId, data);

    if (res.success) {
      pop(this.context);
      showCustomAlertDialog(
        context,
        title: R.strings.notice,
        content: R.strings.invitationSent,
        firstButtonText: R.strings.ok.toUpperCase(),
        firstButtonFunction: () {
          pop(this.context);
        },
      );
    } else {
      pop(this.context);
      showCustomAlertDialog(
        context,
        title: R.strings.error,
        content: res.errorMessage,
        firstButtonText: R.strings.ok.toUpperCase(),
        firstButtonFunction: () {
          pop(this.context);
        },
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
            width: 55,
            child: (TeamMemberUtil.authorizeHigherLevel(
                    TeamMemberType.Member, widget.teamMemberType))
                ? FlatButton(
                    onPressed: () async {
                      await _showCustomDialog(context, widget.teamId);
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
            width: 55,
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
                          selectedTab: _tabController.index,
                          teamId: widget.teamId,
                          options: options,
                          renderAsMember: renderAsMember,
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
        tabBarViewList: tabBarViewItems,
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

//  final FocusNode _inviteNode = FocusNode();

  static Future<void> _showCustomDialog(BuildContext context, int teamId) async {
    TextEditingController _nameController = TextEditingController();

    bool result = await showCustomComplexDialog<bool>(
      context,
      headerContent: R.strings.inviteNewMember,
      descriptionContent: R.strings.inviteNewMemberContent,
      inputFieldList: [
        InputField(
          controller: _nameController,
          enableFullWidth: true,
          labelTitle: "User code or Email",
          hintText: "User code or Email",
          autoFocus: true,
//              focusNode: _inviteNode,
        ),
      ],
      firstButtonText: R.strings.invite.toUpperCase(),
      firstButtonFunction: () async {
        Response<dynamic> res =
            await TeamManager.inviteNewMember(teamId, _nameController.text.trim());

        if (res.success) {
          pop(context);
          showCustomAlertDialog(
            context,
            title: R.strings.notice,
            content: R.strings.invitationSent,
            firstButtonText: R.strings.ok.toUpperCase(),
            firstButtonFunction: () {
              pop(context);
            },
          );
        } else {
          pop(context);
          showCustomAlertDialog(
            context,
            title: R.strings.error,
            content: res.errorMessage,
            firstButtonText: R.strings.ok.toUpperCase(),
            firstButtonFunction: () {
              pop(context);
            },
          );
        }
      },
      secondButtonText: R.strings.cancel.toUpperCase(),
      secondButtonFunction: () => pop(context),
    );
  }
}
