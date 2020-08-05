import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/manager/data_manager.dart';
import 'package:usrun/manager/user_manager.dart';
import 'package:usrun/page/event/event_page.dart';
import 'package:usrun/page/feed/athlete_search_page.dart';
import 'package:usrun/page/feed/feed_page.dart';
import 'package:usrun/page/profile/profile_edit_page.dart';
import 'package:usrun/page/profile/profile_page.dart';
import 'package:usrun/page/record/record_page.dart';
import 'package:usrun/page/team/team_search_page.dart';
import 'package:usrun/page/setting/setting_page.dart';
import 'package:usrun/page/team/team_page.dart';
import 'package:usrun/widget/avatar_view.dart';
import 'package:usrun/util/image_cache_manager.dart';
import 'package:usrun/widget/custom_gradient_app_bar.dart';

class DrawerItem {
  String title;
  String icon;
  String activeIcon;

  DrawerItem(this.title, this.icon, this.activeIcon);
}

class AppPage extends StatefulWidget {
  @override
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  final List<Widget> pages = [
    RecordPage(),
    FeedPage(),
    EventPage(),
    TeamPage(),
    ProfilePage(),
    SettingPage()
  ];

  final drawerItems = [
    DrawerItem(
        R.strings.record, R.myIcons.drawerRecord, R.myIcons.drawerActiveRecord),
    DrawerItem(
        R.strings.uFeed, R.myIcons.drawerUfeed, R.myIcons.drawerActiveUfeed),
    DrawerItem(
        R.strings.events, R.myIcons.drawerEvents, R.myIcons.drawerActiveEvents),
    DrawerItem(
        R.strings.teams, R.myIcons.drawerTeams, R.myIcons.drawerActiveTeams),
    DrawerItem(R.strings.profile, R.myIcons.drawerProfile,
        R.myIcons.drawerActiveProfile),
    DrawerItem(R.strings.settings, R.myIcons.drawerSettings,
        R.myIcons.drawerActiveSettings),
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedDrawerIndex = DataManager.getUserDefaultTab();
  String _avatar = UserManager.currentUser.avatar;
  String _supportAvatar =
      UserManager.currentUser.hcmus ? R.myIcons.hcmusLogo : null;
  String _fullName = UserManager.currentUser.name;
  String _userCode = UserManager.currentUser.code == null
      ? "USRUN${UserManager.currentUser.userId}"
      : UserManager.currentUser.code;

  _onSelectItem(int index) {
    if (_selectedDrawerIndex == index) return;

    setState(() {
      _selectedDrawerIndex = index;
    });

    // Close the drawer
    Navigator.of(context).pop();
  }

  _openDrawer() {
    _scaffoldKey.currentState.openDrawer();
  }

  List<Widget> _appBarActionList() {
    Widget wrapWidget(String iconUrl, Function func) {
      return Container(
        width: R.appRatio.appWidth60,
        child: FlatButton(
          onPressed: func,
          padding: EdgeInsets.all(0.0),
          splashColor: R.colors.lightBlurMajorOrange,
          textColor: Colors.white,
          child: ImageCacheManager.getImage(
            url: iconUrl,
            width: R.appRatio.appAppBarIconSize,
            height: R.appRatio.appAppBarIconSize,
            color: Colors.white,
          ),
        ),
      );
    }

    List<Widget> list = List<Widget>();
    switch (_selectedDrawerIndex) {
      case 0: // Record page
        list.add(Container());
        break;
      case 1: // Feed page
        list.add(
          wrapWidget(
            R.myIcons.appBarSearchBtn,
            () {
              pushPage(
                context,
                AthleteSearchPage(),
              );
            },
          ),
        );
        break;
        break;
      case 2: // Event page
        list.add(Container());
        break;
      case 3: // Team page
        list.add(
          wrapWidget(
            R.myIcons.appBarSearchBtn,
            () {
              pushPage(
                context,
                TeamSearchPage(autoFocusInput: true, defaultList: null),
              );
            },
          ),
        );
        break;
      case 4: // Profile page
        list.add(
          wrapWidget(
            R.myIcons.appBarEditBtn,
            () => pushPage(context, EditProfilePage()),
          ),
        );
        break;
      case 5: // Setting page
        list.add(Container());
        break;
      default: // None of above
        list.add(Container());
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    var drawerWidgets = <Widget>[];
    for (var i = 0; i < drawerItems.length; i++) {
      var item = drawerItems[i];
      drawerWidgets.add(FlatButton(
        onPressed: () => _onSelectItem(i),
        padding: EdgeInsets.all(0),
        textColor: Colors.white,
        child: Container(
          height: R.appRatio.appHeight60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  right: R.appRatio.appSpacing25,
                ),
                child: Image.asset(
                  (i == _selectedDrawerIndex ? item.activeIcon : item.icon),
                  width: R.appRatio.appIconSize25,
                  height: R.appRatio.appIconSize25,
                ),
              ),
              Container(
                width: R.appRatio.appWidth100,
                child: Text(
                  item.title.toUpperCase(),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: R.appRatio.appFontSize18,
                    color: i == _selectedDrawerIndex
                        ? R.colors.oldYellow
                        : Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ));
    }

    Widget _buildElement = Scaffold(
      key: _scaffoldKey,
      appBar: CustomGradientAppBar(
        leadingFunction: () => _openDrawer(),
        leadingIconUrl: R.myIcons.menuIcon,
        actions: _appBarActionList(),
        titleWidget: Text(
          drawerItems[_selectedDrawerIndex].title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      backgroundColor: R.colors.appBackground,
      drawer: Container(
        constraints: new BoxConstraints.expand(
          width: R.appRatio.appWidth250,
          height: R.appRatio.deviceHeight,
        ),
        child: Stack(
          children: <Widget>[
            Image.asset(
              R.images.drawerBackground,
              fit: BoxFit.cover,
              width: R.appRatio.appWidth250,
              height: R.appRatio.deviceHeight,
            ),
            Center(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: R.appRatio.appSpacing50,
                  ),
                  AvatarView(
                    avatarImageURL: _avatar,
                    avatarImageSize: R.appRatio.appAvatarSize130,
                    supportImageURL: _supportAvatar,
                    avatarBoxShadow: BoxShadow(
                      blurRadius: 20.0,
                      color: R.colors.oldYellow,
                      offset: Offset(0.0, 0.0),
                    ),
                  ),
                  SizedBox(
                    height: R.appRatio.appSpacing20,
                  ),
                  Text(
                    _fullName ?? "",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: R.appRatio.appFontSize20,
                    ),
                  ),
                  SizedBox(
                    height: R.appRatio.appSpacing5,
                  ),
                  Text(
                    _userCode,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: R.colors.oldYellow,
                      fontSize: R.appRatio.appFontSize18,
                    ),
                  ),
                  SizedBox(
                    height: R.appRatio.appSpacing25,
                  ),
                  Container(
                    height: 1,
                    width: R.appRatio.appWidth200,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: R.colors.oldYellow,
                        width: 1,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: R.appRatio.appSpacing25,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: drawerWidgets,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
          child: IndexedStack(
            index: _selectedDrawerIndex,
            children: pages,
          ),
          onNotification: (overScroll) {
            overScroll.disallowGlow();
            return false;
          }),
    );

    return WillPopScope(
      child: _buildElement,
      onWillPop: () async {
        if (_scaffoldKey.currentState.isDrawerOpen) {
          pop(context);
          return false;
        } else {
          // TODO: return await showCustomExitDialog(context);
          return false;
        }
      },
    );
  }
}
