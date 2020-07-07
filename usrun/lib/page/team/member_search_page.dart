import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/define.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/manager/team_manager.dart';
import 'package:usrun/manager/user_manager.dart';
import 'package:usrun/model/response.dart';
import 'package:usrun/model/user.dart';
import 'package:usrun/widget/avatar_view.dart';
import 'package:usrun/widget/custom_cell.dart';
import 'package:usrun/widget/custom_popup_menu/custom_popup_item.dart';
import 'package:usrun/widget/custom_popup_menu/custom_popup_menu.dart';
import 'package:usrun/widget/custom_tab_bar.dart';
import 'package:usrun/widget/input_field.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:usrun/util/image_cache_manager.dart';
import 'package:usrun/widget/loading_dot.dart';

class MemberSearchPage extends StatefulWidget {
  final bool autoFocusInput;
  final int resultPerPage = 15;
  final List tabItems;
  final int selectedTab;
  final int teamId;
  final List options;
  final List memberTypes = ['Owner','Admin','Member','Pending','Blocked','Guest'];

  MemberSearchPage({
    this.autoFocusInput = false,
    @required this.tabItems,
    @required this.selectedTab,
    @required this.teamId,
    @required this.options
  });

  @override
  _MemberSearchPageState createState() => _MemberSearchPageState();
}

class _MemberSearchPageState extends State<MemberSearchPage> {
  final TextEditingController _textSearchController = TextEditingController();
  bool _isLoading;
  bool remainingResults;
  List<User> memberList;
  List<User> allMemberList;
  List<User> requestingMemberList;
  List<User> blockingMemberList;
  String curSearchString;
  int curResultPage;
  int _selectedTab;
  List tabItems;
  int _selectedMemberType;
  final _currentUser = UserManager.currentUser;

  @override
  void initState() {
    super.initState();
    curSearchString = "";
    _isLoading = true;
    curResultPage = 1;
    tabItems = widget.tabItems;
    _selectedTab = widget.selectedTab;
    remainingResults = true;
    memberList = List();

    WidgetsBinding.instance.addPostFrameCallback((_) => _updateLoading());
  }

  void _updateLoading() {
    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        _isLoading = !_isLoading;
      });
    });
  }

  void parseResponse(List<User> responseObject){
    responseObject.forEach((element) {
      if(element.teamMemberType.index < 4){
        allMemberList.add(element);
      }
      if(element.teamMemberType.index == 4){
        requestingMemberList.add(element);
      }
      if(element.teamMemberType.index == 5){
        blockingMemberList.add(element);
      }
    });
  }


  void _findMember() async {
    if(!remainingResults) return;

    remainingResults = false;
    Response<dynamic> response = await TeamManager.findTeamMemberRequest(widget.teamId,curSearchString, curResultPage, widget.resultPerPage);

    if(response.success && (response.object as List).isNotEmpty){
      setState(() {
        parseResponse(response.object);
        _onSelectTabItem(_selectedTab);
        remainingResults = true;
        curResultPage += 1;
      });
    }
  }

  void clearMemberLists(){
    memberList = List();
    allMemberList = List();
    requestingMemberList = List();
    blockingMemberList = List();
  }

  void _onSubmittedFunction(data) {
    if (data.toString().length == 0) return;

    //reset states

    setState(() {
      _isLoading = !_isLoading;
      curSearchString = data.toString();
      clearMemberLists();
      curResultPage = 1;
      remainingResults = true;
    });

    // TODO: Implement function here
    print("Data: $data");

    _findMember();

    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void _onSelectTabItem(index){
    if (index == _selectedTab) return;
    _selectedTab = index;
    switch(index){
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

  void _onChangedFunction(data) {
    // [Demo] Clear all searching content => Render "SuggestedTeams" by setState
    if (data.toString().length == 0) {
      setState(() {
        memberList = List();
      });
    }
  }

  bool _isEmptyList() {
    return ((this.memberList == null || this.memberList.length == 0) ? true : false);
  }

  Widget _buildEmptyList() {
    String systemNoti =
        "No result available";

    return Center(
      child: Container(
        padding: EdgeInsets.only(
          left: R.appRatio.appSpacing25,
          right: R.appRatio.appSpacing25,
        ),
        child: Text(
          systemNoti,
          textAlign: TextAlign.justify,
          style: TextStyle(
            color: R.colors.contentText,
            fontSize: R.appRatio.appFontSize14,
          ),
        ),
      ),
    );
  }

  Widget _renderUserList() {
    return AnimationLimiter(
      child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent) {
              if(remainingResults)
                _findMember();
            }
            return true; // just to clear a warning
          },
          child: _isEmptyList()?
          _buildEmptyList():
          ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount:(memberList!=null)?memberList.length:0,
              itemBuilder: (BuildContext ctxt, int index) {
                String avatarImageURL = memberList[index].avatar;
                String supportImageURL = memberList[index].avatar;
                String teamName = memberList[index].name;
                String location = memberList[index].province.toString();
                int memberUserId = memberList[index].userId;
                int teamMemberType = memberList[index].teamMemberType.index - 1;

                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 400),
                  child: SlideAnimation(
                    verticalOffset: 100.0,
                    child: FadeInAnimation(
                      child: Container(
                        padding: EdgeInsets.only(
                          top: (index == 0 ? R.appRatio.appSpacing20 : 0),
                          bottom: R.appRatio.appSpacing20,
                          left: R.appRatio.appSpacing15,
                          right: R.appRatio.appSpacing15,
                        ),
                        child: CustomCell(
                          avatarView: AvatarView(
                            avatarImageURL: avatarImageURL,
                            avatarImageSize: R.appRatio.appWidth60,
                            avatarBoxBorder: Border.all(
                              width: 1,
                              color: R.colors.majorOrange,
                            ),
                            supportImageURL: supportImageURL,
                            pressAvatarImage: () => null,
                          ),
                          // Content
                          title: teamName,
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
                          pressInfo: () => null,
                          centerVerticalSuffix: true,
                          enablePopupMenuButton: (memberUserId == _currentUser.userId) ?false:true,
                          customPopupMenu: CustomPopupMenu(
                            items: widget.options[teamMemberType],
                            onSelected: (index) {
                              null;
                            },
                            popupImage: Image.asset(
                              R.myIcons.popupMenuIconByTheme,
                              width: R.appRatio.appIconSize15,
                              height: R.appRatio.appIconSize15,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              })),
    );
  }

    @override
    Widget build(BuildContext context) {
      FocusScope.of(context).requestFocus(new FocusNode());
      Widget _buildElement = Scaffold(
        resizeToAvoidBottomInset: true,
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
          title: InputField(
            controller: _textSearchController,
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
            onSubmittedFunction: _onSubmittedFunction,
            onChangedFunction: _onChangedFunction,
          ),
        ),

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
          // TabBar
          CustomTabBarStyle03(
          items: tabItems,
          selectedTabIndex: _selectedTab,
          pressTab: _onSelectTabItem,
        ),
          // All contents
          Expanded(
            child: (_isLoading ? LoadingIndicator() : _renderList()),
          ),
      ]));

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
          itemCount: memberList.length,
          itemBuilder: (BuildContext context, int index) {
            if (index == memberList.length - 1) {
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
                    child: _renderCustomCell(index),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget _renderCustomCell(index) {
    int listMemberTypeIndex = memberList[index].teamMemberType.index - 1;
    String avatarImageURL = memberList[index].avatar;
    String supportImageURL = memberList[index].avatar;
    String name = memberList[index].name;
    String location = memberList[index].province.toString();
    String listTeamMemberType = widget.memberTypes[listMemberTypeIndex];


    switch (_selectedTab) {
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
//            pressAvatarImage: () => _pressAvatar(index),
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
//          pressInfo: () => _pressUserInfo(index),
          centerVerticalSuffix: true,
          enablePopupMenuButton: true,
          customPopupMenu:
          CustomPopupMenu(
            items: widget.options[listMemberTypeIndex],
            onSelected: (index) {
//              _onSelectMemberOption(index);
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
//            pressAvatarImage: () => _pressAvatar(index),
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
//          pressInfo: () => _pressUserInfo(index),
          centerVerticalSuffix: true,
          enableCloseButton: true,
//          pressCloseButton: () => _pressCloseBtn(index),
          enableCheckButton: true,
//          pressCheckButton: () => _pressCheckBtn(index),
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
//            pressAvatarImage: () => _pressAvatar(index),
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
//          pressInfo: () => _pressUserInfo(index),
          centerVerticalSuffix: true,
          enableCloseButton: true,
//          pressCloseButton: () => _releaseFromBlock(index),
        );
      default:
        return Container();
    }
  }
}
