import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/define.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/manager/event_manager.dart';
import 'package:usrun/manager/user_manager.dart';
import 'package:usrun/model/event_info.dart';
import 'package:usrun/model/event_organization.dart';
import 'package:usrun/model/response.dart';
import 'package:usrun/page/event/event_athletes.dart';
import 'package:usrun/page/event/event_leaderboard.dart';
import 'package:usrun/page/event/event_poster.dart';
import 'package:usrun/page/event/event_teams.dart';
import 'package:usrun/page/event/register_leave_event_util.dart';
import 'package:usrun/util/date_time_utils.dart';
import 'package:usrun/util/image_cache_manager.dart';
import 'package:usrun/util/string_utils.dart';
import 'package:usrun/util/validator.dart';
import 'package:usrun/widget/avatar_view.dart';
import 'package:usrun/widget/custom_cell.dart';
import 'package:usrun/widget/custom_gradient_app_bar.dart';
import 'package:usrun/widget/my_info_box/normal_info_box.dart';
import 'package:usrun/widget/ui_button.dart';

class EventInfoPage extends StatefulWidget {
  final int eventId;
  final bool joined;

  EventInfoPage({
    @required this.eventId,
    @required this.joined,
  }) : assert(eventId >= 0);

  @override
  _EventInfoPageState createState() => _EventInfoPageState();
}

class _EventInfoPageState extends State<EventInfoPage> {
  RefreshController _refreshController;
  EventInfo _eventInfo;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: true);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _getNecessaryData() async {
    // TODO: Call API here, based on "widget.eventId"
    EventInfo result;

    Response<dynamic> response = await EventManager.getEventInfo(widget.eventId, UserManager.currentUser.userId);

    if(response.success && response.errorCode == -1){
      result = response.object;
    }

    setState(() {
      _eventInfo = result;
    });

    _refreshController.refreshCompleted();
  }

  Widget _renderBanner() {
    return ImageCacheManager.getImage(
      url: _eventInfo.banner,
      width: R.appRatio.deviceWidth,
      height: R.appRatio.appHeight250,
      fit: BoxFit.cover,
    );
  }

  Widget _renderEventHeader() {
    return Padding(
      padding: EdgeInsets.only(
        top: R.appRatio.appSpacing25,
        left: R.appRatio.appSpacing15,
        right: R.appRatio.appSpacing15,
        bottom: R.appRatio.appSpacing25,
      ),
      child: CustomCell(
        enableSplashColor: false,
        avatarView: AvatarView(
          avatarImageURL: _eventInfo.thumbnail,
          avatarImageSize: R.appRatio.appWidth80,
          avatarBoxBorder: Border.all(
            width: 1,
            color: R.colors.majorOrange,
          ),
        ),
        title: _eventInfo.eventName,
        subTitle: _eventInfo.subtitle,
        subTitleStyle: TextStyle(
          fontSize: R.appRatio.appFontSize16,
          fontWeight: FontWeight.normal,
          color: R.colors.contentText,
        ),
        enableAddedContent: false,
      ),
    );
  }

  Widget _renderEventInformation() {
    Widget rowInfoWidget({
      String iconURL,
      String content,
      bool boldContent: false,
      Function func,
    }) {
      FontWeight contentFontWeight = FontWeight.normal;
      if (boldContent) {
        contentFontWeight = FontWeight.bold;
      }

      Widget buildElement = Padding(
        padding: EdgeInsets.only(
          bottom: R.appRatio.appSpacing15,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageCacheManager.getImage(
              url: iconURL,
              width: R.appRatio.appIconSize20,
              height: R.appRatio.appIconSize20,
              fit: BoxFit.contain,
            ),
            SizedBox(width: R.appRatio.appSpacing15),
            Expanded(
              child: Text(
                content ?? "",
                textAlign: TextAlign.justify,
                overflow: TextOverflow.ellipsis,
                maxLines: 30,
                style: TextStyle(
                  color: R.colors.contentText,
                  fontSize: R.appRatio.appFontSize16,
                  fontWeight: contentFontWeight,
                ),
              ),
            ),
          ],
        ),
      );

      if (func != null) {
        buildElement = GestureDetector(
          onTap: func,
          child: buildElement,
        );
      }

      return buildElement;
    }

    String startDate = formatDateTime(
      _eventInfo.startTime,
      formatDisplay: formatTimeDateConst,
    );

    String endDate = formatDateTime(
      _eventInfo.endTime,
      formatDisplay: formatTimeDateConst,
    );

    String eventStartEndDate = "$startDate - $endDate";
    String eventStatus =
        "${R.strings.eventStatusTitle}: ${R.strings.eventStatus[_eventInfo.status]}";
    String description = "${R.strings.description}:\n${_eventInfo.description}";
    String posterURL = _eventInfo.poster;
    String rewards = "${R.strings.rewards}:\n${_eventInfo.reward}";

    return Padding(
      padding: EdgeInsets.only(
        left: R.appRatio.appSpacing15,
        right: R.appRatio.appSpacing15,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Label
          Text(
            R.strings.information,
            style: R.styles.shadowLabelStyle,
          ),
          SizedBox(height: R.appRatio.appSpacing15),
          // Event status
          rowInfoWidget(
            iconURL: R.myIcons.runnerIconByTheme,
            content: eventStatus,
          ),
          // Start - End date
          rowInfoWidget(
            iconURL: R.myIcons.calendarByTheme,
            content: eventStartEndDate,
          ),
          // Event poster
          rowInfoWidget(
            iconURL: R.myIcons.posterByTheme,
            content: R.strings.eventPoster,
            boldContent: true,
            func: () {
              pushPage(
                context,
                EventPosterPage(
                  eventName: _eventInfo.eventName,
                  posterURL: posterURL,
                ),
              );
            },
          ),
          // Event description
          rowInfoWidget(
            iconURL: R.myIcons.infoByTheme,
            content: description,
          ),
          // Event rewards
          rowInfoWidget(
            iconURL: R.myIcons.laurelByTheme,
            content: rewards,
          ),
        ],
      ),
    );
  }

  Widget _renderRegisterOrLeaveButton() {
    if (_eventInfo.status == 2) return Container();

    String text = R.strings.register;
    bool enableGradient = true;
    Function callback = () async {
      bool result = await RegisterLeaveEventUtil.handleRegisterAnEvent(
        context: context,
        eventName: _eventInfo.eventName,
        eventId: widget.eventId,
      );

      if (result != null && result) {
       text = R.strings.leave;
      }
    };

    if(widget.joined) {
      text = R.strings.leave;
      enableGradient = false;
      callback = () async {
        bool result = await RegisterLeaveEventUtil.handleLeaveAnEvent(
          context: context,
          eventName: _eventInfo.eventName,
          eventId: widget.eventId,
        );

        if (result != null && result) {
          text = R.strings.register;
        }
      };
    }

    return Padding(
      padding: EdgeInsets.only(
        top: R.appRatio.appSpacing5,
        bottom: R.appRatio.appSpacing20,
        left: R.appRatio.appSpacing15,
        right: R.appRatio.appSpacing15,
      ),
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

  Widget _renderOrganizations() {
    Widget _renderOrgInfo(
      EventOrganization org,
      String title,
      Color titleColor,
    ) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: R.appRatio.appSpacing15,
        ),
        child: CustomCell(
          enableSplashColor: false,
          enableAddedContent: false,
          title: title,
          titleStyle: TextStyle(
            fontSize: R.appRatio.appFontSize18,
            color: titleColor,
            fontWeight: FontWeight.bold,
          ),
          subTitle: org.name,
          subTitleStyle: TextStyle(
            fontSize: R.appRatio.appFontSize16,
            fontWeight: FontWeight.normal,
            color: R.colors.contentText,
          ),
          avatarView: AvatarView(
            avatarImageSize: R.appRatio.appAvatarSize60,
            avatarImageURL: org.avatar,
          ),
        ),
      );
    }

    Widget _renderOrgList(
      List<dynamic> orgList,
      String title,
      Color titleColor,
    ) {
      if (checkListIsNullOrEmpty(orgList)) {
        return Container();
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: orgList.length,
        itemBuilder: (context, index) {
          EventOrganization org = orgList[index];
          return _renderOrgInfo(org, title, titleColor);
        },
      );
    }

    return Padding(
      padding: EdgeInsets.only(
        left: R.appRatio.appSpacing15,
        right: R.appRatio.appSpacing15,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Label
          Text(
            R.strings.organizations,
            style: R.styles.shadowLabelStyle,
          ),
          SizedBox(height: R.appRatio.appSpacing15),
          // Org 0: Powered by
          _renderOrgList(
            _eventInfo.sponsorIds[0],
            R.strings.poweredBy,
            R.colors.redPink,
          ),
          // Org 1: Gold
          _renderOrgList(
            _eventInfo.sponsorIds[1],
            R.strings.goldSponsor,
            Color(0xFFFFD700),
          ),
          // Org 2: Silver
          _renderOrgList(
            _eventInfo.sponsorIds[2],
            R.strings.silverSponsor,
            R.colors.normalNoteText,
          ),
          // Org 3: Bronze
          _renderOrgList(
            _eventInfo.sponsorIds[3],
            R.strings.bronzeSponsor,
            Color(0xFFCD7F32),
          ),
          // Org 4: Collaborated
          _renderOrgList(
            _eventInfo.sponsorIds[4],
            R.strings.collaborator,
            R.colors.contentText,
          ),
        ],
      ),
    );
  }

  Widget _renderEventStats() {
    String labelTitle = StringUtils.uppercaseFirstLetterEachWord(
      content: R.strings.eventStats,
      pattern: " ",
    );

    String totalParticipants = _eventInfo.totalParticipant.toString();
    String distance = switchBetweenMeterAndKm(
      _eventInfo.totalDistance,
      formatType: RunningUnit.KILOMETER,
    ).toString();
    String totalTeams = _eventInfo.totalTeamParticipant.toString();

    return Padding(
      padding: EdgeInsets.only(
        top: R.appRatio.appSpacing5,
        left: R.appRatio.appSpacing15,
        right: R.appRatio.appSpacing15,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Label
          Text(
            labelTitle,
            style: R.styles.shadowLabelStyle,
          ),
          SizedBox(height: R.appRatio.appSpacing15),
          // Leaderboard button
          GestureDetector(
            onTap: () {
              pushPage(context, EventLeaderboardPage(eventId: widget.eventId, teamId: _eventInfo.teamId,));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ImageCacheManager.getImage(
                  url: R.myIcons.starIconByTheme,
                  width: R.appRatio.appIconSize20,
                  height: R.appRatio.appIconSize20,
                  fit: BoxFit.contain,
                ),
                SizedBox(width: R.appRatio.appSpacing15),
                Text(
                  R.strings.leaderboard,
                  textScaleFactor: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  maxLines: 1,
                  style: TextStyle(
                    color: R.colors.contentText,
                    fontSize: R.appRatio.appFontSize18,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: R.appRatio.appSpacing15),
          // Statistical boxes
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Total runners/participants
              NormalInfoBox(
                id: "0",
                boxSize: R.appRatio.appWidth100,
                dataLine: totalParticipants,
                secondTitleLine: R.strings.runners.toUpperCase(),
                pressBox: (id) {
                  pushPage(context, EventAthleteSearchPage(eventId: widget.eventId));
                },
              ),
              SizedBox(width: R.appRatio.appSpacing15),
              // Distance
              NormalInfoBox(
                id: "1",
                boxSize: R.appRatio.appWidth100,
                dataLine: distance,
                secondTitleLine: "KM",
                pressBox: (id) {
                },
              ),
              SizedBox(width: R.appRatio.appSpacing15),
              // Total teams
              NormalInfoBox(
                id: "2",
                boxSize: R.appRatio.appWidth100,
                dataLine: totalTeams,
                secondTitleLine: R.strings.teams.toUpperCase(),
                pressBox: (id) {
                  pushPage(context, EventTeamSearchPage(eventId: widget.eventId));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _renderBodyContent() {
    if (_eventInfo == null) {
      return Container();
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Banner
          _renderBanner(),
          // Event header
          _renderEventHeader(),
          // Event information
          _renderEventInformation(),
          // Event button (Register/Leave)
          _renderRegisterOrLeaveButton(),
          // Event organizations
          _renderOrganizations(),
          // Event stats
          _renderEventStats(),
          SizedBox(height: R.appRatio.appSpacing30),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String appTitle = StringUtils.uppercaseFirstLetterEachWord(
      content: R.strings.eventInformation,
      pattern: " ",
    );

    Widget smartRefresher = SmartRefresher(
      enablePullUp: false,
      controller: _refreshController,
      child: _renderBodyContent(),
      physics: BouncingScrollPhysics(),
      footer: null,
      onRefresh: () => _getNecessaryData(),
      onLoading: () async {
        await Future.delayed(Duration(milliseconds: 200));
      },
    );

    Widget refreshConfigs = RefreshConfiguration(
      child: smartRefresher,
      headerBuilder: () => WaterDropMaterialHeader(
        backgroundColor: R.colors.majorOrange,
      ),
      footerBuilder: null,
      shouldFooterFollowWhenNotFull: (state) {
        return false;
      },
      hideFooterWhenNotFull: true,
    );

    Widget buildElement = Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: R.colors.appBackground,
      appBar: CustomGradientAppBar(title: appTitle),
      body: refreshConfigs,
    );

    return NotificationListener<OverscrollIndicatorNotification>(
      child: buildElement,
      onNotification: (overScroll) {
        overScroll.disallowGlow();
        return false;
      },
    );
  }
}
