import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/demo_data.dart';
import 'package:usrun/manager/team_manager.dart';
import 'package:usrun/model/response.dart';
import 'package:usrun/model/team_member.dart';
import 'package:usrun/model/user.dart';
import 'package:usrun/page/team/team_search_page.dart';
import 'package:usrun/widget/avatar_view.dart';
import 'package:usrun/widget/custom_cell.dart';
import 'package:usrun/widget/custom_dialog/complex_custom_dialog.dart';
import 'package:usrun/widget/custom_dialog/custom_alert_dialog.dart';
import 'package:usrun/widget/custom_popup_menu.dart';
import 'package:usrun/widget/custom_tab_bar.dart';
import 'package:usrun/widget/input_field.dart';
import 'package:usrun/widget/loading_dot.dart';
import 'package:usrun/util/image_cache_manager.dart';

class TeamMemberPage extends StatefulWidget {
  final adminTabBarItems = [
    {
      "tabName": R.strings.all,
    },
    {
      "tabName": R.strings.requesting,
    },
    {
      "tabName": R.strings.blocking,
    }
  ];

  final tabBarItems = [
    {
      "tabName": R.strings.all,
    },
  ];

  final popUpMenu = [
    {
      "iconURL": R.myIcons.blackAddIcon02,
      "iconSize": R.appRatio.appIconSize15 + 1,
      "title": R.strings.inviteNewMember,
    },
    {
      "iconURL": R.myIcons.blackCloseIcon,
      "iconSize": R.appRatio.appIconSize15,
      "title": R.strings.kickAMember,
    },
    {
      "iconURL": R.myIcons.blackBlockIcon,
      "iconSize": R.appRatio.appIconSize15,
      "title": R.strings.blockAPerson,
    },
  ];

  final member_options = [
    {
      "iconURL": R.myIcons.peopleIconByTheme,
      "iconSize": R.appRatio.appIconSize15,
      "title": "Follow/Unfollow",
    },
    {
      "iconURL": R.myIcons.starIconByTheme,
      "iconSize": R.appRatio.appIconSize15,
      "title": "Promote to admin",
    },
    {
      "iconURL": R.myIcons.blockIconByTheme,
      "iconSize": R.appRatio.appIconSize15,
      "title": "Block from team",
    },
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

  final TextEditingController _nameController = TextEditingController();
  final String _nameLabel = R.strings.name;

  /*
    + Structure of the "items" variable: 
    [
      {
        "avatarImageURL":
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
        "name": "Quốc Trần Kiến Quốc Trần Kiến Quốc Trần Kiến Quốc Trần Kiến",
        'supportImageURL':
          'https://i.pinimg.com/originals/3f/e8/f3/3fe8f39d6470b4f5e6b95b63b41b032f.png',
        "location": "Ho Chi Minh City, Viet Nam",
        "isFollowing": false,
      },
      ...
    ]
  */

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

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _loadSuitableData(_selectedTabIndex));
  }

  void _getAllMembers() async {
    if(!_remainingResults) return;
    _remainingResults = false;
    Response<dynamic> response = await TeamManager
        .getAllTeamMemberPaged(widget.teamId, _curPage, widget.resultPerPage);

    if (response.success && (response.object as List).isNotEmpty) {
      List<User> toAdd = response.object;
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

  void _getMemberByType(int memberType) async {
    if(!_remainingResults) return;
    _remainingResults = false;

    Response<dynamic> response = await TeamManager
        .getTeamMemberByType(widget.teamId, memberType,_curPage, widget.resultPerPage);

    if (response.success && (response.object as List).isNotEmpty) {
      List<User> toAdd = response.object;
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

  _onSelectMemberOption(int memberIndex){

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

  _pressUnFollowBtn(index) {
    // TODO: Implement function here
    print("Pressing UNFOLLOW button on this person");
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
            width: R.appRatio.appWidth60,
            child: FlatButton(
              onPressed: () {
                pushPage(
                  context,
                  //MEMBER SEARCH PAGE
                  TeamSearchPage(autoFocusInput: true, defaultList: [],),
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
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
                  if(_remainingResults) {
                    _loadSuitableData(_selectedTabIndex);
                  }
                }
                return true; // just to clear a warning
              },
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: (_isLoading
                  ? Container(
                      padding: EdgeInsets.only(
                        top: R.appRatio.appSpacing15,
                      ),
                      child: LoadingDotStyle02(),
                    )
                  : _renderList()),
            ),)
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
    return Container(
      padding: EdgeInsets.only(
        left: R.appRatio.appSpacing15,
        right: R.appRatio.appSpacing15,
      ),
      child: AnimationLimiter(
          child:ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount:(items!=null)?items.length:0,
            itemBuilder: (BuildContext ctxt, int index) {
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
                      ),
                      child: _renderCustomCell(index),
                    ),
                  ),
                ),
              );
            }),
    ));
  }

  Widget _renderCustomCell(index) {
    String avatarImageURL = items[index].avatar;
    String supportImageURL = items[index].avatar;
    String name = items[index].name;
    String location = items[index].province.toString();

    switch (_selectedTabIndex) {
      case 0: // All
      // TODO: IMPLEMENT FOLLOWING FEATURES
        bool isFollowing = false;
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
          enablePopupMenuButton: true,
          customPopupMenu: CustomPopupMenu(
            items: widget.member_options,
            onSelected: (index) {
              _onSelectMemberOption(index);
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

  void _showCustomDialog(index) async {
    switch (index) {
      case 0: // Invite
        await showComplexCustomDialog(
          context: context,
          headerContent: R.strings.inviteNewMember,
          descriptionContent: R.strings.inviteNewMemberContent,
          inputFieldList: [
            InputField(
              controller: _nameController,
              enableFullWidth: false,
              labelTitle: _nameLabel,
              hintText: _nameLabel,
            ),
          ],
          submitBtnContent: R.strings.invite,
          submitBtnFunction: () {
            // TODO: Implement function here
            print("Invite new member");
          },
        );
        break;
      case 1: // Kick
        await showComplexCustomDialog(
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
          submitBtnContent: R.strings.kick,
          submitBtnFunction: () {
            // TODO: Implement function here
            print("Kick a member");
          },
        );
        break;
      case 2: // Block
        await showComplexCustomDialog(
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
          submitBtnContent: R.strings.block,
          submitBtnFunction: () {
            // TODO: Implement function here
            print("Block a person");
          },
        );
        break;
      default:
        break;
    }
  }
}
