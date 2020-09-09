import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/define.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/core/net/image_client.dart';
import 'package:usrun/manager/data_manager.dart';
import 'package:usrun/manager/team_manager.dart';
import 'package:usrun/model/response.dart';
import 'package:usrun/model/team.dart';
import 'package:usrun/page/team/team_activity_page.dart';
import 'package:usrun/page/team/team_leaderboard.dart';
import 'package:usrun/page/team/team_member.dart';
import 'package:usrun/page/team/team_rank.dart';
import 'package:usrun/page/team/team_stat_item.dart';
import 'package:usrun/util/camera_picker.dart';
import 'package:usrun/util/image_cache_manager.dart';
import 'package:usrun/util/network_detector.dart';
import 'package:usrun/util/team_member_util.dart';
import 'package:usrun/util/validator.dart';
import 'package:usrun/widget/avatar_view.dart';
import 'package:usrun/widget/custom_cell.dart';
import 'package:usrun/widget/custom_dialog/custom_alert_dialog.dart';
import 'package:usrun/widget/custom_dialog/custom_loading_dialog.dart';
import 'package:usrun/widget/custom_gradient_app_bar.dart';
import 'package:usrun/widget/expandable_text.dart';
import 'package:usrun/widget/loading_dot.dart';
import 'package:usrun/widget/my_info_box/normal_info_box.dart';
import 'package:usrun/widget/ui_button.dart';

class TeamInfoPage extends StatefulWidget {
  final int teamId;
  final Function reloadTeamPage;

  TeamInfoPage({@required this.teamId, this.reloadTeamPage});

  @override
  _TeamInfoPageState createState() => _TeamInfoPageState();
}

class _TeamInfoPageState extends State<TeamInfoPage> {
  bool _isLoading;

  String _teamBanner = R.images.avatar;
  String _teamAvatar = R.images.avatar;
  String _teamSymbol = R.myIcons.hcmusLogo;
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
  bool _verificationStatus = false;
  String currentRunningUnit =
      R.strings.distanceUnit[DataManager.getUserRunningUnit().index];
  TeamMemberType _teamMemberType = TeamMemberType.Guest;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _getTeamInfo();

    WidgetsBinding.instance.addPostFrameCallback((_) => _updateLoading());
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _getTeamInfo() async {
    Response<dynamic> infoResponse =
        await TeamManager.getTeamById(widget.teamId);
    if (infoResponse.success && infoResponse.object != null) {
      mapTeamInfo(infoResponse.object);
      _teamMemberType =
          TeamMemberUtil.enumFromInt(infoResponse.object.teamMemberType);
    }

    Response<dynamic> statResponse =
        await TeamManager.getTeamStatById(widget.teamId);
    if (statResponse.success && statResponse.object != null) {
      mapTeamStat(statResponse.object);
    }

    _refreshController.refreshCompleted();
  }

  void mapTeamStat(TeamStatItem toMap) {
    if (!mounted) return;
    setState(
      () {
        _teamTotalDistance =
            switchBetweenMeterAndKm(toMap.totalDistance).toInt();
        _teamLeadingDistance =
            switchBetweenMeterAndKm(toMap.maxDistance).toInt();
        _teamLeadingTime = DateFormat("hh:mm:ss").format(toMap.maxTime);
        _teamActivities = toMap.totalActivity;
        _teamRank = toMap.rank;
        _teamNewMemThisWeek = toMap.memInWeek;
      },
    );
  }

  void mapTeamInfo(Team toMap) {
    if (!mounted) return;
    setState(() {
      _verificationStatus = toMap.verified;
      _teamSymbol = toMap.verified ? R.myIcons.hcmusLogo : null;
      _teamDescription = toMap.description == null
          ? R.strings.yourDescription
          : toMap.description;
      _teamName = toMap.teamName;
      _teamBanner = toMap.banner;
      _teamMembers = toMap.totalMember;
      _teamPublicStatus = (toMap.privacy == 0 ? true : false);
      _teamLocation = R.strings.provinces[toMap.province];
      _teamAvatar = toMap.thumbnail;
    });
  }

  void _updateLoading() {
    Future.delayed(Duration(milliseconds: 1000), () {
      if (!mounted) return;
      setState(() {
        _isLoading = !_isLoading;
      });
    });
  }

  _changeTeamPrivacy(bool privacy) async {
    Map<String, dynamic> reqParam = {
      "privacy": privacy == true ? 0 : 1,
      "teamId": widget.teamId
    };

    if (!TeamMemberUtil.authorizeHigherLevel(
        TeamMemberType.Admin, _teamMemberType)) {
      showCustomAlertDialog(
        context,
        title: R.strings.notice,
        content: R.strings.notAuthorizedTeamChange,
        firstButtonText: R.strings.ok.toUpperCase(),
        firstButtonFunction: () => pop(this.context),
      );
      return;
    }

    Response<dynamic> updatedTeam = await TeamManager.updateTeam(reqParam);

    if (!updatedTeam.success) {
      showCustomAlertDialog(
        context,
        title: R.strings.notice,
        content: updatedTeam.errorMessage,
        firstButtonText: R.strings.ok.toUpperCase(),
        firstButtonFunction: () => pop(this.context),
      );
      return;
    }
    _teamPublicStatus = privacy;
  }

  Future<String> getUserImageAsBase64(CropStyle cropStyle) async {
    final CameraPicker _selectedCameraFile = CameraPicker();

    dynamic result = await _selectedCameraFile
        .showCameraPickerActionSheet(context, imageQuality: 95);
    if (result == null || result == false) return "";

    if (cropStyle == CropStyle.circle) {
      result = await _selectedCameraFile.cropImage(
        maxWidth: 800,
        maxHeight: 600,
        cropStyle: cropStyle,
        compressFormat: ImageCompressFormat.jpg,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        androidUiSettings: R.imagePickerDefaults.defaultAndroidSettings,
      );
    } else {
      result = await _selectedCameraFile.cropImage(
        cropStyle: cropStyle,
        maxWidth: 800,
        maxHeight: 600,
        compressFormat: ImageCompressFormat.jpg,
        aspectRatio: CropAspectRatio(ratioX: 4, ratioY: 3),
        androidUiSettings: R.imagePickerDefaults.defaultAndroidSettings,
      );
    }
    if (!result) return "";

    return _selectedCameraFile.toBase64();
  }

  _changeTeamImage(String fieldToChange) async {
    Map<String, dynamic> reqParam = Map();

    if (!TeamMemberUtil.authorizeHigherLevel(
        TeamMemberType.Owner, _teamMemberType)) {
      showCustomAlertDialog(
        context,
        title: R.strings.notice,
        content: R.strings.notAuthorizedTeamChange,
        firstButtonText: R.strings.ok.toUpperCase(),
        firstButtonFunction: () {
          pop(this.context);
        },
      );
      return;
    }

    if (await NetworkDetector.checkNetworkAndAlert(context) == false) {
      return;
    }

    try {
      String image;

      if (fieldToChange.compareTo('banner') == 0)
        image = await getUserImageAsBase64(CropStyle.rectangle);
      else
        image = await getUserImageAsBase64(CropStyle.circle);

      if (checkStringNullOrEmpty(image)) {
        return;
      }

      showCustomLoadingDialog(context, text: R.strings.uploading);

      Response<dynamic> linkResponse = await ImageClient.uploadImage(image);
      if (!linkResponse.success) {
        pop(context);
        await showCustomAlertDialog(
          context,
          title: R.strings.notice,
          content: linkResponse.errorMessage,
          firstButtonText: R.strings.ok.toUpperCase(),
          firstButtonFunction: () {
            pop(this.context);
          },
        );
        return;
      }
      reqParam[fieldToChange] = linkResponse.object;
      reqParam['teamId'] = widget.teamId;
      Response<dynamic> updatedTeam = await TeamManager.updateTeam(reqParam);

      if (updatedTeam.success && updatedTeam.object != null) {
        mapTeamInfo(updatedTeam.object);
        widget.reloadTeamPage();
      } else {
        pop(context);
        showCustomAlertDialog(
          context,
          title: R.strings.notice,
          content: updatedTeam.errorMessage,
          firstButtonText: R.strings.ok.toUpperCase(),
          firstButtonFunction: () {
            pop(context);
          },
          secondButtonText: "",
        );
      }
    } catch (error) {
      showCustomAlertDialog(
        context,
        title: R.strings.notice,
        content: error.toString(),
        firstButtonText: R.strings.ok.toUpperCase(),
        firstButtonFunction: () {
          pop(context);
        },
        secondButtonText: "",
      );
    }

    pop(context);
  }

  _joinTeamFunction() async {
    Response<dynamic> response;
    TeamMemberType result;

    if (TeamMemberUtil.authorizeEqualLevel(
        TeamMemberType.Pending, _teamMemberType)) {
      response = await TeamManager.cancelJoinTeam(widget.teamId);
      result = TeamMemberType.Guest;
    }

    if (TeamMemberUtil.authorizeEqualLevel(
        TeamMemberType.Invited, _teamMemberType)) {
      response = await TeamManager.acceptInvitation(widget.teamId);
      result = TeamMemberType.Member;
    }

    if (TeamMemberUtil.authorizeEqualLevel(
        TeamMemberType.Guest, _teamMemberType)) {
      response = await TeamManager.requestJoinTeam(widget.teamId);
      result = TeamMemberType.Pending;
    }

    if (response.success && response.errorCode == -1) {
      if (!mounted) return;
      setState(() {
        _teamMemberType = result;
      });

      if (widget.reloadTeamPage != null) {
        widget.reloadTeamPage();
      }
    } else {
      showCustomAlertDialog(
        context,
        title: R.strings.notice,
        content: response.errorMessage,
        firstButtonText: R.strings.ok.toUpperCase(),
        firstButtonFunction: () {
          pop(this.context);
        },
      );
    }
  }

  Widget _renderJoinButton() {
    if (TeamMemberUtil.authorizeHigherLevel(
        TeamMemberType.Member, _teamMemberType)) {
      return null;
    }

    String toDisplay;
    if (TeamMemberUtil.authorizeEqualLevel(
        TeamMemberType.Invited, _teamMemberType)) {
      toDisplay = R.strings.acceptInvitation;
    }
    if (TeamMemberUtil.authorizeEqualLevel(
        TeamMemberType.Pending, _teamMemberType)) {
      toDisplay = R.strings.cancelJoin;
    }
    if (toDisplay == null) {
      toDisplay = R.strings.join;
    }

    if (_teamName == R.strings.loading) {
      return Container();
    }
    ;

    return UIButton(
      width: double.infinity,
      height: R.appRatio.appHeight45,
      gradient: R.colors.uiGradient,
      text: toDisplay,
      textSize: R.appRatio.appFontSize18,
      fontWeight: FontWeight.bold,
      onTap: _joinTeamFunction,
    );
  }

  String numberDisplayAdapter(dynamic toDisplay) {
    if (toDisplay == -1) {
      return R.strings.na;
    }
    return NumberFormat.compact().format((toDisplay));
  }

//  _transferOwnership() {
//    print("Transferring ownership");
//  }
//
//  _deleteTeam() {
//    print("Deleting team");
//  }

  @override
  Widget build(BuildContext context) {
    Widget _buildElement = Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: R.colors.appBackground,
      appBar: CustomGradientAppBar(title: R.strings.team),
      body: RefreshConfiguration(
        maxOverScrollExtent: 50,
        headerTriggerDistance: 50,
        child: SmartRefresher(
          enablePullDown: true,
          controller: _refreshController,
          onRefresh: _getTeamInfo,
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
                          GestureDetector(
                            onTap: () {
                              _changeTeamImage("banner");
                            },
                            child: ImageCacheManager.getImage(
                              url: _teamBanner,
                              width: R.appRatio.deviceWidth,
                              height: R.appRatio.appHeight250,
                              fit: BoxFit.fill,
                            ),
                          ),
                          (TeamMemberUtil.authorizeLowerLevel(
                                  TeamMemberType.Admin, _teamMemberType)
                              ? Container()
                              : Padding(
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
                            supportImageURL:
                                (TeamMemberUtil.authorizeLowerLevel(
                                        TeamMemberType.Admin, _teamMemberType)
                                    ? null
                                    : R.myIcons.colorEditIconOrangeBg),
                            pressAvatarImage: () {
                              _changeTeamImage("thumbnail");
                            },
                          ),
                          title: _teamName,
                          enableAddedContent: false,
                          subTitle: _teamLocation,
                          subTitleStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: R.appRatio.appFontSize14,
                            color: R.colors.contentText,
                          ),
//                          firstAddedTitle: (_teamPublicStatus
//                              ? R.strings.public
//                              : R.strings.private),
//                          firstAddedTitleIconURL: R.myIcons.keyIconByTheme,
//                          firstAddedTitleIconSize: R.appRatio.appIconSize15,
//                          secondAddedTitle: _teamLocation,
//                          secondAddedTitleIconURL: R.myIcons.gpsIconByTheme,
//                          secondAddedTitleIconSize: R.appRatio.appIconSize15,
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
//                      (this._verificationStatus != false
//                          ? Padding(
//                              padding: EdgeInsets.only(
//                                bottom: R.appRatio.appSpacing25,
//                              ),
//                              child: Column(
//                                mainAxisAlignment: MainAxisAlignment.start,
//                                crossAxisAlignment: CrossAxisAlignment.stretch,
//                                mainAxisSize: MainAxisSize.min,
//                                children: <Widget>[
//                                  Padding(
//                                    padding: EdgeInsets.only(
//                                      left: R.appRatio.appSpacing15,
//                                      bottom: R.appRatio.appSpacing15,
//                                    ),
//                                    child: Text(
//                                      R.strings.symbol,
//                                      style: R.styles.shadowLabelStyle,
//                                    ),
//                                  ),
//                                  Container(
//                                    color: R.colors.sectionBackgroundLayer,
//                                    alignment: Alignment.center,
//                                    padding: EdgeInsets.only(
//                                      top: R.appRatio.appSpacing10,
//                                      bottom: R.appRatio.appSpacing10,
//                                    ),
//                                    child: Column(
//                                      mainAxisAlignment:
//                                          MainAxisAlignment.center,
//                                      crossAxisAlignment:
//                                          CrossAxisAlignment.center,
//                                      children: <Widget>[
//                                        // Symbol image
//                                        ImageCacheManager.getImage(
//                                          url: _teamSymbol,
//                                          fit: BoxFit.cover,
//                                          width: R.appRatio.appWidth50,
//                                          height: R.appRatio.appWidth50,
//                                        ),
//                                        SizedBox(
//                                            height: R.appRatio.appSpacing10),
//                                        // "Verified" string
//                                        Text(
//                                          R.strings.verifiedByUsrun,
//                                          style: TextStyle(
//                                            color: R.colors.contentText,
//                                            fontSize: R.appRatio.appFontSize14,
//                                            fontStyle: FontStyle.italic,
//                                          ),
//                                        ),
//                                      ],
//                                    ),
//                                  ),
//                                ],
//                              ),
//                            )
//                          : Container()),
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
                                style: R.styles.labelStyle,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                pushPage(context,
                                    TeamLeaderBoardPage(teamId: widget.teamId));
                              },
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
                                  disableBoxShadow: true,
                                  pressBox: (id) {
                                    pushPage(
                                      context,
                                      TeamRank(
                                        teamId: widget.teamId,
                                        reloadTeamPage: widget.reloadTeamPage,
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(
                                  width: R.appRatio.appSpacing15,
                                ),
                                NormalInfoBox(
                                  id: "1",
                                  boxSize: R.appRatio.appWidth100,
                                  dataLine: numberDisplayAdapter(
                                    _teamActivities,
                                  ),
                                  secondTitleLine: R.strings.activities,
                                  disableBoxShadow: true,
                                  pressBox: (id) {
                                    pushPage(
                                      context,
                                      TeamActivityPage(
                                        teamId: widget.teamId,
                                      ),
                                    );
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
                                  dataLine: numberDisplayAdapter(
                                    _teamTotalDistance,
                                  ),
                                  secondTitleLine: currentRunningUnit,
                                  disableBoxShadow: true,
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
                                  disableBoxShadow: true,
                                ),
                                SizedBox(
                                  width: R.appRatio.appSpacing15,
                                ),
                                NormalInfoBox(
                                  id: "4",
                                  boxSize: R.appRatio.appWidth100,
                                  dataLine: numberDisplayAdapter(
                                    _teamLeadingDistance,
                                  ),
                                  secondTitleLine: currentRunningUnit +
                                      "\n" +
                                      R.strings.leadingDist,
                                  disableBoxShadow: true,
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
                                  disableBoxShadow: true,
                                ),
                                SizedBox(
                                  width: R.appRatio.appSpacing15,
                                ),
                                NormalInfoBox(
                                  id: "6",
                                  boxSize: R.appRatio.appWidth100,
                                  dataLine: numberDisplayAdapter(_teamMembers),
                                  secondTitleLine: R.strings.members,
                                  disableBoxShadow: true,
                                  pressBox: (id) {
                                    pushPage(
                                      context,
                                      TeamMemberPage(
                                        teamId: widget.teamId,
                                        teamMemberType: _teamMemberType,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Tool zone
//                      (TeamMemberUtil.authorizeLowerLevel(
//                              TeamMemberType.Admin, _teamMemberType))
//                          ? Container()
//                          : Column(
//                              crossAxisAlignment: CrossAxisAlignment.stretch,
//                              mainAxisAlignment: MainAxisAlignment.start,
//                              mainAxisSize: MainAxisSize.min,
//                              children: <Widget>[
//                                Padding(
//                                  padding: EdgeInsets.only(
//                                    left: R.appRatio.appSpacing15,
//                                    bottom: R.appRatio.appSpacing15,
//                                  ),
//                                  child: Text(
//                                    R.strings.toolZone,
//                                    style: R.styles.shadowLabelStyle,
//                                  ),
//                                ),
//                                // Make team public
//                                Padding(
//                                  padding: EdgeInsets.only(
//                                    bottom: R.appRatio.appSpacing15,
//                                  ),
//                                  child: LineButton(
//                                    mainText: R.strings.makeTeamPublicTitle,
//                                    mainTextFontSize: R.appRatio.appFontSize18,
//                                    subTextFontSize: R.appRatio.appFontSize16,
//                                    subText: R.strings.makeTeamPublicSubtitle,
//                                    enableBottomUnderline: true,
//                                    textPadding: EdgeInsets.all(15),
//                                    enableSwitchButton: true,
//                                    initSwitchStatus: _teamPublicStatus,
//                                    switchButtonOffTitle: "Off",
//                                    switchButtonOnTitle: "On",
//                                    switchFunction: (status) =>
//                                        _changeTeamPrivacy(status),
//                                  ),
//                                ),
//                                // Transfer ownership
//                                Padding(
//                                  padding: EdgeInsets.only(
//                                    bottom: R.appRatio.appSpacing15,
//                                  ),
//                                  child: LineButton(
//                                    mainText: R.strings.transferOwnershipTitle,
//                                    mainTextFontSize: R.appRatio.appFontSize18,
//                                    subTextFontSize: R.appRatio.appFontSize16,
//                                    subText:
//                                        R.strings.transferOwnershipSubtitle,
//                                    enableBottomUnderline: true,
//                                    textPadding: EdgeInsets.all(15),
//                                    enableBoxButton: true,
//                                    boxButtonTitle: R.strings.transfer,
//                                    boxButtonFunction: _transferOwnership,
//                                  ),
//                                ),
//                                // Delete team
//                                LineButton(
//                                  mainText: R.strings.deleteTeamTitle,
//                                  mainTextFontSize: R.appRatio.appFontSize18,
//                                  subTextFontSize: R.appRatio.appFontSize16,
//                                  subText: R.strings.deleteTeamSubtitle,
//                                  enableBottomUnderline: true,
//                                  textPadding: EdgeInsets.all(15),
//                                  enableBoxButton: true,
//                                  boxButtonTitle: R.strings.delete,
//                                  boxButtonFunction: _deleteTeam,
//                                ),
//                              ],
//                            )
                    ],
                  ),
                )),
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
