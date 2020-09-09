import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/page/aboutus/about_developers.dart';
import 'package:usrun/page/aboutus/about_usrun.dart';
import 'package:usrun/widget/aboutus_box.dart';
import 'package:usrun/widget/custom_gradient_app_bar.dart';

class AppInfo extends StatelessWidget {
  final double _spacing = 25.0;
  final double _iconSize = 35.0;

  @override
  Widget build(BuildContext context) {
    String versionNumber = R.strings.appInfoVersionSubtitle;
    versionNumber = versionNumber.replaceFirst("###", R.versionNumber);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: R.colors.appBackground,
      appBar: CustomGradientAppBar(title: R.strings.appInformation),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            left: _spacing,
            right: _spacing,
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: _spacing,
                ),
                // About USRUN
                AboutUsBox(
                  iconImageURL: R.myIcons.aboutUsUSRUN,
                  subtitle: R.strings.appInfoUSRUNSubtitle,
                  title: R.strings.appInfoUSRUNTitle,
                  iconSize: _iconSize,
                  pressBox: () {
                    pushPage(context, AboutUSRUN());
                  },
                ),
                SizedBox(
                  height: _spacing,
                ),
                // Developers
                AboutUsBox(
                  iconImageURL: R.myIcons.aboutUsDevelopers,
                  subtitle: R.strings.appInfoDevelopersSubtitle,
                  title: R.strings.appInfoDevelopersTitle,
                  iconSize: _iconSize,
                  pressBox: () {
                    pushPage(context, AboutDevelopers());
                  },
                ),
                SizedBox(
                  height: _spacing,
                ),
                // Version
                AboutUsBox(
                  iconImageURL: R.myIcons.aboutUsVersion,
                  subtitle: versionNumber,
                  title: R.strings.appInfoVersionTitle,
                  iconSize: _iconSize,
                  pressBox: () {},
                ),
                SizedBox(
                  height: _spacing,
                ),
                // Rate app
                AboutUsBox(
                  iconImageURL: R.myIcons.aboutUsRateApp,
                  subtitle: R.strings.appInfoRateAppSubtitle,
                  title: R.strings.appInfoRateAppTitle,
                  iconSize: _iconSize,
                  pressBox: () {
                    StoreRedirect.redirect(
                      androidAppId: R.androidAppId,
                      iOSAppId: R.iOSAppId,
                    );
                  },
                ),
                SizedBox(
                  height: _spacing,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
