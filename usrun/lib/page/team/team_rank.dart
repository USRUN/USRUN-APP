import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/manager/team_manager.dart';
import 'package:usrun/model/response.dart';
import 'package:usrun/page/team/team_info.dart';
import 'package:usrun/page/team/teamstat_rank_item.dart';
import 'package:usrun/util/validator.dart';
import 'package:usrun/widget/avatar_view.dart';
import 'package:usrun/widget/custom_cell.dart';
import 'package:usrun/widget/custom_dialog/custom_alert_dialog.dart';
import 'package:usrun/widget/custom_gradient_app_bar.dart';
import 'package:usrun/widget/header_rank_lead.dart';
import 'package:usrun/widget/loading_dot.dart';

class TeamRank extends StatefulWidget {
  final int teamId;

  TeamRank({@required this.teamId});

  @override
  _TeamRankState createState() => _TeamRankState();
}

class _TeamRankState extends State<TeamRank> {
  bool _isLoading;
  List<TeamStatRankItem> items;

  /*
    + Structure of the "items" variable:
    [
      {
        "avatarImageURL":
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
        "name": "Quốc Trần Kiến",
        "distance": 421.34,
      },
      ...
    ]
  */

  @override
  void initState() {
    super.initState();
    items = [];
    _isLoading = true;

    getTeamRank();
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateLoading());
  }

  void getTeamRank() async {
    Response<dynamic> teamRank =
        await TeamManager.getTeamStatRank(widget.teamId);

    if (teamRank.success && (teamRank.object as List).isNotEmpty) {
      items = teamRank.object;
    } else {
      showCustomAlertDialog(
        context,
        title: R.strings.error,
        content: teamRank.errorMessage,
        firstButtonText: R.strings.ok.toUpperCase(),
        firstButtonFunction: () => pop(context),
      );
    }
  }

  void _updateLoading() {
    Future.delayed(Duration(milliseconds: 1000), () {
      if (!mounted) return;
      setState(
        () {
          _isLoading = !_isLoading;
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildElement = Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: R.colors.appBackground,
      appBar: CustomGradientAppBar(title: R.strings.teamRank),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // HeaderRankLead
          Container(
            decoration: BoxDecoration(
              color: R.colors.boxBackground,
              boxShadow: [
                BoxShadow(
                  blurRadius: 2.0,
                  offset: Offset(0.0, 1.0),
                  color: R.colors.btnShadow,
                ),
              ],
            ),
            child: HeaderRankLead(),
          ),
          // All contents
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: (_isLoading
                  ? Container(
                      padding: EdgeInsets.only(
                        top: R.appRatio.appSpacing15,
                      ),
                      child: LoadingIndicator(),
                    )
                  : (checkListIsNullOrEmpty(items))
                      ? _buildEmptyList()
                      : _renderList()),
            ),
          ),
        ],
      ),
    );

    return NotificationListener<OverscrollIndicatorNotification>(
        child: _buildElement,
        onNotification: (overScroll) {
          overScroll.disallowGlow();
          return false;
        });
  }

  Widget _buildEmptyList() {
    String systemNoti = R.strings.noResult;

    return Center(
      child: Container(
        padding: EdgeInsets.only(
          left: R.appRatio.appSpacing25,
          right: R.appRatio.appSpacing25,
        ),
        child: Text(
          systemNoti,
          textAlign: TextAlign.justify,
          style: TextStyle(
            color: R.colors.contentText,
            fontSize: R.appRatio.appFontSize16,
          ),
        ),
      ),
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
              int teamId = items[index].teamId;
              String rank = items[index].rank.toString();
              String avatarImageURL = items[index].avatar;
              String name = items[index].name;
              String distance = NumberFormat("#,##0.##", "en_US")
                  .format(items[index].distance);

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
                                rank,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: (widget.teamId == teamId)
                                      ? R.colors.orangeNoteText
                                      : R.colors.contentText,
                                  fontSize: R.appRatio.appFontSize16,
                                ),
                              ),
                            ),
                          ),
                          // Custom cell
                          Expanded(
                            child: CustomCell(
                              avatarView: AvatarView(
                                avatarImageURL: avatarImageURL,
                                avatarImageSize: R.appRatio.appWidth50,
                                avatarBoxBorder: Border.all(
                                  width: 1,
                                  color: R.colors.majorOrange,
                                ),
                                pressAvatarImage: () {
                                  // TODO: Implement here
                                  print(
                                      "Pressing avatar image with index $index, no. ${index + 1}");
                                },
                              ),
                              // Content
                              title: name,
                              titleStyle: TextStyle(
                                fontSize: R.appRatio.appFontSize16,
                                color: (widget.teamId == teamId)
                                    ? R.colors.orangeNoteText
                                    : R.colors.contentText,
                              ),
                              enableAddedContent: false,
                              pressInfo: () {
                                // TODO: Implement here
                                print(
                                    "Pressing info with index $index, no. ${index + 1}");
                                pushPage(context, TeamInfoPage(teamId: teamId));
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
                                  color: (widget.teamId == teamId)
                                      ? R.colors.orangeNoteText
                                      : R.colors.contentText,
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
