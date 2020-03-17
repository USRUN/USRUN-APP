import 'package:flutter/material.dart';
import 'package:usrun/util/reflector.dart';
import 'package:usrun/model/mapper_object.dart';

class R {
  static final _Color colors = _Color();
  static Strings strings = Strings();
  static final _Images images = _Images();
  static final Styles styles = Styles();

  static AppRatio appRatio = AppRatio();
  static _MyIcons myIcons = _MyIcons();

  static void initLocalized(String jsonContent) {
    R.strings = MapperObject.create<Strings>(jsonContent);
  }

  static void initAppRatio(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;
    double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    appRatio.setUpAppRatio(size.width, size.height, devicePixelRatio, textScaleFactor);
  }

  static void changeAppTheme(String appTheme) {
    if (appTheme.compareTo('Light') != 0 && appTheme.compareTo('Black') != 0) {
      appTheme = 'Light';
    }

    myIcons.changeTheme(appTheme);
  }
}

class AppRatio {
  /* 
    + This is private variables.
    + Figma design information.
  */
  final double _figmaDeviceWidth                = 411;
  final double _figmaDeviceHeight               = 731;

  final double _figmaFontSize12                 = 12;
  final double _figmaFontSize14                 = 14;
  final double _figmaFontSize16                 = 16;
  final double _figmaFontSize18                 = 18;
  final double _figmaFontSize20                 = 20;
  final double _figmaFontSize22                 = 22;
  final double _figmaFontSize24                 = 24;
  final double _figmaFontSize26                 = 26;
  final double _figmaFontSize28                 = 28;  

  final double _figmaWidth70                    = 70;
  final double _figmaWidth80                    = 80;
  final double _figmaWidth150                    = 150;
  final double _figmaWidth181                   = 181;
  final double _figmaWidth200                   = 200;
  final double _figmaWidth250                   = 250;
  final double _figmaWidth300                   = 300;
  final double _figmaWidth381                   = 381;

  final double _figmaHeight25                   = 25;
  final double _figmaHeight30                   = 30;
  final double _figmaHeight40                   = 40;
  final double _figmaHeight50                   = 50;
  final double _figmaHeight60                   = 60;
  final double _figmaHeight70                   = 70;
  final double _figmaHeight80                   = 80;
  final double _figmaHeight320                  = 320;

  final double _figmaSpacing5                   = 5;
  final double _figmaSpacing10                  = 10;
  final double _figmaSpacing15                  = 15;
  final double _figmaSpacing20                  = 20;
  final double _figmaSpacing25                  = 25;
  final double _figmaSpacing30                  = 30;
  final double _figmaSpacing35                  = 35;
  final double _figmaSpacing40                  = 40;
  final double _figmaSpacing45                  = 45;
  final double _figmaSpacing50                  = 50;

  final double _figmaIconSize15                 = 15;
  final double _figmaIconSize18                 = 18;
  final double _figmaIconSize20                 = 20;
  final double _figmaIconSize25                 = 25;
  final double _figmaIconSize30                 = 30;
  final double _figmaIconSize35                 = 35;
  final double _figmaIconSize40                 = 40;

  final double _figmaAppBarIconSize             = 22;
  final double _figmaWelcomPageLogoTextSize     = 160;
  final double _figmaDropDownImageSquareSize    = 40;
  final double _figmaDropDownArrowIconSize      = 32;

  final double _figmaAvatarSize130              = 130;
  final double _figmaAvatarSize150              = 150;

  /* 
    + This is public variables.
    + Information of device screen.
  */
  double deviceWidth;
  double deviceHeight;
  double devicePixelRatio;
  double textScaleFactor;

  /*
    + This is public variables.
    + Official and real object information.
  */
  double appFontSize12;
  double appFontSize14;
  double appFontSize16;
  double appFontSize18;
  double appFontSize20;
  double appFontSize22;
  double appFontSize24;
  double appFontSize26;
  double appFontSize28;

  double appWidth70;
  double appWidth80;
  double appWidth150;
  double appWidth181;
  double appWidth200;
  double appWidth250;
  double appWidth300;
  double appWidth381;

  double appHeight25;
  double appHeight30;
  double appHeight40;
  double appHeight50;
  double appHeight60;
  double appHeight70;
  double appHeight80;
  double appHeight320;

  double appSpacing5;
  double appSpacing10;
  double appSpacing15;
  double appSpacing20;
  double appSpacing25;
  double appSpacing30;
  double appSpacing35;
  double appSpacing40;
  double appSpacing45;
  double appSpacing50;

  double appIconSize15;
  double appIconSize18;
  double appIconSize20;
  double appIconSize25;
  double appIconSize30;
  double appIconSize35;
  double appIconSize40;

  double appAppBarIconSize;
  double appWelcomPageLogoTextSize;
  double appDropDownImageSquareSize;
  double appDropDownArrowIconSize;

  double appAvatarSize130;
  double appAvatarSize150;

  /*
    + This is private function.
    + Formula for finding suitable size of object
  */
  double _computeWidth(num figmaObjSize) {
    return (this.deviceWidth / this._figmaDeviceWidth) * figmaObjSize;
  }

  double _computeHeight(num figmaObjSize) {
    double result = (this.deviceHeight / this._figmaDeviceHeight) * figmaObjSize;  
    return (result <= figmaObjSize)
            ? result : 
            (
              (result <= figmaObjSize + 10) 
              ? figmaObjSize : 
              (
                (result <= figmaObjSize + 20) ? (figmaObjSize + 10) : (figmaObjSize + 15)
              )
            );
  }

  double _computeFontSize(double desiredFontSize) {
    double result =  ((this.textScaleFactor == 1.0) ? 
                      (_computeWidth(desiredFontSize)) : 
                      (desiredFontSize - (desiredFontSize * (this.textScaleFactor - 1.0)))
                    );
    return (result > desiredFontSize) ? desiredFontSize : result;
  }

  /* 
    + This is public function.
    + This is used when initializing application.
    + Set up app ratio.
  */
  void setUpAppRatio(double deviceWidth, double deviceHeight, double devicePixelRatio, double textScaleFactor) {
    // Store device width and height
    this.deviceWidth = deviceWidth;
    this.deviceHeight = deviceHeight;
    this.devicePixelRatio = devicePixelRatio;
    this.textScaleFactor = textScaleFactor;
    // print("Width x Height x DPR x TSF: $deviceWidth, $deviceHeight, $devicePixelRatio, $textScaleFactor");

    // Find font size
    appFontSize12 = _computeFontSize(this._figmaFontSize12);
    appFontSize14 = _computeFontSize(this._figmaFontSize14);
    appFontSize16 = _computeFontSize(this._figmaFontSize16);
    appFontSize18 = _computeFontSize(this._figmaFontSize18);
    appFontSize20 = _computeFontSize(this._figmaFontSize20);
    appFontSize22 = _computeFontSize(this._figmaFontSize22);
    appFontSize24 = _computeFontSize(this._figmaFontSize24);
    appFontSize26 = _computeFontSize(this._figmaFontSize26);
    appFontSize28 = _computeFontSize(this._figmaFontSize28);
    // print("Font size: ${this._figmaFontSize22}, $appFontSize22 - ${this._figmaFontSize18}, $appFontSize18");

    // Find width & height of objects
    appWidth70 = _computeWidth(this._figmaWidth70);
    appWidth80 = _computeWidth(this._figmaWidth80);
    appWidth150 = _computeWidth(this._figmaWidth150);
    appWidth181 = _computeWidth(this._figmaWidth181);
    appWidth200 = _computeWidth(this._figmaWidth200);
    appWidth250 = _computeWidth(this._figmaWidth250);
    appWidth300 = _computeWidth(this._figmaWidth300);
    appWidth381 = _computeWidth(this._figmaWidth381);

    appHeight25 = _computeHeight(this._figmaHeight25);
    appHeight30 = _computeHeight(this._figmaHeight30);
    appHeight40 = _computeHeight(this._figmaHeight40);
    appHeight50 = _computeHeight(this._figmaHeight50);
    appHeight60 = _computeHeight(this._figmaHeight60);
    appHeight70 = _computeHeight(this._figmaHeight70);
    appHeight80 = _computeHeight(this._figmaHeight80);
    appHeight320 = _computeHeight(this._figmaHeight320);

    // Find spacing
    appSpacing5 = _computeWidth(this._figmaSpacing5);
    appSpacing10 = _computeWidth(this._figmaSpacing10);
    appSpacing15 = _computeWidth(this._figmaSpacing15);
    appSpacing20 = _computeWidth(this._figmaSpacing20);
    appSpacing25 = _computeWidth(this._figmaSpacing25);
    appSpacing30 = _computeWidth(this._figmaSpacing30);
    appSpacing35 = _computeWidth(this._figmaSpacing35);
    appSpacing40 = _computeWidth(this._figmaSpacing40);
    appSpacing45 = _computeWidth(this._figmaSpacing45);
    appSpacing50 = _computeWidth(this._figmaSpacing50);

    // Find icon size
    appIconSize15 = _computeWidth(this._figmaIconSize15);
    appIconSize18 = _computeWidth(this._figmaIconSize18);
    appIconSize20 = _computeWidth(this._figmaIconSize20);
    appIconSize25 = _computeWidth(this._figmaIconSize25);
    appIconSize30 = _computeWidth(this._figmaIconSize30);
    appIconSize35 = _computeWidth(this._figmaIconSize35);
    appIconSize40 = _computeWidth(this._figmaIconSize40);

    // Find size of other things
    appAppBarIconSize = _computeWidth(this._figmaAppBarIconSize);
    appWelcomPageLogoTextSize = _computeWidth(this._figmaWelcomPageLogoTextSize);
    appDropDownImageSquareSize = _computeWidth(this._figmaDropDownImageSquareSize);
    appDropDownArrowIconSize = _computeWidth(this._figmaDropDownArrowIconSize);

    // Find size of avatars
    appAvatarSize130 = _computeWidth(this._figmaAvatarSize130);
    appAvatarSize150 = _computeWidth(this._figmaAvatarSize150);

    /*
      ...
      Define MORE here
      ...
    */
  }
}

class _Color {
  // Gradient color
  final Gradient uiGradient = LinearGradient(colors: [
    Color(0xFFFC8800),
    Color(0xFFF26B30),
    Color(0xFFEE4C3E),
    Color(0xFFDA2A16)
  ], stops: [
    0.0,
    0.25,
    0.5,
    1.0
  ]);

  /*
    + [NgocVo] Unused colors
      - final Color yellow = Color(0xFFFC8800);
      - final Color red = Color(0xFFDA2A16);
      - final Color pinkRed = Color(0xFFEE4C3E);
      - final Color blue = Color(0xFF03318C);
  */
  
  // Official/Main/Common color of app
  Color majorOrange                   = Color(0xFFFD632C);
  Color blurMajorOrange               = Color.fromRGBO(253, 99, 44, 0.5);
  Color grayABABAB                    = Color(0xFFABABAB);
  Color oldYellow                     = Color(0xFFF9C86A);

  // Default is Light theme
  // #FD632C = RGB(253, 99, 44)
  // #FFEBDE = RGB(255, 235, 222)
  // #000000 = RGB(0, 0, 0)
  Color labelText                     = Color(0xFFFD632C);
  Color contentText                   = Color(0xFF000000);
  Color orangeNoteText                = Color(0xFFFD632C);
  Color normalNoteText                = Color(0xFF808080);
  Color lighterNormalNoteText         = Color(0xFFABABAB);
  Color appBackground                 = Color(0xFFFFFFFF);
  Color boxBackground                 = Color(0xFFFFFFFF);
  Color sectionBackgroundLayer        = Color.fromRGBO(255, 235, 222, 0.2);
  Color btnShadow                     = Color.fromRGBO(0, 0, 0, 0.5);
  Color textShadow                    = Color.fromRGBO(0, 0, 0, 0.25);
  Color tabLayer                      = Color.fromRGBO(253, 99, 44, 0.1);
  Color discussionLayer               = Color.fromRGBO(253, 99, 44, 0.2);
  Color notiLayer                     = Color.fromRGBO(253, 99, 44, 0.2);

  // User need to change theme
  void changeTheme(String theme) {
    if (theme.compareTo('Light') == 0) {
      labelText                     = Color(0xFFFD632C);
      contentText                   = Color(0xFF000000);
      orangeNoteText                = Color(0xFFFD632C);
      normalNoteText                = Color(0xFF808080);
      lighterNormalNoteText         = Color(0xFFABABAB);
      appBackground                 = Color(0xFFFFFFFF);
      boxBackground                 = Color(0xFFFFFFFF);
      sectionBackgroundLayer        = Color.fromRGBO(255, 235, 222, 0.2);
      btnShadow                     = Color.fromRGBO(0, 0, 0, 0.5);
      textShadow                    = Color.fromRGBO(0, 0, 0, 0.25);
      tabLayer                      = Color.fromRGBO(253, 99, 44, 0.1);
      discussionLayer               = Color.fromRGBO(253, 99, 44, 0.2);
      notiLayer                     = Color.fromRGBO(253, 99, 44, 0.2);
    }
    else {
      // #212121 = RGB(33, 33, 33)
      // #FFFFFF = RGB(255, 255, 255)
      // #ABABAB = RGB(171, 171, 171)
      labelText                     = Color(0xFFFD632C);
      contentText                   = Color(0xFFFFFFFF);
      orangeNoteText                = Color(0xFFFD632C);
      normalNoteText                = Color(0xFFABABAB);
      lighterNormalNoteText         = Color(0xFFABABAB);
      appBackground                 = Color(0xFF121212);
      boxBackground                 = Color(0xFF212121);
      sectionBackgroundLayer        = Color.fromRGBO(33, 33, 33, 0.5);
      btnShadow                     =  Color.fromRGBO(255, 255, 255, 0.5);
      textShadow                    = Color.fromRGBO(255, 255, 255, 0.25);
      tabLayer                      = Color.fromRGBO(255, 255, 255, 0.1);
      discussionLayer               = Color.fromRGBO(171, 171, 171, 0.2);
      notiLayer                     = Color.fromRGBO(171, 171, 171, 0.2);
    }
  }
}

class _MyIcons {
  // Default icons (These are never change by Light/Black theme)
  final String appBarBackBtn = 'assets/myicons/icon-white-back.png';
  final String appBarCheckBtn = 'assets/myicons/icon-big-white-check.png';
  final String tabBarSearchBtn = 'assets/myicons/icon-orange-search.png';
  final String tabBarCloseBtn = 'assets/myicons/icon-orange-close.png';
  final String drawerRecord = 'assets/myicons/icon-white-light-record.png';
  final String drawerEvents = 'assets/myicons/icon-white-events-02.png';
  final String drawerUfeed = 'assets/myicons/icon-white-news-feed-02.png';
  final String drawerProfile = 'assets/myicons/icon-white-profile-02.png';
  final String drawerTeams = 'assets/myicons/icon-white-teams.png';
  final String drawerSettings = 'assets/myicons/icon-white-settings.png';
  final String drawerActiveRecord = 'assets/myicons/icon-yellow-light-record.png';
  final String drawerActiveEvents = 'assets/myicons/icon-yellow-events-02.png';
  final String drawerActiveUfeed = 'assets/myicons/icon-yellow-news-feed-02.png';
  final String drawerActiveProfile = 'assets/myicons/icon-yellow-profile-02.png';
  final String drawerActiveTeams = 'assets/myicons/icon-yellow-teams.png';
  final String drawerActiveSettings = 'assets/myicons/icon-yellow-settings.png';
  final String aboutUsUSRUN = 'assets/myicons/icon-color-letter.png';
  final String aboutUsDevelopers = 'assets/myicons/icon-color-developers.png';
  final String aboutUsVersion = 'assets/myicons/icon-color-update-version.png';
  final String aboutUsRateApp = 'assets/myicons/icon-color-stars.png';
  final String appBarEditBtn = 'assets/myicons/icon-white-edit.png';
  final String icStartRecord = 'assets/myicons/icon-record-start.png';
  final String icStopRecord = 'assets/myicons/icon-record-stop.png';
  final String icResumeRecord = 'assets/myicons/icon-record-restart.png';
  final String icPauseRecord = 'assets/myicons/icon-record-pause.png'; 
  final String icStatisticWhite = 'assets/myicons/icon-white-record-statistics.png';
  final String icStatisticColor = 'assets/myicons/icon-color-record-statistics.png'; 
  final String icRecordEventWhite = 'assets/myicons/icon-white-record-events.png';
  final String icRecordEventColor = 'assets/myicons/icon-color-record-events.png'; 

  final String icCurrentSpot = 'assets/myicons/spot.gif';

  // Default is Light theme 
  String defaultIcon = 'assets/myicons/icon-black-image-default.png';
  String nextIcon = 'assets/myicons/icon-black-next.png';
  
  // User wants to change theme
  void changeTheme(String theme) {
    if (theme.compareTo('Light') == 0) {
      defaultIcon = 'assets/myicons/icon-black-image-default.png';
      nextIcon = 'assets/myicons/icon-black-next.png';

      // TODO: "Light" icons
    }
    else {
      defaultIcon = 'assets/myicons/icon-white-image-default.png';
      nextIcon = 'assets/myicons/icon-white-next.png';

      // TODO: "Black" icons
    }
  }
}

class _Images {
  // USRUN logo images
  final String appIcon = 'assets/usrunlogo/app-icon.png';
  final String logoText = 'assets/usrunlogo/logo-text.png';
  final String logo = 'assets/usrunlogo/logo.png';

  // Common images
  final String welcomeBanner = 'assets/images/welcome.png';

  final String loginFacebook = 'assets/images/login_fb.png';
  final String loginGoogle = 'assets/images/login_gg.png';
  final String loginEmail = 'assets/images/login_email.png';
  final String orLine = 'assets/images/or_line.png';

  final String drawerBackground = 'assets/images/drawer_background.png';
  final String drawerBackgroundDarker = 'assets/images/drawer_background_darker.jpg';

  final String avatar = 'assets/images/avatar.png';
  final String avatarQuocTK = 'assets/images/avatar_quoctk.png';
  final String avatarNgocVTT = 'assets/images/avatar_ngocvtt.png';
  final String avatarHuyTA = 'assets/images/avatar_huyta.png';
  final String avatarPhucTT = 'assets/images/avatar_phuctt.png';
  final String avatarKhaTM = 'assets/images/avatar_khatm.png';
}



@reflector
class Strings {
  String usrun;

  String ok;
  String error;
  String notice;

  String alreadyAMember;
  String signIn;
  String signUp;
  String resetPassword;

  String profile;
  String editProfile;

  String record;

  String uFeed;

  String events;

  String teams;

  String settings;
  String changePassword;
  String aboutUs;
  String inAppNotifications;
  String privacyProfile;
  String hotContact;
  String legal;
  String faqs;

  String notiActLabel;
  String notiActReactionTitle;
  String notiActReactionSubtitle;
  String notiActDiscussionTitle;
  String notiActDiscussionSubtitle;
  String notiActShareTitle;
  String notiActShareSubtitle;
  String notiActMentionInDiscussionTitle;
  String notiActMentionInDiscussionSubtitle;
  String notiEvtLabel;
  String notiEvtInfoTitle;
  String notiEvtInfoSubtitle;
  String notiEvtReminder6HTitle;
  String notiEvtReminder6HSubtitle;
  String notiEvtReminder24HTitle;
  String notiEvtReminder24HSubtitle;
  String notiEvtRankChangesTitle;
  String notiEvtRankChangesSubtitle;
  String notiEvtInvitationTitle;
  String notiEvtInvitationSubtitle;
  String notiFFLabel;
  String notiFFNewFollowersTitle;
  String notiFFNewFollowersSubtitle;
  String notiFFNewActivitiesTitle;
  String notiFFNewActivitiesSubtitle;
  String notiTMLabel;
  String notiTMInvitationTitle;
  String notiTMInvitationSubtitle;
  String notiTMPlansTitle;
  String notiTMPlansSubtitle;
  String notiTMPostsTitle;
  String notiTMPostsSubtitle;

  String statusEveryone;
  String statusFollowers;
  String statusFollowing;
  String statusOnlyMe;

  String privacyFindLabel;
  String privacyFindEmailTitle;
  String privacyFindUserCodeTitle;
  String privacyFindNameTitle;
  String privacyFollowLabel;
  String privacyFollowFeatureTitle;
  String privacyFollowFeatureSubtitle;
  String privacyActLabel;
  String privacyActLimitPeopleTitle;
  String privacyActLimitPeopleSubtitle;
  String privacyOPILabel;
  String privacyOPISeeUserCodeTitle;
  String privacyOPISeeDetailedInfoTitle;
  String privacyOPISeeDetailedInfoSubtitle;
  String privacyOPISeeFollowersTitle;
  String privacyOPISeeFollowingTitle;
  String privacyOPISeePhotosTitle;
  String privacyOPISeeEventBadgesTitle;
  String privacyOPISeeStatsTitle;
  String privacyOPISeeEventsTitle;
  String privacyOPISeeTeamsTitle;
  String privacyOPISeeTeamPlansTitle;

  String student;
  String connected;
  String disconnected;

  String settingsAccountLabel;
  String settingsAccountTypeTitle;
  String settingsAccountChangePasswordTitle;
  String settingsAccountPrivacyProfileTitle;
  String settingsAccountConnectGoogleTitle;
  String settingsAccountConnectFacebookTitle;
  String settingsDisplayLabel;
  String settingsDisplayDefaultTabTitle;
  String settingsDisplayMeasureTitle;
  String settingsDisplayThemeTitle;
  String settingsDisplayLanguageTitle;
  String settingsNotiLabel;
  String settingsNotiInAppTitle;
  String settingsNotiEmailTitle;
  String settingsNotiEmailSubtitle;
  String settingsSOLabel;
  String settingsSOFAQsTitle;
  String settingsSOContactTitle;
  String settingsSOLegalTitle;
  String settingsSOAboutUsTitle;
  String settingsSOLogOutTitle;

  String aboutUsUSRUNTitle;
  String aboutUsUSRUNSubtitle;
  String aboutUsDevelopersTitle;
  String aboutUsDevelopersSubtitle;
  String aboutUsVersionTitle;
  String aboutUsVersionSubtitle;
  String aboutUsRateAppTitle;
  String aboutUsRateAppSubtitle;

  String aboutDevelopers;
  String aboutDevName_1;
  String aboutDevTitle_1;
  String aboutDevName_2;
  String aboutDevTitle_2;
  String aboutDevName_3;
  String aboutDevTitle_3;
  String aboutDevName_4;
  String aboutDevTitle_4;
  String aboutDevName_5;
  String aboutDevTitle_5;

  String aboutUSRUN_1;
  String aboutUSRUN_2;
  String aboutUSRUN_3;
  String aboutUSRUN_4;
  String aboutUSRUN_5;
  String aboutUSRUN_6;
  String aboutUSRUN_7;

  String search;

  Map<String, dynamic> errorMessages;

  String errorTitle;
  String errorLoginFail;
  String errorLogoutFail;
  String errorUserCancelledLogin;
  String errorNetworkUnstable;
  String errorUserNotFoundCreateNew;
  String errorEmailInvalid;
  String errorPasswordShort;
  String errorInvalidPassword;
  String errorEmailIsUsed;
  String errorNameIsRequired;
  String errorBirthday;
  String errorWeightIsRequired;
  String errorHeightIsRequired;
  String isNotNumber;
  String errorGenderIsRequired;
  String errorTeamTypeIsRequired;
  String errorSportTypeIsRequired;
  String errorLeaderBoardTypeIsRequired;
  String errorSelectionEmpty;
  String errorYouShouldAddPeople;
  String errorNoInternetAccess;
  String errorUserNotFound;
  String errorEmailPassword;

  String requestTimeOut;
}

class Styles {
  final TextStyle labelStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: R.appRatio.appFontSize18,
      color: R.colors.labelText);

  final TextStyle shadowLabelStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: R.appRatio.appFontSize18,
      color: R.colors.labelText,
      shadows: <Shadow>[
        Shadow(
          offset: Offset(2.0, 2.0),
          blurRadius: 4.0,
          color: R.colors.textShadow,
        ),
      ]);
}
