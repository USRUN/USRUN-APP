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
import 'package:usrun/page/profile/profile_page.dart';
import 'package:usrun/util/date_time_utils.dart';
import 'package:usrun/util/image_cache_manager.dart';
import 'package:usrun/util/validator.dart';
import 'package:usrun/widget/avatar_view.dart';
import 'package:usrun/widget/charts/splits_chart.dart';
import 'package:usrun/widget/custom_cell.dart';
import 'package:usrun/widget/custom_dialog/custom_alert_dialog.dart';
import 'package:usrun/widget/custom_popup_menu/custom_popup_item.dart';
import 'package:usrun/widget/custom_popup_menu/custom_popup_menu.dart';
import 'package:usrun/widget/photo_list/photo_item.dart';
import 'package:usrun/widget/photo_list/photo_list.dart';

class FullUserActivityItem extends StatefulWidget {
  final UserActivity userActivity;

  FullUserActivityItem({
    @required this.userActivity,
  });

  @override
  _FullUserActivityItemState createState() => _FullUserActivityItemState();
}

class _FullUserActivityItemState extends State<FullUserActivityItem> {
  final double _spacing = 15.0;
  bool isPushing = false;
  final double _textSpacing = 5.0;
  final List<PopupItem<int>> _popupItemList = [
    PopupItem<int>(
      title: R.strings.editActivity,
      titleStyle: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
      value: 0,
      iconURL: R.myIcons.blackEditIcon,
      iconSize: 14,
    ),
    PopupItem<int>(
      title: R.strings.deleteActivity,
      titleStyle: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
      value: 1,
      iconURL: R.myIcons.blackCloseIcon,
      iconSize: 14,
    ),
  ];

  UserActivity _userActivity;

  @override
  void initState() {
    super.initState();
    _userActivity = widget.userActivity;
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
        showCustomAlertDialog(
          context,
          title: R.strings.caution,
          content: R.strings.confirmActivityDeletion,
          firstButtonText: R.strings.delete.toUpperCase(),
          firstButtonFunction: () {
            // TODO: Call API to delete this activity
            print("Call API to delete this activity");

            pop(context);
            pop(context);
          },
          secondButtonText: R.strings.cancel.toUpperCase(),
          secondButtonFunction: () => pop(context),
        );
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

    Widget _descriptionWidget = Container(
      margin: EdgeInsets.only(top: _textSpacing),
      child: Text(
        _userActivity.description,
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

    return Container(
      margin: EdgeInsets.all(_spacing),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _titleWidget,
          _descriptionWidget,
        ],
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
        ImageCacheManager.getImage(
          url: mapPhoto,
          height: 220,
          fit: BoxFit.cover,
        ),
        (photoList != null
            ? PhotoList(
                items: photoList,
              )
            : Container()),
      ],
    );
  }

  Widget _renderStatisticBox() {
    Widget _wrapWidgetData({
      @required String firstTitle,
      @required String data,
      @required String unitTitle,
    }) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: R.colors.majorOrange,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              firstTitle.toUpperCase(),
              textScaleFactor: 1.0,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: R.colors.contentText,
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 6),
            Text(
              data.toUpperCase(),
              textScaleFactor: 1.0,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: R.colors.contentText,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 6),
            Text(
              unitTitle.toUpperCase(),
              textScaleFactor: 1.0,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: R.colors.contentText,
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    Widget _distanceWidget = _wrapWidgetData(
      firstTitle: R.strings.distance,
      data: switchBetweenMeterAndKm(_userActivity.totalDistance).toString(),
      unitTitle: R.strings.distanceUnit[DataManager.getUserRunningUnit().index],
    );

    Widget _timeWidget = _wrapWidgetData(
      firstTitle: R.strings.time,
      data: secondToTimeFormat(_userActivity.totalTime),
      unitTitle: R.strings.timeUnit,
    );

    Widget _avgPaceWidget = _wrapWidgetData(
      firstTitle: R.strings.avgPace,
      data: secondToMinFormat(_userActivity.avgPace.toInt()).toString(),
      unitTitle: R.strings.avgPaceUnit,
    );

//    TODO: Can be used in the future
//    Widget _avgHeartWidget = _wrapWidgetData(
//      firstTitle: R.strings.avgHeart,
//      data: _userActivity.avgHeart.toString(),
//      unitTitle: R.strings.avgHeartUnit,
//    );
//
//    Widget _maxHeartWidget = _wrapWidgetData(
//      firstTitle: R.strings.maxHeart,
//      data: _userActivity.maxHeart.toString(),
//      unitTitle: R.strings.avgHeartUnit,
//    );

    Widget _avgTotalStepWidget = _wrapWidgetData(
      firstTitle: R.strings.total,
      data: _userActivity.totalStep != -1
          ? _userActivity.totalStep.toString()
          : R.strings.na,
      unitTitle: R.strings.totalStepsUnit,
    );

//    TODO: Can be used in the future
//    Widget _elevGainWidget = _wrapWidgetData(
//      firstTitle: R.strings.elevGain,
//      data: _userActivity.elevGain?.toString() ?? R.strings.na,
//      unitTitle: R.strings.m,
//    );
//
//    Widget _maxElevWidget = _wrapWidgetData(
//      firstTitle: R.strings.maxElev,
//      data: _userActivity.elevMax?.toString() ?? R.strings.na,
//      unitTitle: R.strings.m,
//    );

    Widget _caloriesWidget = _wrapWidgetData(
      firstTitle: R.strings.calories,
      data: _userActivity.calories != -1
          ? _userActivity.calories.toString()
          : R.strings.na,
      unitTitle: R.strings.caloriesUnit,
    );

    List<Widget> widgetList = <Widget>[
      _distanceWidget,
      _timeWidget,
      _avgPaceWidget,
//      _avgHeartWidget,
//      _maxHeartWidget,
      _avgTotalStepWidget,
//       _elevGainWidget,
//       _maxElevWidget,
      _caloriesWidget,
    ];

    return Container(
      margin: EdgeInsets.all(_spacing),
      child: GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(0),
        crossAxisCount: 3,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        children: widgetList,
      ),
    );
  }

  Widget _renderDetailVisualization() {
    // TODO: Go to a page for detail visualization (charts and important info while running)
    return Container();
  }

  Widget _renderEventInfoBox() {
    if (_userActivity.eventId == null) {
      return Container();
    }

    double _boxHeight = 80;
    double _imgWidth = 120;

    // TODO: Code here
    return Container(
      color: R.colors.sectionBackgroundLayer,
      height: _boxHeight,
      margin: EdgeInsets.only(
        top: _spacing,
        bottom: _spacing,
      ),
      padding: EdgeInsets.only(
        left: _spacing,
        right: _spacing,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ImageCacheManager.getImage(
            url: _userActivity.eventThumbnail,
            width: _boxHeight,
            height: _boxHeight,
            fit: BoxFit.fill,
          ),
          SizedBox(width: _spacing),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Title
                Text(
                  R.strings.event,
                  textScaleFactor: 1,
                  maxLines: 1,
                  style: TextStyle(
                    color: R.colors.majorOrange,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                // Event name
                Text(
                  _userActivity.eventName,
                  textScaleFactor: 1,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: R.colors.contentText,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: 8),
                // Horizontal divider
                Divider(
                  color: R.colors.majorOrange,
                  height: 1,
                  thickness: 1,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderInteractionBox() {
    // TODO: Code interaction box here (Like, Discussion, Share)
    return Container();
  }

  Widget _renderSplits() {
    return SplitsChart(
      splitModelArray: _userActivity.splitModelArray,
      labelTitle: R.strings.splits,
      labelPadding: EdgeInsets.fromLTRB(
        _spacing,
        _spacing,
        _spacing,
        10,
      ),
      headingColor: R.colors.contentText,
      textColor: R.colors.contentText,
      dividerColor: R.colors.contentText,
      paceBoxColor: R.colors.redPink,
      chartPadding: EdgeInsets.only(
        left: _spacing,
        right: _spacing,
        bottom: _spacing * 2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          _renderDetailVisualization(),
          if (_userActivity.eventId != -1) _renderEventInfoBox(),
          _renderInteractionBox(),
          if(!checkListIsNullOrEmpty(_userActivity.splitModelArray)) _renderSplits()
        ],
      ),
    );
  }
}
