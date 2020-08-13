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
import 'package:usrun/widget/avatar_view.dart';
import 'package:usrun/widget/custom_cell.dart';
import 'package:usrun/widget/custom_gradient_app_bar.dart';
import 'package:usrun/widget/input_field.dart';
import 'package:usrun/widget/loading_dot.dart';
import 'package:usrun/widget/team_list/team_item.dart';

class TeamSearchPage extends StatefulWidget {
  final bool autoFocusInput;
  final int resultPerPage = 15;
  final List defaultList;

  TeamSearchPage({this.autoFocusInput = false, @required this.defaultList});

  @override
  _TeamSearchPageState createState() => _TeamSearchPageState();
}

class _TeamSearchPageState extends State<TeamSearchPage> {
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _textSearchController = TextEditingController();
  bool _isLoading;
  bool remainingResults;
  List<TeamItem> teamList;
  String curSearchString;
  int curResultPage;

  @override
  void initState() {
    super.initState();
    curSearchString = "";
    _isLoading = true;
    curResultPage = 1;
    remainingResults = true;
    teamList = List();

    if (widget.defaultList != null)
      teamList = widget.defaultList;
    else
      _findTeamByName();

    WidgetsBinding.instance.addPostFrameCallback((_) => _updateLoading());
  }

  void _updateLoading() {
    Future.delayed(Duration(milliseconds: 1000), () {
      if (!mounted) return;
      setState(() {
        _isLoading = !_isLoading;
      });
    });
  }

  void _findTeamByName() async {
    if (!remainingResults) return;

    remainingResults = false;
    Response<dynamic> response = await TeamManager.findTeamRequest(
        curSearchString, curResultPage, widget.resultPerPage);

    if (response.success && (response.object as List).isNotEmpty) {
      List<TeamItem> toAdd = List();
      response.object.forEach((element) {
        toAdd.add(new TeamItem.from(element));
      });

      if (!mounted) return;
      setState(() {
        teamList.addAll(toAdd);
        remainingResults = true;
        curResultPage += 1;
      });
    }
  }

  void _onSubmittedFunction(data) {
    if (data.toString().length == 0) return;
    if (!mounted) return;

    setState(() {
      _isLoading = !_isLoading;
      curSearchString = data.toString();
      teamList.clear();
      curResultPage = 0;
      remainingResults = true;
    });

    _findTeamByName();

    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void _onChangedFunction(data) {
    if (data.toString().length == 0) {
      if (!mounted) return;
      setState(() {
        teamList = widget.defaultList;
      });
    }
  }

  bool _isEmptyList() {
    return ((this.teamList == null || this.teamList.length == 0)
        ? true
        : false);
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

  Widget _renderSuggestedTeams() {
    return AnimationLimiter(
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            if (remainingResults) _findTeamByName();
          }
          return true; // just to clear a warning
        },
        child: _isEmptyList()
            ? _buildEmptyList()
            : ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: (teamList != null) ? teamList.length : 0,
                itemBuilder: (BuildContext context, int index) {
                  String avatarImageURL = teamList[index].avatarImageURL;
                  String teamName = teamList[index].name;
                  String athleteQuantity = NumberFormat("#,##0", "en_US")
                      .format(teamList[index].athleteQuantity);
                  String location = teamList[index].location.toString();

                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 400),
                    child: SlideAnimation(
                      verticalOffset: 100.0,
                      child: FadeInAnimation(
                        child: CustomCell(
                          padding: EdgeInsets.only(
                            top: R.appRatio.appSpacing15 - 2,
                            bottom: R.appRatio.appSpacing15 - 2,
                            left: R.appRatio.appSpacing15,
                            right: R.appRatio.appSpacing15,
                          ),
                          avatarView: AvatarView(
                            avatarImageURL: avatarImageURL,
                            avatarImageSize: R.appRatio.appWidth60,
                            avatarBoxBorder: Border.all(
                              width: 1,
                              color: R.colors.majorOrange,
                            ),
                          ),
                          // Content
                          title: teamName,
                          titleStyle: TextStyle(
                            fontSize: R.appRatio.appFontSize16,
                            color: R.colors.contentText,
                            fontWeight: FontWeight.w500,
                          ),
                          firstAddedTitle: athleteQuantity,
                          firstAddedTitleIconURL: R.myIcons.peopleIconByTheme,
                          firstAddedTitleIconSize: R.appRatio.appIconSize15,
                          secondAddedTitle: location,
                          secondAddedTitleIconURL: R.myIcons.gpsIconByTheme,
                          secondAddedTitleIconSize: R.appRatio.appIconSize15,
                          pressInfo: () {
                            pushPage(
                              context,
                              TeamInfoPage(
                                teamId: teamList[index].teamId,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildElement = Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: R.colors.appBackground,
      appBar: CustomGradientAppBar(
        titleWidget: InputField(
          controller: _textSearchController,
          focusNode: _searchFocusNode,
          hintText: R.strings.search,
          hintStyle: TextStyle(
            fontSize: R.appRatio.appFontSize18,
            color: Colors.white.withOpacity(0.5),
          ),
          contentStyle: TextStyle(
            color: Colors.white,
            fontSize: R.appRatio.appFontSize18,
            fontWeight: FontWeight.w500,
          ),
          bottomUnderlineColor: Colors.white,
          enableBottomUnderline: true,
          isDense: true,
          autoFocus: widget.autoFocusInput,
          textInputAction: TextInputAction.search,
          onSubmittedFunction: _onSubmittedFunction,
          onChangedFunction: _onChangedFunction,
        ),
      ),
      body: (_isLoading ? LoadingIndicator() : _renderSuggestedTeams()),
    );

    return NotificationListener<OverscrollIndicatorNotification>(
      child: _buildElement,
      onNotification: (overScroll) {
        overScroll.disallowGlow();
        return false;
      },
    );
  }
}
