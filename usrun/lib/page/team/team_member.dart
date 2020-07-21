import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/define.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/demo_data.dart';
import 'package:usrun/manager/team_manager.dart';
import 'package:usrun/model/response.dart';
import 'package:usrun/model/team_member.dart';
import 'package:usrun/model/user.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:usrun/page/team/team_member_item.dart';
import 'package:usrun/widget/avatar_view.dart';
import 'package:usrun/widget/custom_cell.dart';
import 'package:usrun/widget/custom_dialog/custom_alert_dialog.dart';
import 'package:usrun/widget/custom_dialog/custom_complex_dialog.dart';
import 'package:usrun/widget/custom_popup_menu/custom_popup_item.dart';
import 'package:usrun/widget/custom_popup_menu/custom_popup_menu.dart';
import 'package:usrun/widget/custom_tab_bar.dart';
import 'package:usrun/widget/input_field.dart';
import 'package:usrun/widget/loading_dot.dart';
import 'package:usrun/util/image_cache_manager.dart';

import 'member_search_page.dart';

class TeamMemberPage extends StatefulWidget {
  final adminTabBarItems = [
    R.strings.all,
    R.strings.requesting,
    R.strings.blocking,
  ];

  static final popUpMenu = [
    PopupItem(
        iconURL: R.myIcons.closeIconByTheme,
        iconSize: R.appRatio.appIconSize15,
        title: R.strings.kickAMember,
        value: "Kick"),
    PopupItem(
        iconURL: R.myIcons.blockIconByTheme,
        iconSize: R.appRatio.appIconSize15,
        title: R.strings.blockAPerson,
        value: "Block"),
    PopupItem(
        iconURL: R.myIcons.starIconByTheme,
        iconSize: R.appRatio.appIconSize15,
        title: R.strings.promoteAPerson,
        value: "Promote"),
    PopupItem(
        iconURL: R.myIcons.caloriesStatsIconByTheme,
        iconSize: R.appRatio.appIconSize15,
        title: R.strings.demoteAPerson,
        value: "Demote"),
  ];

  final tabBarItems = [R.strings.all];

  final List<List<PopupItem>> member_options = [[], [], []];

  final List<List<PopupItem>> admin_options = [
    [],
    [],
    [popUpMenu[0], popUpMenu[1]]
  ];

  final List<List<PopupItem>> owner_options = [
    [],
    [popUpMenu[0], popUpMenu[1], popUpMenu[3]],
    popUpMenu.sublist(0, 3),
  ];

  final List memberTypes = [
    'Owner',
    'Admin',
    'Member',
    'Pending',
    'Blocked',
    'Guest'
  ];

  final int teamId;
  final int teamMemberType;
  final int resultPerPage = 10;

  TeamMemberPage({@required this.teamId, @required this.teamMemberType});

  @override
  _TeamMemberPageState createState() => _TeamMemberPageState();
}

class _TeamMemberPageState extends State<TeamMemberPage> {
  bool _isLoading = false;
  int _selectedTabIndex;
  List<User> items = List();
  int _curPage;
  bool _remainingResults;
  List tabItems;
  List options = List();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final TextEditingController _nameController = TextEditingController();

  final String _nameLabel = "User Code or Email";

  @override
  void initState() {
    super.initState();

    _selectedTabIndex = 0;
    _curPage = 1;
    _remainingResults = true;

    if (widget.teamMemberType < 3) {
      tabItems = widget.adminTabBarItems;
    } else {
      tabItems = widget.tabBarItems;
    }

    switch (widget.teamMemberType) {
      case 1:
        options = List<List<PopupItem>>();
        options = widget.owner_options;
        break;
      case 2:
        options = widget.admin_options;
        break;
      case 3:
        options = widget.member_options;
        break;
    }

    _loadSuitableData(0);

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _loadSuitableData(_selectedTabIndex));
  }

  void _inviteMember(dynamic data) async {
    Response<dynamic> res =
        await TeamManager.inviteNewMember(widget.teamId, data);
    if (res.success) {
      pop(this.context);
      showCustomAlertDialog(context,
          title: R.strings.notice,
          content: "Invitation sent",
          firstButtonText: R.strings.ok,
          firstButtonFunction: () => pop(this.context),
          secondButtonText: null);
    } else {
      pop(this.context);
      showCustomAlertDialog(context,
          title: R.strings.error,
          content: res.errorMessage,
          firstButtonText: R.strings.ok,
          firstButtonFunction: () => pop(this.context),
          secondButtonText: null);
    }
  }

  void _getAllMembers() async {
    if (!_remainingResults) return;
    _remainingResults = false;

    TeamManager.getAllTeamMemberPaged(
            widget.teamId, _curPage, widget.resultPerPage)
        .then((response) => {
              if (response.success && (response.object as List).isNotEmpty)
                {
                  setState(() {
                    items.addAll(response.object);
                    _curPage += 1;
                    _remainingResults = true;
                  })
                }
            });

    setState(() {
      _isLoading = false;
    });
  }

  void _getMemberByType(int memberType) async {
    if (!_remainingResults) return;
    _remainingResults = false;

    Response<dynamic> response = await TeamManager.getTeamMemberByType(
        widget.teamId, memberType, _curPage, widget.resultPerPage);

    if (response.success && (response.object as List).isNotEmpty) {
      List<User> toAdd = response.object;

      UserRole queryMemberType = UserRole.values[memberType];
      toAdd.forEach((element) {
        element.teamMemberType = queryMemberType;
      });

      setState(() {
        items.addAll(toAdd);
        _remainingResults = true;
        _curPage += 1;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _loadSuitableData(tabIndex) {
    //  OWNER(1),
    //  ADMIN(2),
    //  MEMBER(3),
    //  PENDING(4),
    //  BLOCKED(5);
    // GUESS (6);

    switch (tabIndex) {
      case 0: // All
        _getAllMembers();
        break;
      case 1: // Requesting
        _getMemberByType(4);
        break;
      case 2: // Blocking
        _getMemberByType(5);
        break;
      default:
        break;
    }
  }

  _loadMoreData() {
    // TODO: Implement function here
    print("Loading more data...");
    _loadSuitableData(_selectedTabIndex);
  }

  _onSelectItem(int tabIndex) {
    if (_selectedTabIndex == tabIndex) return;
    setState(() {
      _isLoading = true;
      items = List();
      _curPage = 1;
      _remainingResults = true;
      _selectedTabIndex = tabIndex;
      _loadSuitableData(tabIndex);
    });
  }

  _reloadItems(int tabIndex) {
    _isLoading = true;
    items = List();
    _curPage = 1;
    _remainingResults = true;
    _selectedTabIndex = tabIndex;
    _loadSuitableData(tabIndex);
    _refreshController.refreshCompleted();
  }

  _onSelectMemberOption(int index, String value) {
    switch (value) {
      case "Follow":
        break;
      case "Block":
        changeMemberRole(index, 5);
        break;
      case "Kick":
        break;
      case "Promote":
        changeMemberRole(index, 2);
        break;
      case "Demote":
        changeMemberRole(index, 3);
        break;
    }
  }

  _pressAvatar(index) {
    // TODO: Implement function here
    print("Pressing avatar image");
  }

  _pressUserInfo(index) {
    // TODO: Implement function here
    print("Pressing info");
  }

  _pressCloseBtn(index) {
    // TODO: Implement function here
    // Decline join request

    print("Decline ${items[index].userId} join request");

    changeMemberRole(index, 5);
  }

  _pressCheckBtn(index) {
    // TODO: Implement function here
    // Approve join request

    print("Approve ${items[index].userId} join request");

    changeMemberRole(index, 3);
  }

  _releaseFromBlock(index) {
    // Remove from block list
    print("Remove ${items[index].userId} from block list");

    changeMemberRole(index, 4);
  }

  void changeMemberRole(int index, int newMemberType) async {
    setState(() {
      _isLoading = true;
    });

    Response<dynamic> response = await TeamManager.updateTeamMemberRole(
        widget.teamId, items[index].userId, newMemberType);
    if (response.success) {
      setState(() {
        _onSelectItem(_selectedTabIndex);
        _isLoading = false;
      });
    } else {
      showCustomAlertDialog(context,
          title: R.strings.notice,
          content: response.errorMessage,
          firstButtonText: R.strings.ok.toUpperCase(), firstButtonFunction: () {
        pop(this.context);
      });
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildEmptyList() {
    String noResult = R.strings.emptyMemberList;
    String noResultSubtitle = R.strings.emptyMemberListSubtitle;

    return Center(
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
                  noResult,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: R.colors.contentText,
                    fontSize: R.appRatio.appFontSize18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  noResultSubtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: R.colors.contentText,
                    fontSize: R.appRatio.appFontSize14,
                  ),
                ),
              ])),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildElement = Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: R.colors.appBackground,
      appBar: GradientAppBar(
        leading: FlatButton(
          onPressed: () => pop(context),
          padding: EdgeInsets.all(0.0),
          splashColor: R.colors.lightBlurMajorOrange,
          textColor: Colors.white,
          child: ImageCacheManager.getImage(
            url: R.myIcons.appBarBackBtn,
            width: R.appRatio.appAppBarIconSize,
            height: R.appRatio.appAppBarIconSize,
          ),
        ),
        gradient: R.colors.uiGradient,
        centerTitle: true,
        title: Text(
          R.strings.teamMember,
          style: TextStyle(
              color: Colors.white, fontSize: R.appRatio.appFontSize22),
        ),
        actions: <Widget>[
          Container(
            width: R.appRatio.appWidth40,
            child: FlatButton(
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
            ),
          ),
          Container(
            width: R.appRatio.appWidth60,
            child: FlatButton(
                onPressed: () {
                  pushPage(
                    context,
                    //MEMBER SEARCH PAGE
                    MemberSearchPage(
                        autoFocusInput: true,
                        tabItems: tabItems,
                        selectedTab: _selectedTabIndex,
                        teamId: widget.teamId,
                        options: options),
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
                )),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // TabBar
          CustomTabBarStyle03(
            items: tabItems,
            selectedTabIndex: _selectedTabIndex,
            pressTab: _onSelectItem,
          ),
          // All contents
          Expanded(
            child: (items.isEmpty
                ? _buildEmptyList()
                : (_isLoading ? LoadingIndicator() : _renderList())),
          ),
        ],
      ),
    );

    return NotificationListener<OverscrollIndicatorNotification>(
        child: _buildElement,
        onNotification: (overScroll) {
          overScroll.disallowGlow();
          return false;
        });
  }

  Widget _renderList() {
    return AnimationLimiter(
        child: RefreshConfiguration(
            maxOverScrollExtent: 50,
            headerTriggerDistance: 50,
            child: SmartRefresher(
              enablePullDown: true,
              controller: _refreshController,
              onRefresh: () => {_reloadItems(_selectedTabIndex)},
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == items.length - 1) {
                      _loadMoreData();
                    }

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
                  }),
            )));
  }

  Widget _renderCustomCell(index) {
    int listMemberTypeIndex = items[index].teamMemberType.index - 1;
    String avatarImageURL = items[index].avatar;
    String supportImageURL = items[index].avatar;
    String name = items[index].name;
    String location = items[index].province.toString();
    String listTeamMemberType = widget.memberTypes[listMemberTypeIndex];

    switch (_selectedTabIndex) {
      case 0: // All
        return CustomCell(
          avatarView: AvatarView(
            avatarImageURL: avatarImageURL,
            avatarImageSize: R.appRatio.appWidth60,
            avatarBoxBorder: Border.all(
              width: 1,
              color: R.colors.majorOrange,
            ),
            pressAvatarImage: () => _pressAvatar(index),
          ),
          // Content
          title: name,
          titleStyle: TextStyle(
            fontSize: R.appRatio.appFontSize16,
            color: R.colors.contentText,
            fontWeight: FontWeight.w500,
          ),
          enableAddedContent: false,
          subTitle: listTeamMemberType,
          subTitleStyle: TextStyle(
            fontSize: R.appRatio.appFontSize14,
            color: R.colors.contentText,
          ),
          pressInfo: () => _pressUserInfo(index),
          centerVerticalSuffix: true,
          enablePopupMenuButton: options[listMemberTypeIndex].isNotEmpty,
          customPopupMenu: CustomPopupMenu(
            items: options[listMemberTypeIndex],
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
      case 1: // Requesting
        return CustomCell(
          avatarView: AvatarView(
            avatarImageURL: avatarImageURL,
            avatarImageSize: R.appRatio.appWidth60,
            avatarBoxBorder: Border.all(
              width: 1,
              color: R.colors.majorOrange,
            ),
            supportImageURL: supportImageURL,
            pressAvatarImage: () => _pressAvatar(index),
          ),
          // Content
          title: name,
          titleStyle: TextStyle(
            fontSize: R.appRatio.appFontSize16,
            color: R.colors.contentText,
            fontWeight: FontWeight.w500,
          ),
          enableAddedContent: false,
          subTitle: location,
          subTitleStyle: TextStyle(
            fontSize: R.appRatio.appFontSize14,
            color: R.colors.contentText,
          ),
          pressInfo: () => _pressUserInfo(index),
          centerVerticalSuffix: true,
          enableCloseButton: true,
          pressCloseButton: () => _pressCloseBtn(index),
          enableCheckButton: true,
          pressCheckButton: () => _pressCheckBtn(index),
        );
      case 2: // Blocking
        return CustomCell(
          avatarView: AvatarView(
            avatarImageURL: avatarImageURL,
            avatarImageSize: R.appRatio.appWidth60,
            avatarBoxBorder: Border.all(
              width: 1,
              color: R.colors.majorOrange,
            ),
            supportImageURL: supportImageURL,
            pressAvatarImage: () => _pressAvatar(index),
          ),
          // Content
          title: name,
          titleStyle: TextStyle(
            fontSize: R.appRatio.appFontSize16,
            color: R.colors.contentText,
            fontWeight: FontWeight.w500,
          ),
          enableAddedContent: false,
          subTitle: location,
          subTitleStyle: TextStyle(
            fontSize: R.appRatio.appFontSize14,
            color: R.colors.contentText,
          ),
          pressInfo: () => _pressUserInfo(index),
          centerVerticalSuffix: true,
          enableCloseButton: true,
          pressCloseButton: () => _releaseFromBlock(index),
        );
      default:
        return Container();
    }
  }

  // TODO: Test focusnode
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
            // TODO: Implement function here
            print("Invite new member");
            _inviteMember(_nameController.text);
          },
          secondButtonText: R.strings.cancel.toUpperCase(),
          secondButtonFunction: () => pop(context),
        );
        break;
      case 1: // Kick
        await showCustomComplexDialog(
          context: context,
          headerContent: R.strings.kickAMember,
          descriptionContent: R.strings.kickAMemberContent,
          inputFieldList: [
            InputField(
              controller: _nameController,
              enableFullWidth: false,
              labelTitle: _nameLabel,
              hintText: _nameLabel,
            ),
          ],
          firstButtonText: R.strings.kick.toUpperCase(),
          firstButtonFunction: () {
            // TODO: Implement function here
            print("Kick a member");
          },
          secondButtonText: R.strings.cancel.toUpperCase(),
          secondButtonFunction: () => pop(context),
        );
        break;
      case 2: // Block
        await showCustomComplexDialog(
          context: context,
          headerContent: R.strings.blockAPerson,
          descriptionContent: R.strings.blockAPersonContent,
          inputFieldList: [
            InputField(
              controller: _nameController,
              enableFullWidth: false,
              labelTitle: _nameLabel,
              hintText: _nameLabel,
            ),
          ],
          firstButtonText: R.strings.block.toUpperCase(),
          firstButtonFunction: () {
            // TODO: Implement function here
            print("Block a person");
          },
          secondButtonText: R.strings.cancel.toUpperCase(),
          secondButtonFunction: () => pop(context),
        );
        break;
      default:
        break;
    }
  }
}
