import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/animation/slide_page_route.dart';
import 'package:usrun/core/define.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/manager/data_manager.dart';
import 'package:usrun/manager/user_manager.dart';
import 'package:usrun/model/object_filter.dart';
import 'package:usrun/model/response.dart';
import 'package:usrun/model/user.dart';
import 'package:usrun/page/setting/app_info.dart';
import 'package:usrun/page/setting/change_password.dart';
import 'package:usrun/page/setting/inapp_notifications.dart';
import 'package:usrun/page/setting/privacy_profile.dart';
import 'package:usrun/page/welcome/welcome_page.dart';
import 'package:usrun/widget/custom_dialog/custom_alert_dialog.dart';
import 'package:usrun/widget/custom_dialog/custom_complex_dialog.dart';
import 'package:usrun/widget/custom_dialog/custom_language_dialog.dart';
import 'package:usrun/widget/custom_dialog/custom_selection_dialog.dart';
import 'package:usrun/widget/input_field.dart';
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
  bool showVerifyButtons =
      UserManager.currentUser.email.endsWith("@student.hcmus.edu.vn") &&
          !UserManager.currentUser.hcmus;

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
      title: R.strings.settingsDefaultTabTitle,
      description: R.strings.settingsDefaultTabDescription,
    );

    if (selectedIndex != null) {
      DataManager.setUserDefaultTab(selectedIndex);
      if (!mounted) return;
      setState(() {
        currentDefaultTab = selectedIndex;
      });
    }
  }

  void handleChangeRunningUnit(state) async {
    if (state) {
      DataManager.setUserRunningUnit(RunningUnit.METER);
    } else {
      DataManager.setUserRunningUnit(RunningUnit.KILOMETER);
    }

    await showCustomAlertDialog(
      context,
      title: R.strings.notice,
      content: R.strings.settingsAskForRestart,
      firstButtonText: R.strings.ok.toUpperCase(),
      firstButtonFunction: () {
        restartApp(0);
      },
      secondButtonText: R.strings.cancel,
      secondButtonFunction: () {
        pop(context);
      },
    );
  }

  // VERIFICATIONS
//  void handleAccountVerificationResponse(String otp) async {
//    Response<dynamic> response = await UserManager.verifyAccount(otp);
//
//    User newUser = currentUser;
//    newUser.hcmus = true;
//    currentUser.copy(newUser);
//    DataManager.saveUser(newUser);
//
//    pop(context);
//
//    if (response.success) {
//      setState(
//        () {
//          showVerifyButtons = false;
//        },
//      );
//
//      await showCustomAlertDialog(
//        context,
//        title: R.strings.notice,
//        content: R.strings.settingsAccountVerified,
//        firstButtonText: R.strings.ok.toUpperCase(),
//        firstButtonFunction: () {
//          pop(context);
//        },
//      );
//    } else {
//      await showCustomAlertDialog(
//        context,
//        title: R.strings.error.toUpperCase(),
//        content: response.errorMessage,
//        firstButtonText: R.strings.ok.toUpperCase(),
//        firstButtonFunction: () {
//          pop(context);
//        },
//      );
//    }
//  }
//
//  void handleVerifyButton() async {
//    TextEditingController _otpController = TextEditingController();
//    FocusNode _otpNode = FocusNode();
//
//    await showCustomComplexDialog(
//      context: context,
//      headerContent: "ACCOUNT VERIFICATION",
//      descriptionContent:
//          "Verify your account using the OTP sent to your email",
//      inputFieldList: [
//        InputField(
//          controller: _otpController,
//          enableFullWidth: true,
//          labelTitle: R.strings.otp,
//          hintText: R.strings.settingsCheckMailForOTP,
//          focusNode: _otpNode,
//        ),
//      ],
//      firstButtonText: R.strings.settingsVerifyButton.toUpperCase(),
//      firstButtonFunction: () async {
//        handleAccountVerificationResponse(_otpController.text);
//      },
//      secondButtonText: R.strings.cancel.toUpperCase(),
//      secondButtonFunction: () => pop(context),
//    );
//  }
//
//  void handleResendButton() async {
//    await showCustomAlertDialog(
//      context,
//      title: R.strings.settingsResendOTP.toUpperCase(),
//      content: "Do you want us to send another OTP to your mail?",
//      firstButtonText: R.strings.settingsResendOTP.toUpperCase(),
//      firstButtonFunction: () async {
//        Response response = await UserManager.resendOTP();
//        pop(context);
//
//        if (response.success) {
//          await showCustomAlertDialog(
//            context,
//            title: R.strings.notice.toUpperCase(),
//            content: R.strings.settingsOTPSent,
//            firstButtonText: R.strings.ok.toUpperCase(),
//            firstButtonFunction: () {
//              pop(context);
//            },
//          );
//        } else {
//          await showCustomAlertDialog(
//            context,
//            title: R.strings.error.toUpperCase(),
//            content: response.errorMessage,
//            firstButtonText: R.strings.ok.toUpperCase(),
//            firstButtonFunction: () {
//              pop(context);
//            },
//          );
//        }
//      },
//      secondButtonText: R.strings.cancel,
//      secondButtonFunction: () {
//        pop(context);
//      },
//    );
//  }

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
                resultTextFontSize: R.appRatio.appFontSize16,
                enableBottomUnderline: true,
                textPadding: EdgeInsets.all(15),
                lineFunction: () {},
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
                resultTextFontSize: R.appRatio.appFontSize16,
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
                resultTextFontSize: R.appRatio.appFontSize16,
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
                resultTextFontSize: R.appRatio.appFontSize16,
                enableBottomUnderline: true,
                textPadding: EdgeInsets.all(15),
                lineFunction: () {
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
                initSwitchStatus:
                    DataManager.getUserRunningUnit() == RunningUnit.METER,
                switchFunction: (state) {
                  handleChangeRunningUnit(state);
                },
              ),
              LineButton(
                mainText: R.strings.settingsDisplayThemeTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                subText: R.strings.appThemeDescription,
                subTextFontSize: R.appRatio.appFontSize16,
                enableBottomUnderline: true,
                textPadding: EdgeInsets.all(15),
                lineFunction: () async {
                  int index = await showCustomSelectionDialog(
                    context,
                    [
                      ObjectFilter(
                        name: R.strings.lightTheme,
                        value: AppTheme.LIGHT.index,
                      ),
                      ObjectFilter(
                        name: R.strings.darkTheme,
                        value: AppTheme.DARK.index,
                      ),
                    ],
                    R.currentAppTheme.index,
                    title: R.strings.chooseAppThemeTitle,
                    description: R.strings.chooseAppThemeDescription,
                  );

                  if (index != null) {
                    AppTheme appTheme = AppTheme.values[index];
                    R.changeAppTheme(appTheme);
                    DataManager.saveAppTheme(appTheme);
                    restartApp(0);
                  }
                },
              ),
              LineButton(
                mainText: R.strings.settingsDisplayLanguageTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                subText: R.strings.languageDescription,
                subTextFontSize: R.appRatio.appFontSize16,
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
                subTextFontSize: R.appRatio.appFontSize16,
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
                mainText: R.strings.settingsSOAppInfoTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                enableBottomUnderline: true,
                textPadding: EdgeInsets.all(15),
                lineFunction: () {
                  pushPage(context, AppInfo());
                },
              ),
              LineButton(
                mainText: R.strings.settingsSOLogOutTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                enableBottomUnderline: false,
                textPadding: EdgeInsets.all(15),
                lineFunction: () async {
                  await showCustomAlertDialog(
                    context,
                    title: R.strings.caution,
                    content: R.strings.logoutApp,
                    firstButtonText: R.strings.yes.toUpperCase(),
                    firstButtonFunction: () {
                      UserManager.logout();
                      pop(context);
                      Future.delayed(
                        Duration(milliseconds: 600),
                        () {
                          showPageWithRoute(
                            context,
                            SlidePageRoute(page: WelcomePage()),
                            popUntilFirstRoutes: true,
                          );
                        },
                      );
                    },
                    secondButtonText: R.strings.no.toUpperCase(),
                    secondButtonFunction: () => pop(context),
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
