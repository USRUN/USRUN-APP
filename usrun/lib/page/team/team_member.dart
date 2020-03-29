import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/demo_data.dart';
import 'package:usrun/widget/avatar_view.dart';
import 'package:usrun/widget/custom_cell.dart';
import 'package:usrun/widget/custom_popup_menu.dart';
import 'package:usrun/widget/custom_tab_bar.dart';
import 'package:usrun/widget/loading_dot.dart';

class TeamMember extends StatefulWidget {
  final tabBarItems = [
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

  @override
  _TeamMemberState createState() => _TeamMemberState();
}

class _TeamMemberState extends State<TeamMember> {
  bool _isLoading = false;
  int _selectedTabIndex;
  List items = List();

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
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _loadSuitableData(_selectedTabIndex));
  }

  void _getAllMembers() {
    setState(() {
      _isLoading = !_isLoading;
    });

    // TODO: Implement function here
    Future.delayed(Duration(milliseconds: 1000), () {
      return items = DemoData().allTeamMember;
    }).then((val) {
      setState(() {
        _isLoading = !_isLoading;
        items = val;
      });
    });
  }

  void _getRequestingMembers() {
    setState(() {
      _isLoading = !_isLoading;
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
  }

  void _getBlockingMembers() {
    setState(() {
      _isLoading = !_isLoading;
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

  _onSelectItem(int tabIndex) {
    if (_selectedTabIndex == tabIndex) return;
    setState(() {
      _selectedTabIndex = tabIndex;
      _loadSuitableData(tabIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildElement = Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: R.colors.appBackground,
      appBar: GradientAppBar(
        leading: new IconButton(
          icon: Image.asset(
            R.myIcons.appBarBackBtn,
            width: R.appRatio.appAppBarIconSize,
          ),
          onPressed: () => pop(context),
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
            padding: EdgeInsets.only(
              right: R.appRatio.appSpacing15 - 2,
            ),
            child: CustomPopupMenu(
              items: DemoData().popupMenuList02,
              onSelected: (index) {
                // TODO: Implement function here
                print("Index $index is selected");
              },
              popupImage: Image.asset(
                R.myIcons.appBarPopupMenuIcon,
                width: R.appRatio.appAppBarIconSize,
                height: R.appRatio.appAppBarIconSize,
                fit: BoxFit.contain,
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
            ),
          ),
        ],
      ),
    );

    return NotificationListener<OverscrollIndicatorNotification>(
        child: _buildElement,
        onNotification: (overscroll) {
          overscroll.disallowGlow();
        });
  }

  Widget _renderList() {
    return Container(
      padding: EdgeInsets.only(
        left: R.appRatio.appSpacing15,
        right: R.appRatio.appSpacing15,
      ),
      child: AnimationLimiter(
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: items.length,
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
      ),
    );
  }

  Widget _renderCustomCell(index) {
    String avatarImageURL = items[index]['avatarImageURL'];
    String supportImageURL = items[index]['supportImageURL'];
    String name = items[index]['name'];
    String location = items[index]['location'];

    switch (_selectedTabIndex) {
      case 0: // All
        bool isFollowing = items[index]['isFollowing'];
        return CustomCell(
          avatarView: AvatarView(
            avatarImageURL: avatarImageURL,
            avatarImageSize: R.appRatio.appWidth60,
            avatarBoxBorder: Border.all(
              width: 1,
              color: R.colors.majorOrange,
            ),
            supportImageURL: supportImageURL,
            pressAvatarImage: () {
              // TODO: Implement function here
              print("Pressing avatar image");
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
            // TODO: Implement function here
            print("Pressing info");
          },
          centerVerticalSuffix: true,
          enableFFButton: true,
          isFollowButton: (isFollowing ? false : true),
          pressFFButton: (isFollowing
              ? () {
                  // TODO: Implement function here
                  print("Pressing UNFOLLOW button on this person");
                }
              : () {
                  // TODO: Implement function here
                  print("Pressing FOLLOWING button on this person");
                }),
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
            pressAvatarImage: () {
              // TODO: Implement function here
              print("Pressing avatar image");
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
            // TODO: Implement function here
            print("Pressing info");
          },
          centerVerticalSuffix: true,
          enableCloseButton: true,
          pressCloseButton: () {
            // TODO: Implement function here
            print("Pressing CLOSE button on this person");
          },
          enableCheckButton: true,
          pressCheckButton: () {
            // TODO: Implement function here
            print("Pressing CHECK button on this person");
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
            supportImageURL: supportImageURL,
            pressAvatarImage: () {
              // TODO: Implement function here
              print("Pressing avatar image");
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
            // TODO: Implement function here
            print("Pressing info");
          },
          centerVerticalSuffix: true,
          enableCloseButton: true,
          pressCloseButton: () {
            // TODO: Implement function here
            print("Pressing CLOSE button on this person");
          },
        );
      default:
        return Container();
    }
  }
}
