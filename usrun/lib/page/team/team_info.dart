import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/define.dart';
import 'package:usrun/manager/team_manager.dart';
import 'package:usrun/model/team.dart';
import 'package:usrun/page/team/team_activity_page.dart';
import 'package:usrun/page/team/team_leaderboard.dart';
import 'package:usrun/page/team/team_member.dart';
import 'package:usrun/model/response.dart';
import 'package:usrun/page/team/team_rank.dart';
import 'package:usrun/page/team/team_stat_item.dart';
import 'package:usrun/util/image_cache_manager.dart';
import 'package:usrun/util/team_member_util.dart';
import 'package:usrun/widget/avatar_view.dart';
import 'package:usrun/widget/custom_cell.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/widget/custom_dialog/custom_alert_dialog.dart';
import 'package:usrun/widget/expandable_text.dart';
import 'package:usrun/widget/line_button.dart';
import 'package:usrun/widget/loading_dot.dart';
import 'package:usrun/widget/my_info_box/normal_info_box.dart';
import 'package:usrun/widget/ui_button.dart';

class TeamInfoPage extends StatefulWidget {
  final int teamId;

  TeamInfoPage({@required this.teamId});

  @override
  _TeamInfoPageState createState() => _TeamInfoPageState();
}

class _TeamInfoPageState extends State<TeamInfoPage> {
  bool _isLoading;

  String _teamBanner = R.images.drawerBackgroundDarker;
  String _teamAvatar = R.images.avatar;
  String _teamSymbol = R.images.avatarQuocTK;
  String _teamName = R.strings.loading;
  bool _teamPublicStatus = true;
  String _teamLocation = R.strings.loading;
  String _teamDescription = R.strings.loadingTeamInfo;
  int _teamRank = -1;
  int _teamActivities = -1;
  int _teamTotalDistance = -1;
  String _teamLeadingTime = "00:00:00";
  int _teamLeadingDistance = -1;
  int _teamNewMemThisWeek = -1;
  int _teamMembers = -1;
  TeamMemberType _teamMemberType = TeamMemberType.Guest;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  /*
    + userRole:
      //  OWNER(1),
      //  ADMIN(2),
      //  MEMBER(3),
      //  PENDING(4),
      //  BLOCKED(5);
      // GUESS (6);
  */

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _getTeamInfo();

    WidgetsBinding.instance.addPostFrameCallback((_) => _updateLoading());
  }

  void _getTeamInfo() async {
    Response<dynamic> infoResponse =
        await TeamManager.getTeamById(widget.teamId);
    if (infoResponse.success && infoResponse.object != null) {
      mapTeamInfo(infoResponse.object);
      _teamMemberType = TeamMemberUtil.enumFromInt(infoResponse.object.teamMemberType);
    }

    Response<dynamic> statResponse =
        await TeamManager.getTeamStatById(widget.teamId);
    if (statResponse.success && statResponse.object != null) {
      mapTeamStat(statResponse.object);
    }

    _refreshController.refreshCompleted();
  }

  void mapTeamStat(TeamStatItem toMap) {
    _teamTotalDistance = toMap.totalDistance;
    _teamLeadingDistance = toMap.maxDistance;
    _teamLeadingTime = DateFormat("hh:mm:ss").format(toMap.maxTime);
    _teamActivities = toMap.totalActivity;
    _teamRank = toMap.rank;
    _teamNewMemThisWeek = toMap.memInWeek;
  }

  void mapTeamInfo(Team toMap) {
    setState(() {
      _teamDescription =
          toMap.description == null ? R.strings.description : toMap.description;
      _teamName = toMap.teamName;
      _teamBanner = toMap.banner;
      _teamMembers = toMap.totalMember;
      _teamPublicStatus = (toMap.privacy == 0 ? true : false);
      _teamLocation = toMap.province.toString();
      _teamAvatar = toMap.thumbnail;
    });
  }

  void _updateLoading() {
    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        _isLoading = !_isLoading;
      });
    });
  }

  _shareTeamInfo() {
    // TODO: Code here
    print("Pressing share team info");
  }

  _changeTeamPrivacy(bool privacy) async {
    Map<String, dynamic> reqParam = {
      "privacy": privacy == true ? 0 : 1,
      "teamId": widget.teamId
    };

    if (!TeamMemberUtil.authorizeHigherLevel(
        TeamMemberType.Admin, _teamMemberType)) {
      showCustomAlertDialog(context,
          title: R.strings.notice,
          content: R.strings.notAuthorizedTeamChange,
          firstButtonText: R.strings.ok.toUpperCase(), firstButtonFunction: () {
        pop(this.context);
      });
      return;
    }

    Response<dynamic> updatedTeam = await TeamManager.updateTeam(reqParam);

    if (!updatedTeam.success) {
      showCustomAlertDialog(context,
          title: R.strings.notice,
          content: updatedTeam.errorMessage,
          firstButtonText: R.strings.ok.toUpperCase(), firstButtonFunction: () {
        pop(this.context);
      });
      return;
    }
    _teamPublicStatus = privacy;
  }

  _changeTeamImage(String fieldToChange) async {
    Map<String, dynamic> reqParam = Map();

    if (!TeamMemberUtil.authorizeHigherLevel(
        TeamMemberType.Admin, _teamMemberType)) {
      showCustomAlertDialog(context,
          title: R.strings.notice,
          content: R.strings.notAuthorizedTeamChange,
          firstButtonText: R.strings.ok.toUpperCase(), firstButtonFunction: () {
        pop(this.context);
      });
      return;
    }

    try {
      var image;

      if (fieldToChange == 'banner')
        image = await pickImageByShape(context, CropStyle.rectangle);
      else
        image = image = await pickImageByShape(context, CropStyle.circle);

      if (image != null) {
        List<int> imageBytes = image.readAsBytesSync();
        String base64Image =
            "data:image/${image.path.split('.').last};base64,${Base64Codec().encode(imageBytes)}";
        reqParam[fieldToChange] = base64Image;
        reqParam['teamId'] = widget.teamId;
        Response<dynamic> updatedTeam = await TeamManager.updateTeam(reqParam);

        if (updatedTeam.success && updatedTeam.object != null) {
          mapTeamInfo(updatedTeam.object);
        } else {
          showCustomAlertDialog(context,
              title: R.strings.notice,
              content: updatedTeam.errorMessage,
              firstButtonText: R.strings.ok.toUpperCase(),
              firstButtonFunction: () {
            pop(this.context);
          });
        }
      }
    } catch (error) {
      showCustomAlertDialog(context,
          title: R.strings.notice,
          content: error.toString(),
          firstButtonText: R.strings.ok.toUpperCase(), firstButtonFunction: () {
        pop(this.context);},
        secondButtonText: ""
        );}
  }


  _joinTeamFunction() async {

    if (TeamMemberUtil.authorizeEqualLevel(TeamMemberType.Pending, _teamMemberType)) {
      Response<dynamic> response =
      await TeamManager.cancelJoinTeam(widget.teamId);

      if (response.success) {
        setState(() {
          _teamMemberType = TeamMemberType.Guest;
        });
      } else {
        showCustomAlertDialog(context,
            title: R.strings.notice,
            content: response.errorMessage,
            firstButtonText: R.strings.ok.toUpperCase(),
            firstButtonFunction: () {
              pop(this.context);
            },
            secondButtonText: "");
      }
      return;
    }

    if (TeamMemberUtil.authorizeEqualLevel(TeamMemberType.Guest, _teamMemberType) || TeamMemberUtil.authorizeEqualLevel(TeamMemberType.Invited, _teamMemberType)) {
      Response<dynamic> response =
          await TeamManager.requestJoinTeam(widget.teamId);

      if (response.success) {
        setState(() {
          _teamMemberType = TeamMemberType.Pending;
        });
      } else {
        showCustomAlertDialog(context,
            title: R.strings.notice,
            content: response.errorMessage,
            firstButtonText: R.strings.ok.toUpperCase(),
            firstButtonFunction: () {
          pop(this.context);},
        secondButtonText: "");
      }
    }
  }

  Widget _renderJoinButton() {
    if (TeamMemberUtil.authorizeHigherLevel(TeamMemberType.Member, _teamMemberType)) return null;

    String toDisplay;
    if (TeamMemberUtil.authorizeEqualLevel(TeamMemberType.Invited, _teamMemberType)) {
      toDisplay = R.strings.acceptInvitation;
    }
    if (TeamMemberUtil.authorizeEqualLevel(TeamMemberType.Pending, _teamMemberType)) {
      toDisplay = R.strings.cancelJoin;
    }
    if(toDisplay == null){
      toDisplay = R.strings.join;
    }

    return UIButton(
        width: R.appRatio.appWidth381,
        height: R.appRatio.appHeight50,
        gradient: R.colors.uiGradient,
        text: toDisplay,
        textSize: R.appRatio.appFontSize20,
        onTap: () => _joinTeamFunction());
  }

  String numberDisplayAdapter(dynamic toDisplay) {
    if (toDisplay == -1) {
      return R.strings.na;
    } else
      return toDisplay.toString();
  }

  _transferOwnership() {
    // TODO: Code here
    print("Transferring ownership");
  }

  _deleteTeam() {
    // TODO: Code here
    print("Deleting team");
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
    Widget _buildElement = Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: R.colors.appBackground,
      appBar: GradientAppBar(
        leading: FlatButton(
          onPressed: () => pop(context),
          padding: EdgeInsets.all(0.0),
          splashColor: R.colors.lightBlurMajorOrange,
          textColor: Colors.white,
          child: ImageCacheManager.getImage(
            url: R.myIcons.appBarBackBtn,
            width: R.appRatio.appAppBarIconSize,
            height: R.appRatio.appAppBarIconSize,
          ),
        ),
        gradient: R.colors.uiGradient,
        centerTitle: true,
        title: Text(
          R.strings.team,
          style: TextStyle(
              color: Colors.white, fontSize: R.appRatio.appFontSize22),
        ),
      ),
      body: RefreshConfiguration(
          maxOverScrollExtent: 50,
          headerTriggerDistance: 50,
          child: SmartRefresher(
            enablePullDown: true,
            controller: _refreshController,
            onRefresh: () => {_getTeamInfo()},
            child: (_isLoading
                ? LoadingIndicator()
                : SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // Banner
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: <Widget>[
                        ImageCacheManager.getImage(
                          url: _teamBanner,
                          width: R.appRatio.deviceWidth,
                          height: R.appRatio.appHeight250,
                          fit: BoxFit.cover,
                        ),
                        (TeamMemberUtil.authorizeLowerLevel(
                            TeamMemberType.Admin, _teamMemberType)
                            ? Container()
                            : GestureDetector(
                          onTap: () => _changeTeamImage("banner"),
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: R.appRatio.appSpacing15,
                              bottom: R.appRatio.appSpacing15,
                            ),
                            child: Container(
                              width: R.appRatio.appIconSize30,
                              height: R.appRatio.appIconSize30,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 2.0,
                                    offset: Offset(0.0, 0.0),
                                    color: R.colors.majorOrange,
                                  ),
                                ],
                              ),
                              child: ImageCacheManager.getImage(
                                url: R.myIcons.colorEditIcon,
                                fit: BoxFit.cover,
                                width: R.appRatio.appIconSize15,
                                height: R.appRatio.appIconSize15,
                              ),
                            ),
                          ),
                        )),
                      ],
                    ),
                    SizedBox(
                      height: R.appRatio.appSpacing25,
                    ),
                    // Custom cell
                    Padding(
                      padding: EdgeInsets.only(
                        left: R.appRatio.appSpacing15,
                        right: R.appRatio.appSpacing15,
                        bottom: R.appRatio.appSpacing25,
                      ),
                      child: CustomCell(
                        enableSplashColor: false,
                        avatarView: AvatarView(
                          avatarImageURL: _teamAvatar,
                          avatarImageSize: R.appRatio.appWidth80,
                          avatarBoxBorder: Border.all(
                            width: 1,
                            color: R.colors.majorOrange,
                          ),
                          supportImageURL: (TeamMemberUtil.authorizeLowerLevel(
                              TeamMemberType.Admin, _teamMemberType)
                              ? null
                              : R.myIcons.colorEditIconOrangeBg),
                          pressAvatarImage: () => _changeTeamImage("Avatar"),
                        ),
                        title: _teamName,
                        enableAddedContent: true,
                        firstAddedTitle: (_teamPublicStatus
                            ? R.strings.public
                            : R.strings.private),
                        firstAddedTitleIconURL: R.myIcons.keyIconByTheme,
                        firstAddedTitleIconSize: R.appRatio.appIconSize15,
                        secondAddedTitle: _teamLocation,
                        secondAddedTitleIconURL: R.myIcons.gpsIconByTheme,
                        secondAddedTitleIconSize: R.appRatio.appIconSize15,
                      ),
                    ),
                    // Description
                    Padding(
                      padding: EdgeInsets.only(
                        left: R.appRatio.appSpacing15,
                        right: R.appRatio.appSpacing15,
                        bottom: R.appRatio.appSpacing25,
                      ),
                      child: ExpandableText(_teamDescription),
                    ),
                    // Join button
                    (TeamMemberUtil.authorizeLowerLevel(
                        TeamMemberType.Pending, _teamMemberType) &&
                        _teamMemberType != TeamMemberType.Blocked)
                        ? Padding(
                      padding: EdgeInsets.only(
                        left: R.appRatio.appSpacing15,
                        right: R.appRatio.appSpacing15,
                        bottom: R.appRatio.appSpacing25,
                      ),
                      child: _renderJoinButton(),
                    )
                        : Container(),
                    // Symbol
                    (_teamSymbol.length != 0
                        ? Padding(
                      padding: EdgeInsets.only(
                        bottom: R.appRatio.appSpacing25,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                              left: R.appRatio.appSpacing15,
                              bottom: R.appRatio.appSpacing15,
                            ),
                            child: Text(
                              R.strings.symbol,
                              style: R.styles.shadowLabelStyle,
                            ),
                          ),
                          Container(
                            color: R.colors.sectionBackgroundLayer,
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(
                              top: R.appRatio.appSpacing10,
                              bottom: R.appRatio.appSpacing10,
                            ),
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: <Widget>[
                                // Symbol image
                                ImageCacheManager.getImage(
                                  url: _teamSymbol,
                                  fit: BoxFit.cover,
                                  width: R.appRatio.appWidth50,
                                  height: R.appRatio.appWidth50,
                                ),
                                SizedBox(
                                    height: R.appRatio.appSpacing10),
                                // "Verified" string
                                Text(
                                  R.strings.verifiedByUsrun,
                                  style: TextStyle(
                                    color: R.colors.contentText,
                                    fontSize: R.appRatio.appFontSize14,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                        : Container),
                    // Team stats
                    Padding(
                      padding: EdgeInsets.only(
                        left: R.appRatio.appSpacing15,
                        right: R.appRatio.appSpacing15,
                        bottom: R.appRatio.appSpacing25,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: R.appRatio.appSpacing15,
                            ),
                            child: Text(
                              R.strings.teamStats,
                              style: R.styles.shadowLabelStyle,
                            ),
                          ),
                          GestureDetector(
                            // TODO: Pass teamId to pushPage!!!
                            onTap: () =>
                                pushPage(context,
                                    TeamLeaderBoardPage(teamId: widget.teamId)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                ImageCacheManager.getImage(
                                  url: R.myIcons.starIconByTheme,
                                  width: R.appRatio.appIconSize18,
                                  height: R.appRatio.appIconSize18,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(
                                  width: R.appRatio.appSpacing10,
                                ),
                                Text(
                                  R.strings.leaderboard,
                                  style: TextStyle(
                                    color: R.colors.contentText,
                                    fontSize: R.appRatio.appFontSize16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: R.appRatio.appSpacing15,
                          ),
                          // Rank & Activities
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              NormalInfoBox(
                                id: "0",
                                boxSize: R.appRatio.appWidth100,
                                dataLine: numberDisplayAdapter(_teamRank),
                                secondTitleLine: R.strings.rank,
                                pressBox: (id) {
                                  pushPage(
                                      context,
                                      TeamRank(
                                        teamId: widget.teamId,
                                      ));
                                },
                              ),
                              SizedBox(
                                width: R.appRatio.appSpacing15,
                              ),
                              NormalInfoBox(
                                id: "1",
                                boxSize: R.appRatio.appWidth100,
                                dataLine:
                                numberDisplayAdapter(_teamActivities),
                                secondTitleLine: R.strings.activities,
                                pressBox: (id) {
                                  // TODO: Pass teamId to pushPage!!!
                                  pushPage(
                                      context,
                                      TeamActivityPage(
                                          teamId: widget.teamId,
                                          totalActivity: _teamActivities));
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: R.appRatio.appSpacing15,
                          ),
                          // Distance, Leading time & Leading distance
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              NormalInfoBox(
                                id: "2",
                                boxSize: R.appRatio.appWidth100,
                                dataLine:
                                numberDisplayAdapter(_teamTotalDistance),
                                secondTitleLine: "KM",
                              ),
                              SizedBox(
                                width: R.appRatio.appSpacing15,
                              ),
                              NormalInfoBox(
                                id: "3",
                                boxSize: R.appRatio.appWidth100,
                                dataLine: _teamLeadingTime,
                                secondTitleLine:
                                "HH:MM:SS\n" + R.strings.leadingTime,
                              ),
                              SizedBox(
                                width: R.appRatio.appSpacing15,
                              ),
                              NormalInfoBox(
                                id: "4",
                                boxSize: R.appRatio.appWidth100,
                                dataLine: numberDisplayAdapter(
                                    _teamLeadingDistance),
                                secondTitleLine:
                                "KM\n" + R.strings.leadingDist,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: R.appRatio.appSpacing15,
                          ),
                          // New members this week & Members
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              NormalInfoBox(
                                id: "5",
                                boxSize: R.appRatio.appWidth100,
                                dataLine:
                                numberDisplayAdapter(_teamNewMemThisWeek),
                                secondTitleLine: R.strings.newMemThisWeek,
                              ),
                              SizedBox(
                                width: R.appRatio.appSpacing15,
                              ),
                              NormalInfoBox(
                                id: "6",
                                boxSize: R.appRatio.appWidth100,
                                dataLine: numberDisplayAdapter(_teamMembers),
                                secondTitleLine: R.strings.members,
                                pressBox: (id) {
                                  // TODO: Pass teamId to pushPage!!!
                                  pushPage(
                                      context,
                                      TeamMemberPage(
                                        teamId: widget.teamId,
                                        teamMemberType: _teamMemberType,
                                      ));
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Tool zone
                    // TODO: Pass teamId to pushPage!!!
                    (TeamMemberUtil.authorizeLowerLevel(
                        TeamMemberType.Admin, _teamMemberType))
                        ? Container()
                        : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            left: R.appRatio.appSpacing15,
                            bottom: R.appRatio.appSpacing15,
                          ),
                          child: Text(
                            R.strings.toolZone,
                            style: R.styles.shadowLabelStyle,
                          ),
                        ),
                        // Make team public
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: R.appRatio.appSpacing15,
                          ),
                          child: LineButton(
                            mainText:
                            R.strings.makeTeamPublicTitle,
                            mainTextFontSize:
                            R.appRatio.appFontSize18,
                            subTextFontSize:
                            R.appRatio.appFontSize14,
                            subText:
                            R.strings.makeTeamPublicSubtitle,
                            enableBottomUnderline: true,
                            enableSwitchButton: true,
                            initSwitchStatus: _teamPublicStatus,
                            switchButtonOffTitle: "Off",
                            switchButtonOnTitle: "On",
                            switchFunction: (status) =>
                                _changeTeamPrivacy(status),
                          ),
                        ),
                        // Transfer ownership
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: R.appRatio.appSpacing15,
                          ),
                          child: LineButton(
                            mainText:
                            R.strings.transferOwnershipTitle,
                            mainTextFontSize:
                            R.appRatio.appFontSize18,
                            subTextFontSize:
                            R.appRatio.appFontSize14,
                            subText: R.strings
                                .transferOwnershipSubtitle,
                            enableBottomUnderline: true,
                            enableBoxButton: true,
                            boxButtonTitle: R.strings.transfer,
                            boxButtonFuction: () =>
                                _transferOwnership(),
                          ),
                        ),
                        // Delete team
                        LineButton(
                          mainText: R.strings.deleteTeamTitle,
                          mainTextFontSize:
                          R.appRatio.appFontSize18,
                          subTextFontSize:
                          R.appRatio.appFontSize14,
                          subText: R.strings.deleteTeamSubtitle,
                          enableBottomUnderline: true,
                          enableBoxButton: true,
                          boxButtonTitle: R.strings.delete,
                          boxButtonFuction: () => _deleteTeam(),)
                      ],
                    )
                  ]),
            )
            ),
          )),
    );

    return NotificationListener<OverscrollIndicatorNotification>(
        child: _buildElement,
        onNotification: (overScroll) {
          overScroll.disallowGlow();
          return false;
        });
  }
}
