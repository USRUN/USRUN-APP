import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/widget/avatar_view.dart';
import 'package:usrun/widget/custom_gradient_app_bar.dart';

class AboutDevelopers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget _buildElement = Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: R.colors.appBackground,
      appBar: CustomGradientAppBar(title: R.strings.aboutDevelopers),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            left: R.appRatio.appSpacing25,
            right: R.appRatio.appSpacing25,
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: R.appRatio.appSpacing30,
                ),
                // -----
                // DEVELOPER 1
                Center(
                  child: AvatarView(
                    avatarImageURL: R.images.avatarQuocTK,
                    avatarImageSize: R.appRatio.appAvatarSize130,
                  ),
                ),
                SizedBox(
                  height: R.appRatio.appSpacing10,
                ),
                Text(
                  R.strings.aboutDevName_1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: R.colors.majorOrange,
                    fontSize: R.appRatio.appFontSize18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: R.appRatio.appSpacing10,
                ),
                Text(
                  R.strings.aboutDevTitle_1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: R.colors.contentText,
                    fontSize: R.appRatio.appFontSize18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: R.appRatio.appSpacing40,
                ),
                // DEVELOPER 2
                Center(
                  child: AvatarView(
                    avatarImageURL: R.images.avatarPhucTT,
                    avatarImageSize: R.appRatio.appAvatarSize130,
                  ),
                ),
                SizedBox(
                  height: R.appRatio.appSpacing10,
                ),
                Text(
                  R.strings.aboutDevName_2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: R.colors.majorOrange,
                    fontSize: R.appRatio.appFontSize18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: R.appRatio.appSpacing10,
                ),
                Text(
                  R.strings.aboutDevTitle_2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: R.colors.contentText,
                    fontSize: R.appRatio.appFontSize18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: R.appRatio.appSpacing40,
                ),
                // DEVELOPER 3
                Center(
                  child: AvatarView(
                    avatarImageURL: R.images.avatarNgocVTT,
                    avatarImageSize: R.appRatio.appAvatarSize130,
                  ),
                ),
                SizedBox(
                  height: R.appRatio.appSpacing10,
                ),
                Text(
                  R.strings.aboutDevName_3,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: R.colors.majorOrange,
                    fontSize: R.appRatio.appFontSize18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: R.appRatio.appSpacing10,
                ),
                Text(
                  R.strings.aboutDevTitle_3,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: R.colors.contentText,
                    fontSize: R.appRatio.appFontSize18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: R.appRatio.appSpacing40,
                ),
                // DEVELOPER 4
                Center(
                  child: AvatarView(
                    avatarImageURL: R.images.avatarKhaTM,
                    avatarImageSize: R.appRatio.appAvatarSize130,
                  ),
                ),
                SizedBox(
                  height: R.appRatio.appSpacing10,
                ),
                Text(
                  R.strings.aboutDevName_4,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: R.colors.majorOrange,
                    fontSize: R.appRatio.appFontSize18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: R.appRatio.appSpacing10,
                ),
                Text(
                  R.strings.aboutDevTitle_4,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: R.colors.contentText,
                    fontSize: R.appRatio.appFontSize18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: R.appRatio.appSpacing40,
                ),
                // DEVELOPER 5
                Center(
                  child: AvatarView(
                    avatarImageURL: R.images.avatarHuyTA,
                    avatarImageSize: R.appRatio.appAvatarSize130,
                  ),
                ),
                SizedBox(
                  height: R.appRatio.appSpacing10,
                ),
                Text(
                  R.strings.aboutDevName_5,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: R.colors.majorOrange,
                    fontSize: R.appRatio.appFontSize18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: R.appRatio.appSpacing10,
                ),
                Text(
                  R.strings.aboutDevTitle_5,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: R.colors.contentText,
                    fontSize: R.appRatio.appFontSize18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // -----
                SizedBox(
                  height: R.appRatio.appSpacing30,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return NotificationListener<OverscrollIndicatorNotification>(
        child: _buildElement,
        onNotification: (overScroll) {
          overScroll.disallowGlow();
          return false;
        });
  }
}
