import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/define.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/model/event.dart';
import 'package:usrun/page/event/event_info.dart';
import 'package:usrun/util/date_time_utils.dart';
import 'package:usrun/util/image_cache_manager.dart';
import 'package:usrun/util/validator.dart';
import 'package:usrun/widget/avatar_view.dart';
import 'package:usrun/widget/ui_button.dart';

class EventInfoLine extends StatefulWidget {
  final Event eventItem;
  final Function registerCallback;
  final Function leaveCallback;
  final bool enableActionButton;
  final bool enableBoxShadow;

  EventInfoLine({
    @required this.eventItem,
    this.registerCallback,
    this.leaveCallback,
    this.enableActionButton = true,
    this.enableBoxShadow = true,
  });

  @override
  _EventInfoLineState createState() => _EventInfoLineState();
}

class _EventInfoLineState extends State<EventInfoLine> {
  Event _eventItem;
  final double _avatarSize = R.appRatio.appWidth90;

  @override
  void initState() {
    super.initState();
    _eventItem = widget.eventItem;
  }

  void _goToDetailEventPage() {
    // TODO: Go to event_information page with param "eventId"
    // =====> Trang này chưa build hiện giờ <=====
    print("[EVENT_INFO_LINE] Go to event_information page");
    pushPage(context, EventInfoPage(eventId: widget.eventItem.eventId));
  }

  Widget _renderEventAvatar() {
    return AvatarView(
      avatarImageURL: _eventItem.thumbnail,
      avatarImageSize: _avatarSize,
      pressAvatarImage: _goToDetailEventPage,
      avatarBoxBorder: Border.all(
        width: 1.5,
        color: R.currentAppTheme == AppTheme.LIGHT
            ? R.colors.majorOrange
            : Colors.white,
      ),
    );
  }

  Widget _renderEventTitle() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Title
        Text(
          _eventItem.eventName,
          textScaleFactor: 1.0,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.justify,
          style: TextStyle(
            color: R.colors.contentText,
            fontSize: R.appRatio.appFontSize18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: R.appRatio.appSpacing5),
        // Subtitle
        Text(
          _eventItem.subtitle,
          textScaleFactor: 1.0,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.justify,
          style: TextStyle(
            color: R.colors.contentText,
            fontSize: R.appRatio.appFontSize16,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _renderEventRemainingInfo() {
    String startDate = formatDateTime(
      _eventItem.startTime,
      formatDisplay: formatTimeDateConst,
    );

    String endDate = formatDateTime(
      _eventItem.endTime,
      formatDisplay: formatTimeDateConst,
    );

    String eventStartEndDate = "$startDate - $endDate";

    Widget _renderIconAndText(
      String iconURL,
      String text, {
      Color givenColor,
      FontWeight fontWeight,
      bool enableExpanded: true,
    }) {
      Widget iconWidget = ImageCacheManager.getImage(
        url: iconURL,
        width: R.appRatio.appIconSize20,
        height: R.appRatio.appIconSize20,
        color: givenColor,
      );

      Widget contentWidget = Text(
        text,
        textScaleFactor: 1.0,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.left,
        style: TextStyle(
          color: givenColor ?? R.colors.contentText,
          fontSize: R.appRatio.appFontSize16,
          fontWeight: fontWeight ?? FontWeight.normal,
        ),
      );

      if (enableExpanded) {
        double width = R.appRatio.deviceWidth - R.appRatio.appSpacing20 * 2 - 2;

        return Container(
          width: width,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Icon
              iconWidget,
              SizedBox(width: R.appRatio.appSpacing10),
              // Text
              Expanded(
                child: contentWidget,
              ),
            ],
          ),
        );
      } else {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Icon
            iconWidget,
            SizedBox(width: R.appRatio.appSpacing10),
            // Text
            contentWidget,
          ],
        );
      }
    }

    Widget _renderRegisterOrLeaveButton() {
      if (!widget.enableActionButton) return Container();

      String text = R.strings.join;
      Function callback = widget.registerCallback;
      bool enableGradient = true;

      if (_eventItem.joined) {
        text = R.strings.leave;
        callback = widget.leaveCallback;
        enableGradient = false;
      }

      return Padding(
        padding: EdgeInsets.only(top: R.appRatio.appSpacing20),
        child: UIButton(
          text: text,
          textColor: Colors.white,
          textSize: R.appRatio.appFontSize18,
          fontWeight: FontWeight.bold,
          height: R.appRatio.appHeight45,
          width: double.infinity,
          gradient: (enableGradient ? R.colors.uiGradient : null),
          color: (enableGradient ? null : R.colors.grayButtonColor),
          onTap: callback,
          radius: 5,
          enableShadow: true,
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Event status & Total participants & Total team participants
        Row(
          children: <Widget>[
            // Event status
            _renderIconAndText(
              R.myIcons.caloriesStatsIconByTheme,
              R.strings.eventStatus[_eventItem.status.index],
              givenColor: R.colors.majorOrange,
              fontWeight: FontWeight.bold,
              enableExpanded: false,
            ),
            SizedBox(width: R.appRatio.appSpacing25),
            // Total participants
            _renderIconAndText(
              R.myIcons.runnerIconByTheme,
              _eventItem.totalParticipant.toString(),
              enableExpanded: false,
            ),
            SizedBox(width: R.appRatio.appSpacing25),
            // Total team participants
            _renderIconAndText(
              R.myIcons.peopleIconByTheme,
              _eventItem.totalTeamParticipant.toString(),
              enableExpanded: false,
            ),
          ],
        ),
        SizedBox(height: R.appRatio.appSpacing15),
        // Opening - Ending date time
        _renderIconAndText(
          R.myIcons.calendarByTheme,
          eventStartEndDate,
        ),
        SizedBox(height: R.appRatio.appSpacing15),
        // Powered by
        !checkStringNullOrEmpty(_eventItem.poweredBy)
            ? _renderIconAndText(
                R.myIcons.rocketByTheme,
                _eventItem.poweredBy,
              )
            : Container(),
        // Register/Leave button
        _renderRegisterOrLeaveButton(),
      ],
    );
  }

  Widget _renderBodyContent() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Avatar
            _renderEventAvatar(),
            SizedBox(width: R.appRatio.appSpacing15),
            // Event title & subtitle
            Expanded(
              child: _renderEventTitle(),
            ),
          ],
        ),
        SizedBox(height: R.appRatio.appSpacing15),
        // Event remaining info
        _renderEventRemainingInfo(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _goToDetailEventPage,
      child: Container(
        decoration: BoxDecoration(
          color: R.colors.appBackground,
          boxShadow: (widget.enableBoxShadow
              ? [
                  BoxShadow(
                    blurRadius: 4.0,
                    offset: Offset(0.0, 0.0),
                    color: R.colors.textShadow,
                  ),
                ]
              : null),
        ),
        padding: EdgeInsets.all(R.appRatio.appSpacing20),
        child: _renderBodyContent(),
      ),
    );
  }
}
