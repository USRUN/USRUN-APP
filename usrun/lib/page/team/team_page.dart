import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:usrun/core/R.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/demo_data.dart';
import 'package:usrun/page/team/team_search_page.dart';
import 'package:usrun/util/image_cache_manager.dart';
import 'package:usrun/widget/avatar_view.dart';
import 'package:usrun/widget/custom_cell.dart';
import 'package:usrun/widget/custom_popup_menu.dart';
import 'package:usrun/widget/line_button.dart';
import 'package:usrun/widget/loading_dot.dart';
import 'package:usrun/widget/team_list.dart';

class TeamPage extends StatefulWidget {
  @override
  _TeamPageState createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  bool _isLoading;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
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

  @override
  Widget build(BuildContext context) {
    return (_isLoading
        ? LoadingDotStyle02()
        : Scaffold(
            backgroundColor: R.colors.appBackground,
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
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
                      items: DemoData().teamList,
                      labelTitle: R.strings.yourTeams,
                      enableLabelShadow: true,
                      enableScrollBackgroundColor: true,
                      pressItemFuction: (teamid) {
                        print(
                            "[YourTeams] This team with id $teamid is pressed");
                      },
                    ),
                    SizedBox(
                      height: R.appRatio.appSpacing20,
                    ),
                    TeamList(
                      items: DemoData().teamList + DemoData().teamList,
                      labelTitle: R.strings.weSuggestYou,
                      enableLabelShadow: true,
                      enableScrollBackgroundColor: true,
                      enableSplitListToTwo: true,
                      pressItemFuction: (teamid) {
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
                          TeamSearchPage(autoFocusInput: false),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ));
  }
}
