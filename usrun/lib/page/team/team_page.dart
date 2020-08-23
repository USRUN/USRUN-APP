import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/manager/team_manager.dart';
import 'package:usrun/manager/user_manager.dart';
import 'package:usrun/model/response.dart';
import 'package:usrun/model/team.dart';
import 'package:usrun/page/team/team_info.dart';
import 'package:usrun/page/team/team_search_page.dart';
import 'package:usrun/util/image_cache_manager.dart';
import 'package:usrun/util/validator.dart';
import 'package:usrun/widget/line_button.dart';
import 'package:usrun/widget/loading_dot.dart';
import 'package:usrun/widget/team_list/team_item.dart';
import 'package:usrun/widget/team_list/team_list.dart';

class TeamPage extends StatefulWidget {
  final int suggestionLength = 15;

  @override
  _TeamPageState createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  bool _isLoading;
  List<TeamItem> _myTeamList;
  List<TeamItem> _teamSuggestionList;
  List<TeamItem> _myInvitedTeamList;
  List<TeamItem> _myRequestingTeamList;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _teamSuggestionList = List();
    _myTeamList = List();

    WidgetsBinding.instance.addPostFrameCallback((_) => _updateLoading());
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => _getMyTeamList(UserManager.currentUser.userId));
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => _getSuggestionList(widget.suggestionLength));
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void reloadTeamList() {
    _getMyTeamList(UserManager.currentUser.userId);
    _getSuggestionList(widget.suggestionLength);
    _refreshController.refreshCompleted();
  }

  void _updateLoading() {
    Future.delayed(
      Duration(milliseconds: 1000),
      () {
        setState(
          () {
            _isLoading = !_isLoading;
          },
        );
      },
    );
  }

  List<dynamic> _getBannerList() {
    if (checkListIsNullOrEmpty(_teamSuggestionList)) {
      List<dynamic> bannerList = List<dynamic>();
      return bannerList;
    }

    List<dynamic> bannerList = List<dynamic>();
    for (int i = 0; i < _teamSuggestionList.length; ++i) {
      bannerList.add(ImageCacheManager.getImageData(
          url: _teamSuggestionList[i].bannerImageURL));
    }

    return bannerList;
  }

  void _getMyTeamList(int userId) async {
    Response<dynamic> response = await TeamManager.getMyTeam();
    if (response.success && (response.object).isNotEmpty) {
      List<TeamItem> _toMyTeamList = List();
      List<TeamItem> _toMyInvitedTeamList = List();
      List<TeamItem> _toMyRequestingTeamList = List();

      response.object.forEach((Team element) {
        switch (element.teamMemberType) {
          case 5:
            _toMyInvitedTeamList.add(new TeamItem.from(element));
            break;
          case 4:
            _toMyRequestingTeamList.add(new TeamItem.from(element));
            break;
          default:
            _toMyTeamList.add(new TeamItem.from(element));
            break;
        }
      });
      setState(
        () {
          _myTeamList = _toMyTeamList;
          _myRequestingTeamList = _toMyRequestingTeamList;
          _myInvitedTeamList = _toMyInvitedTeamList;
        },
      );
    } else {
      _myTeamList = null;
      _myRequestingTeamList = null;
      _myInvitedTeamList = null;
    }
  }

  void _getSuggestionList(int howMany) async {
    Response<dynamic> response = await TeamManager.getTeamSuggestion(howMany);
    if (response.success && (response.object).isNotEmpty) {
      List<TeamItem> toAdd = List();

      response.object.forEach((element) {
        toAdd.add(new TeamItem.from(element));
      });

      setState(() {
        _teamSuggestionList = toAdd;
      });
    } else {
      _teamSuggestionList = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colors.appBackground,
      body: RefreshConfiguration(
        maxOverScrollExtent: 50,
        headerTriggerDistance: 50,
        headerBuilder: () => WaterDropMaterialHeader(
          backgroundColor: R.colors.majorOrange,
        ),
        footerBuilder: null,
        shouldFooterFollowWhenNotFull: (state) {
          return false;
        },
        hideFooterWhenNotFull: true,
        child: SmartRefresher(
          enablePullDown: true,
          controller: _refreshController,
          onRefresh: reloadTeamList,
          child: (_isLoading
              ? LoadingDot()
              : SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(
                        height: R.appRatio.appHeight250,
                        width: R.appRatio.deviceWidth,
                        child: Carousel(
                          images: _getBannerList(),
                          defaultImage: R.images.smallDefaultImage,
                          dotSize: R.appRatio.appIconSize5,
                          dotSpacing: R.appRatio.appSpacing20,
                          dotColor: Colors.white,
                          dotIncreasedColor: R.colors.majorOrange,
                          dotBgColor: Colors.black.withOpacity(0.25),
                          boxFit: BoxFit.cover,
                          indicatorBgPadding: 5.0,
                          animationDuration: Duration(milliseconds: 500),
                          autoplayDuration: Duration(seconds: 8),
                        ),
                      ),
                      SizedBox(
                        height: R.appRatio.appSpacing20,
                      ),
                      TeamList(
                        items: _myTeamList,
                        labelTitle: R.strings.yourTeams,
                        enableLabelShadow: true,
                        enableScrollBackgroundColor: true,
                        pressItemFunction: (teamItem) {
                          pushPage(
                            context,
                            TeamInfoPage(teamId: teamItem.teamId),
                          );
                        },
                      ),
                      (checkListIsNullOrEmpty(_myInvitedTeamList)
                          ? Container()
                          : SizedBox(
                              height: R.appRatio.appSpacing20,
                            )),
                      (checkListIsNullOrEmpty(_myInvitedTeamList)
                          ? Container()
                          : TeamList(
                              items: _myInvitedTeamList,
                              labelTitle: R.strings.inviteTeamListTitle,
                              enableLabelShadow: true,
                              enableScrollBackgroundColor: true,
                              enableSplitListToTwo: false,
                              pressItemFunction: (teamItem) {
                                pushPage(
                                  context,
                                  TeamInfoPage(
                                    teamId: teamItem.teamId,
                                  ),
                                );
                              },
                            )),
                      (checkListIsNullOrEmpty(_myRequestingTeamList)
                          ? Container()
                          : SizedBox(
                              height: R.appRatio.appSpacing20,
                            )),
                      (checkListIsNullOrEmpty(_myRequestingTeamList)
                          ? Container()
                          : TeamList(
                              items: _myRequestingTeamList,
                              labelTitle: R.strings.requestTeamListTitle,
                              enableLabelShadow: true,
                              enableScrollBackgroundColor: true,
                              enableSplitListToTwo: false,
                              pressItemFunction: (teamItem) {
                                pushPage(context,
                                    TeamInfoPage(teamId: teamItem.teamId));
                              },
                            )),
                      SizedBox(
                        height: R.appRatio.appSpacing20,
                      ),
                      TeamList(
                        items: _teamSuggestionList,
                        labelTitle: R.strings.weSuggestYou,
                        enableLabelShadow: true,
                        enableScrollBackgroundColor: true,
                        enableSplitListToTwo: false,
                        pressItemFunction: (teamItem) {
                          pushPage(
                            context,
                            TeamInfoPage(teamId: teamItem.teamId),
                          );
                        },
                      ),
                      SizedBox(
                        height: R.appRatio.appSpacing20,
                      ),
                      LineButton(
                        mainText: R.strings.viewAllTeams,
                        mainTextFontSize: R.appRatio.appFontSize16,
                        enableSuffixIcon: true,
                        suffixIconSize: R.appRatio.appIconSize15,
                        suffixIconImageURL: R.myIcons.nextIconByTheme,
                        enableBottomUnderline: true,
                        textPadding: EdgeInsets.all(15),
                        enableTopUnderline: true,
                        lineFunction: () {
                          pushPage(
                            context,
                            TeamSearchPage(
                              autoFocusInput: false,
                              defaultList: _teamSuggestionList,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )),
        ),
      ),
    );
  }
}
