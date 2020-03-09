import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/page/aboutus/about_developers.dart';
import 'package:usrun/page/aboutus/about_usrun.dart';
import 'package:usrun/widget/aboutus_box.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          R.strings.aboutUs,
          style: TextStyle(
              color: Colors.white, fontSize: R.appRatio.appFontSize22),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            left: R.appRatio.appSpacing30,
            right: R.appRatio.appSpacing30,
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: R.appRatio.appSpacing30,
                ),
                // About USRUN
                AboutUsBox(
                  iconImageURL: R.myIcons.aboutUsUSRUN,
                  subtitle: R.strings.aboutUsUSRUNSubtitle,
                  title: R.strings.aboutUsUSRUNTitle,
                  iconSize: R.appRatio.appIconSize40,
                  pressBox: () {
                    pushPage(context, AboutUSRUN());
                  },
                ),
                SizedBox(
                  height: R.appRatio.appSpacing30,
                ),
                // Developers
                AboutUsBox(
                  iconImageURL: R.myIcons.aboutUsDevelopers,
                  subtitle: R.strings.aboutUsDevelopersSubtitle,
                  title: R.strings.aboutUsDevelopersTitle,
                  iconSize: R.appRatio.appIconSize40,
                  pressBox: () {
                    pushPage(context, AboutDevelopers());
                  },
                ),
                SizedBox(
                  height: R.appRatio.appSpacing30,
                ),
                // Version
                AboutUsBox(
                  iconImageURL: R.myIcons.aboutUsVersion,
                  subtitle: R.strings.aboutUsVersionSubtitle,
                  title: R.strings.aboutUsVersionTitle,
                  iconSize: R.appRatio.appIconSize40,
                  pressBox: null, // TODO: Implement this function here
                ),
                SizedBox(
                  height: R.appRatio.appSpacing30,
                ),
                // Rate app
                AboutUsBox(
                  iconImageURL: R.myIcons.aboutUsRateApp,
                  subtitle: R.strings.aboutUsRateAppSubtitle,
                  title: R.strings.aboutUsRateAppTitle,
                  iconSize: R.appRatio.appIconSize40 + 5,
                  pressBox: null, // TODO: Implement this function here
                ),
                SizedBox(
                  height: R.appRatio.appSpacing30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
