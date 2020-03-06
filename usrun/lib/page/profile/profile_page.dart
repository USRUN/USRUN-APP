import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/widget/complex_info_box.dart';
import 'package:usrun/widget/event_badge_list.dart';
import 'package:usrun/widget/event_list.dart';
import 'package:usrun/widget/follower_following_list.dart';
import 'package:usrun/widget/normal_info_box.dart';
import 'package:usrun/widget/photo_list.dart';
import 'package:usrun/widget/simple_info_box.dart';
import 'package:usrun/widget/stats_section.dart';
import 'package:usrun/widget/team_list.dart';
import 'package:usrun/widget/team_plan_list.dart';

class ProfilePage extends StatelessWidget {
  final _eventBadgeList = [
    {
      'eventID': '0',
      'badgeImageURL':
          'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Western%20Sydney%20Wanderers%20FC/WSWFCFlamesShortQuoteWallpaperbySunnyboiiii.jpg'
    },
    {
      'eventID': '1',
      'badgeImageURL':
          'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Western%20Sydney%20Wanderers%20FC/WSWFCFlamesShortQuoteWallpaperbySunnyboiiii.jpg'
    },
    {
      'eventID': '2',
      'badgeImageURL':
          'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Western%20Sydney%20Wanderers%20FC/WSWFCFlamesShortQuoteWallpaperbySunnyboiiii.jpg'
    },
    {
      'eventID': '3',
      'badgeImageURL':
          'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Western%20Sydney%20Wanderers%20FC/WSWFCFlamesShortQuoteWallpaperbySunnyboiiii.jpg'
    },
    {
      'eventID': '4',
      'badgeImageURL':
          'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Western%20Sydney%20Wanderers%20FC/WSWFCFlamesShortQuoteWallpaperbySunnyboiiii.jpg'
    },
    {
      'eventID': '5',
      'badgeImageURL':
          'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Western%20Sydney%20Wanderers%20FC/WSWFCFlamesShortQuoteWallpaperbySunnyboiiii.jpg'
    },
    {
      'eventID': '6',
      'badgeImageURL':
          'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Western%20Sydney%20Wanderers%20FC/WSWFCFlamesShortQuoteWallpaperbySunnyboiiii.jpg'
    },
    {
      'eventID': '7',
      'badgeImageURL':
          'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Western%20Sydney%20Wanderers%20FC/WSWFCFlamesShortQuoteWallpaperbySunnyboiiii.jpg'
    },
    {
      'eventID': '8',
      'badgeImageURL':
          'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Western%20Sydney%20Wanderers%20FC/WSWFCFlamesShortQuoteWallpaperbySunnyboiiii.jpg'
    },
    {
      'eventID': '9',
      'badgeImageURL':
          'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Western%20Sydney%20Wanderers%20FC/WSWFCFlamesShortQuoteWallpaperbySunnyboiiii.jpg'
    },
    {
      'eventID': '10',
      'badgeImageURL':
          'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Western%20Sydney%20Wanderers%20FC/WSWFCFlamesShortQuoteWallpaperbySunnyboiiii.jpg'
    }
  ];

  final _photoItemList = [
    {
      'thumbnailURL':
          'https://i.pinimg.com/originals/3f/e8/f3/3fe8f39d6470b4f5e6b95b63b41b032f.png',
      'imageURL':
          'https://i.pinimg.com/originals/3f/e8/f3/3fe8f39d6470b4f5e6b95b63b41b032f.png'
    },
    {
      'thumbnailURL':
          'https://fsa.zobj.net/crop.php?r=Jpxw0sc1BcrDUUhFmPojrSJwGldpurelLtyUo5aZfSedCBxQxUUSMl91wbzycYOPAancYe8Y1eViVrNu4Eqj-3IhWGNot1_J8OKDVoYBdbx7B4RAfYwVnAtw8yF-di-mAgGvseJ1A_d_M3LL',
      'imageURL':
          'https://fsa.zobj.net/crop.php?r=Jpxw0sc1BcrDUUhFmPojrSJwGldpurelLtyUo5aZfSedCBxQxUUSMl91wbzycYOPAancYe8Y1eViVrNu4Eqj-3IhWGNot1_J8OKDVoYBdbx7B4RAfYwVnAtw8yF-di-mAgGvseJ1A_d_M3LL'
    },
    {
      'thumbnailURL':
          'https://m.media-amazon.com/images/M/MV5BOTk5ODg0OTU5M15BMl5BanBnXkFtZTgwMDQ3MDY3NjM@._V1_QL50_SY1000_CR0,0,674,1000_AL_.jpg',
      'imageURL':
          'https://m.media-amazon.com/images/M/MV5BOTk5ODg0OTU5M15BMl5BanBnXkFtZTgwMDQ3MDY3NjM@._V1_QL50_SY1000_CR0,0,674,1000_AL_.jpg'
    },
    {
      'thumbnailURL':
          'https://i113.photobucket.com/albums/n224/hazels_designs/rahne-1.gif',
      'imageURL':
          'https://i113.photobucket.com/albums/n224/hazels_designs/rahne-1.gif'
    },
    {
      'thumbnailURL':
          'https://i1091.photobucket.com/albums/i395/ugg-boot/kid%20ugg%20boot/ugg-5991-kids-sand-boots_05.jpg',
      'imageURL':
          'https://i1091.photobucket.com/albums/i395/ugg-boot/kid%20ugg%20boot/ugg-5991-kids-sand-boots_05.jpg'
    },
    {
      'thumbnailURL':
          'https://i1088.photobucket.com/albums/i324/chishono/Short%20North%20Chiropractic/shortnorthchiropractic8.jpg',
      'imageURL':
          'https://i1088.photobucket.com/albums/i324/chishono/Short%20North%20Chiropractic/shortnorthchiropractic8.jpg'
    },
    {
      'thumbnailURL':
          'https://i1088.photobucket.com/albums/i324/chishono/Short%20North%20Chiropractic/shortnorthchiropractic10.jpg',
      'imageURL':
          'https://i1088.photobucket.com/albums/i324/chishono/Short%20North%20Chiropractic/shortnorthchiropractic10.jpg'
    },
    {
      'thumbnailURL':
          'https://i1217.photobucket.com/albums/dd388/jnelson9r/J%20Nelson%20Real%20Estate/JNELSONREALESTATE2.jpg',
      'imageURL':
          'https://i1217.photobucket.com/albums/dd388/jnelson9r/J%20Nelson%20Real%20Estate/JNELSONREALESTATE2.jpg'
    },
    {
      'thumbnailURL':
          'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedFCAwayFlamesWallpaperbySunnyboiiii.jpg',
      'imageURL':
          'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedFCAwayFlamesWallpaperbySunnyboiiii.jpg'
    },
    {
      'thumbnailURL':
          'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg',
      'imageURL':
          'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg'
    },
    {
      'thumbnailURL':
          'https://i49.photobucket.com/albums/f260/starfoxfan/fursona.jpg',
      'imageURL':
          'https://i49.photobucket.com/albums/f260/starfoxfan/fursona.jpg'
    }
  ];

  final _ffItemList = [
    {
      "userCode": "0",
      "avatarImageURL":
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      "supportImageURL":
          "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
      "fullName": "Trần Kiến Quốc",
      "cityName": "Ho Chi Minh",
    },
    {
      "userCode": "1",
      "avatarImageURL":
          "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
      "supportImageURL":
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      "fullName": "Võ Thị Thanh Ngọc",
      "cityName": "Bà Rịa - Vũng Tàu",
    },
    {
      "userCode": "2",
      "avatarImageURL":
          "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
      "supportImageURL":
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      "fullName": "Trần Minh Kha",
      "cityName": "Mã Pí Lèng",
    },
    {
      "userCode": "3",
      "avatarImageURL":
          "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
      "supportImageURL":
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      "fullName": "Quách Ngọc Trang",
      "cityName": "Ha Noi",
    },
    {
      "userCode": "4",
      "avatarImageURL":
          "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
      "supportImageURL":
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      "fullName": "Trần Hải Âu Dương",
      "cityName": "Thừa Thiên Huế",
    },
    {
      "userCode": "5",
      "avatarImageURL":
          "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
      "supportImageURL":
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      "fullName": "Lê Trương Phú Đạt",
      "cityName": "Phía Bắc Việt Nam",
    },
    {
      "userCode": "6",
      "avatarImageURL":
          "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
      "supportImageURL":
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      "fullName": "Tôn Công Nữ Chính",
      "cityName": "Đảo Cà Mau Việt Nam",
    }
  ];

  final _eventList = [
    {
      "id": "0",
      "name": "UpRace - Move Viet Nam",
      "athleteQuantity": 44284,
      "isFinished": true,
      "bannerImageURL":
          "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg"
    },
    {
      "id": "1",
      "name": "VietNam Mountain Marathon 2019",
      "athleteQuantity": 1231231,
      "isFinished": true,
      "bannerImageURL":
          "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg"
    },
    {
      "id": "2",
      "name": "Let's Run Everybody",
      "athleteQuantity": 89105,
      "isFinished": false,
      "bannerImageURL":
          "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg"
    },
    {
      "id": "3",
      "name": "Chạy Vì Cộng Đồng Trẻ Mồ Côi",
      "athleteQuantity": 48105,
      "isFinished": false,
      "bannerImageURL":
          "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg"
    },
    {
      "id": "4",
      "name": "US-Run-Event-2020",
      "athleteQuantity": 5156,
      "isFinished": true,
      "bannerImageURL":
          "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg"
    }
  ];

  final _teamList = [
    {
      "id": "0",
      "name": "Trường Đại học Khoa học Tự nhiên 123 123 123",
      "athleteQuantity": 44284,
      "avatarImageURL":
          "https://i.pinimg.com/originals/3f/e8/f3/3fe8f39d6470b4f5e6b95b63b41b032f.png",
      "supportImageURL":
          "https://i1091.photobucket.com/albums/i395/ugg-boot/kid%20ugg%20boot/ugg-5991-kids-sand-boots_05.jpg"
    },
    {
      "id": "1",
      "name": "Cửa hàng Ecoshop",
      "athleteQuantity": 195724,
      "avatarImageURL": R.images.avatarHuyTA,
      "supportImageURL": R.images.avatar
    },
    {
      "id": "2",
      "name": "Techcombank",
      "athleteQuantity": 2000000,
      "avatarImageURL": R.images.avatarNgocVTT,
      "supportImageURL": R.images.avatar
    },
    {
      "id": "3",
      "name": "Run Club Marvel Forever Be Young, Yay! 1 2 3 4 5",
      "athleteQuantity": 516,
      "avatarImageURL": R.images.avatarKhaTM,
      "supportImageURL": R.images.avatar
    },
    {
      "id": "4",
      "name": "Lý Luận Chạy",
      "athleteQuantity": 5276,
      "avatarImageURL": R.images.avatarPhucTT,
      "supportImageURL": R.images.avatar
    },
  ];

  final _teamPlanList = [
    {
      "planID": "0",
      "dateTime": "10/01/2020 18:30",
      "isFinished": true,
      "mapImageURL":
          "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
      "planName": "Time to train, get high friends, oh yay go go go 123 123!",
      "teamName": "Trường Đại học Khoa học Tự nhiên",
    },
    {
      "planID": "1",
      "dateTime": "05/3/2020 5:30",
      "isFinished": true,
      "mapImageURL":
          "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
      "planName": "Move Your Body Move Your Body Move Your Body Move Your Body",
      "teamName": "Ngân hàng Techcombank",
    },
    {
      "planID": "2",
      "dateTime": "28/02/2020 6:30",
      "isFinished": false,
      "mapImageURL":
          "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
      "planName": "Everyone is so boring :D",
      "teamName": "Cửa hàng EcoShop",
    },
    {
      "planID": "3",
      "dateTime": "31/05/2020 15:50",
      "isFinished": false,
      "mapImageURL":
          "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
      "planName": "Let's race, Let's run, Let's move",
      "teamName": "RUN-CLUB-ENERY",
    },
    {
      "planID": "4",
      "dateTime": "02/09/2020 00:00",
      "isFinished": true,
      "mapImageURL":
          "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
      "planName": "Lễ Quốc Khánh, sợ gì, chạy ngay đi ^^",
      "teamName": "Câu lạc bộ Chạy bộ miền Nam Việt Nam",
    },
  ];

  final _statsListStyle01 = [
    {
      "title": "Activities",
      "data": "104",
      "unit": "",
      "iconURL": R.myIcons.activitiesStatsIconByTheme,
      "enableBottomBorder": true,
      "isSuffixIcon": true,
      "enableMarginBottom": true,
    },
    {
      "title": "Total Dist",
      "data": "1251.78",
      "unit": "km",
      "iconURL": R.myIcons.roadStatsIconByTheme,
      "enableBottomBorder": true,
      "isSuffixIcon": true,
      "enableMarginBottom": true,
    },
    {
      "title": "Total Steps",
      "data": "257462",
      "unit": "",
      "iconURL": R.myIcons.footStepStatsIconByTheme,
      "enableBottomBorder": true,
      "isSuffixIcon": true,
      "enableMarginBottom": true,
    },
    {
      "title": "Total Time",
      "data": "37188",
      "unit": "min",
      "iconURL": R.myIcons.timeStatsIconByTheme,
      "enableBottomBorder": true,
      "isSuffixIcon": true,
      "enableMarginBottom": true,
    },
    {
      "title": "Avg Time",
      "data": "131",
      "unit": "min",
      "iconURL": R.myIcons.timeStatsIconByTheme,
      "enableBottomBorder": false,
      "isSuffixIcon": true,
      "enableMarginBottom": true,
    },
    {
      "title": "Avg Pace",
      "data": "10:51",
      "unit": "/km",
      "iconURL": R.myIcons.paceStatsIconByTheme,
      "enableBottomBorder": true,
      "isSuffixIcon": false,
      "enableMarginBottom": true,
    },
    {
      "title": "Avg Heart",
      "data": "138",
      "unit": "bpm",
      "iconURL": R.myIcons.heartBeatStatsIconByTheme,
      "enableBottomBorder": true,
      "isSuffixIcon": false,
      "enableMarginBottom": true,
    },
    {
      "title": "Total Cal",
      "data": "15818",
      "unit": "/kcal",
      "iconURL": R.myIcons.caloriesStatsIconByTheme,
      "enableBottomBorder": true,
      "isSuffixIcon": false,
      "enableMarginBottom": true,
    },
    {
      "title": "Avg Elev",
      "data": "382",
      "unit": "m",
      "iconURL": R.myIcons.elevationStatsIconByTheme,
      "enableBottomBorder": true,
      "isSuffixIcon": false,
      "enableMarginBottom": true,
    },
    {
      "title": "Max Elev",
      "data": "224",
      "unit": "m",
      "iconURL": R.myIcons.elevationStatsIconByTheme,
      "enableBottomBorder": false,
      "isSuffixIcon": false,
      "enableMarginBottom": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colors.appBackground,
      body: Center(
        child: Container(
          height: 400,
          color: Colors.lightGreen,
          padding: EdgeInsets.only(
            left: R.appRatio.appSpacing15,
            right: R.appRatio.appSpacing15,
          ),
          child: null,
        ),
      ),
    );
  }
}
