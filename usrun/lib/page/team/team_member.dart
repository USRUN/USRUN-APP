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
import 'package:usrun/page/team/team_member_item.dart';
import 'package:usrun/widget/avatar_view.dart';
import 'package:usrun/widget/custom_cell.dart';
import 'package:usrun/widget/custom_dialog/complex_custom_dialog.dart';
import 'package:usrun/widget/custom_popup_menu/custom_popup_item.dart';
import 'package:usrun/widget/custom_popup_menu/custom_popup_menu.dart';
import 'package:usrun/widget/custom_tab_bar.dart';
import 'package:usrun/widget/input_field.dart';
import 'package:usrun/widget/loading_dot.dart';
import 'package:usrun/util/image_cache_manager.dart';

class TeamMemberPage extends StatefulWidget {
  final tabBarItems = [
    R.strings.all,
    R.strings.requesting,
    R.strings.blocking,
  ];

  final popUpMenu = [
    CustomPopupItem(
      iconURL: R.myIcons.blackAddIcon02,
      iconSize: R.appRatio.appIconSize15 + 1,
      title: R.strings.inviteNewMember,
    ),
    CustomPopupItem(
      iconURL: R.myIcons.blackCloseIcon,
      iconSize: R.appRatio.appIconSize15,
      title: R.strings.kickAMember,
    ),
    CustomPopupItem(
      iconURL: R.myIcons.blackBlockIcon,
      iconSize: R.appRatio.appIconSize15,
      title: R.strings.blockAPerson,
    ),
  ];

  final int teamId;
  final int resultPerPage = 15;

  TeamMemberPage({@required this.teamId});

  @override
  _TeamMemberPageState createState() => _TeamMemberPageState();
}

class _TeamMemberPageState extends State<TeamMemberPage> {
  bool _isLoading = false;
  int _selectedTabIndex;
  int _curPage;
  bool _remainingResults;
  List<TeamMemberItem> items = List();

  final TextEditingController _nameController = TextEditingController();
  final String _nameLabel = R.strings.name;

  @override
  void initState() {
    super.initState();
    _selectedTabIndex = 0;
    _curPage = 1;
    _remainingResults = true;

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _loadSuitableData(_selectedTabIndex));
  }

  void _getAllMembers() async {
    setState(() {
      _isLoading = !_isLoading;
      _curPage = 1;
      _remainingResults = true;
    });

    if (_remainingResults) {
      Response<List<TeamMember>> response =
          await TeamManager.getAllTeamMemberPaged(
              widget.teamId, _curPage, widget.resultPerPage);
      if (response.success) {
        // TODO: Implement function here
        List<TeamMember> data = response.object;
        setState(() {
          items = DemoData().allTeamMember;
          _curPage += 1;
        });
        if (response.object.length > 0)
          _curPage += 1;
        else
          _remainingResults = false;
      }
    }

    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void _getRequestingMembers() async {
    setState(() {
      _isLoading = !_isLoading;
      _curPage = 0;
      _remainingResults = true;
    });

    // TODO: Implement function here
    Future.delayed(Duration(milliseconds: 1000), () {
      return items = DemoData().requestingTeamMember;
    }).then((val) {
      setState(() {
        _isLoading = !_isLoading;
        items = val;
      });
    });

//    Response<List<TeamMember>> teamMembers = await TeamManager.getTeamMemberByType(widget.teamId, 1);
  }

  void _getBlockingMembers() {
    setState(() {
      _isLoading = !_isLoading;
      _curPage = 0;
      _remainingResults = true;
    });

    // TODO: Implement function here
    Future.delayed(Duration(milliseconds: 1000), () {
      return items = DemoData().blockingTeamMember;
    }).then((val) {
      setState(() {
        _isLoading = !_isLoading;
        items = val;
      });
    });
  }

  void _loadSuitableData(tabIndex) {
    switch (tabIndex) {
      case 0: // All
        _getAllMembers();
        break;
      case 1: // Requesting
        _getRequestingMembers();
        break;
      case 2: // Blocking
        _getBlockingMembers();
        break;
      default:
        break;
    }
  }

  _loadMoreData() {
    // TODO: Implement function here
    print("Loading more data...");
  }

  _onSelectItem(int tabIndex) {
    if (_selectedTabIndex == tabIndex) return;
    setState(() {
      _selectedTabIndex = tabIndex;
      _loadSuitableData(tabIndex);
    });
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
    print("Pressing CLOSE button on this person");
  }

  _pressCheckBtn(index) {
    // TODO: Implement function here
    print("Pressing CHECK button on this person");
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
              onPressed: () {},
              padding: EdgeInsets.all(0.0),
              splashColor: R.colors.lightBlurMajorOrange,
              textColor: Colors.white,
              child: CustomPopupMenu(
                items: widget.popUpMenu,
                onSelected: (index) {
                  _showCustomDialog(index);
                },
                popupImage: Image.asset(
                  R.myIcons.appBarPopupMenuIcon,
                  width: R.appRatio.appAppBarIconSize,
                  height: R.appRatio.appAppBarIconSize,
                  fit: BoxFit.contain,
                ),
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
            items: widget.tabBarItems,
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
    String avatarImageURL = items[index].avatarImageURL;
    String supportImageURL = items[index].supportImageURL;
    String name = items[index].name;
    String location = items[index].location;

    switch (_selectedTabIndex) {
      case 0: // All
        bool isFollowing = items[index].isFollowing;
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
          enableFFButton: true,
          isFollowButton: (isFollowing ? false : true),
          pressFFButton: (isFollowing
              ? () => _pressUnFollowBtn(index)
              : () => _pressFollowBtn(index)),
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
          pressCloseButton: () => _pressCloseBtn(index),
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
