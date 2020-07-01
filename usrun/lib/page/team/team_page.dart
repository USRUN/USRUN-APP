import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:usrun/core/R.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/demo_data.dart';
import 'package:usrun/manager/user_manager.dart';
import 'package:usrun/model/response.dart';
import 'package:usrun/model/team.dart';
import 'package:usrun/page/team/team_info.dart';
import 'package:usrun/page/team/team_search_page.dart';
import 'package:usrun/util/image_cache_manager.dart';
import 'package:usrun/widget/line_button.dart';
import 'package:usrun/widget/loading_dot.dart';
import 'package:usrun/widget/team_list.dart';
import 'package:usrun/manager/team_manager.dart';

class TeamPage extends StatefulWidget {
  final int suggestionLength = 15;
  @override
  _TeamPageState createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  bool _isLoading;
  List _myTeamList;
  List _teamSuggestionList;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _teamSuggestionList = List();
    _myTeamList = List();
    _getMyTeamList(UserManager.currentUser.userId);
    _getSuggestionList(widget.suggestionLength);

    WidgetsBinding.instance.addPostFrameCallback((_) => _updateLoading());
  }

  void _updateLoading() {
    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        _isLoading = !_isLoading;
      });
    });
  }

  List<dynamic> _getBannerList() {
    List<dynamic> bannerList = List<dynamic>();

    List<dynamic> data = DemoData().bannerList;
    for (int i = 0; i < data.length; ++i) {
      bannerList.add(ImageCacheManager.getImageData(url: data[i]['imageURL']));
    }

    return bannerList;
  }

  void _getMyTeamList(int userId) async {
    Response<dynamic> response = await TeamManager.getMyTeam();
//    Response<List<Team>> response = await TeamManager.getTeamSuggestion(5);
    if (response.success && (response.object as List).isNotEmpty) {
      setState(() {
        _myTeamList = response.object;
      });
    } else {
      _myTeamList = null;
    }
  }

  void _getSuggestionList(int howMany) async {
//    Response<List<Team>> response = await TeamManager.getTeamSuggestion(howMany);
    Response<dynamic> response = await TeamManager.getMyTeam();
    if (response.success && (response.object as List).isNotEmpty) {
      setState(() {
        _teamSuggestionList = response.object;
      });
    } else {
      _teamSuggestionList = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: R.colors.appBackground,
        body: (_isLoading
            ? LoadingDotStyle02()
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
                      pressItemFuction: (teamid) {
                        // TODO: Test
                        pushPage(context, TeamInfoPage(teamId: teamid));
                        print(
                            "[YourTeams] This team with id $teamid is pressed");
                      },
                    ),
                    SizedBox(
                      height: R.appRatio.appSpacing20,
                    ),
                    TeamList(
//                      items: DemoData().teamList + DemoData().teamList,
                      items: _teamSuggestionList,
                      labelTitle: R.strings.weSuggestYou,
                      enableLabelShadow: true,
                      enableScrollBackgroundColor: true,
                      enableSplitListToTwo: _teamSuggestionList.length > 10? true:false,
                      pressItemFuction: (teamid) {
                        pushPage(context, TeamInfoPage(teamId: teamid));
                        print(
                            "[WeSuggestYou] This team with id $teamid is pressed");
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
                      enableTopUnderline: true,
                      lineFunction: () {
                        pushPage(
                          context,
                          TeamSearchPage(autoFocusInput: false,defaultList: _teamSuggestionList),
                        );
                      },
                    ),
                  ],
                ),
              )));
  }
}
