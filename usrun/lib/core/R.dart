import 'dart:core';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:package_info/package_info.dart';
import 'package:usrun/util/reflector.dart';
import 'package:usrun/model/mapper_object.dart';

import 'define.dart';

class R {
  static Strings strings = Strings();
  static final _Colors colors = _Colors();
  static final _Images images = _Images();
  static final _Constants constants = _Constants();
  static _Styles styles = _Styles();
  static _AppRatio appRatio = _AppRatio();
  static _MyIcons myIcons = _MyIcons();
  static _ImagePickerDefaults imagePickerDefaults = _ImagePickerDefaults();
  static AppTheme currentAppTheme = AppTheme.LIGHT;
  static String currentAppLanguage = "en";
  static RunningUnit currentRunningUnit = RunningUnit.KILOMETER;
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  static PackageInfo packageInfo;
  static String modelName = "";
  static String deviceId = "";
  static String versionNumber = "";
  static String buildNumber = "";
  static String androidAppId = "vn.hcmus.usrun";
  static String iOSAppId = "vn.hcmus.usrun";
  static final Map<String, String> _modelAppleMapper = {
    "i386": "32-bit Simulator",
    "x86_64": "64-bit Simulator",

    // Output on an iPhone
    "iPhone1,1": "iPhone",
    "iPhone1,2": "iPhone 3G",
    "iPhone2,1": "iPhone 3GS",
    "iPhone3,1": "iPhone 4 (GSM)",
    "iPhone3,3": "iPhone 4 (CDMA/Verizon/Sprint)",
    "iPhone4,1": "iPhone 4S",
    "iPhone5,1": "iPhone 5 (model A1428, AT&T/Canada)",
    "iPhone5,2": "iPhone 5 (model A1429, everything else)",
    "iPhone5,3": "iPhone 5c (model A1456, A1532 | GSM)",
    "iPhone5,4":
        "iPhone 5c (model A1507, A1516, A1526 (China), A1529 | Global)",
    "iPhone6,1": "iPhone 5s (model A1433, A1533 | GSM)",
    "iPhone6,2":
        "iPhone 5s (model A1457, A1518, A1528 (China), A1530 | Global)",
    "iPhone7,1": "iPhone 6 Plus",
    "iPhone7,2": "iPhone 6",
    "iPhone8,1": "iPhone 6S",
    "iPhone8,2": "iPhone 6S Plus",
    "iPhone8,4": "iPhone SE",
    "iPhone9,1": "iPhone 7 (CDMA)",
    "iPhone9,3": "iPhone 7 (GSM)",
    "iPhone9,2": "iPhone 7 Plus (CDMA)",
    "iPhone9,4": "iPhone 7 Plus (GSM)",
    "iPhone10,1": "iPhone 8 (CDMA)",
    "iPhone10,4": "iPhone 8 (GSM)",
    "iPhone10,2": "iPhone 8 Plus (CDMA)",
    "iPhone10,5": "iPhone 8 Plus (GSM)",
    "iPhone10,3": "iPhone X (CDMA)",
    "iPhone10,6": "iPhone X (GSM)",
    "iPhone11,2": "iPhone XS",
    "iPhone11,4": "iPhone XS Max",
    "iPhone11,6": "iPhone XS Max China",
    "iPhone11,8": "iPhone XR",
    "iPhone12,1": "iPhone 11",
    "iPhone12,3": "iPhone 11 Pro",
    "iPhone12,5": "iPhone 11 Pro Max",

    //iPad 1
    "iPad1,1": "iPad - Wifi (model A1219)",
    "iPad1,2": "iPad - Wifi + Cellular (model A1337)",

    //iPad 2
    "iPad2,1": "Wifi (model A1395)",
    "iPad2,2": "GSM (model A1396)",
    "iPad2,3": "3G (model A1397)",
    "iPad2,4": "Wifi (model A1395)",

    // iPad Mini
    "iPad2,5": "Wifi (model A1432)",
    "iPad2,6": "Wifi + Cellular (model  A1454)",
    "iPad2,7": "Wifi + Cellular (model  A1455)",

    //iPad 3
    "iPad3,1": "Wifi (model A1416)",
    "iPad3,2": "Wifi + Cellular (model  A1403)",
    "iPad3,3": "Wifi + Cellular (model  A1430)",

    //iPad 4
    "iPad3,4": "Wifi (model A1458)",
    "iPad3,5": "Wifi + Cellular (model  A1459)",
    "iPad3,6": "Wifi + Cellular (model  A1460)",

    //iPad AIR
    "iPad4,1": "Wifi (model A1474)",
    "iPad4,2": "Wifi + Cellular (model A1475)",
    "iPad4,3": "Wifi + Cellular (model A1476)",

    // iPad Mini 2
    "iPad4,4": "Wifi (model A1489)",
    "iPad4,5": "Wifi + Cellular (model A1490)",
    "iPad4,6": "Wifi + Cellular (model A1491)",

    // iPad Mini 3
    "iPad4,7": "Wifi (model A1599)",
    "iPad4,8": "Wifi + Cellular (model A1600)",
    "iPad4,9": "Wifi + Cellular (model A1601)",

    // iPad Mini 4
    "iPad5,1": "Wifi (model A1538)",
    "iPad5,2": "Wifi + Cellular (model A1550)",

    //iPad AIR 2
    "iPad5,3": "Wifi (model A1566)",
    "iPad5,4": "Wifi + Cellular (model A1567)",

    // iPad PRO 9.7"
    "iPad6,3": "Wifi (model A1673)",
    "iPad6,4": "Wifi + Cellular (model A1674)",
    "iPad6,5": "Wifi + Cellular (model A1675)",

    //iPad PRO 12.9"
    "iPad6,7": "Wifi (model A1584)",
    "iPad6,8": "Wifi + Cellular (model A1652)",

    //iPad (5th generation)
    "iPad6,11": "Wifi (model A1822)",
    "iPad6,12": "Wifi + Cellular (model A1823)",

    //iPad PRO 12.9" (2nd Gen)
    "iPad7,1": "Wifi (model A1670)",
    "iPad7,2": "Wifi + Cellular (model A1671)",
    "iPad7,3": "Wifi + Cellular (model A1821)",

    //iPad PRO 10.5"
    "iPad7,4": "Wifi (model A1701)",
    "iPad7,5": "Wifi + Cellular (model A1709)",

    //iPod Touch
    "iPod1,1": "iPod Touch",
    "iPod2,1": "iPod Touch Second Generation",
    "iPod3,1": "iPod Touch Third Generation",
    "iPod4,1": "iPod Touch Fourth Generation",
    "iPod7,1": "iPod Touch 6th Generation",

    // Apple Watch
    "Watch1,1": "Apple Watch 38mm case",
    "Watch1,2": "Apple Watch 38mm case",
    "Watch2,6": "Apple Watch Series 1 38mm case",
    "Watch2,7": "Apple Watch Series 1 42mm case",
    "Watch2,3": "Apple Watch Series 2 38mm case",
    "Watch2,4": "Apple Watch Series 2 42mm case",
    "Watch3,1": "Apple Watch Series 3 38mm case (GPS+Cellular)",
    "Watch3,2": "Apple Watch Series 3 42mm case (GPS+Cellular)",
    "Watch3,3": "Apple Watch Series 3 38mm case (GPS)",
    "Watch3,4": "Apple Watch Series 3 42mm case (GPS)",
    "Watch4,1": "Apple Watch Series 4 40mm case (GPS)",
    "Watch4,2": "Apple Watch Series 4 44mm case (GPS)",
    "Watch4,3": "Apple Watch Series 4 40mm case (GPS+Cellular)",
    "Watch4,4": "Apple Watch Series 4 44mm case (GPS+Cellular)"
  };

  static void initLocalization(String lang, String jsonContent) {
    currentAppLanguage = lang;
    R.strings = MapperObject.create<Strings>(jsonContent);
  }

  static void initAppRatio(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;
    double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    appRatio.setUpAppRatio(size.width, size.height, devicePixelRatio,
        textScaleFactor, statusBarHeight);
  }

  static void changeAppTheme(AppTheme appTheme) {
    currentAppTheme = appTheme;
    myIcons.changeTheme(appTheme);
    colors.changeTheme(appTheme);
    styles = _Styles();
  }

  static Future<void> initPackageAndDeviceInfo() async {
    packageInfo = await PackageInfo.fromPlatform();

    if (Platform.isAndroid) {
      var androidInfo = await deviceInfoPlugin.androidInfo;
      modelName =
          "${androidInfo.manufacturer.toUpperCase()} ${androidInfo.model}";
      deviceId = androidInfo.androidId;
    } else if (Platform.isIOS) {
      var iOSInfo = await deviceInfoPlugin.iosInfo;
      modelName = _modelAppleMapper[iOSInfo.utsname.machine] ?? "";
      deviceId = iOSInfo.identifierForVendor;
    }

    buildNumber = packageInfo.buildNumber;
    versionNumber = packageInfo.version;
  }
}

class _Constants {
  final int numberToSplitFFList = 60;
  final int numberToSplitPhotoList = 60;
  final int maxProfileTabBarNumber = 5;
  final int activityTimelineNumber = 5;

  // DateTime(year, month, day, hour, minute, second, milisecond, microsecond)
  final DateTime releasedAppDate = DateTime(2019, 03, 12);
}

class _AppRatio {
  /*
    + This is private variables.
    + Figma design information.
  */
  final double _figmaDeviceWidth = 411;
  final double _figmaDeviceHeight = 731;

  final double _figmaFontSize12 = 12;
  final double _figmaFontSize14 = 14;
  final double _figmaFontSize16 = 16;
  final double _figmaFontSize18 = 18;
  final double _figmaFontSize20 = 20;
  final double _figmaFontSize22 = 22;
  final double _figmaFontSize24 = 24;
  final double _figmaFontSize26 = 26;
  final double _figmaFontSize28 = 28;
  final double _figmaFontSize32 = 32;
  final double _figmaFontSize34 = 34;
  final double _figmaFontSize36 = 36;
  final double _figmaFontSize38 = 38;
  final double _figmaFontSize40 = 40;
  final double _figmaFontSize42 = 42;

  final double _figmaWidth1 = 1;
  final double _figmaWidth30 = 30;
  final double _figmaWidth40 = 40;
  final double _figmaWidth50 = 50;
  final double _figmaWidth60 = 60;
  final double _figmaWidth70 = 70;
  final double _figmaWidth80 = 80;
  final double _figmaWidth90 = 90;
  final double _figmaWidth100 = 100;
  final double _figmaWidth110 = 110;
  final double _figmaWidth120 = 120;
  final double _figmaWidth130 = 130;
  final double _figmaWidth140 = 140;
  final double _figmaWidth150 = 150;
  final double _figmaWidth160 = 160;
  final double _figmaWidth170 = 170;
  final double _figmaWidth181 = 181;
  final double _figmaWidth190 = 190;
  final double _figmaWidth200 = 200;
  final double _figmaWidth210 = 210;
  final double _figmaWidth220 = 220;
  final double _figmaWidth230 = 230;
  final double _figmaWidth240 = 240;
  final double _figmaWidth250 = 250;
  final double _figmaWidth260 = 260;
  final double _figmaWidth270 = 270;
  final double _figmaWidth280 = 280;
  final double _figmaWidth290 = 290;
  final double _figmaWidth300 = 300;
  final double _figmaWidth310 = 310;
  final double _figmaWidth320 = 320;
  final double _figmaWidth330 = 330;
  final double _figmaWidth340 = 340;
  final double _figmaWidth350 = 350;
  final double _figmaWidth360 = 360;
  final double _figmaWidth370 = 370;
  final double _figmaWidth381 = 381;

  final double _figmaHeight10 = 10;
  final double _figmaHeight15 = 15;
  final double _figmaHeight20 = 20;
  final double _figmaHeight25 = 25;
  final double _figmaHeight30 = 30;
  final double _figmaHeight40 = 40;
  final double _figmaHeight45 = 45;
  final double _figmaHeight50 = 50;
  final double _figmaHeight60 = 60;
  final double _figmaHeight70 = 70;
  final double _figmaHeight80 = 80;
  final double _figmaHeight90 = 90;
  final double _figmaHeight100 = 100;
  final double _figmaHeight110 = 110;
  final double _figmaHeight120 = 120;
  final double _figmaHeight130 = 130;
  final double _figmaHeight140 = 140;
  final double _figmaHeight150 = 150;
  final double _figmaHeight160 = 160;
  final double _figmaHeight170 = 170;
  final double _figmaHeight180 = 180;
  final double _figmaHeight190 = 190;
  final double _figmaHeight200 = 200;
  final double _figmaHeight210 = 210;
  final double _figmaHeight220 = 220;
  final double _figmaHeight230 = 230;
  final double _figmaHeight240 = 240;
  final double _figmaHeight250 = 250;
  final double _figmaHeight260 = 260;
  final double _figmaHeight270 = 270;
  final double _figmaHeight280 = 280;
  final double _figmaHeight290 = 290;
  final double _figmaHeight300 = 300;
  final double _figmaHeight320 = 320;

  final double _figmaSpacing5 = 5;
  final double _figmaSpacing10 = 10;
  final double _figmaSpacing15 = 15;
  final double _figmaSpacing20 = 20;
  final double _figmaSpacing25 = 25;
  final double _figmaSpacing30 = 30;
  final double _figmaSpacing35 = 35;
  final double _figmaSpacing40 = 40;
  final double _figmaSpacing45 = 45;
  final double _figmaSpacing50 = 50;

  final double _figmaIconSize5 = 5;
  final double _figmaIconSize10 = 10;
  final double _figmaIconSize15 = 15;
  final double _figmaIconSize18 = 18;
  final double _figmaIconSize20 = 20;
  final double _figmaIconSize25 = 25;
  final double _figmaIconSize30 = 30;
  final double _figmaIconSize35 = 35;
  final double _figmaIconSize40 = 40;

  final double _figmaAppBarIconSize = 20;
  final double _figmaWelcomPageLogoTextSize = 160;
  final double _figmaDropDownImageSquareSize = 40;
  final double _figmaDropDownArrowIconSize = 32;
  final double _figmaEventBadgeSize = 80;
  final double _figmaPhotoThumbnailSize = 80;

  final double _figmaAvatarSize80 = 80;
  final double _figmaAvatarSize130 = 130;
  final double _figmaAvatarSize150 = 150;

  /*
    + This is public variables.
    + Information of device screen.
  */
  double deviceWidth;
  double deviceHeight;
  double devicePixelRatio;
  double textScaleFactor;
  double statusBarHeight;
  double appBarHeight;

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
  double appFontSize32;
  double appFontSize34;
  double appFontSize36;
  double appFontSize38;
  double appFontSize40;
  double appFontSize42;

  double appWidth1;
  double appWidth30;
  double appWidth40;
  double appWidth50;
  double appWidth60;
  double appWidth70;
  double appWidth80;
  double appWidth90;
  double appWidth100;
  double appWidth110;
  double appWidth120;
  double appWidth130;
  double appWidth140;
  double appWidth150;
  double appWidth160;
  double appWidth170;
  double appWidth181;
  double appWidth190;
  double appWidth200;
  double appWidth210;
  double appWidth220;
  double appWidth230;
  double appWidth240;
  double appWidth250;
  double appWidth260;
  double appWidth270;
  double appWidth280;
  double appWidth290;
  double appWidth300;
  double appWidth310;
  double appWidth320;
  double appWidth330;
  double appWidth340;
  double appWidth350;
  double appWidth360;
  double appWidth370;
  double appWidth381;

  double appHeight10;
  double appHeight15;
  double appHeight20;
  double appHeight25;
  double appHeight30;
  double appHeight40;
  double appHeight45;
  double appHeight50;
  double appHeight60;
  double appHeight70;
  double appHeight80;
  double appHeight90;
  double appHeight100;
  double appHeight110;
  double appHeight120;
  double appHeight130;
  double appHeight140;
  double appHeight150;
  double appHeight160;
  double appHeight170;
  double appHeight180;
  double appHeight190;
  double appHeight200;
  double appHeight210;
  double appHeight220;
  double appHeight230;
  double appHeight240;
  double appHeight250;
  double appHeight260;
  double appHeight270;
  double appHeight280;
  double appHeight290;
  double appHeight300;
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

  double appIconSize5;
  double appIconSize10;
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
  double appEventBadgeSize;
  double appPhotoThumbnailSize;

  double appAvatarSize80;
  double appAvatarSize130;
  double appAvatarSize150;

  /*
    + This is private function.
    + Formula for finding suitable size of object
  */
  double _computeWidth(num figmaObjSize) {
    return ((this.deviceWidth / this._figmaDeviceWidth) * figmaObjSize)
        .roundToDouble();
  }

  double _computeHeight(num figmaObjSize) {
    double result =
        ((this.deviceHeight / this._figmaDeviceHeight) * figmaObjSize)
            .roundToDouble();
    return (result <= figmaObjSize)
        ? result
        : ((result <= figmaObjSize + 10)
            ? figmaObjSize
            : ((result <= figmaObjSize + 20)
                ? (figmaObjSize + 10)
                : (figmaObjSize + 15)));
  }

  double _computeFontSize(double desiredFontSize) {
    double result = ((this.textScaleFactor == 1.0)
        ? (_computeWidth(desiredFontSize))
        : (desiredFontSize - (desiredFontSize * (this.textScaleFactor - 1.0))));
    return (result > desiredFontSize) ? desiredFontSize : result;
  }

  /*
    + This is public function.
    + This is used when initializing application.
    + Set up app ratio.
  */
  void setUpAppRatio(
    double deviceWidth,
    double deviceHeight,
    double devicePixelRatio,
    double textScaleFactor,
    double statusBarHeight,
  ) {
    // Store device width and height
    this.deviceWidth = deviceWidth.roundToDouble();
    this.deviceHeight = deviceHeight.roundToDouble();
    this.devicePixelRatio = devicePixelRatio.roundToDouble();
    this.textScaleFactor = textScaleFactor.roundToDouble();
    this.statusBarHeight = statusBarHeight.roundToDouble();
    this.appBarHeight = AppBar().preferredSize.height;

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
    appFontSize32 = _computeFontSize(this._figmaFontSize32);
    appFontSize34 = _computeFontSize(this._figmaFontSize34);
    appFontSize36 = _computeFontSize(this._figmaFontSize36);
    appFontSize38 = _computeFontSize(this._figmaFontSize38);
    appFontSize40 = _computeFontSize(this._figmaFontSize40);
    appFontSize42 = _computeFontSize(this._figmaFontSize42);

    // Find width & height of objects
    appWidth1 = _computeWidth(this._figmaWidth1);
    appWidth30 = _computeWidth(this._figmaWidth30);
    appWidth40 = _computeWidth(this._figmaWidth40);
    appWidth50 = _computeWidth(this._figmaWidth50);
    appWidth60 = _computeWidth(this._figmaWidth60);
    appWidth70 = _computeWidth(this._figmaWidth70);
    appWidth80 = _computeWidth(this._figmaWidth80);
    appWidth90 = _computeWidth(this._figmaWidth90);
    appWidth100 = _computeWidth(this._figmaWidth100);
    appWidth110 = _computeWidth(this._figmaWidth110);
    appWidth120 = _computeWidth(this._figmaWidth120);
    appWidth130 = _computeWidth(this._figmaWidth130);
    appWidth140 = _computeWidth(this._figmaWidth140);
    appWidth150 = _computeWidth(this._figmaWidth150);
    appWidth160 = _computeWidth(this._figmaWidth160);
    appWidth170 = _computeWidth(this._figmaWidth170);
    appWidth181 = _computeWidth(this._figmaWidth181);
    appWidth190 = _computeWidth(this._figmaWidth190);
    appWidth200 = _computeWidth(this._figmaWidth200);
    appWidth210 = _computeWidth(this._figmaWidth210);
    appWidth220 = _computeWidth(this._figmaWidth220);
    appWidth230 = _computeWidth(this._figmaWidth230);
    appWidth240 = _computeWidth(this._figmaWidth240);
    appWidth250 = _computeWidth(this._figmaWidth250);
    appWidth260 = _computeWidth(this._figmaWidth260);
    appWidth270 = _computeWidth(this._figmaWidth270);
    appWidth280 = _computeWidth(this._figmaWidth280);
    appWidth290 = _computeWidth(this._figmaWidth290);
    appWidth300 = _computeWidth(this._figmaWidth300);
    appWidth310 = _computeWidth(this._figmaWidth310);
    appWidth320 = _computeWidth(this._figmaWidth320);
    appWidth330 = _computeWidth(this._figmaWidth330);
    appWidth340 = _computeWidth(this._figmaWidth340);
    appWidth350 = _computeWidth(this._figmaWidth350);
    appWidth360 = _computeWidth(this._figmaWidth360);
    appWidth370 = _computeWidth(this._figmaWidth370);
    appWidth381 = _computeWidth(this._figmaWidth381);

    appHeight10 = _computeHeight(this._figmaHeight10);
    appHeight15 = _computeHeight(this._figmaHeight15);
    appHeight20 = _computeHeight(this._figmaHeight20);
    appHeight25 = _computeHeight(this._figmaHeight25);
    appHeight30 = _computeHeight(this._figmaHeight30);
    appHeight40 = _computeHeight(this._figmaHeight40);
    appHeight45 = _computeHeight(this._figmaHeight45);
    appHeight50 = _computeHeight(this._figmaHeight50);
    appHeight60 = _computeHeight(this._figmaHeight60);
    appHeight70 = _computeHeight(this._figmaHeight70);
    appHeight80 = _computeHeight(this._figmaHeight80);
    appHeight90 = _computeHeight(this._figmaHeight90);
    appHeight100 = _computeHeight(this._figmaHeight100);
    appHeight110 = _computeHeight(this._figmaHeight110);
    appHeight120 = _computeHeight(this._figmaHeight120);
    appHeight130 = _computeHeight(this._figmaHeight130);
    appHeight140 = _computeHeight(this._figmaHeight140);
    appHeight150 = _computeHeight(this._figmaHeight150);
    appHeight160 = _computeHeight(this._figmaHeight160);
    appHeight170 = _computeHeight(this._figmaHeight170);
    appHeight180 = _computeHeight(this._figmaHeight180);
    appHeight190 = _computeHeight(this._figmaHeight190);
    appHeight200 = _computeHeight(this._figmaHeight200);
    appHeight210 = _computeHeight(this._figmaHeight210);
    appHeight220 = _computeHeight(this._figmaHeight220);
    appHeight230 = _computeHeight(this._figmaHeight230);
    appHeight240 = _computeHeight(this._figmaHeight240);
    appHeight250 = _computeHeight(this._figmaHeight250);
    appHeight260 = _computeHeight(this._figmaHeight260);
    appHeight270 = _computeHeight(this._figmaHeight270);
    appHeight280 = _computeHeight(this._figmaHeight280);
    appHeight290 = _computeHeight(this._figmaHeight290);
    appHeight300 = _computeHeight(this._figmaHeight300);
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
    appIconSize5 = _computeWidth(this._figmaIconSize5);
    appIconSize10 = _computeWidth(this._figmaIconSize10);
    appIconSize15 = _computeWidth(this._figmaIconSize15);
    appIconSize18 = _computeWidth(this._figmaIconSize18);
    appIconSize20 = _computeWidth(this._figmaIconSize20);
    appIconSize25 = _computeWidth(this._figmaIconSize25);
    appIconSize30 = _computeWidth(this._figmaIconSize30);
    appIconSize35 = _computeWidth(this._figmaIconSize35);
    appIconSize40 = _computeWidth(this._figmaIconSize40);

    // Find size of other things
    appAppBarIconSize = _computeWidth(this._figmaAppBarIconSize);
    appWelcomPageLogoTextSize =
        _computeWidth(this._figmaWelcomPageLogoTextSize);
    appDropDownImageSquareSize =
        _computeWidth(this._figmaDropDownImageSquareSize);
    appDropDownArrowIconSize = _computeWidth(this._figmaDropDownArrowIconSize);
    appEventBadgeSize = _computeWidth(this._figmaEventBadgeSize);
    appPhotoThumbnailSize = _computeWidth(this._figmaPhotoThumbnailSize);

    // Find size of avatars
    appAvatarSize80 = _computeWidth(this._figmaAvatarSize80);
    appAvatarSize130 = _computeWidth(this._figmaAvatarSize130);
    appAvatarSize150 = _computeWidth(this._figmaAvatarSize150);

    /*
      ...
      Define MORE here
      ...
    */
  }
}

class _Colors {
  // Gradient color
  final Gradient uiGradient = LinearGradient(
    colors: [
      Color(0xFFFC8800),
      Color(0xFFF26B30),
      Color(0xFFEE4C3E),
      Color(0xFFDA2A16)
    ],
    stops: [0.0, 0.25, 0.5, 1.0],
  );

  final Gradient verticalUiGradient = LinearGradient(
    begin: Alignment.bottomCenter,
    colors: [
      Color(0xFFFC8800),
      Color(0xFFF26B30),
      Color(0xFFEE4C3E),
      Color(0xFFDA2A16)
    ],
    stops: [0.0, 0.25, 0.5, 1.0],
  );

  // Official/Main/Common color of app
  Color majorOrange = Color(0xFFFD632C);
  Color lightBlurMajorOrange = Color.fromRGBO(253, 99, 44, 0.1);
  Color blurMajorOrange = Color.fromRGBO(253, 99, 44, 0.5);
  Color grayF2F2F2 = Color(0xFFF2F2F2);
  Color grayABABAB = Color(0xFFABABAB);
  Color gray515151 = Color(0xFF515151);
  Color gray808080 = Color(0xFF808080);
  Color redPink = Color(0xFFFF5C4E);
  Color oldYellow = Color(0xFFF9C86A);
  Color labelText = Color(0xFFFD632C);

  // Default is Light theme
  // #FD632C = RGB(253, 99, 44)
  // #FFEBDE = RGB(255, 235, 222)
  // #000000 = RGB(0, 0, 0)
  Color contentText = Color(0xFF000000);
  Color orangeNoteText = Color(0xFFFD632C);
  Color normalNoteText = Color(0xFF808080);
  Color lighterNormalNoteText = Color(0xFFABABAB);
  Color appBackground = Color(0xFFFFFFFF);
  Color boxBackground = Color(0xFFFFFFFF);
  Color grayButtonColor = Color(0xFF515151);
  Color sectionBackgroundLayer = Color.fromRGBO(255, 235, 222, 0.4);
  Color btnShadow = Color.fromRGBO(0, 0, 0, 0.5);
  Color textShadow = Color.fromRGBO(0, 0, 0, 0.25);
  Color tabLayer = Color.fromRGBO(253, 99, 44, 0.1);
  Color discussionLayer = Color.fromRGBO(253, 99, 44, 0.2);
  Color notificationLayer = Color.fromRGBO(253, 99, 44, 0.2);
  Color supportAvatarBorder = Color(0xFF01458E);

  // User need to change theme
  void changeTheme(AppTheme theme) {
    if (theme == AppTheme.LIGHT) {
      contentText = Color(0xFF000000);
      orangeNoteText = Color(0xFFFD632C);
      normalNoteText = Color(0xFF808080);
      lighterNormalNoteText = Color(0xFFABABAB);
      appBackground = Color(0xFFFFFFFF);
      boxBackground = Color(0xFFFFFFFF);
      grayButtonColor = Color(0xFF515151);
      sectionBackgroundLayer = Color.fromRGBO(255, 235, 222, 0.4);
      btnShadow = Color.fromRGBO(0, 0, 0, 0.5);
      textShadow = Color.fromRGBO(0, 0, 0, 0.25);
      tabLayer = Color.fromRGBO(253, 99, 44, 0.1);
      discussionLayer = Color.fromRGBO(253, 99, 44, 0.2);
      notificationLayer = Color.fromRGBO(253, 99, 44, 0.2);
      supportAvatarBorder = Color(0xFF01458E);
    } else {
      // #212121 = RGB(33, 33, 33)
      // #FFFFFF = RGB(255, 255, 255)
      // #ABABAB = RGB(171, 171, 171)
      contentText = Color(0xFFFFFFFF);
      orangeNoteText = Color(0xFFFD632C);
      normalNoteText = Color(0xFFABABAB);
      lighterNormalNoteText = Color(0xFFABABAB);
      appBackground = Color(0xFF121212);
      boxBackground = Color(0xFF212121);
      grayButtonColor = Color(0xFFABABAB);
      sectionBackgroundLayer = Color.fromRGBO(33, 33, 33, 0.5);
      btnShadow = Color.fromRGBO(255, 255, 255, 0.5);
      textShadow = Color.fromRGBO(255, 255, 255, 0.25);
      tabLayer = Color.fromRGBO(255, 255, 255, 0.1);
      discussionLayer = Color.fromRGBO(171, 171, 171, 0.2);
      notificationLayer = Color.fromRGBO(171, 171, 171, 0.2);
      supportAvatarBorder = Colors.transparent;
    }
  }
}

class _MyIcons {
  // Default icons (These are never change by Light/Black theme)
  final String appBarBackBtn = 'assets/myicons/icon-white-back.png';
  final String appBarCheckBtn = 'assets/myicons/icon-big-white-check.png';
  final String appBarShareBtn = 'assets/myicons/icon-white-bold-share.png';
  final String appBarSearchBtn = 'assets/myicons/icon-white-search.png';
  final String appBarEditBtn = 'assets/myicons/icon-white-edit.png';
  final String appBarPopupMenuIcon = 'assets/myicons/icon-white-3-dots.png';
  final String tabBarSearchBtn = 'assets/myicons/icon-orange-search.png';
  final String tabBarCloseBtn = 'assets/myicons/icon-orange-close.png';
  final String drawerRecord = 'assets/myicons/icon-white-light-record.png';
  final String drawerEvents = 'assets/myicons/icon-white-events-02.png';
  final String drawerUfeed = 'assets/myicons/icon-white-news-feed-02.png';
  final String drawerProfile = 'assets/myicons/icon-white-profile-02.png';
  final String drawerTeams = 'assets/myicons/icon-white-teams.png';
  final String drawerSettings = 'assets/myicons/icon-white-settings.png';
  final String drawerActiveRecord =
      'assets/myicons/icon-yellow-light-record.png';
  final String drawerActiveEvents = 'assets/myicons/icon-yellow-events-02.png';
  final String drawerActiveUfeed =
      'assets/myicons/icon-yellow-news-feed-02.png';
  final String drawerActiveProfile =
      'assets/myicons/icon-yellow-profile-02.png';
  final String drawerActiveTeams = 'assets/myicons/icon-yellow-teams.png';
  final String drawerActiveSettings = 'assets/myicons/icon-yellow-settings.png';
  final String aboutUsUSRUN = 'assets/myicons/icon-color-letter.png';
  final String aboutUsDevelopers = 'assets/myicons/icon-color-developers.png';
  final String aboutUsVersion = 'assets/myicons/icon-color-update-version.png';
  final String aboutUsRateApp = 'assets/myicons/icon-color-stars.png';
  final String icStartRecord = 'assets/myicons/icon-record-start.png';
  final String icStopRecord = 'assets/myicons/icon-record-stop.png';
  final String icResumeRecord = 'assets/myicons/icon-record-restart.png';
  final String icPauseRecord = 'assets/myicons/icon-record-pause.png';
  final String icStatisticWhite =
      'assets/myicons/icon-white-record-statistics.png';
  final String icStatisticColor =
      'assets/myicons/icon-color-record-statistics.png';
  final String icRecordEventWhite =
      'assets/myicons/icon-white-record-events.png';
  final String icRecordEventColor =
      'assets/myicons/icon-color-record-events.png';
  final String icCurrentSpot = 'assets/myicons/icon-color-markeruser.png';
  final String englishColor = 'assets/myicons/icon-color-en.png';
  final String vietnameseColor = 'assets/myicons/icon-color-vi.png';

  // ---
  final String defaultIcon = 'assets/myicons/icon-black-image-default.png';
  final String menuIcon = 'assets/myicons/icon-white-hamburger-menu.png';
  final String nextIcon = 'assets/myicons/icon-black-next.png';
  final String chevronLeftIcon = 'assets/myicons/icon-black-chevron-left.png';
  final String chevronRightIcon = 'assets/myicons/icon-black-chevron-right.png';
  final String repeatIcon = 'assets/myicons/icon-black-repeat.png';
  final String finishIcon = 'assets/myicons/icon-color-finish.png';
  final String heartBeatStatsIcon = 'assets/myicons/icon-black-heart-beat.png';
  final String footStepStatsIcon = 'assets/myicons/icon-black-footstep.png';
  final String elevationStatsIcon = 'assets/myicons/icon-black-elevation.png';
  final String caloriesStatsIcon = 'assets/myicons/icon-black-calories.png';
  final String timeStatsIcon = 'assets/myicons/icon-black-time.png';
  final String paceStatsIcon = 'assets/myicons/icon-black-speed-ometer.png';
  final String roadStatsIcon = 'assets/myicons/icon-black-road.png';
  final String activitiesStatsIcon = 'assets/myicons/icon-black-runner-02.png';
  final String pathIcon = 'assets/myicons/icon-black-path.png';
  final String blackLoveIcon = 'assets/myicons/icon-black-love.png';
  final String blackBoldLoveIcon = 'assets/myicons/icon-black-bold-love.png';
  final String orangeLoveIcon = 'assets/myicons/icon-orange-love.png';
  final String orangeBolLoveIcon = 'assets/myicons/icon-orange-bold-love.png';
  final String blackCommentIcon = 'assets/myicons/icon-black-comment.png';
  final String blackShareIcon = 'assets/myicons/icon-black-share.png';
  final String blackRunnerIcon = 'assets/myicons/icon-black-runner.png';
  final String whiteInfoIcon = 'assets/myicons/icon-white-info.png';
  final String whiteShoeIcon = 'assets/myicons/icon-white-shoe.png';
  final String whiteStatisticsIcon = 'assets/myicons/icon-white-statistics.png';
  final String blackAttachmentIcon02 =
      'assets/myicons/icon-black-attachments-02.png';
  final String blackBlockIcon = 'assets/myicons/icon-black-block.png';
  final String blackAddIcon02 = 'assets/myicons/icon-black-add-02.png';
  final String blackCloseIcon = 'assets/myicons/icon-black-close.png';
  final String whiteCloseIcon = 'assets/myicons/icon-white-close.png';
  final String blackNewsFeedIcon = 'assets/myicons/icon-black-news-feed.png';
  final String colorEditIcon = 'assets/myicons/icon-color-edit.png';
  final String colorEditIconOrangeBg =
      'assets/myicons/icon-color-edit-orange-background.png';
  final String blackEditIcon = 'assets/myicons/icon-black-edit.png';
  final String whiteEditIcon = 'assets/myicons/icon-white-edit.png';
  final String blackPostIcon = 'assets/myicons/icon-black-post.png';
  final String blackPopupMenuIcon = 'assets/myicons/icon-black-3-dots.png';

  // Default is Light theme (Black color)
  String defaultIconByTheme = 'assets/myicons/icon-black-image-default.png';
  String nextIconByTheme = 'assets/myicons/icon-black-next.png';
  String peopleIconByTheme = 'assets/myicons/icon-black-people.png';
  String heartBeatStatsIconByTheme = 'assets/myicons/icon-black-heart-beat.png';
  String footStepStatsIconByTheme = 'assets/myicons/icon-black-footstep.png';
  String elevationStatsIconByTheme = 'assets/myicons/icon-black-elevation.png';
  String caloriesStatsIconByTheme = 'assets/myicons/icon-black-calories.png';
  String timeStatsIconByTheme = 'assets/myicons/icon-black-time.png';
  String paceStatsIconByTheme = 'assets/myicons/icon-black-speed-ometer.png';
  String roadStatsIconByTheme = 'assets/myicons/icon-black-road.png';
  String activitiesStatsIconByTheme = 'assets/myicons/icon-black-runner-02.png';
  String loveIconByTheme = 'assets/myicons/icon-black-love.png';
  String commentIconByTheme = 'assets/myicons/icon-black-comment.png';
  String shareIconByTheme = 'assets/myicons/icon-black-share.png';
  String runnerIconByTheme = 'assets/myicons/icon-black-runner.png';
  String attachmentIcon02ByTheme =
      'assets/myicons/icon-black-attachments-02.png';
  String blockIconByTheme = 'assets/myicons/icon-black-block.png';
  String addIcon02ByTheme = 'assets/myicons/icon-black-add-02.png';
  String closeIconByTheme = 'assets/myicons/icon-black-close.png';
  String editIconByTheme = 'assets/myicons/icon-black-edit.png';
  String postIconByTheme = 'assets/myicons/icon-black-post.png';
  String popupMenuIconByTheme = 'assets/myicons/icon-black-3-dots.png';
  String gpsIconByTheme = 'assets/myicons/icon-black-gps.png';
  String keyIconByTheme = 'assets/myicons/icon-black-key.png';
  String hcmusLogo = 'assets/myicons/khtn.png';
  String starIconByTheme = 'assets/myicons/icon-black-star.png';

  // User wants to change theme
  void changeTheme(AppTheme theme) {
    if (theme == AppTheme.LIGHT) {
      defaultIconByTheme = 'assets/myicons/icon-black-image-default.png';
      nextIconByTheme = 'assets/myicons/icon-black-next.png';
      peopleIconByTheme = 'assets/myicons/icon-black-people.png';
      heartBeatStatsIconByTheme = 'assets/myicons/icon-black-heart-beat.png';
      footStepStatsIconByTheme = 'assets/myicons/icon-black-footstep.png';
      elevationStatsIconByTheme = 'assets/myicons/icon-black-elevation.png';
      caloriesStatsIconByTheme = 'assets/myicons/icon-black-calories.png';
      timeStatsIconByTheme = 'assets/myicons/icon-black-time.png';
      paceStatsIconByTheme = 'assets/myicons/icon-black-speed-ometer.png';
      roadStatsIconByTheme = 'assets/myicons/icon-black-road.png';
      activitiesStatsIconByTheme = 'assets/myicons/icon-black-runner-02.png';
      loveIconByTheme = 'assets/myicons/icon-black-love.png';
      commentIconByTheme = 'assets/myicons/icon-black-comment.png';
      shareIconByTheme = 'assets/myicons/icon-black-share.png';
      runnerIconByTheme = 'assets/myicons/icon-black-runner.png';
      attachmentIcon02ByTheme = 'assets/myicons/icon-black-attachments-02.png';
      blockIconByTheme = 'assets/myicons/icon-black-block.png';
      addIcon02ByTheme = 'assets/myicons/icon-black-add-02.png';
      closeIconByTheme = 'assets/myicons/icon-black-close.png';
      editIconByTheme = 'assets/myicons/icon-black-edit.png';
      postIconByTheme = 'assets/myicons/icon-black-post.png';
      popupMenuIconByTheme = 'assets/myicons/icon-black-3-dots.png';
      gpsIconByTheme = 'assets/myicons/icon-black-gps.png';
      keyIconByTheme = 'assets/myicons/icon-black-key.png';
      starIconByTheme = 'assets/myicons/icon-black-star.png';

      // TODO: Light theme (Black color)
    } else {
      defaultIconByTheme = 'assets/myicons/icon-white-image-default.png';
      nextIconByTheme = 'assets/myicons/icon-white-next.png';
      peopleIconByTheme = 'assets/myicons/icon-white-people.png';
      heartBeatStatsIconByTheme = 'assets/myicons/icon-white-heart-beat.png';
      footStepStatsIconByTheme = 'assets/myicons/icon-white-footstep.png';
      elevationStatsIconByTheme = 'assets/myicons/icon-white-elevation.png';
      caloriesStatsIconByTheme = 'assets/myicons/icon-white-calories.png';
      timeStatsIconByTheme = 'assets/myicons/icon-white-time.png';
      paceStatsIconByTheme = 'assets/myicons/icon-white-speed-ometer.png';
      roadStatsIconByTheme = 'assets/myicons/icon-white-road.png';
      activitiesStatsIconByTheme = 'assets/myicons/icon-white-runner-02.png';
      loveIconByTheme = 'assets/myicons/icon-white-love.png';
      commentIconByTheme = 'assets/myicons/icon-white-comment.png';
      shareIconByTheme = 'assets/myicons/icon-white-share.png';
      runnerIconByTheme = 'assets/myicons/icon-white-runner.png';
      attachmentIcon02ByTheme = 'assets/myicons/icon-white-attachments-02.png';
      blockIconByTheme = 'assets/myicons/icon-white-block.png';
      addIcon02ByTheme = 'assets/myicons/icon-white-add-02.png';
      closeIconByTheme = 'assets/myicons/icon-white-close.png';
      editIconByTheme = 'assets/myicons/icon-white-edit.png';
      postIconByTheme = 'assets/myicons/icon-white-post.png';
      popupMenuIconByTheme = 'assets/myicons/icon-white-3-dots.png';
      gpsIconByTheme = 'assets/myicons/icon-white-gps.png';
      keyIconByTheme = 'assets/myicons/icon-white-key.png';
      starIconByTheme = 'assets/myicons/icon-white-star.png';

      // TODO: Black theme (Light color)
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

  final String loginFacebookEnglish = 'assets/images/login-fb-en.png';
  final String loginFacebookVietnam = 'assets/images/login-fb-vi.png';
  final String loginGoogleEnglish = 'assets/images/login-gg-en.png';
  final String loginGoogleVietnam = 'assets/images/login-gg-vi.png';
  final String loginEmailEnglish = 'assets/images/login-email-en.png';
  final String loginEmailVietnam = 'assets/images/login-email-vi.png';
  final String orLine = 'assets/images/or-line.png';
  final String pageBackground = 'assets/images/page-background.png';

  final String drawerBackground = 'assets/images/drawer-background.png';
  final String drawerBackgroundDarker =
      'assets/images/drawer-background-darker.png';
  final String smallDefaultImage = 'assets/images/small-default-image.png';
  final String staticStatsChart01 = 'assets/images/static-stats-chart-01.png';
  final String staticStatsChart02 = 'assets/images/static-stats-chart-02.png';
  final String staticStatsChart03 = 'assets/images/static-stats-chart-03.png';

  final String avatar = 'assets/images/avatar.png';
  final String avatarQuocTK = 'assets/images/avatar-quoctk.png';
  final String avatarNgocVTT = 'assets/images/avatar-ngocvtt.png';
  final String avatarHuyTA = 'assets/images/avatar-huyta.png';
  final String avatarPhucTT = 'assets/images/avatar-phuctt.png';
  final String avatarKhaTM = 'assets/images/avatar-khatm.png';
}

@reflector
class Strings {
  String usrun;

  String firstName;
  String lastName;
  String password;
  String passwordHint;
  String currentPassword;
  String newPassword;
  String retypePassword;
  String retypePasswordHint;
  String forgotPassword;
  String passwordNotice;
  String reset;
  String resetPasswordNotice;
  String email;
  String emailHint;
  String country;
  String city;
  String district;
  String whatYourJob;
  String whatYourJobHint;
  String birthday;
  String gender;
  String height;
  String weight;
  String biography;
  String biographyHint;
  String follow;
  String unFollow;

  List<String> provinces;

  String inviteNewMember;
  String inviteNewMemberContent;
  String invite;
  String kickAMember;
  String kickAMemberContent;
  String kick;
  String blockAPerson;
  String blockAPersonContent;
  String block;

  String day;
  String week;
  String month;
  String year;

  String yearPicker;
  String monthPicker;
  String weekPicker;
  String datePicker;
  String timePicker;
  String dateTimePicker;

  String selectedDay;
  String selectedWeek;
  String selectedMonth;
  String currentWeek;
  String currentMonth;
  String currentYear;

  String january;
  String february;
  String march;
  String april;
  String may;
  String june;
  String july;
  String august;
  String september;
  String october;
  String november;
  String december;

  String monday;
  String tuesday;
  String wednesday;
  String thursday;
  String friday;
  String saturday;
  String sunday;

  String ok;
  String cancel;
  String error;
  String notice;

  String alreadyAMember;
  String signIn;
  String signUp;
  String resetPassword;

  String warning;
  String caution;
  String exitApp;
  String logoutApp;
  String yes;
  String no;
  String close;

  String profile;
  String editProfile;
  String discardEditedChanges;

  String athleteProfile;
  String athleteBadges;
  String athletePhotos;
  String athleteFollowing;
  String athleteFollowingNotice;
  String athleteFollowers;
  String athleteFollowersNotice;
  String athleteEvents;
  String athleteTeams;
  String athleteTeamPlans;
  String athleteActivities;
  String athleteStatsInCurrentYear;

  String personalFollowing;
  String personalFollowingNotice;
  String personalFollowers;
  String personalFollowersNotice;
  String personalEvents;
  String personalTeams;
  String personalTeamPlans;
  String personalEventBadges;
  String personalPhotos;
  String personalActivities;

  String record;
  String gpsAcquiring;
  String gpsReady;
  String gpsNotFound;
  String gpsServiceUnavailable;
  String enableGPS;
  String time;
  String distance;
  String pace;
  String avgPace;
  String avgHeart;
  String maxHeart;
  String movingTime;
  String calories;
  String total;
  String totalStep;
  String timeUnit;
  String meters;
  String km;
  String m;
  String avgPaceUnit;
  String avgHeartUnit;
  String movingTimeUnit;
  String caloriesUnit;
  String totalStepsUnit;
  String stats;
  String title;
  String description;
  String elevGain;
  String maxElev;
  String yourPhotos;
  String yourMaps;
  String paceChart;
  String viewMapDescription;
  String uploadActivity;
  String morningRun;
  String afternoonRun;
  String eveningRun;
  String nightRun;
  String pause;
  String discard;
  String upload;
  String na;

  String uFeed;
  String readMore;
  String editActivity;
  String deleteActivity;
  String confirmActivityDeletion;
  String askToRemoveOldOnlinePhoto;

  String events;
  String event;

  String teams;
  String team;

  String public;
  String private;
  String join;
  String cancelJoin;
  String acceptInvitation;
  String symbol;
  String verifiedByUsrun;
  String teamStats;
  String leaderboard;
  String rank;
  String activities;
  String activity;
  String splits;
  String members;
  String leadingTime;
  String leadingDist;
  String newMemThisWeek;
  String toolZone;
  String makeTeamPublicTitle;
  String makeTeamPublicSubtitle;
  String moderateNewPostsTitle;
  String moderateNewPostsSubtitle;
  String create;
  String createNewTeamPlanTitle;
  String createNewTeamPlanSubtitle;
  String grant;
  String grantRoleToMemberTitle;
  String grantRoleToMemberSubtitle;
  String transfer;
  String transferOwnershipTitle;
  String transferOwnershipSubtitle;
  String delete;
  String deleteTeamTitle;
  String deleteTeamSubtitle;
  String noResult;
  String noResultSubtitle;
  String memberOnly;
  String memberOnlySubtitle;
  String startSearch;
  String startSearchSubtitle;
  String notAuthorizedTeamChange;
  String demoteAPerson;
  String promoteAPerson;
  String inviteTeamListTitle;
  String requestTeamListTitle;
  String emptyMemberList;
  String emptyMemberListSubtitle;

  String viewAllTeams;
  String yourTeams;
  String weSuggestYou;
  String teamLeaderboard;
  String teamRank;
  String numberOrder;
  String name;
  String distanceKm;
  String distanceM;
  String teamMember;
  String all;
  String hiding;
  String requesting;
  String blocking;
  String reporting;
  String processing;
  String updating;
  String loading;
  String loadingTeamInfo;

  String settings;
  String changePassword;
  String appInfo;
  String inAppNotifications;
  String privacyProfile;
  String hotContact;
  String legal;
  String faqs;

  List<String> eventStatus;

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
  String settingsSOAppInfoTitle;
  String settingsSOLogOutTitle;
  String settingsChangePasswordSuccessful;
  String settingsCPEmptyField;
  String settingsCPPwdNotMatch;
  String settingsCPNewPwdDifferent;
  String settingsCPInvalidPwd;
  String settingsCPReLogin;

  String appInfoUSRUNTitle;
  String appInfoUSRUNSubtitle;
  String appInfoDevelopersTitle;
  String appInfoDevelopersSubtitle;
  String appInfoVersionTitle;
  String appInfoVersionSubtitle;
  String appInfoRateAppTitle;
  String appInfoRateAppSubtitle;

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

  String chooseLanguageTitle;
  String chooseLanguageDescription;
  String english;
  String vietnamese;
  String languageDescription;

  String chooseAppThemeTitle;
  String chooseAppThemeDescription;
  String lightTheme;
  String darkTheme;
  String appThemeDescription;

  String takeAPhoto;
  String openPhotoLibrary;
  String clearSelectedFile;

  Map<String, dynamic> errorMessages;

  String nothingToShow;
  String errorLoginFail;
  String errorLogoutFail;
  String errorUserCancelledLogin;
  String errorUserNotFoundCreateNew;
  String errorInvalidEmail;
  String errorEmptyPassword;
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
  String errorUserNotFound;
  String errorEmailPassword;
  String errorOccurred;
  String requestTimeOut;
}

class _Styles {
  final TextStyle labelStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: R.appRatio.appFontSize18,
    color: R.colors.labelText,
  );

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
    ],
  );

  final TextStyle subTitleStyle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: R.appRatio.appFontSize12,
    color: R.colors.contentText,
  );

  final TextStyle shadowSubTitleStyle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: R.appRatio.appFontSize12,
    color: R.colors.contentText,
    shadows: <Shadow>[
      Shadow(
        offset: Offset(2.0, 2.0),
        blurRadius: 4.0,
        color: R.colors.textShadow,
      ),
    ],
  );
}

class _ImagePickerDefaults {
  // Sizes are in kilobytes
  final double maxWidth = 800;
  final double maxHeight = 600;
  final int imageQuality = 80;
  final int maxOutputSize = 75;
  final int minInputSize = 500;
  final int maxInputSize = 6000;
  final int refSize = 4000;

  AndroidUiSettings defaultAndroidSettings = new AndroidUiSettings(
      toolbarColor: R.colors.majorOrange,
      showCropGrid: false,
      toolbarTitle: "Crop Your Image",
      toolbarWidgetColor: Colors.white,
      cropFrameColor: R.colors.majorOrange,
      dimmedLayerColor: R.colors.blurMajorOrange);

  IOSUiSettings defaultIOSSettings;
}
