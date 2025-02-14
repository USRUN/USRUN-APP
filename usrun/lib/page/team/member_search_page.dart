import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/define.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/manager/team_manager.dart';
import 'package:usrun/manager/user_manager.dart';
import 'package:usrun/model/response.dart';
import 'package:usrun/model/user.dart';
import 'package:usrun/page/profile/profile_page.dart';
import 'package:usrun/util/validator.dart';
import 'package:usrun/widget/avatar_view.dart';
import 'package:usrun/widget/custom_cell.dart';
import 'package:usrun/widget/custom_dialog/custom_alert_dialog.dart';
import 'package:usrun/widget/custom_gradient_app_bar.dart';
import 'package:usrun/widget/custom_popup_menu/custom_popup_menu.dart';
import 'package:usrun/widget/custom_tab_bar.dart';
import 'package:usrun/widget/input_field.dart';
import 'package:usrun/widget/loading_dot.dart';

class MemberSearchPage extends StatefulWidget {
  final bool autoFocusInput;
  final int resultPerPage = 15;
  final List tabItems;
  final int selectedTab;
  final int teamId;
  final List options;
  final bool renderAsMember;
  final List memberTypes = [
    'Owner',
    'Admin',
    'Member',
    'Pending',
    'Invited',
    'Blocked',
    'Guest'
  ];

  MemberSearchPage({
    this.autoFocusInput = false,
    @required this.tabItems,
    @required this.selectedTab,
    @required this.teamId,
    @required this.options,
    @required this.renderAsMember,
  });

  @override
  _MemberSearchPageState createState() => _MemberSearchPageState();
}

class _MemberSearchPageState extends State<MemberSearchPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textSearchController = TextEditingController();

  bool remainingResults;
  List options;
  List<Widget> tabBarViewItems;
  List<User> memberList;
  List<User> allMemberList;
  List<User> requestingMemberList;
  List<User> blockingMemberList;
  String _curSearchString;
  int _curResultPage;
  int _selectedTab;
  List<String> tabItems;
  TabController _tabController;
  bool _isLoading;

  @override
  void initState() {
    super.initState();
    _curSearchString = "";
    _curResultPage = 1;
    _isLoading = false;
    options = checkListIsNullOrEmpty(widget.options) ? List() : widget.options;
    tabItems = widget.tabItems;
    _selectedTab = widget.selectedTab;
    remainingResults = true;
    memberList = List();
    _tabController = TabController(length: widget.tabItems.length, vsync: this);
    _tabController.animateTo(widget.selectedTab);
    _tabController.addListener(() {
      _onSelectTabItem(_tabController.index);
    });
  }

  void parseResponse(List<User> responseObject) {
    responseObject.forEach((element) {
      if (element.teamMemberType <= TeamMemberType.Member.index + 1) {
        allMemberList.add(element);
      }
      if (element.teamMemberType == TeamMemberType.Pending.index + 1) {
        requestingMemberList.add(element);
      }
      if (element.teamMemberType == TeamMemberType.Blocked.index + 1) {
        blockingMemberList.add(element);
      }
    });
  }

  void _findMember() async {
    if (!remainingResults) return;

    remainingResults = false;
    Response<dynamic> response = await TeamManager.findTeamMemberRequest(
        widget.teamId, _curSearchString, _curResultPage, widget.resultPerPage);

    if (response.success && (response.object as List).isNotEmpty && mounted) {
      setState(() {
        parseResponse(response.object);
        remainingResults = true;
        _curResultPage += 1;
      });
    }
  }

  void clearMemberLists() {
    memberList = List();
    allMemberList = List();
    requestingMemberList = List();
    blockingMemberList = List();
  }

  void _onSubmittedFunction(data) {
    if (data.toString().length == 0) return;
    if (!mounted) return;

    setState(() {
      _curSearchString = data.toString();
      clearMemberLists();
      _curResultPage = 1;
      remainingResults = true;
      _isLoading = false;
    });

    _findMember();
  }

  void _onSelectTabItem(index) {
    if (index == _selectedTab) return;

    setState(
      () {
        _selectedTab = index;
      },
    );

    switch (index) {
      case 0:
        setState(() {
          memberList = allMemberList;
        });
        break;
      case 1:
        setState(() {
          memberList = requestingMemberList;
        });
        break;
      case 2:
        setState(() {
          memberList = blockingMemberList;
        });
        break;
    }
  }

  void loadTeamMemberProfile(int index) async {
    Response<dynamic> response =
        await UserManager.getUserInfo(memberList[index].userId);
    User user = response.object;

    pushPage(context, ProfilePage(userInfo: user, enableAppBar: true));
  }

  void _pressAvatar(index) {
    loadTeamMemberProfile(index);
  }

  void _pressUserInfo(index) {
    loadTeamMemberProfile(index);
  }

  void _onChangedFunction(data) {}

  _pressCloseBtn(index) {
    changeMemberRole(requestingMemberList, index, TeamMemberType.Blocked.index);
  }

  _pressCheckBtn(index) {
    changeMemberRole(requestingMemberList, index, TeamMemberType.Member.index);
  }

  _releaseFromBlock(index) {
    changeMemberRole(blockingMemberList, index, TeamMemberType.Pending.index);
  }

  _onSelectMemberOption(int index, String value) {
    switch (value) {
      case "Follow":
        break;
      case "Block":
        changeMemberRole(allMemberList, index, TeamMemberType.Blocked.index);
        break;
      case "Kick":
        changeMemberRole(allMemberList, index, TeamMemberType.Pending.index);
        break;
      case "Promote":
        changeMemberRole(allMemberList, index, TeamMemberType.Admin.index);
        break;
      case "Demote":
        changeMemberRole(allMemberList, index, TeamMemberType.Member.index);
        break;
    }
  }

  void changeMemberRole(List items, int index, int newMemberType) async {
    if (!mounted || items[index] == null) {
      return;
    }

    setState(
      () {
        _isLoading = true;
      },
    );

    Response<dynamic> response = await TeamManager.updateTeamMemberRole(
        widget.teamId, items[index].userId, newMemberType);
    if (response.success) {
      setState(() {
        _onSubmittedFunction(_curSearchString);
      });
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
        if (mounted) {
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
    String noResult = R.strings.noResult;
    String noResultSubtitle = R.strings.noResultSubtitle;
    String startSearch = R.strings.startSearch;
    String startSearchSubtitle = R.strings.startSearchSubtitle;

    if (_curSearchString.isEmpty) {
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
                    startSearch,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      color: R.colors.contentText,
                      fontSize: R.appRatio.appFontSize18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    startSearchSubtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: R.colors.contentText,
                      fontSize: R.appRatio.appFontSize14,
                    ),
                  ),
                ])),
      );
    }

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
      resizeToAvoidBottomInset: true,
      backgroundColor: R.colors.appBackground,
      appBar: CustomGradientAppBar(
        titleWidget: InputField(
          controller: _textSearchController,
          cursorColor: Colors.white,
          hintText: R.strings.search,
          hintStyle: TextStyle(
            fontSize: R.appRatio.appFontSize18,
            color: Colors.white.withOpacity(0.5),
          ),
          contentStyle: TextStyle(
            color: Colors.white,
            fontSize: R.appRatio.appFontSize18,
            fontWeight: FontWeight.w500,
          ),
          bottomUnderlineColor: Colors.white,
          enableBottomUnderline: true,
          isDense: true,
          autoFocus: widget.autoFocusInput,
          textInputAction: TextInputAction.search,
          onSubmittedFunction: (data) {
            _onSubmittedFunction(data);
          },
          onChangedFunction: _onChangedFunction,
        ),
      ),
      body: CustomTabBarStyle03(
        tabBarTitleList: tabItems,
        tabController: _tabController,
//        pressTab: _onSelectTabItem,
        tabBarViewList: widget.renderAsMember
            ? [
                _isLoading ? LoadingIndicator() : _renderList(allMemberList, 0),
              ]
            : [
                _isLoading ? LoadingIndicator() : _renderList(allMemberList, 0),
                _isLoading
                    ? LoadingIndicator()
                    : _renderList(requestingMemberList, 1),
                _isLoading
                    ? LoadingIndicator()
                    : _renderList(blockingMemberList, 2),
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

  Widget _renderList(List items, int mode) {
    if (checkListIsNullOrEmpty(items)) {
      return _buildEmptyList();
    }

    return AnimationLimiter(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: (items == null) ? 0 : items.length,
          itemBuilder: (BuildContext context, int index) {
            if (index == items.length - 1) {
              _findMember();
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
                    child: widget.renderAsMember
                        ? _renderMemberCustomCell(index)
                        : _renderCustomCell(items, mode, index),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget _renderMemberCustomCell(int index) {
    if (checkListIsNullOrEmpty(allMemberList)) return Container();

    int listMemberTypeIndex = allMemberList[index].teamMemberType - 1;
    String avatarImageURL = allMemberList[index].avatar;
    String name = allMemberList[index].name;
    String listTeamMemberType = R.strings.teamMemberTypes[listMemberTypeIndex];

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
      subTitle: listTeamMemberType,
      subTitleStyle: TextStyle(
        fontSize: R.appRatio.appFontSize14,
        color: R.colors.contentText,
      ),
      pressInfo: () {
        _pressUserInfo(index);
      },
      centerVerticalSuffix: true,
      enablePopupMenuButton: false,
    );
  }

  Widget _renderCustomCell(List items, int mode, int index) {
    String avatarImageURL = items[index].avatar;
    String name = items[index].name;
    String location = items[index].province.toString();
    int listMemberTypeIndex = items[index].teamMemberType - 1;
    String listTeamMemberType = widget.memberTypes[listMemberTypeIndex];

    switch (mode) {
      case 0: // All
        return CustomCell(
          avatarView: AvatarView(
            avatarImageURL: avatarImageURL,
            avatarImageSize: R.appRatio.appWidth60,
            avatarBoxBorder: Border.all(
              width: 1,
              color: R.colors.majorOrange,
            ),
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
          pressInfo: () {
            _pressUserInfo(index);
          },
          centerVerticalSuffix: true,
          enablePopupMenuButton:
              !checkListIsNullOrEmpty(widget.options[listMemberTypeIndex]),
          customPopupMenu: CustomPopupMenu(
            items: widget.options[listMemberTypeIndex],
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
          subTitle: location,
          subTitleStyle: TextStyle(
            fontSize: R.appRatio.appFontSize14,
            color: R.colors.contentText,
          ),
          pressInfo: () {
            _pressUserInfo(index);
          },
          centerVerticalSuffix: true,
          enableCloseButton: true,
          pressCloseButton: () {
            _pressCloseBtn(index);
          },
          enableCheckButton: true,
          pressCheckButton: () {
            _pressCheckBtn(index);
          },
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
          subTitle: location,
          subTitleStyle: TextStyle(
            fontSize: R.appRatio.appFontSize14,
            color: R.colors.contentText,
          ),
          pressInfo: () {
            _pressUserInfo(index);
          },
          centerVerticalSuffix: true,
          enableCloseButton: true,
          pressCloseButton: () {
            _releaseFromBlock(index);
          },
        );
      default:
        return Container();
    }
  }
}
