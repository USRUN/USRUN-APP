import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/manager/team_manager.dart';
import 'package:usrun/model/team.dart';
import 'package:usrun/page/team/team_leaderboard.dart';
import 'package:usrun/page/team/team_member.dart';
import 'package:usrun/model/response.dart';
import 'package:usrun/page/team/team_rank.dart';
import 'package:usrun/util/image_cache_manager.dart';
import 'package:usrun/widget/avatar_view.dart';
import 'package:usrun/widget/custom_cell.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/widget/custom_dialog/complex_custom_dialog.dart';
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
  String _teamName = "Trường Đại học Khoa học Tự nhiên";
  bool _teamPublicStatus = true;
  String _teamLocation = "Ho Chi Minh City, Viet Nam";
  String _teamDescription =
      "Dành cho những bạn yêu thích môn chạy bộ và mong muốn phát triển phong trào chạy bộ ở Việt Nam. Hãy để niềm cảm hứng với chạy bộ được lan tỏa!\nDành cho những bạn yêu thích môn chạy bộ và mong muốn phát triển phong trào chạy bộ ở Việt Nam. Hãy để niềm cảm hứng với chạy bộ được lan tỏa!\nDành cho những bạn yêu thích môn chạy bộ và mong muốn phát triển phong trào chạy bộ ở Việt Nam. Hãy để niềm cảm hứng với chạy bộ được lan tỏa!\nDành cho những bạn yêu thích môn chạy bộ và mong muốn phát triển phong trào chạy bộ ở Việt Nam. Hãy để niềm cảm hứng với chạy bộ được lan tỏa!\nDành cho những bạn yêu thích môn chạy bộ và mong muốn phát triển phong trào chạy bộ ở Việt Nam. Hãy để niềm cảm hứng với chạy bộ được lan tỏa!\nDành cho những bạn yêu thích môn chạy bộ và mong muốn phát triển phong trào chạy bộ ở Việt Nam. Hãy để niềm cảm hứng với chạy bộ được lan tỏa!\n";
  int _teamRank = 1024;
  int _teamActivities = 82859;
  int _teamTotalDistance = 1839284;
  String _teamLeadingTime = "12:49:32";
  int _teamLeadingDistance = 285;
  int _teamNewMemThisWeek = 492;
  int _teamMembers = 29472;
  int _userRole = 4;

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

  void _getTeamInfo() async{
    Response<Team> response = await TeamManager.getTeamById(widget.teamId);
    if(response.success && response.object != null){
      mapTeamInfo(response.object);
      _userRole = response.object.teamMemberType;
    }
  }

  void mapTeamInfo(Team toMap){
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

  _changeTeamImage(String fieldToChange) async{
    Map<String,dynamic> reqParam = Map();

    if (_userRole > 2) {
      showCustomAlertDialog(context,
          title: R.strings.notice,
          content: "You are not authorized to change $fieldToChange",
          firstButtonText: R.strings.ok.toUpperCase(),
          firstButtonFunction: () {
            pop(this.context);
          });
      return;
    }
    print("Changing $fieldToChange image");

    try {
      var image = await pickImage(context);
      if (image != null) {
        // call API update Team
        List<int> imageBytes = image.readAsBytesSync();
        String base64Image = "data:image/${image.path.split('.').last};base64,${Base64Codec().encode(imageBytes)}";
        reqParam[fieldToChange] = base64Image;
        reqParam['teamId'] = widget.teamId;
        Response<dynamic> updatedTeam = await TeamManager.updateTeam(reqParam);

        if(updatedTeam.success && updatedTeam.object != null) {
          mapTeamInfo(updatedTeam.object);
        } else{
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
      print(error);
      showCustomAlertDialog(context,
          title: R.strings.notice,
          content: error.toString(),
          firstButtonText: R.strings.ok.toUpperCase(),
          firstButtonFunction: () {
            pop(this.context);
          });
    }
  }

  _changeTeamBanner() async{
    if(_userRole > 2) return;
    _changeTeamImage("banner");
  }

  _changeTeamAvatar() async {
    if(_userRole > 2) return;
    _changeTeamImage("thumbnail");
  }

  _joinTeamFunction() async {
    if(_userRole == 6){
    print("Joining team");
    Response<dynamic> response = await TeamManager.requestJoinTeam(widget.teamId);

    if(response.success){
      setState(() {
        _userRole = 4;
      });
    } else {
      showCustomAlertDialog(context,
          title: R.strings.notice,
          content: response.errorMessage,
          firstButtonText: R.strings.ok.toUpperCase(),
          firstButtonFunction: () {
            pop(this.context);
          });
    }}
    else {
      print("Cancel join team");
      Response<dynamic> response = await TeamManager.cancelJoinTeam(widget.teamId);

      if(response.success){
        setState(() {
          _userRole = 6;
        });
      } else {
        showCustomAlertDialog(context,
            title: R.strings.notice,
            content: response.errorMessage,
            firstButtonText: R.strings.ok.toUpperCase(),
            firstButtonFunction: () {
              pop(this.context);
        });
      }
    }
  }

  _makeTeamPublic(status) {
    // TODO: Code here
    print("Making team public with status $status");
  }

  _moderateNewPosts(status) {
    // TODO: Code here
    print("Moderating new posts with status $status");
  }

  _createNewTeamPlan() {
    // TODO: Code here
    print("Creating new team plan");
  }

  _grantRoleToMember() {
    // TODO: Code here
    print("Granting role to member");
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
          leading: new IconButton(
            icon: Image.asset(
              R.myIcons.appBarBackBtn,
              width: R.appRatio.appAppBarIconSize,
            ),
            onPressed: () => pop(context),
          ),
          gradient: R.colors.uiGradient,
          centerTitle: true,
          title: Text(
            R.strings.team,
            style: TextStyle(
                color: Colors.white, fontSize: R.appRatio.appFontSize22),
          ),
          actions: <Widget>[
            IconButton(
              icon: Image.asset(
                R.myIcons.appBarShareBtn,
                width: R.appRatio.appAppBarIconSize,
              ),
              onPressed: () => _shareTeamInfo(),
            ),
          ],
        ),
        body: (_isLoading
            ? LoadingDot()
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
                  (_userRole < 2
                      ? Container()
                      : GestureDetector(
                    onTap: () => _changeTeamBanner(),
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
                  avatarView: AvatarView(
                    avatarImageURL: _teamAvatar,
                    avatarImageSize: R.appRatio.appWidth80,
                    avatarBoxBorder: Border.all(
                      width: 1,
                      color: R.colors.majorOrange,
                    ),
                    supportImageURL: (_userRole < 2
                        ? null
                        : R.myIcons.colorEditIconOrangeBg),
                    pressAvatarImage: () => _changeTeamAvatar(),
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
              (_userRole == 0
                  ? Padding(
                padding: EdgeInsets.only(
                  left: R.appRatio.appSpacing15,
                  right: R.appRatio.appSpacing15,
                  bottom: R.appRatio.appSpacing25,
                ),
                child: UIButton(
                    width: R.appRatio.appWidth381,
                    height: R.appRatio.appHeight50,
                    gradient: R.colors.uiGradient,
                    text: R.strings.join,
                    textSize: R.appRatio.appFontSize20,
                    onTap: () => _joinTeamFunction),
              )
                  : Container()),
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
                        mainAxisAlignment: MainAxisAlignment.center,
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
                          SizedBox(height: R.appRatio.appSpacing10),
                          // "Verified" string
                          Text(
                            R.strings.verifiedByUsrun,
                            style: TextStyle(
                              color: R.colors.contentText,
                              fontSize: R.appRatio.appFontSize14,
                              fontStyle: FontStyle.italic,
                            ),
                            child: UIButton(
                                width: R.appRatio.appWidth381,
                                height: R.appRatio.appHeight50,
                                gradient: R.colors.uiGradient,
                                text: _userRole == 6 ? R.strings.join: "Cancel join request",
                                textSize: R.appRatio.appFontSize20,
                                onTap: () => _joinTeamFunction()),
                          )
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
                      onTap: () => pushPage(context, TeamLeaderBoard(teamId:widget.teamId)),
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
                          dataLine: _teamRank.toString(),
                          secondTitleLine: R.strings.rank,
                          pressBox: (id) {
                            pushPage(context, TeamRank());
                          },
                        ),
                        SizedBox(
                          width: R.appRatio.appSpacing15,
                        ),
                        NormalInfoBox(
                          id: "1",
                          boxSize: R.appRatio.appWidth100,
                          dataLine: _teamActivities.toString(),
                          secondTitleLine: R.strings.activities,
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
                          dataLine: _teamTotalDistance.toString(),
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
                          dataLine: _teamLeadingDistance.toString(),
                          secondTitleLine: "KM\n" + R.strings.leadingDist,
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
                          dataLine: _teamNewMemThisWeek.toString(),
                          secondTitleLine: R.strings.newMemThisWeek,
                        ),
                        SizedBox(
                          width: R.appRatio.appSpacing15,
                        ),
                        NormalInfoBox(
                          id: "6",
                          boxSize: R.appRatio.appWidth100,
                          dataLine: _teamMembers.toString(),
                          secondTitleLine: R.strings.members,
                          pressBox: (id) {
                            // TODO: Pass teamId to pushPage!!!
                            pushPage(context, TeamMemberPage());
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Tool zone
              // TODO: Pass teamId to pushPage!!!
              (_userRole < 2
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
                  (_userRole == 3
                      ? Padding(
                    padding: EdgeInsets.only(
                      bottom: R.appRatio.appSpacing15,
                    ),
                    child: LineButton(
                      mainText: R.strings.makeTeamPublicTitle,
                      mainTextFontSize:
                      R.appRatio.appFontSize18,
                      subTextFontSize:
                      R.appRatio.appFontSize14,
                      subText:
                      R.strings.makeTeamPublicSubtitle,
                      enableBottomUnderline: true,
                      enableSwitchButton: true,
                      initSwitchStatus: false,
                      switchButtonOffTitle: "Off",
                      switchButtonOnTitle: "On",
                      switchFunction: (status) =>
                          _makeTeamPublic(status),
                    ),
                  )
                      : Container()),
                  // Moderate post
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: R.appRatio.appSpacing15,
                    ),
                    child: LineButton(
                      mainText: R.strings.moderateNewPostsTitle,
                      mainTextFontSize: R.appRatio.appFontSize18,
                      subTextFontSize: R.appRatio.appFontSize14,
                      subText: R.strings.moderateNewPostsSubtitle,
                      enableBottomUnderline: true,
                      enableSwitchButton: true,
                      switchButtonOffTitle: "Off",
                      switchButtonOnTitle: "On",
                      initSwitchStatus: false,
                      switchFunction: (status) =>
                          _moderateNewPosts(status),
                    ),
                  ),
                  // Create new team plan
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: R.appRatio.appSpacing15,
                    ),
                    child: LineButton(
                      mainText: R.strings.createNewTeamPlanTitle,
                      mainTextFontSize: R.appRatio.appFontSize18,
                      subTextFontSize: R.appRatio.appFontSize14,
                      subText: R.strings.createNewTeamPlanSubtitle,
                      enableBottomUnderline: true,
                      enableBoxButton: true,
                      boxButtonTitle: R.strings.create,
                      boxButtonFuction: () => _createNewTeamPlan(),
                    ),
                  ),
                  // Grant role to mantember
                  (_userRole == 3
                      ? Padding(
                    padding: EdgeInsets.only(
                      bottom: R.appRatio.appSpacing15,
                    ),
                    child: LineButton(
                      mainText:
                      R.strings.grantRoleToMemberTitle,
                      mainTextFontSize:
                      R.appRatio.appFontSize18,
                      subTextFontSize:
                      R.appRatio.appFontSize14,
                      subText:
                      R.strings.grantRoleToMemberSubtitle,
                      enableBottomUnderline: true,
                      enableBoxButton: true,
                      boxButtonTitle: R.strings.grant,
                      boxButtonFuction: () =>
                          _grantRoleToMember(),
                    ),
                  )
                      : Container()),
                  // Transfer ownership
                  (_userRole == 3
                      ? Padding(
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
                      subText:
                      R.strings.transferOwnershipSubtitle,
                      enableBottomUnderline: true,
                      enableBoxButton: true,
                      boxButtonTitle: R.strings.transfer,
                      boxButtonFuction: () =>
                          _transferOwnership(),
                    ),
                  )
                      : Container()),
                  // Delete team
                  (_userRole == 3
                      ? LineButton(
                    mainText: R.strings.deleteTeamTitle,
                    mainTextFontSize:
                    R.appRatio.appFontSize18,
                    subTextFontSize: R.appRatio.appFontSize14,
                    subText: R.strings.deleteTeamSubtitle,
                    enableBottomUnderline: true,
                    enableBoxButton: true,
                    boxButtonTitle: R.strings.delete,
                    boxButtonFuction: () => _deleteTeam(),
                  )
                      : Container()),
                ],
              )),
            ],
          ),
        )));

    return NotificationListener<OverscrollIndicatorNotification>(
        child: _buildElement,
        onNotification: (overscroll) {
          overscroll.disallowGlow();
        });
  }
}