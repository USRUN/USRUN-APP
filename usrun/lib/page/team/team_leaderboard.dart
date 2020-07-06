import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/model/response.dart';
import 'package:usrun/manager/team_manager.dart';
import 'package:usrun/model/team_leaderboard.dart';
import 'package:usrun/page/team/team_rank_item.dart';
import 'package:usrun/widget/avatar_view.dart';
import 'package:usrun/widget/custom_cell.dart';
import 'package:usrun/widget/loading_dot.dart';
import 'package:usrun/widget/header_rank_lead.dart';
import 'package:usrun/util/image_cache_manager.dart';

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

  void _getLeaderBoard() async {
    Response<List<TeamLeaderboard>> teamLeaderboard =
        await TeamManager.getTeamLeaderBoard(widget.teamId);
    if (teamLeaderboard.success && teamLeaderboard.object != null) {
      items = List();
      teamLeaderboard.object.forEach((element) {items.add(TeamRankItem.from(element));});
    }
    else items = null;
  }

  void _updateLoading() {
    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        _isLoading = !_isLoading;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
          R.strings.teamLeaderboard,
          style: TextStyle(
              color: Colors.white, fontSize: R.appRatio.appFontSize22),
        ),
      ),
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
                                (index + 1).toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: R.colors.contentText,
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
                                      "Pressing avatar image with index $index, no. ${index + 1}, userId: ${items[index].userId}");
                                },
                              ),
                              // Content
                              title: name,
                              titleStyle: TextStyle(
                                fontSize: R.appRatio.appFontSize16,
                                color: R.colors.contentText,
                              ),
                              enableAddedContent: false,
                              pressInfo: () {
                                // TODO: Implement here
                                print(
                                    "Pressing info with index $index, no. ${index + 1}");
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
                                  color: R.colors.contentText,
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
