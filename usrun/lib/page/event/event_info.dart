import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/model/event_info.dart';
import 'package:usrun/model/event_organization.dart';
import 'package:usrun/page/event/event_poster.dart';
import 'package:usrun/page/event/register_leave_event_util.dart';
import 'package:usrun/util/date_time_utils.dart';
import 'package:usrun/util/image_cache_manager.dart';
import 'package:usrun/util/string_utils.dart';
import 'package:usrun/widget/avatar_view.dart';
import 'package:usrun/widget/custom_cell.dart';
import 'package:usrun/widget/custom_gradient_app_bar.dart';
import 'package:usrun/widget/ui_button.dart';

class EventInfoPage extends StatefulWidget {
  final int eventId;

  EventInfoPage({
    @required this.eventId,
  }) : assert(eventId >= 0);

  @override
  _EventInfoPageState createState() => _EventInfoPageState();
}

class _EventInfoPageState extends State<EventInfoPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  EventInfo _eventInfo;

  @override
  void initState() {
    super.initState();
    _getNecessaryData();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _getNecessaryData() async {
    // TODO: Call API here, based on "widget.eventId"
    EventInfo result = await Future.delayed(Duration(milliseconds: 2500), () {
      return EventInfo(
        eventName: "US Racing for Health 2023",
        subtitle:
            "Chạy bộ nào các bạn trẻ ơi, siêng năng chăm chỉ tập luyện vì sức khỏe của bạn :D",
        description:
            "Đẩy là phần mô tả ngắn gọn chỉ hiển thị thông tin về sự kiện này. Chạy bộ nào các bạn trẻ ơi, siêng năng chăm chỉ tập luyện vì sức khỏe của bạn :D.",
        thumbnail: R.images.avatar,
        status: 0,
        banner: R.images.avatarNgocVTT,
        poster: R.images.avatarNgocVTT,
        reward:
            "<1> Tiền mặt 500.000 VND, quà tặng từ Công ty Cổ phẩn MAK\n\n<2> Tiền mặt 300.000 VND, quà tặng từ KoLAP\n\n<3> Tiền mặt 100.000 VND\n\n<KK> Giấy chứng nhận Online",
        sponsorIds: [
          [
            EventOrganization(
              avatar: R.images.avatarQuocTK,
              name: "Công ty Cổ phần MAK",
            ),
          ],
          [
            EventOrganization(
              avatar: R.images.avatarHuyTA,
              name: "Công ty Cổ phần QAS",
            ),
          ],
          [
            EventOrganization(
              avatar: R.images.avatarPhucTT,
              name: "Công ty Cổ phần POL",
            ),
          ],
          [
            EventOrganization(
              avatar: R.images.avatar,
              name: "Công ty Cổ phần TYC",
            ),
          ],
          [
            EventOrganization(
              avatar: R.images.appIcon,
              name: "Công ty Cổ phần PQOM",
            ),
          ],
        ],
        totalParticipant: 194729,
        totalTeamParticipant: 1048,
        totalDistance: 859175,
        startTime: DateTime.now().subtract(Duration(days: 7)),
        endTime: DateTime.now().subtract(Duration(days: 5)),
      );
    });

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
      );

      if (result != null && result) {
        // TODO: Register successfully
      }
    };

//    TODO: Chưa có biến "joined" để check
//    if (_eventItem.joined) {
//      text = R.strings.leave;
//      enableGradient = false;
//      callback = () async {
//        bool result = await RegisterLeaveEventUtil.handleLeaveAnEvent(
//          context: context,
//          eventName: _eventInfo.eventName,
//        );
//
//        if (result != null && result) {
//          // TODO: Leave successfully
//        }
//      };
//    }

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
    return Container();
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
          // TODO: Code here
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
