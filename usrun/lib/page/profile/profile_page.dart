import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/manager/user_manager.dart';
import 'package:usrun/page/profile/profile_activity.dart';
import 'package:usrun/page/profile/profile_info.dart';
import 'package:usrun/page/profile/profile_stats.dart';
import 'package:usrun/widget/avatar_view.dart';
import 'package:usrun/widget/custom_tab_bar.dart';

class ProfilePage extends StatefulWidget {
  final tabBarItems = [
    {
      "iconURL": R.myIcons.whiteStatisticsIcon,
    },
    {
      "iconURL": R.myIcons.whiteShoeIcon,
    },
    {
      "iconURL": R.myIcons.whiteInfoIcon,
    }
  ];

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedTabIndex = 0;
  String _avatarImageURL = UserManager.currentUser.avatar;
  String _supportImageURL = UserManager.currentUser.hcmus?R.myIcons.hcmusLogo:null;
  String _fullName = UserManager.currentUser.name;
  String _userCode = UserManager.currentUser.code==null?"USRUN${UserManager.currentUser.userId}":UserManager.currentUser.code;

  dynamic _getContentItemWidget(int tabIndex) {
    Widget widget;

    switch (tabIndex) {
      case 0:
        widget = ProfileStats();
        break;
      case 1:
        widget = ProfileActivity();
        break;
      case 2:
        widget = ProfileInfo();
        break;
      default:
        widget = ProfileStats();
        break;
    }

    return widget;
  }

  _onSelectItem(int tabIndex) {
    if (_selectedTabIndex == tabIndex) return;
    setState(() {
      _selectedTabIndex = tabIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colors.appBackground,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: R.appRatio.appSpacing25,
            ),
            Align(
              alignment: Alignment.center,
              child: AvatarView(
                avatarImageURL: _avatarImageURL,
                avatarImageSize: R.appRatio.appAvatarSize130,
                supportImageURL: _supportImageURL,
                avatarBoxBorder: Border.all(
                  color: R.colors.majorOrange,
                  width: 2,
                ),
              ),
            ),
            SizedBox(
              height: R.appRatio.appSpacing20,
            ),
            Text(
              _fullName,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: R.colors.contentText,
                fontSize: R.appRatio.appFontSize20,
              ),
            ),
            SizedBox(
              height: R.appRatio.appSpacing5,
            ),
            Text(
              _userCode,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: R.colors.contentText,
                fontSize: R.appRatio.appFontSize18,
              ),
            ),
            SizedBox(
              height: R.appRatio.appSpacing20,
            ),
            CustomTabBarStyle01(
              selectedTabIndex: _selectedTabIndex,
              items: widget.tabBarItems,
              pressTab: _onSelectItem,
            ),
            SizedBox(
              height: R.appRatio.appSpacing20,
            ),
            _getContentItemWidget(_selectedTabIndex),
          ],
        ),
      ),
    );
  }
}
