import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/page/event/event_page.dart';
import 'package:usrun/page/feed/feed_page.dart';
import 'package:usrun/page/profile/edit_profile.dart';
import 'package:usrun/page/profile/profile_page.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:usrun/page/record/record_page.dart';
import 'package:usrun/page/setting/setting_page.dart';
import 'package:usrun/page/team/team_page.dart';
import 'package:usrun/widget/avatar_view.dart';

class DrawerItem {
  String title;
  String icon;
  String activeIcon;
  DrawerItem(this.title, this.icon, this.activeIcon);
}

class AppPage extends StatefulWidget {
  final drawerItems = [
    DrawerItem(R.strings.record, R.myIcons.drawerRecord, R.myIcons.drawerActiveRecord),
    DrawerItem(R.strings.uFeed, R.myIcons.drawerUfeed, R.myIcons.drawerActiveUfeed),
    DrawerItem(R.strings.events, R.myIcons.drawerEvents, R.myIcons.drawerActiveEvents),
    DrawerItem(R.strings.teams, R.myIcons.drawerTeams, R.myIcons.drawerActiveTeams),
    DrawerItem(R.strings.profile, R.myIcons.drawerProfile, R.myIcons.drawerActiveProfile),
    DrawerItem(R.strings.settings, R.myIcons.drawerSettings, R.myIcons.drawerActiveSettings),
  ];

  @override
  _AppPageState createState() => _AppPageState();
}


class _AppPageState extends State<AppPage> {
  int _selectedDrawerIndex = 0;
  String _avatar = R.images.avatarQuocTK;
  String _supportAvatar = R.images.avatar;
  String _fullName = "We Are USRUN";
  String _userCode = "USR9381852";

    final List<Widget> pages = [RecordPage(),FeedPage(),EventPage(),ProfilePage(),SettingPage()];
  _getDrawerItemWidget(int pos) {

    
  
  
    switch (pos) {
      case 0:
        return new RecordPage();
      case 1:
        return new FeedPage();
      case 2:
        return new EventPage();
      case 3:
        return new TeamPage();
      case 4:
        return new ProfilePage();
      case 5:
        return new SettingPage();
      default:
        return new FeedPage();
    }
  }

  _onSelectItem(int index) {
    setState(() {
      _selectedDrawerIndex = index;
    });

    // Close the drawer
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var drawerWidgets = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var item = widget.drawerItems[i];
      drawerWidgets.add(new GestureDetector(
        onTap: () => _onSelectItem(i),
        child: new Container(
          width: R.appRatio.appWidth150,
          padding: EdgeInsets.only(
            bottom: R.appRatio.appSpacing30,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
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
              Text(
                item.title.toUpperCase(),
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: R.appRatio.appFontSize18,
                    color: i == _selectedDrawerIndex
                        ? R.colors.oldYellow
                        : Colors.white),
              ),
            ],
          ),
        ),
      ));
    }

    return Scaffold(
      appBar: GradientAppBar(
        gradient: R.colors.uiGradient,
        centerTitle: true,
        title: Text(
          widget.drawerItems[_selectedDrawerIndex].title,
          style: TextStyle(
              color: Colors.white, fontSize: R.appRatio.appFontSize22),
        ),
        actions: <Widget>[
          (_selectedDrawerIndex == 4
              ? IconButton(
                  icon: Image.asset(
                    R.myIcons.appBarEditBtn,
                    width: R.appRatio.appAppBarIconSize,
                  ),
                  onPressed: () {
                    pushPage(context, EditProfilePage());
                  },
                )
              : Container()),
        ],
      ),
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
                      _fullName,
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
                      child:
                          NotificationListener<OverscrollIndicatorNotification>(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: drawerWidgets,
                                ),
                              ),
                              onNotification: (overscroll) {
                                overscroll.disallowGlow();
                              }),
                    ),
                  ],
                ),
              )
            ],
          )),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}
