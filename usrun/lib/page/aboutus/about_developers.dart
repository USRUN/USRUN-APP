import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/widget/avatar_view.dart';

class AboutDevelopers extends StatelessWidget {
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
          R.strings.aboutDevelopers,
          style: TextStyle(
              color: Colors.white, fontSize: R.appRatio.appFontSize22),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            left: R.appRatio.appPadding25,
            right: R.appRatio.appPadding25,
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: R.appRatio.appSpacing25,
                ),
                // -----
                // DEVELOPER 1
                AvatarView(
                  avatarImageURL: null, // TODO: Put team images here
                  avatarImageSize: R.appRatio.appAvatarSize150,
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
                  height: R.appRatio.appSpacing30,
                ),
                // DEVELOPER 2
                AvatarView(
                  avatarImageURL: null, // TODO: Put team images here
                  avatarImageSize: R.appRatio.appAvatarSize150,
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
                  height: R.appRatio.appSpacing30,
                ),
                // DEVELOPER 3
                AvatarView(
                  avatarImageURL: null, // TODO: Put team images here
                  avatarImageSize: R.appRatio.appAvatarSize150,
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
                  height: R.appRatio.appSpacing30,
                ),
                // DEVELOPER 4
                AvatarView(
                  avatarImageURL: null, // TODO: Put team images here
                  avatarImageSize: R.appRatio.appAvatarSize150,
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
                  height: R.appRatio.appSpacing30,
                ),
                // DEVELOPER 5
                AvatarView(
                  avatarImageURL: null, // TODO: Put team images here
                  avatarImageSize: R.appRatio.appAvatarSize150,
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
                  height: R.appRatio.appSpacing25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
