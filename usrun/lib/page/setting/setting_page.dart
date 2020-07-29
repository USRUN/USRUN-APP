import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/define.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/manager/data_manager.dart';
import 'package:usrun/model/object_filter.dart';
import 'package:usrun/model/user.dart';
import 'package:usrun/manager/user_manager.dart';
import 'package:usrun/page/setting/about_us.dart';
import 'package:usrun/page/setting/change_password.dart';
import 'package:usrun/page/setting/inapp_notifications.dart';
import 'package:usrun/page/setting/privacy_profile.dart';
import 'package:usrun/page/welcome/welcome_page.dart';
import 'package:usrun/widget/custom_dialog/custom_language_dialog.dart';
import 'package:usrun/widget/custom_dialog/custom_selection_dialog.dart';
import 'package:usrun/widget/line_button.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  User currentUser = UserManager.currentUser;
  List<String> possibleTab = [
    R.strings.record,
    R.strings.uFeed,
    R.strings.events,
    R.strings.teams,
    R.strings.profile,
    R.strings.settings,
  ];
  int currentDefaultTab = DataManager.getUserDefaultTab();

  void handleChangeDefaultTab() async {
    int selectedIndex = await showCustomSelectionDialog(
      context,
      [
        ObjectFilter(name: R.strings.record, value: 0),
        ObjectFilter(name: R.strings.uFeed, value: 1),
        ObjectFilter(name: R.strings.events, value: 2),
        ObjectFilter(name: R.strings.teams, value: 3),
        ObjectFilter(name: R.strings.profile, value: 4),
        ObjectFilter(name: R.strings.settings, value: 5),
      ],
      currentDefaultTab,
      title: "Select default tab",
      description:
          "You can choose a default tab which will be displayed when the app opened",
    );

    if (selectedIndex != null) {
      DataManager.setUserDefaultTab(selectedIndex);

      setState(() {
        currentDefaultTab = selectedIndex;
      });
    }
  }

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
                  left: 15,
                ),
                child: Text(
                  R.strings.settingsAccountLabel,
                  textAlign: TextAlign.start,
                  style: R.styles.shadowLabelStyle,
                ),
              ),
              LineButton(
                mainText: R.strings.settingsAccountTypeTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                resultText: R.strings.student,
                resultTextFontSize: R.appRatio.appFontSize14,
                enableBottomUnderline: true,
                textPadding: EdgeInsets.all(15),
                lineFunction: () {
                  // TODO: Implement function here
                  print("Line function");
                },
              ),
              // No password to be changed if user signed up using social networks
              (currentUser.type == LoginChannel.UsRun)
                  ? LineButton(
                      mainText: R.strings.changePassword,
                      mainTextFontSize: R.appRatio.appFontSize18,
                      enableBottomUnderline: true,
                      textPadding: EdgeInsets.all(15),
                      lineFunction: () {
                        pushPage(context, ChangePasswordPage());
                      },
                    )
                  : Container(),
              LineButton(
                mainText: R.strings.settingsAccountPrivacyProfileTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                enableBottomUnderline: true,
                textPadding: EdgeInsets.all(15),
                lineFunction: () {
                  pushPage(context, PrivacyProfile());
                },
              ),
              LineButton(
                mainText: R.strings.settingsAccountConnectGoogleTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                resultText: R.strings.connected,
                resultTextFontSize: R.appRatio.appFontSize14,
                enableBottomUnderline: true,
                textPadding: EdgeInsets.all(15),
                enableSplashColor: false,
                lineFunction: () {
                  // TODO: Implement function here
                  print("Line function");
                },
              ),
              LineButton(
                mainText: R.strings.settingsAccountConnectFacebookTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                resultText: R.strings.disconnected,
                resultTextFontSize: R.appRatio.appFontSize14,
                enableBottomUnderline: true,
                textPadding: EdgeInsets.all(15),
                enableSplashColor: false,
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
                  left: 15,
                ),
                child: Text(
                  R.strings.settingsDisplayLabel,
                  textAlign: TextAlign.start,
                  style: R.styles.shadowLabelStyle,
                ),
              ),
              LineButton(
                mainText: R.strings.settingsDisplayDefaultTabTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                resultText: possibleTab[currentDefaultTab],
                resultTextFontSize: R.appRatio.appFontSize14,
                enableBottomUnderline: true,
                textPadding: EdgeInsets.all(15),
                lineFunction: () async {
                  handleChangeDefaultTab();
                },
              ),
              LineButton(
                mainText: R.strings.settingsDisplayMeasureTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                enableBottomUnderline: true,
                textPadding: EdgeInsets.all(15),
                enableSwitchButton: true,
                switchButtonOnTitle: "M",
                switchButtonOffTitle: "Km",
                initSwitchStatus: true,
                switchFunction: (state) {
                  // TODO: Implementing here
                  print('Current State of SWITCH IS: $state');
                },
              ),
              LineButton(
                mainText: R.strings.settingsDisplayThemeTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                enableBottomUnderline: true,
                textPadding: EdgeInsets.all(15),
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
              LineButton(
                mainText: R.strings.settingsDisplayLanguageTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                subText: R.strings.languageDescription,
                subTextFontSize: R.appRatio.appFontSize14,
                enableBottomUnderline: true,
                textPadding: EdgeInsets.all(15),
                lineFunction: () async {
                  String lang = await showCustomLanguageDialog<String>(context);
                  if (lang != null) {
                    DataManager.saveLanguage(lang);
                    restartApp(0);
                  }
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
                  left: 15,
                ),
                child: Text(
                  R.strings.settingsNotiLabel,
                  textAlign: TextAlign.start,
                  style: R.styles.shadowLabelStyle,
                ),
              ),
              LineButton(
                mainText: R.strings.settingsNotiInAppTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                enableBottomUnderline: true,
                textPadding: EdgeInsets.all(15),
                lineFunction: () {
                  pushPage(context, InAppNotifications());
                },
              ),
              LineButton(
                mainText: R.strings.settingsNotiEmailTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                subText: R.strings.settingsNotiEmailSubtitle,
                subTextFontSize: R.appRatio.appFontSize14,
                enableBottomUnderline: true,
                textPadding: EdgeInsets.all(15),
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
                  left: 15,
                ),
                child: Text(
                  R.strings.settingsSOLabel,
                  textAlign: TextAlign.start,
                  style: R.styles.shadowLabelStyle,
                ),
              ),
              LineButton(
                mainText: R.strings.settingsSOFAQsTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                enableBottomUnderline: true,
                textPadding: EdgeInsets.all(15),
                lineFunction: () {
                  // TODO: Implement function here
                  print("Line function");
                },
              ),
              LineButton(
                mainText: R.strings.settingsSOContactTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                enableBottomUnderline: true,
                textPadding: EdgeInsets.all(15),
                lineFunction: () {
                  // TODO: Implement function here
                  print("Line function");
                },
              ),
              LineButton(
                mainText: R.strings.settingsSOLegalTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                enableBottomUnderline: true,
                textPadding: EdgeInsets.all(15),
                lineFunction: () {
                  // TODO: Implement function here
                  print("Line function");
                },
              ),
              LineButton(
                mainText: R.strings.settingsSOAboutUsTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                enableBottomUnderline: true,
                textPadding: EdgeInsets.all(15),
                lineFunction: () {
                  pushPage(context, AboutUs());
                },
              ),
              LineButton(
                mainText: R.strings.settingsSOLogOutTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                enableBottomUnderline: false,
                textPadding: EdgeInsets.all(15),
                lineFunction: () {
                  UserManager.logout();
                  showPage(
                    context,
                    WelcomePage(),
                    popUntilFirstRoutes: true,
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
