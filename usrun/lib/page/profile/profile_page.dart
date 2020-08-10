import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/manager/user_manager.dart';
import 'package:usrun/model/user.dart';
import 'package:usrun/page/profile/profile_activity.dart';
import 'package:usrun/page/profile/profile_edit_page.dart';
import 'package:usrun/page/profile/profile_info.dart';
import 'package:usrun/page/profile/profile_stats.dart';
import 'package:usrun/util/image_cache_manager.dart';
import 'package:usrun/widget/avatar_view.dart';
import 'package:usrun/widget/custom_gradient_app_bar.dart';
import 'package:usrun/widget/custom_tab_bar.dart';

class ProfilePage extends StatefulWidget {
  final tabBarItems = [
    R.myIcons.whiteStatisticsIcon,
    R.myIcons.whiteShoeIcon,
    R.myIcons.whiteInfoIcon,
  ];

  final User userInfo;
  final bool enableAppBar;

  ProfilePage({
    this.userInfo,
    this.enableAppBar = false,
  });

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedTabIndex;
  User _userInfo;
  String _avatarImageURL;
  String _supportImageURL;
  String _fullName;
  String _userCode;

  @override
  void initState() {
    super.initState();
    _initNecessaryData();
  }

  void _loadUserData() async {
    if (widget.userInfo == null) {
      return;
    }

    // TODO: Call API to get user profile information from _userInfo.userId
    // P/s: This user info is not the sign-in user

    setState(() {
      // TODO: Change "null" and "N/A" to the value after calling API
      _avatarImageURL = R.images.avatar;
      _supportImageURL = R.images.avatar;
      _fullName = "N/A";
      _userCode = "N/A";
    });
  }

  void _initNecessaryData() {
    _selectedTabIndex = 0;
    _userInfo = widget.userInfo ?? UserManager.currentUser;
    _avatarImageURL = "";
    _supportImageURL = "";
    _fullName = "";
    _userCode = "";

    void _displayMyOwnProfile() {
      _avatarImageURL = UserManager.currentUser.avatar;
      _supportImageURL =
          UserManager.currentUser.hcmus ? R.myIcons.hcmusLogo : null;
      _fullName = UserManager.currentUser.name;
      _userCode = UserManager.currentUser.code == null
          ? "USRUN${UserManager.currentUser.userId}"
          : UserManager.currentUser.code;
    }

    if (_userInfo == null) {
      _displayMyOwnProfile();
    } else {
      if (_userInfo.userId == UserManager.currentUser.userId) {
        _displayMyOwnProfile();
      } else {
        _loadUserData();
      }
    }
  }

  Widget _renderAppBar() {
    if (!widget.enableAppBar) {
      return null;
    }

    Widget _renderEditButton() {
      if (_userInfo != null) {
        return Container();
      }

      return Container(
        width: 50,
        child: FlatButton(
          onPressed: () => pushPage(context, EditProfilePage()),
          padding: EdgeInsets.all(0.0),
          splashColor: R.colors.lightBlurMajorOrange,
          textColor: Colors.white,
          child: ImageCacheManager.getImage(
            url: R.myIcons.appBarEditBtn,
            width: 18,
            height: 18,
            color: Colors.white,
          ),
        ),
      );
    }

    return CustomGradientAppBar(
      title: R.strings.profile,
      actions: <Widget>[
        _renderEditButton(),
      ],
    );
  }

  dynamic _getContentItemWidget(int tabIndex) {
    Widget widget;
    // TODO: Pass the value of "_userInfo" as a param of these widget page
    switch (tabIndex) {
      case 0:
        widget = ProfileStats();
        break;
      case 1:
        widget = ProfileActivity();
        break;
      case 2:
        widget = ProfileInfo(
          userId: _userInfo.userId,
        );
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
    Widget _buildElement = Scaffold(
      backgroundColor: R.colors.appBackground,
      appBar: _renderAppBar(),
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
                avatarImageSize: 120,
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

    return NotificationListener<OverscrollIndicatorNotification>(
        child: _buildElement,
        onNotification: (overScroll) {
          overScroll.disallowGlow();
          return false;
        });
  }
}
