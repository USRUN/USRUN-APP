import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/demo_data.dart';
import 'package:usrun/widget/avatar_view.dart';
import 'package:usrun/widget/custom_cell.dart';
import 'package:usrun/widget/input_field.dart';
import 'package:usrun/widget/loading_dot.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class TeamSearchPage extends StatefulWidget {
  final bool autoFocusInput;

  TeamSearchPage({
    this.autoFocusInput = false,
  });

  @override
  _TeamSearchPageState createState() => _TeamSearchPageState();
}

class _TeamSearchPageState extends State<TeamSearchPage> {
  final TextEditingController _textSearchController = TextEditingController();
  bool _isLoading;
  List teamList;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    teamList = DemoData().suggestedTeamList;
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateLoading());
  }

  void _updateLoading() {
    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        _isLoading = !_isLoading;
      });
    });
  }

  void _onSubmittedFunction(data) {
    if (data.toString().length == 0) return;
    setState(() {
      _isLoading = !_isLoading;
    });

    // TODO: Implement function here
    print("Data: $data");

    // [Demo] Enter searching content => Render "SearchedTeams" by setState
    List<dynamic> newList = List<dynamic>();
    Future.delayed(Duration(milliseconds: 1000), () {
      newList.addAll(teamList.getRange(2, 7));
    }).then((val) {
      setState(() {
        _isLoading = !_isLoading;
        teamList = newList;
      });
    });
  }

  void _onChangedFunction(data) {
    // [Demo] Clear all searching content => Render "SuggestedTeams" by setState
    if (data.toString().length == 0) {
      setState(() {
        teamList = DemoData().suggestedTeamList;
      });
    }
  }

  Widget _renderSuggestedTeams() {
    return AnimationLimiter(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: teamList.length,
          itemBuilder: (BuildContext ctxt, int index) {
            String avatarImageURL = teamList[index]['avatarImageURL'];
            String supportImageURL = teamList[index]['supportImageURL'];
            String teamName = teamList[index]['teamName'];
            String athleteQuantity = NumberFormat("#,##0", "en_US")
                .format(teamList[index]['athleteQuantity']);
            String location = teamList[index]['location'];

            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 400),
              child: SlideAnimation(
                verticalOffset: 100.0,
                child: FadeInAnimation(
                  child: Container(
                    padding: EdgeInsets.only(
                      top: (index == 0 ? R.appRatio.appSpacing20 : 0),
                      bottom: R.appRatio.appSpacing20,
                      left: R.appRatio.appSpacing15,
                      right: R.appRatio.appSpacing15,
                    ),
                    child: CustomCell(
                      avatarView: AvatarView(
                        avatarImageURL: avatarImageURL,
                        avatarImageSize: R.appRatio.appWidth60,
                        avatarBoxBorder: Border.all(
                          width: 1,
                          color: R.colors.majorOrange,
                        ),
                        supportImageURL: supportImageURL,
                        pressAvatarImage: () {
                          print("Pressing avatar image");
                        },
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
                        print("Pressing info");
                      },
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildElement = Scaffold(
      resizeToAvoidBottomInset: true,
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
        title: InputField(
          controller: _textSearchController,
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
      body: (_isLoading ? LoadingDotStyle02() : _renderSuggestedTeams()),
    );

    return NotificationListener<OverscrollIndicatorNotification>(
        child: _buildElement,
        onNotification: (overscroll) {
          overscroll.disallowGlow();
        });
  }
}
