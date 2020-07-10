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
import 'package:usrun/page/team/team_member_item.dart';
import 'package:usrun/widget/avatar_view.dart';
import 'package:usrun/widget/custom_cell.dart';
import 'package:usrun/widget/custom_dialog/complex_custom_dialog.dart';
import 'package:usrun/widget/custom_dialog/custom_alert_dialog.dart';
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

  final tabBarItems = [
    R.strings.all
  ];

  static final Map<String,dynamic> follow = {
    "iconURL": R.myIcons.peopleIconByTheme,
    "iconSize": R.appRatio.appIconSize15,
    "title": "Follow/Unfollow",
  };

  static final Map<String,dynamic> block = {
    "iconURL": R.myIcons.peopleIconByTheme,
    "iconSize": R.appRatio.appIconSize15,
    "title": "Block from team",
  };

  static final Map<String,dynamic> promote = {
      "iconURL": R.myIcons.starIconByTheme,
      "iconSize": R.appRatio.appIconSize15,
      "title": "Promote to admin",
  };

  static final Map<String,dynamic> demote = {
    "iconURL": R.myIcons.peopleIconByTheme,
    "iconSize": R.appRatio.appIconSize15,
    "title": "Demote from Admin",
  };



  final member_options = [
    new CustomPopupItem.from(follow)
  ];

  final admin_options = [
    [
      new CustomPopupItem.from(follow)
    ],
    [
      new CustomPopupItem.from(follow)
    ],
    [
      new CustomPopupItem.from(follow),
      new CustomPopupItem.from(block)
    ]
  ];

  final owner_options = [
    [
      new CustomPopupItem.from(follow)
    ],

    [
      new CustomPopupItem.from(follow),
      new CustomPopupItem.from(demote),
      new CustomPopupItem.from(block)
    ],

    [
      new CustomPopupItem.from(follow),
      new CustomPopupItem.from(promote),
      new CustomPopupItem.from(block)
    ]
  ];

  final List memberTypes = ['Owner','Admin','Member','Pending','Blocked','Guest'];

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

  final TextEditingController _nameController = TextEditingController();
  final String _nameLabel = R.strings.name;

  @override
  void initState() {
    super.initState();
    _selectedTabIndex = 0;
    _curPage = 1;
    _remainingResults = true;

    if(widget.teamMemberType < 3){
      tabItems = widget.adminTabBarItems;
    } else{
      tabItems = widget.tabBarItems;
    }

    switch(widget.teamMemberType){
      case 1:
        options = List();
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

  void _getAllMembers() async {
    if(!_remainingResults) return;
      _remainingResults = false;

    Response<dynamic> response =
        await TeamManager.getAllTeamMemberPaged(
            widget.teamId, _curPage, widget.resultPerPage);

    if (response.success && (response.object as List).isNotEmpty) {
      List<User> toAdd = response.object;
      setState(() {
        items.addAll(toAdd);
          _curPage += 1;
        _remainingResults = true;
        });
      }

    setState(() {
      _isLoading = false;
    });
  }

  void _getMemberByType(int memberType) async {
    if(!_remainingResults) return;
    _remainingResults = false;

    Response<dynamic> response = await TeamManager
        .getTeamMemberByType(widget.teamId, memberType,_curPage, widget.resultPerPage);

    if (response.success && (response.object as List).isNotEmpty) {
      List<User> toAdd = response.object;

      UserRole queryMemberType =  UserRole.values[memberType];
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

  _onSelectMemberOption(int memberIndex, int optionIndex){
  }

  _pressAvatar(index) {
    // TODO: Implement function here
    print("Pressing avatar image");
  }

  _pressUserInfo(index) {
    // TODO: Implement function here
    print("Pressing info");
  }

  _pressFollowBtn(index) {
    // TODO: Implement function here
    print("Pressing FOLLOWING button on this person");
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

  _releaseFromBlock(index){
    // Remove from block list
    print("Remove ${items[index].userId} from block list");

    changeMemberRole(index,4);
  }

  void changeMemberRole(int index, int newMemberType) async{
    setState(() {
      _isLoading= true;
    });

    Response<dynamic> response = await TeamManager.updateTeamMemberRole(widget.teamId, items[index].userId, newMemberType);
    if(response.success){
      setState(() {
        items.removeAt(index);
        _isLoading= false;
      });
    } else {
      showCustomAlertDialog(context,
          title: R.strings.notice,
          content: response.errorMessage,
          firstButtonText: R.strings.ok.toUpperCase(),
          firstButtonFunction: () {
            pop(this.context);
          });
      setState(() {
        _isLoading= false;
      });
    }
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
                print("Open member invitation page");
                // push page
//                pushPage(
//                  context,
//                  // TODO: INVITE MEMBER PAGE
//                );
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
                  MemberSearchPage(autoFocusInput: true,tabItems: tabItems,selectedTab:_selectedTabIndex,teamId: widget.teamId,options: options,),
                );},
              padding: EdgeInsets.all(0.0),
              splashColor: R.colors.lightBlurMajorOrange,
              textColor: Colors.white,
                child: ImageCacheManager.getImage(
                  url: R.myIcons.appBarSearchBtn,
                  width: R.appRatio.appAppBarIconSize,
                  height: R.appRatio.appAppBarIconSize,
                  color: Colors.white,
                ),
            ),
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
            child: (_isLoading ? LoadingIndicator() : _renderList()),
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
    );
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
          subTitle: listTeamMemberType,
          subTitleStyle: TextStyle(
            fontSize: R.appRatio.appFontSize14,
            color: R.colors.contentText,
          ),
          pressInfo: () => _pressUserInfo(index),
          centerVerticalSuffix: true,
          enablePopupMenuButton: true,
          customPopupMenu:
          CustomPopupMenu(
            items: options[listMemberTypeIndex],
            onSelected: (optionIndex) {
              _onSelectMemberOption(index,optionIndex);
            },
            popupImage: Image.asset(
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
}
