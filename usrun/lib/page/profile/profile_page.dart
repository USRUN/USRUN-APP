import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
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


  final RefreshController _refreshController = RefreshController(
      initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _initNecessaryData();
  }


  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _avatarImageURL = R.images.avatar;
      _supportImageURL = R.images.avatar;
      _fullName = R.strings.na;
      _userCode = R.strings.na;
    });
    _refreshController.refreshCompleted();
  }

  void _displayProfile() {
    _avatarImageURL = _userInfo.avatar;
    _supportImageURL =
    _userInfo.hcmus ? R.myIcons.hcmusLogo : null;
    _fullName = _userInfo.name;
    _userCode = _userInfo.code == null
        ? "USRUN${_userInfo.userId}"
        : _userInfo.code;
  }

  void _initNecessaryData() {
    _selectedTabIndex = 0;
    _userInfo = widget.userInfo == null? UserManager.currentUser: widget.userInfo;
    _avatarImageURL = "";
    _supportImageURL = "";
    _fullName = "";
    _userCode = "";

    _displayProfile();

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
          width: 55,
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

    _renderBodyContent() {
      return SingleChildScrollView(
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
      );
    }

    @override
    Widget build(BuildContext context) {
      Widget smartRefresher = SmartRefresher(
        enablePullUp: false,
        controller: _refreshController,
        child: _renderBodyContent(),
        physics: BouncingScrollPhysics(),
        footer: null,
        onRefresh: () => _loadData(),
        onLoading: () async {
          await Future.delayed(Duration(milliseconds: 200));
        },
      );

      Widget refreshConfigs = RefreshConfiguration(
        child: smartRefresher,
        headerBuilder: () =>
            WaterDropMaterialHeader(
              backgroundColor: R.colors.majorOrange,
            ),
        footerBuilder: null,
        shouldFooterFollowWhenNotFull: (state) {
          return false;
        },
        hideFooterWhenNotFull: true,
      );

      return NotificationListener<OverscrollIndicatorNotification>(
          child: refreshConfigs,
          onNotification: (overScroll) {
            overScroll.disallowGlow();
            return false;
          });
    }
}

