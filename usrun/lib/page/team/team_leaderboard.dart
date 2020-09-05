import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/define.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/manager/team_manager.dart';
import 'package:usrun/manager/user_manager.dart';
import 'package:usrun/model/response.dart';
import 'package:usrun/model/user.dart';
import 'package:usrun/page/profile/profile_page.dart';
import 'package:usrun/page/team/team_rank_item.dart';
import 'package:usrun/util/validator.dart';
import 'package:usrun/widget/avatar_view.dart';
import 'package:usrun/widget/custom_cell.dart';
import 'package:usrun/widget/custom_gradient_app_bar.dart';
import 'package:usrun/widget/header_rank_lead.dart';
import 'package:usrun/widget/loading_dot.dart';

class TeamLeaderBoardPage extends StatefulWidget {
  final int teamId;

  TeamLeaderBoardPage({@required this.teamId});

  @override
  _TeamLeaderBoardPageState createState() => _TeamLeaderBoardPageState();
}

class _TeamLeaderBoardPageState extends State<TeamLeaderBoardPage> {
  bool _isLoading;
  List<TeamRankItem> items;

  @override
  void initState() {
    super.initState();
    _isLoading = true;

    _getLeaderBoard();

    WidgetsBinding.instance.addPostFrameCallback((_) => _updateLoading());
  }

  void loadTeamMemberProfile(int index) async {
    Response<dynamic> response =
        await UserManager.getUserInfo(items[index].userId);
    User user = response.object;

    pushPage(context, ProfilePage(userInfo: user, enableAppBar: true));
  }

  void _getLeaderBoard() async {
    Response<dynamic> teamLeaderboard =
        await TeamManager.getTeamLeaderBoard(widget.teamId);
    if (teamLeaderboard.success && teamLeaderboard.object != null) {
      items = List();
      teamLeaderboard.object.forEach((element) {
        items.add(TeamRankItem.from(element));
      });
    } else
      items = null;
  }

  void _updateLoading() {
    Future.delayed(Duration(milliseconds: 1000), () {
      if (!mounted) return;
      setState(() {
        _isLoading = !_isLoading;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double headerRankLeadHeight = R.appRatio.appHeight50;

    Widget _buildElement = Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: R.colors.appBackground,
      appBar: CustomGradientAppBar(title: R.strings.teamLeaderboard),
      body: (!_isLoading && checkListIsNullOrEmpty(items))
          ? _buildEmptyList()
          : Stack(
              children: <Widget>[
                // All contents
                Container(
                  margin: EdgeInsets.only(
                    top: headerRankLeadHeight,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: (_isLoading
                        ? Container(
                            padding: EdgeInsets.only(
                              top: R.appRatio.appSpacing15,
                            ),
                            child: LoadingIndicator(),
                          )
                        : _renderList()),
                  ),
                ),
                // HeaderRankLead
                HeaderRankLead(
                  enableShadow: true,
                  height: headerRankLeadHeight,
                ),
              ],
            ),
    );

    return NotificationListener<OverscrollIndicatorNotification>(
      child: _buildElement,
      onNotification: (overScroll) {
        overScroll.disallowGlow();
        return false;
      },
    );
  }

  Widget _buildEmptyList() {
    String systemNoti = R.strings.listCouldNotBeLoad;

    return Center(
      child: Container(
          padding: EdgeInsets.only(
            left: R.appRatio.appSpacing25,
            right: R.appRatio.appSpacing25,
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  systemNoti,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: R.colors.contentText,
                    fontSize: R.appRatio.appFontSize18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ])),
    );
  }

  Widget _renderList() {
    return Container(
      padding: EdgeInsets.only(
        left: R.appRatio.appSpacing10,
        right: R.appRatio.appSpacing10,
      ),
      child: AnimationLimiter(
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (BuildContext ctxt, int index) {
              String avatarImageURL = items[index].avatarImageURL;
              String name = items[index].name;
              String distance = NumberFormat.compact().format(
                switchBetweenMeterAndKm(
                  items[index].distance,
                  formatType: RunningUnit.KILOMETER,
                ),
              );
              Color contentColor =
                  items[index].userId == UserManager.currentUser.userId
                      ? R.colors.majorOrange
                      : R.colors.contentText;

              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 400),
                child: SlideAnimation(
                  verticalOffset: 100.0,
                  child: FadeInAnimation(
                    child: Container(
                      padding: EdgeInsets.only(
                        top: (index == 0 ? R.appRatio.appSpacing15 : 0),
                        bottom: R.appRatio.appSpacing15,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // Number order
                          Container(
                            width: R.appRatio.appWidth50,
                            alignment: Alignment.center,
                            child: FittedBox(
                              child: Text(
                                (index + 1).toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: contentColor,
                                  fontSize: R.appRatio.appFontSize16,
                                ),
                              ),
                            ),
                          ),
                          // Custom cell
                          Expanded(
                            child: CustomCell(
                              enableSplashColor: false,
                              avatarView: AvatarView(
                                avatarImageURL: avatarImageURL,
                                avatarImageSize: R.appRatio.appWidth50,
                                avatarBoxBorder: Border.all(
                                  width: 1,
                                  color: R.colors.majorOrange,
                                ),
                                pressAvatarImage: () {
                                  loadTeamMemberProfile(index);
                                },
                              ),
                              // Content
                              title: name,
                              titleStyle: TextStyle(
                                fontSize: R.appRatio.appFontSize16,
                                color: contentColor,
                              ),
                              enableAddedContent: false,
                              pressInfo: () {
                                loadTeamMemberProfile(index);
                              },
                            ),
                          ),
                          // Distance
                          Container(
                            width: R.appRatio.appWidth80,
                            alignment: Alignment.center,
                            child: FittedBox(
                              child: Text(
                                distance,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: contentColor,
                                  fontSize: R.appRatio.appFontSize16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
