import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/animation/slide_page_route.dart';
import 'package:usrun/core/define.dart';
import 'package:usrun/main.dart';
import 'package:usrun/manager/data_manager.dart';
import 'package:usrun/manager/user_manager.dart';
import 'package:usrun/widget/custom_dialog/custom_alert_dialog.dart';
import 'R.dart';

// ================ PRIVATE VARIABLES ================

int _errorCode = 0;

// ================ MAIN ================
T cast<T>(x) => x is T ? x : null;

Future<void> initializeConfigs(BuildContext context) async {
  R.initAppRatio(context);
  await DataManager.initialize();
  loadAppTheme();
  UserManager.initialize();
  await R.initPackageAndDeviceInfo();
}

void loadAppTheme() {
  AppTheme appTheme = AppTheme.LIGHT;
  int themeIndex = DataManager.loadAppTheme();

  if (themeIndex == null) {
    DataManager.saveAppTheme(appTheme);
  } else {
    appTheme = AppTheme.values[themeIndex];
  }

  R.changeAppTheme(appTheme);
}

bool hasSelectedLanguageFirstTime() {
  bool isFirstTime = DataManager.loadSelectLanguageFirstTime();
  if (isFirstTime == null || !isFirstTime) return false;
  return true;
}

void initDefaultLocale(String lang) {
  switch (lang) {
    case "en":
      Intl.defaultLocale = "en_US";
      break;
    case "vi":
    default:
      Intl.defaultLocale = "vi_VN";
  }
}

Future<void> loadCurrentLanguage() async {
  String lang = "vi";

  String appLang = DataManager.loadLanguage();
  if (appLang != null && appLang.length != 0) {
    lang = appLang;
  } else {
    DataManager.saveLanguage(lang);
  }

  initDefaultLocale(lang);

  String jsonContent =
      await rootBundle.loadString("assets/localization/$lang.json");
  R.initLocalization(lang, jsonContent);
}

Future<void> setLanguage(String lang) async {
  if (lang == null || lang.length == 0) {
    throw Exception("The param of setLanguage function mustn't be null");
  }

  DataManager.saveSelectLanguageFirstTime(true);
  DataManager.saveLanguage(lang);

  initDefaultLocale(lang);

  String jsonContent =
      await rootBundle.loadString("assets/localization/$lang.json");
  R.initLocalization(lang, jsonContent);
}

Map<int, Color> rgbToMaterialColor(int r, int g, int b) {
  return {
    50: Color.fromRGBO(r, g, b, .1),
    100: Color.fromRGBO(r, g, b, .2),
    200: Color.fromRGBO(r, g, b, .3),
    300: Color.fromRGBO(r, g, b, .4),
    400: Color.fromRGBO(r, g, b, .5),
    500: Color.fromRGBO(r, g, b, .6),
    600: Color.fromRGBO(r, g, b, .7),
    700: Color.fromRGBO(r, g, b, .8),
    800: Color.fromRGBO(r, g, b, .9),
    900: Color.fromRGBO(r, g, b, 1),
  };
}

void restartApp(int errorCode) {
  if (errorCode == null) return;
  if (errorCode == 0 || errorCode != _errorCode) {
    setErrorCode(errorCode);
    UsRunApp.restartApp(errorCode);
  }
}

int hexaStringColorToInt(String hexaStringColor) {
  if (!hexaStringColor.startsWith("#")) {
    return 0xFF000000;
  } else {
    hexaStringColor = hexaStringColor.substring(1);
    hexaStringColor = "0xFF" + hexaStringColor;
    return int.parse(hexaStringColor);
  }
}

// ================ CHECKING SYSTEM ================

void setErrorCode(int code) {
  _errorCode = code;
}

bool checkSystemStatus() {
  /*
    + True: It's fine
    + False: Not fine
  */

  if (_errorCode == 0) return true;

  String message = "";
  switch (_errorCode) {
    case MAINTENANCE:
      message = R.strings.errorMessages["$MAINTENANCE"];
      break;
    case ACCESS_DENY:
      message = R.strings.errorMessages["$ACCESS_DENY"];
      break;
    case FORCE_UPDATE:
      message = R.strings.errorMessages["$FORCE_UPDATE"];
      break;
    default:
      message = R.strings.errorOccurred;
  }

  showCustomAlertDialog(
    navigatorKey.currentState.overlay.context,
    title: R.strings.caution,
    content: message,
    firstButtonText: R.strings.ok.toUpperCase(),
    firstButtonFunction: () => pop(navigatorKey.currentState.overlay.context),
  );

  return false;
}

// ================ NAVIGATOR ================

Future<T> showPage<T>(BuildContext context, Widget page,
    {bool popUntilFirstRoutes = false}) {
  if (!checkSystemStatus()) return null;
  if (popUntilFirstRoutes) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
  Route route = MaterialPageRoute(builder: (context) => page);
  return Navigator.of(context).pushReplacement(route);
}

Future<T> showPageWithRoute<T>(BuildContext context, Route<T> route,
    {bool popUntilFirstRoutes = false}) {
  if (!checkSystemStatus()) return null;
  if (popUntilFirstRoutes) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
  return Navigator.of(context).pushReplacement(route);
}

Future<T> pushPageWithNavState<T>(Widget page) {
  Route route = MaterialPageRoute(builder: (_) => page);
  return navigatorKey.currentState.push(route);
}

Future<T> pushPage<T>(BuildContext context, Widget page) {
  if (!checkSystemStatus()) return null;
  Route route = SlidePageRoute(page: page);
  return Navigator.of(context).push(route);
}

Future<T> pushPageWithRoute<T>(BuildContext context, Route<T> route) {
  if (!checkSystemStatus()) return null;
  return Navigator.of(context).push(route);
}

void pop(BuildContext context, {bool rootNavigator = false, dynamic object}) {
  if (rootNavigator == null) rootNavigator = false;
  if (Navigator.of(context).canPop()) {
    Navigator.of(context, rootNavigator: rootNavigator).pop(object);
  }
}

// ================ COMMON PUBLIC FUNCTIONS ================

int getPlatform() {
  return Platform.isIOS ? PlatformType.iOS.index : PlatformType.Android.index;
}
