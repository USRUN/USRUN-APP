import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/manager/data_manager.dart';
import 'package:usrun/manager/user_manager.dart';
import 'package:usrun/model/response.dart';
import 'package:usrun/model/user.dart';
import 'package:usrun/model/user_activity.dart';
import 'package:usrun/page/feed/edit_activity_page.dart';
import 'package:usrun/page/feed/user_activity_page.dart';
import 'package:usrun/page/profile/profile_page.dart';
import 'package:usrun/util/date_time_utils.dart';
import 'package:usrun/util/image_cache_manager.dart';
import 'package:usrun/util/validator.dart';
import 'package:usrun/widget/avatar_view.dart';
import 'package:usrun/widget/custom_cell.dart';
import 'package:usrun/widget/custom_dialog/custom_alert_dialog.dart';
import 'package:usrun/widget/custom_popup_menu/custom_popup_item.dart';
import 'package:usrun/widget/custom_popup_menu/custom_popup_menu.dart';
import 'package:usrun/widget/my_info_box/normal_info_box.dart';
import 'package:usrun/widget/photo_list/photo_item.dart';
import 'package:usrun/widget/photo_list/photo_list.dart';

class CompactUserActivityItem extends StatefulWidget {
  final UserActivity userActivity;
  final Function callbackFunc;

  CompactUserActivityItem(
      {@required this.userActivity, @required this.callbackFunc});

  @override
  _CompactUserActivityItemState createState() =>
      _CompactUserActivityItemState();
}

class _CompactUserActivityItemState extends State<CompactUserActivityItem> {
  final double _spacing = 15.0;
  final double _textSpacing = 5.0;
  bool isPushing = false;
  BuildContext dialogContext;
  final List<PopupItem<int>> _popupItemList = [
    PopupItem<int>(
      title: R.strings.editActivity,
      titleStyle: TextStyle(
        fontSize: 16,
        color: R.colors.contentText,
      ),
      value: 0,
      iconURL: R.myIcons.editIconByTheme,
      iconSize: 14,
    ),
    PopupItem<int>(
      title: R.strings.deleteActivity,
      titleStyle: TextStyle(
        fontSize: 16,
        color: R.colors.contentText,
      ),
      value: 1,
      iconURL: R.myIcons.closeIconByTheme,
      iconSize: 14,
    ),
  ];

  UserActivity _userActivity;

  @override
  void initState() {
    super.initState();
    _userActivity = widget.userActivity;
  }

  _goToUserActivityPage() async {
    UserActivity newUserActivity = await pushPage(
      context,
      UserActivityPage(
        userActivity: _userActivity,
      ),
    );

    if (newUserActivity != null) {
      setState(() {
        _userActivity = newUserActivity;
      });
    }
  }

  _goToUserProfile() async {
    if (isPushing) {
      return;
    }
    isPushing = true;

    if (_userActivity.userId == UserManager.currentUser.userId) {
      await pushPage(
        context,
        ProfilePage(
          userInfo: UserManager.currentUser,
          enableAppBar: true,
        ),
      );
    } else {
      Response<dynamic> response =
          await UserManager.getUserInfo(_userActivity.userId);
      if (response.success && response.errorCode == -1) {
        User user = response.object;

        await pushPage(
            context, ProfilePage(userInfo: user, enableAppBar: true));
      } else {
        await showCustomAlertDialog(
          context,
          title: R.strings.error,
          content: response.errorMessage,
          firstButtonText: R.strings.ok,
          firstButtonFunction: () {
            pop(context);
          },
        );
      }
    }
    isPushing = false;
  }

  void _onSelectedPopup(var value) async {
    switch (value) {
      case 0:
        // Edit activity
        UserActivity newUserActivity = await pushPage(
          context,
          EditActivityPage(
            userActivity: _userActivity,
          ),
        );

        if (newUserActivity != null) {
          setState(() {
            _userActivity = newUserActivity;
          });
        }
        break;
      case 1:
        // Delete current activity
        {
          bool willDelete = await showCustomAlertDialog(
            context,
            title: R.strings.caution,
            content: R.strings.confirmActivityDeletion,
            firstButtonText: R.strings.delete.toUpperCase(),
            firstButtonFunction: () {
              pop(context, object: true);
            },
            secondButtonText: R.strings.cancel.toUpperCase(),
            secondButtonFunction: () => pop(context, object: false),
          );
          if (willDelete) _deleteActivity();
        }
        break;
    }
  }

  Widget _renderHeader() {
    bool _enablePopupMenuButton = false;
    if (_userActivity.userId == UserManager.currentUser.userId) {
      _enablePopupMenuButton = true;
    }

    return CustomCell(
      enableSplashColor: false,
      avatarView: AvatarView(
        avatarImageURL: _userActivity.userAvatar,
        avatarImageSize: 50,
        avatarBoxBorder: Border.all(
          width: 1,
          color: R.colors.majorOrange,
        ),
        pressAvatarImage: _goToUserProfile,
        supportImageURL: _userActivity.userHcmus ? R.myIcons.hcmusLogo : null,
        supportImageBorder: Border.all(
          width: 0.6,
          color: R.colors.supportAvatarBorder,
        ),
      ),
      enableAddedContent: false,
      pressInfo: _goToUserProfile,
      title: _userActivity.userDisplayName,
      titleStyle: TextStyle(
        color: R.colors.contentText,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      subTitle: formatDateTime(
        _userActivity.createTime,
        formatDisplay: formatTimeDateConst,
      ),
      subTitleStyle: TextStyle(
        color: R.colors.contentText,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      padding: EdgeInsets.fromLTRB(
        _spacing,
        _spacing,
        _spacing,
        0,
      ),
      enablePopupMenuButton: _enablePopupMenuButton,
      customPopupMenu: CustomPopupMenu<int>(
        onSelected: _onSelectedPopup,
        items: _popupItemList,
        enableChild: true,
        popupChild: Container(
          width: R.appRatio.appWidth50,
          padding: EdgeInsets.only(top: 8),
          alignment: Alignment.topRight,
          child: ImageCacheManager.getImage(
            url: R.myIcons.popupMenuIconByTheme,
            width: 16,
            height: 16,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _renderTitleAndDescription() {
    bool enableReadMore = false;
    String description = _userActivity.description;

    int maxDescriptionLength = 160;
    if (!checkStringNullOrEmpty(description) &&
        description.length > maxDescriptionLength) {
      enableReadMore = true;
      description = description.substring(
        0,
        maxDescriptionLength,
      );
      description += "...";
    }

    Widget _titleWidget = Text(
      _userActivity.title,
      textAlign: TextAlign.left,
      textScaleFactor: 1.0,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: R.colors.contentText,
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
    );

    Widget _descriptionWidget = Container();
    if (!checkStringNullOrEmpty(description)) {
      _descriptionWidget = Container(
        margin: EdgeInsets.only(top: _textSpacing),
        child: Text(
          description,
          textAlign: TextAlign.left,
          textScaleFactor: 1.0,
          overflow: TextOverflow.ellipsis,
          maxLines: 10,
          style: TextStyle(
            color: R.colors.contentText,
            fontWeight: FontWeight.normal,
            fontSize: 15,
          ),
        ),
      );
    }

    Widget _readMoreWidget = Container();
    if (enableReadMore) {
      _readMoreWidget = Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(
          top: _textSpacing,
        ),
        child: InkWell(
          onTap: _goToUserActivityPage,
          splashColor: Colors.white,
          child: Text(
            R.strings.readMore,
            textAlign: TextAlign.left,
            textScaleFactor: 1.0,
            softWrap: true,
            style: TextStyle(
              color: R.colors.normalNoteText,
              fontWeight: FontWeight.normal,
              fontSize: 14,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      );
    }

    return FlatButton(
      onPressed: _goToUserActivityPage,
      splashColor: R.colors.lightBlurMajorOrange,
      textColor: Colors.white,
      padding: EdgeInsets.all(0),
      child: Container(
        margin: EdgeInsets.all(_spacing),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _titleWidget,
            _descriptionWidget,
            _readMoreWidget,
          ],
        ),
      ),
    );
  }

  Widget _renderPhotos() {
    String mapPhoto;
    if (_userActivity.photos.isEmpty)
      mapPhoto = R.images.logoText;
    else
      mapPhoto = _userActivity.photos[0];

    List<PhotoItem> photoList;
    if (_userActivity.photos.length > 1) {
      photoList = List();
      for (int i = 1; i < _userActivity.photos.length; ++i) {
        String img = _userActivity.photos[i];
        photoList.add(PhotoItem(
          imageURL: img,
          thumbnailURL: img,
        ));
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        GestureDetector(
          onTap: _goToUserActivityPage,
          child: ImageCacheManager.getImage(
            url: mapPhoto,
            height: 220,
            fit: BoxFit.cover,
          ),
        ),
        (photoList != null
            ? PhotoList(
                items: photoList,
              )
            : Container()),
      ],
    );
  }

  Widget _buildStatsBox({
    @required String firstTitle,
    @required String data,
    @required String unitTitle,
  }) {
    return NormalInfoBox(
      boxSize: R.appRatio.deviceWidth * 0.3,
      id: firstTitle,
      firstTitleLine: firstTitle,
      secondTitleLine: unitTitle,
      dataLine: data,
      disableGradientLine: true,
      boxRadius: 0,
      disableBoxShadow: true,
      pressBox: null,
    );
  }

  Widget _renderStatisticBox() {
    Widget _distanceWidget = _buildStatsBox(
      firstTitle: R.strings.distance,
      data: switchDistanceUnit(_userActivity.totalDistance).toString(),
      unitTitle: R.strings.distanceUnit[DataManager.getUserRunningUnit().index],
    );

    Widget _timeWidget = _buildStatsBox(
      firstTitle: R.strings.time,
      data: secondToTimeFormat(_userActivity.totalTime),
      unitTitle: R.strings.timeUnit,
    );

    Widget _avgPaceWidget = _buildStatsBox(
      firstTitle: R.strings.avgPace,
      data: secondToMinFormat(_userActivity.avgPace.toInt()),
      unitTitle: R.strings.avgPaceUnit,
    );

    double _cellHeight = 90;

    return Container(
      height: _cellHeight,
      margin: EdgeInsets.all(_spacing),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: _distanceWidget,
          ),
          Container(
            width: 1,
            height: _cellHeight,
            child: VerticalDivider(
              color: R.colors.majorOrange,
              thickness: 1.0,
            ),
          ),
          Expanded(
            child: _timeWidget,
          ),
          Container(
            width: 1,
            height: _cellHeight,
            child: VerticalDivider(
              color: R.colors.majorOrange,
              thickness: 1.0,
            ),
          ),
          Expanded(
            child: _avgPaceWidget,
          ),
        ],
      ),
    );
  }

  Widget _renderInteractionBox() {
    // TODO: Code interaction box here (Like, Discussion, Share)
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    dialogContext = context;
    return Container(
      decoration: BoxDecoration(
        color: R.colors.appBackground,
        boxShadow: [
          BoxShadow(
            blurRadius: 4.0,
            offset: Offset(0.0, 0.0),
            color: R.colors.textShadow,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _renderHeader(),
          _renderTitleAndDescription(),
          _renderPhotos(),
          _renderStatisticBox(),
          _renderInteractionBox(),
        ],
      ),
    );
  }

  _deleteActivity() async {
    Response<dynamic> result =
        await UserManager.deleteActivity(_userActivity.userActivityId);
    if (result.success) {
      showCustomAlertDialog(context,
          title: R.strings.announcement,
          content: R.strings.successfullyDeleted,
          firstButtonText: R.strings.ok, firstButtonFunction: () async {
        pop(context);
        await widget.callbackFunc();
      });
    } else {
      showCustomAlertDialog(context,
          title: R.strings.announcement,
          content: result.errorMessage,
          firstButtonText: R.strings.ok, firstButtonFunction: () {
        pop(context);
      });
    }
  }
}
