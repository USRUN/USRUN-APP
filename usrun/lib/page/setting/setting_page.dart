import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/page/setting/about_us.dart';
import 'package:usrun/page/setting/change_password.dart';
import 'package:usrun/page/setting/inapp_notifications.dart';
import 'package:usrun/page/setting/privacy_profile.dart';
import 'package:usrun/widget/line_button.dart';

import '../../core/helper.dart';
import '../../manager/user_manager.dart';
import '../welcome/welcome_page.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: R.colors.appBackground,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: R.appRatio.appSpacing20,
              ),
              /* 
                  ACCOUNT
              */
              Padding(
                padding: EdgeInsets.only(
                  left: R.appRatio.appSpacing15,
                ),
                child: Text(
                  R.strings.settingsAccountLabel,
                  textAlign: TextAlign.start,
                  style: R.styles.shadowLabelStyle,
                ),
              ),
              SizedBox(
                height: R.appRatio.appSpacing15,
              ),
              LineButton(
                mainText: R.strings.settingsAccountTypeTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                resultText: R.strings.student,
                resultTextFontSize: R.appRatio.appFontSize14,
                spacingUnderlineAndMainText: R.appRatio.appSpacing15,
                enableBottomUnderline: true,
                lineFunction: () {
                  // TODO: Implement function here
                  print("Line function");
                },
              ),
              SizedBox(
                height: R.appRatio.appSpacing15,
              ),
              LineButton(
                mainText: R.strings.changePassword,
                mainTextFontSize: R.appRatio.appFontSize18,
                spacingUnderlineAndMainText: R.appRatio.appSpacing15,
                enableBottomUnderline: true,
                lineFunction: () {
                  pushPage(context, ChangePasswordPage());
                },
              ),
              SizedBox(
                height: R.appRatio.appSpacing15,
              ),
              LineButton(
                mainText: R.strings.settingsAccountPrivacyProfileTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                spacingUnderlineAndMainText: R.appRatio.appSpacing15,
                enableBottomUnderline: true,
                lineFunction: () {
                  pushPage(context, PrivacyProfile());
                },
              ),
              SizedBox(
                height: R.appRatio.appSpacing15,
              ),
              LineButton(
                mainText: R.strings.settingsAccountConnectGoogleTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                resultText: R.strings.connected,
                resultTextFontSize: R.appRatio.appFontSize14,
                spacingUnderlineAndMainText: R.appRatio.appSpacing15,
                enableBottomUnderline: true,
                lineFunction: () {
                  // TODO: Implement function here
                  print("Line function");
                },
              ),
              SizedBox(
                height: R.appRatio.appSpacing15,
              ),
              LineButton(
                mainText: R.strings.settingsAccountConnectFacebookTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                resultText: R.strings.disconnected,
                resultTextFontSize: R.appRatio.appFontSize14,
                spacingUnderlineAndMainText: R.appRatio.appSpacing15,
                enableBottomUnderline: true,
                lineFunction: () {
                  // TODO: Implement function here
                  print("Line function");
                },
              ),
              SizedBox(
                height: R.appRatio.appSpacing25,
              ),
              /* 
                  DISPLAY
              */
              Padding(
                padding: EdgeInsets.only(
                  left: R.appRatio.appSpacing15,
                ),
                child: Text(
                  R.strings.settingsDisplayLabel,
                  textAlign: TextAlign.start,
                  style: R.styles.shadowLabelStyle,
                ),
              ),
              SizedBox(
                height: R.appRatio.appSpacing15,
              ),
              LineButton(
                mainText: R.strings.settingsDisplayDefaultTabTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                resultText: R.strings.uFeed,
                resultTextFontSize: R.appRatio.appFontSize14,
                spacingUnderlineAndMainText: R.appRatio.appSpacing15,
                enableBottomUnderline: true,
                lineFunction: () {
                  // TODO: Implement function here
                  print("Line function");
                },
              ),
              SizedBox(
                height: R.appRatio.appSpacing15,
              ),
              LineButton(
                mainText: R.strings.settingsDisplayMeasureTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                spacingUnderlineAndMainText: R.appRatio.appSpacing15,
                enableBottomUnderline: true,
                enableSwitchButton: true,
                switchButtonOnTitle: "M",
                switchButtonOffTitle: "Km",
                initSwitchStatus: true,
                switchFunction: (state) {
                  // TODO: Implementing here
                  print('Current State of SWITCH IS: $state');
                },
              ),
              SizedBox(
                height: R.appRatio.appSpacing15,
              ),
              LineButton(
                mainText: R.strings.settingsDisplayThemeTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                spacingUnderlineAndMainText: R.appRatio.appSpacing15,
                enableBottomUnderline: true,
                enableSwitchButton: true,
                switchButtonOnTitle: "On",
                switchButtonOffTitle: "Off",
                initSwitchStatus: (R.currentAppTheme == "Light" ? false : true),
                switchFunction: (state) {
                  if (state) {
                    R.changeAppTheme("Black");
                  } else {
                    R.changeAppTheme("Light");
                  }
                  setState(() {});
                },
              ),
              SizedBox(
                height: R.appRatio.appSpacing15,
              ),
              LineButton(
                mainText: R.strings.settingsDisplayLanguageTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                spacingUnderlineAndMainText: R.appRatio.appSpacing15,
                enableBottomUnderline: true,
                enableSwitchButton: true,
                switchButtonOnTitle: "En",
                switchButtonOffTitle: "Vi",
                initSwitchStatus: true,
                switchFunction: (state) {
                  // TODO: Implementing here
                  print('Current State of SWITCH IS: $state');
                },
              ),
              SizedBox(
                height: R.appRatio.appSpacing25,
              ),
              /* 
                  NOTIFICATIONS
              */
              Padding(
                padding: EdgeInsets.only(
                  left: R.appRatio.appSpacing15,
                ),
                child: Text(
                  R.strings.settingsNotiLabel,
                  textAlign: TextAlign.start,
                  style: R.styles.shadowLabelStyle,
                ),
              ),
              SizedBox(
                height: R.appRatio.appSpacing15,
              ),
              LineButton(
                mainText: R.strings.settingsNotiInAppTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                spacingUnderlineAndMainText: R.appRatio.appSpacing15,
                enableBottomUnderline: true,
                lineFunction: () {
                  pushPage(context, InAppNotifications());
                },
              ),
              SizedBox(
                height: R.appRatio.appSpacing15,
              ),
              LineButton(
                mainText: R.strings.settingsNotiEmailTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                subText: R.strings.settingsNotiEmailSubtitle,
                subTextFontSize: R.appRatio.appFontSize14,
                spacingUnderlineAndMainText: R.appRatio.appSpacing15,
                enableBottomUnderline: true,
                enableSwitchButton: true,
                switchButtonOnTitle: "On",
                switchButtonOffTitle: "Off",
                initSwitchStatus: false,
                switchFunction: (state) {
                  // TODO: Implementing here
                  print('Current State of SWITCH IS: $state');
                },
              ),
              SizedBox(
                height: R.appRatio.appSpacing25,
              ),
              /* 
                  SUPPORT & OTHERS
              */
              Padding(
                padding: EdgeInsets.only(
                  left: R.appRatio.appSpacing15,
                ),
                child: Text(
                  R.strings.settingsSOLabel,
                  textAlign: TextAlign.start,
                  style: R.styles.shadowLabelStyle,
                ),
              ),
              SizedBox(
                height: R.appRatio.appSpacing15,
              ),
              LineButton(
                mainText: R.strings.settingsSOFAQsTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                spacingUnderlineAndMainText: R.appRatio.appSpacing15,
                enableBottomUnderline: true,
                lineFunction: () {
                  // TODO: Implement function here
                  print("Line function");
                },
              ),
              SizedBox(
                height: R.appRatio.appSpacing15,
              ),
              LineButton(
                mainText: R.strings.settingsSOContactTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                spacingUnderlineAndMainText: R.appRatio.appSpacing15,
                enableBottomUnderline: true,
                lineFunction: () {
                  // TODO: Implement function here
                  print("Line function");
                },
              ),
              SizedBox(
                height: R.appRatio.appSpacing15,
              ),
              LineButton(
                mainText: R.strings.settingsSOLegalTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                spacingUnderlineAndMainText: R.appRatio.appSpacing15,
                enableBottomUnderline: true,
                lineFunction: () {
                  // TODO: Implement function here
                  print("Line function");
                },
              ),
              SizedBox(
                height: R.appRatio.appSpacing15,
              ),
              LineButton(
                mainText: R.strings.settingsSOAboutUsTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                spacingUnderlineAndMainText: R.appRatio.appSpacing15,
                enableBottomUnderline: true,
                lineFunction: () {
                  pushPage(context, AboutUs());
                },
              ),
              SizedBox(
                height: R.appRatio.appSpacing15,
              ),
              LineButton(
                mainText: R.strings.settingsSOLogOutTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                spacingUnderlineAndMainText: R.appRatio.appSpacing15,
                enableBottomUnderline: true,
                lineFunction: () {
                  UserManager.logout();
                  showPage(
                    context,
                    WelcomePage(),
                    popAllRoutes: true,
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
