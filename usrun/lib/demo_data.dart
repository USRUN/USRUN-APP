import 'package:intl/intl.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/page/team/team_member_item.dart';
import 'package:usrun/page/team/team_rank_item.dart';
import 'package:usrun/page/team/team_search_item.dart';
import 'package:usrun/widget/custom_popup_menu/custom_popup_item.dart';
import 'package:usrun/widget/event_badge_list/event_badge_item.dart';
import 'package:usrun/widget/event_list/event_item.dart';
import 'package:usrun/widget/follower_following_list/follower_following_item.dart';
import 'package:usrun/widget/photo_list/photo_item.dart';
import 'package:usrun/widget/team_list/team_item.dart';
import 'package:usrun/widget/team_plan_list/team_plan_item.dart';

class DemoData {
  final eventBadgeList = [
    EventBadgeItem(
      value: '0',
      imageURL:
          'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Western%20Sydney%20Wanderers%20FC/WSWFCFlamesShortQuoteWallpaperbySunnyboiiii.jpg',
    ),
    EventBadgeItem(
      value: '1',
      imageURL:
          'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Western%20Sydney%20Wanderers%20FC/WSWFCFlamesShortQuoteWallpaperbySunnyboiiii.jpg',
    ),
    EventBadgeItem(
      value: '2',
      imageURL:
          'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Western%20Sydney%20Wanderers%20FC/WSWFCFlamesShortQuoteWallpaperbySunnyboiiii.jpg',
    ),
    EventBadgeItem(
      value: '3',
      imageURL:
          'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Western%20Sydney%20Wanderers%20FC/WSWFCFlamesShortQuoteWallpaperbySunnyboiiii.jpg',
    ),
    EventBadgeItem(
      value: '4',
      imageURL:
          'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Western%20Sydney%20Wanderers%20FC/WSWFCFlamesShortQuoteWallpaperbySunnyboiiii.jpg',
    ),
    EventBadgeItem(
      value: '5',
      imageURL:
          'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Western%20Sydney%20Wanderers%20FC/WSWFCFlamesShortQuoteWallpaperbySunnyboiiii.jpg',
    ),
    EventBadgeItem(
      value: '6',
      imageURL:
          'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Western%20Sydney%20Wanderers%20FC/WSWFCFlamesShortQuoteWallpaperbySunnyboiiii.jpg',
    ),
    EventBadgeItem(
      value: '7',
      imageURL:
          'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Western%20Sydney%20Wanderers%20FC/WSWFCFlamesShortQuoteWallpaperbySunnyboiiii.jpg',
    ),
    EventBadgeItem(
      value: '8',
      imageURL:
          'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Western%20Sydney%20Wanderers%20FC/WSWFCFlamesShortQuoteWallpaperbySunnyboiiii.jpg',
    ),
    EventBadgeItem(
      value: '9',
      imageURL:
          'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Western%20Sydney%20Wanderers%20FC/WSWFCFlamesShortQuoteWallpaperbySunnyboiiii.jpg',
    ),
    EventBadgeItem(
      value: '10',
      imageURL:
          'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Western%20Sydney%20Wanderers%20FC/WSWFCFlamesShortQuoteWallpaperbySunnyboiiii.jpg',
    ),
  ];

  final photoItemList = [
    PhotoItem(
      imageURL:
          'https://i.pinimg.com/originals/3f/e8/f3/3fe8f39d6470b4f5e6b95b63b41b032f.png',
      thumbnailURL:
          'https://i.pinimg.com/originals/3f/e8/f3/3fe8f39d6470b4f5e6b95b63b41b032f.png',
    ),
    PhotoItem(
      imageURL:
          'https://fsa.zobj.net/crop.php?r=Jpxw0sc1BcrDUUhFmPojrSJwGldpurelLtyUo5aZfSedCBxQxUUSMl91wbzycYOPAancYe8Y1eViVrNu4Eqj-3IhWGNot1_J8OKDVoYBdbx7B4RAfYwVnAtw8yF-di-mAgGvseJ1A_d_M3LL',
      thumbnailURL:
          'https://fsa.zobj.net/crop.php?r=Jpxw0sc1BcrDUUhFmPojrSJwGldpurelLtyUo5aZfSedCBxQxUUSMl91wbzycYOPAancYe8Y1eViVrNu4Eqj-3IhWGNot1_J8OKDVoYBdbx7B4RAfYwVnAtw8yF-di-mAgGvseJ1A_d_M3LL',
    ),
    PhotoItem(
      imageURL:
          'https://m.media-amazon.com/images/M/MV5BOTk5ODg0OTU5M15BMl5BanBnXkFtZTgwMDQ3MDY3NjM@._V1_QL50_SY1000_CR0,0,674,1000_AL_.jpg',
      thumbnailURL:
          'https://m.media-amazon.com/images/M/MV5BOTk5ODg0OTU5M15BMl5BanBnXkFtZTgwMDQ3MDY3NjM@._V1_QL50_SY1000_CR0,0,674,1000_AL_.jpg',
    ),
    PhotoItem(
      imageURL:
          'https://i113.photobucket.com/albums/n224/hazels_designs/rahne-1.gif',
      thumbnailURL:
          'https://i113.photobucket.com/albums/n224/hazels_designs/rahne-1.gif',
    ),
    PhotoItem(
      imageURL:
          'https://i1091.photobucket.com/albums/i395/ugg-boot/kid%20ugg%20boot/ugg-5991-kids-sand-boots_05.jpg',
      thumbnailURL:
          'https://i1091.photobucket.com/albums/i395/ugg-boot/kid%20ugg%20boot/ugg-5991-kids-sand-boots_05.jpg',
    ),
    PhotoItem(
      imageURL:
          'https://i1088.photobucket.com/albums/i324/chishono/Short%20North%20Chiropractic/shortnorthchiropractic8.jpg',
      thumbnailURL:
          'https://i1088.photobucket.com/albums/i324/chishono/Short%20North%20Chiropractic/shortnorthchiropractic8.jpg',
    ),
    PhotoItem(
      imageURL:
          'https://i1088.photobucket.com/albums/i324/chishono/Short%20North%20Chiropractic/shortnorthchiropractic10.jpg',
      thumbnailURL:
          'https://i1088.photobucket.com/albums/i324/chishono/Short%20North%20Chiropractic/shortnorthchiropractic10.jpg',
    ),
    PhotoItem(
      imageURL:
          'https://i1217.photobucket.com/albums/dd388/jnelson9r/J%20Nelson%20Real%20Estate/JNELSONREALESTATE2.jpg',
      thumbnailURL:
          'https://i1217.photobucket.com/albums/dd388/jnelson9r/J%20Nelson%20Real%20Estate/JNELSONREALESTATE2.jpg',
    ),
    PhotoItem(
      imageURL:
          'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedFCAwayFlamesWallpaperbySunnyboiiii.jpg',
      thumbnailURL:
          'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedFCAwayFlamesWallpaperbySunnyboiiii.jpg',
    ),
    PhotoItem(
      imageURL:
          'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg',
      thumbnailURL:
          'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg',
    ),
    PhotoItem(
      imageURL:
          'https://i49.photobucket.com/albums/f260/starfoxfan/fursona.jpg',
      thumbnailURL:
          'https://i49.photobucket.com/albums/f260/starfoxfan/fursona.jpg',
    ),
  ];

  final ffItemList = [
    FollowerFollowingItem(
      value: "0",
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      supportImageURL:
          "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
      fullName: "Trần Kiến Quốc",
      cityName: "Ho Chi Minh",
    ),
    FollowerFollowingItem(
      value: "1",
      avatarImageURL:
          "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
      supportImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      fullName: "Võ Thị Thanh Ngọc",
      cityName: "Bà Rịa - Vũng Tàu",
    ),
    FollowerFollowingItem(
      value: "2",
      avatarImageURL:
          "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
      supportImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      fullName: "Trần Minh Kha",
      cityName: "Mã Pí Lèng",
    ),
    FollowerFollowingItem(
      value: "3",
      avatarImageURL:
          "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
      supportImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      fullName: "Quách Ngọc Trang",
      cityName: "Ha Noi",
    ),
    FollowerFollowingItem(
      value: "4",
      avatarImageURL:
          "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
      supportImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      fullName: "Trần Hải Âu Dương",
      cityName: "Thừa Thiên Huế",
    ),
    FollowerFollowingItem(
      value: "5",
      avatarImageURL:
          "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
      supportImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      fullName: "Lê Trương Phú Đạt",
      cityName: "Phía Bắc Việt Nam",
    ),
    FollowerFollowingItem(
      value: "6",
      avatarImageURL:
          "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
      supportImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      fullName: "Tôn Công Nữ Chính",
      cityName: "Đảo Cà Mau Việt Nam",
    ),
  ];

  final eventList = [
    EventItem(
      value: "0",
      name: "UpRace - Move Viet Nam",
      athleteQuantity: 44284,
      isFinished: true,
      bannerImageURL:
          "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
    ),
    EventItem(
      value: "1",
      name: "VietNam Mountain Marathon 2019",
      athleteQuantity: 1231231,
      isFinished: true,
      bannerImageURL:
          "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
    ),
    EventItem(
      value: "2",
      name: "Let's Run Everybody",
      athleteQuantity: 89105,
      isFinished: false,
      bannerImageURL:
          "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
    ),
    EventItem(
      value: "3",
      name: "Chạy Vì Cộng Đồng Trẻ Mồ Côi",
      athleteQuantity: 48105,
      isFinished: false,
      bannerImageURL:
          "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
    ),
    EventItem(
      value: "4",
      name: "US-Run-Event-2020",
      athleteQuantity: 5156,
      isFinished: true,
      bannerImageURL:
          "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
    ),
  ];

  final teamList = [
    TeamItem(
      value: "0",
      name: "Trường Đại học Khoa học Tự nhiên 123 123 123",
      athleteQuantity: 44284,
      avatarImageURL:
          "https://i.pinimg.com/originals/3f/e8/f3/3fe8f39d6470b4f5e6b95b63b41b032f.png",
      supportImageURL:
          "https://i1091.photobucket.com/albums/i395/ugg-boot/kid%20ugg%20boot/ugg-5991-kids-sand-boots_05.jpg",
    ),
    TeamItem(
      value: "1",
      name: "Cửa hàng Ecoshop",
      athleteQuantity: 195724,
      avatarImageURL: R.images.avatarHuyTA,
      supportImageURL: R.images.avatar,
    ),
    TeamItem(
      value: "2",
      name: "Techcombank",
      athleteQuantity: 2000000,
      avatarImageURL: R.images.avatarNgocVTT,
      supportImageURL: R.images.avatar,
    ),
    TeamItem(
      value: "3",
      name: "Run Club Marvel Forever Be Young, Yay! 1 2 3 4 5",
      athleteQuantity: 516,
      avatarImageURL: R.images.avatarKhaTM,
      supportImageURL: R.images.avatar,
    ),
    TeamItem(
      value: "4",
      name: "Lý Luận Chạy",
      athleteQuantity: 5276,
      avatarImageURL: R.images.avatarPhucTT,
      supportImageURL: R.images.avatar,
    ),
  ];

  final teamPlanList = [
    TeamPlanItem(
      value: "0",
      dateTime: DateFormat("dd/MM/yyyy hh:mm").parse("10/01/2020 18:30"),
      isFinished: true,
      mapImageURL:
          "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
      planName: "Time to train, get high friends, oh yay go go go 123 123!",
      teamName: "Trường Đại học Khoa học Tự nhiên",
    ),
    TeamPlanItem(
      value: "1",
      dateTime: DateFormat("dd/MM/yyyy hh:mm").parse("05/3/2020 5:30"),
      isFinished: true,
      mapImageURL:
          "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
      planName: "Move Your Body Move Your Body Move Your Body Move Your Body",
      teamName: "Ngân hàng Techcombank",
    ),
    TeamPlanItem(
      value: "2",
      dateTime: DateFormat("dd/MM/yyyy hh:mm").parse("28/02/2020 6:30"),
      isFinished: false,
      mapImageURL:
          "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
      planName: "Everyone is so boring :D",
      teamName: "Cửa hàng EcoShop",
    ),
    TeamPlanItem(
      value: "3",
      dateTime: DateFormat("dd/MM/yyyy hh:mm").parse("31/05/2020 15:50"),
      isFinished: false,
      mapImageURL:
          "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
      planName: "Let's race, Let's run, Let's move",
      teamName: "RUN-CLUB-ENERY",
    ),
    TeamPlanItem(
      value: "4",
      dateTime: DateFormat("dd/MM/yyyy hh:mm").parse("02/09/2020 00:00"),
      isFinished: true,
      mapImageURL:
          "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
      planName: "Lễ Quốc Khánh, sợ gì, chạy ngay đi ^^",
      teamName: "Câu lạc bộ Chạy bộ miền Nam Việt Nam",
    ),
  ];

  final activityTimelineList = [
    {
      "activityID": "0",
      "dateTime": "March 04, 2020",
      "title": "Morning run",
      "calories": "472",
      "distance": 35.15,
      "elevation": "192m",
      "pace": "8:04/km",
      "time": "3:32:57",
      "isLoved": true,
      "loveNumber": 1902,
    },
    {
      "activityID": "1",
      "dateTime": "January 05, 2020",
      "title": "Evening run",
      "calories": "281",
      "distance": 14.32,
      "elevation": "25m",
      "pace": "6:45/km",
      "time": "1:58:41",
      "isLoved": false,
      "loveNumber": 281,
    },
    {
      "activityID": "2",
      "dateTime": "September 05, 2019",
      "title": "Afternoon run",
      "calories": "355",
      "distance": 10.5,
      "elevation": "142m",
      "pace": "7:39/km",
      "time": "58:41",
      "isLoved": false,
      "loveNumber": 10488,
    },
    {
      "activityID": "3",
      "dateTime": "October 20, 2019",
      "title": "Afternoon run",
      "calories": "759",
      "distance": 21.3,
      "elevation": "182m",
      "pace": "6:32/km",
      "time": "24:43:52",
      "isLoved": true,
      "loveNumber": 123,
    },
    {
      "activityID": "4",
      "dateTime": "October 18, 2019",
      "title": "Morning run",
      "calories": "1192",
      "distance": 42.2,
      "elevation": "468m",
      "pace": "8:42/km",
      "time": "1:02:43:52",
      "isLoved": false,
      "loveNumber": 351,
    },
  ];

  final statsListStyle01 = [
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

  final statsListStyle02 = [
    {
      "id": "0",
      "title": "Activities",
      "data": "2",
      "unit": "",
      "iconURL": R.myIcons.activitiesStatsIcon,
      "enableCircleStyle": true,
    },
    {
      "id": "1",
      "title": "Total Time",
      "data": "271",
      "unit": "min",
      "iconURL": R.myIcons.timeStatsIcon,
    },
    {
      "id": "2",
      "title": "AVG Time",
      "data": "148",
      "unit": "min",
      "iconURL": R.myIcons.timeStatsIcon,
    },
    {
      "id": "3",
      "title": "AVG Heart",
      "data": "132",
      "unit": "bpm",
      "iconURL": R.myIcons.heartBeatStatsIcon,
      "enableImageStyle": true,
      "imageURL": R.images.staticStatsChart02,
    },
    {
      "id": "4",
      "title": "Total Steps",
      "data": "6582",
      "unit": "",
      "iconURL": R.myIcons.footStepStatsIcon,
      "enableCircleStyle": true,
    },
    {
      "id": "5",
      "title": "Total Distance",
      "data": "37.49",
      "unit": "km",
      "iconURL": R.myIcons.roadStatsIcon,
    },
    {
      "id": "6",
      "title": "AVG Pace",
      "data": "10:28",
      "unit": "/km",
      "iconURL": R.myIcons.paceStatsIcon,
      "enableImageStyle": true,
      "imageURL": R.images.staticStatsChart01,
    },
    {
      "id": "7",
      "title": "Total Cal",
      "data": "628",
      "unit": "kcal",
      "iconURL": R.myIcons.caloriesStatsIcon,
      "enableCircleStyle": true,
    },
    {
      "id": "8",
      "title": "AVG Elev",
      "data": "126",
      "unit": "meters",
      "iconURL": R.myIcons.elevationStatsIcon,
      "enableImageStyle": true,
      "imageURL": R.images.staticStatsChart03,
    },
    {
      "id": "9",
      "title": "Max Elev",
      "data": "204",
      "unit": "meters",
      "iconURL": R.myIcons.elevationStatsIcon,
    },
  ];

  final statsListStyle03 = [
    {
      "id": "0",
      "subTitle": "Activities",
      "dataTitle": "104",
      "unitTitle": "",
    },
    {
      "id": "1",
      "subTitle": "Total Dist",
      "dataTitle": "1251.78",
      "unitTitle": "km",
    },
    {
      "id": "2",
      "subTitle": "Total Steps",
      "dataTitle": "31257462",
      "unitTitle": "",
    },
    {
      "id": "3",
      "subTitle": "Total Time",
      "dataTitle": "18502",
      "unitTitle": "min",
    },
    {
      "id": "4",
      "subTitle": "AVG Time",
      "dataTitle": "142",
      "unitTitle": "min",
    },
    {
      "id": "5",
      "subTitle": "AVG Pace",
      "dataTitle": "10:51",
      "unitTitle": "/km",
    },
    {
      "id": "6",
      "subTitle": "AVG Heart",
      "dataTitle": "138",
      "unitTitle": "bpm",
    },
    {
      "id": "7",
      "subTitle": "Total Cal",
      "dataTitle": "15818",
      "unitTitle": "kcal",
    },
    {
      "id": "8",
      "subTitle": "AVG Elev",
      "dataTitle": "382",
      "unitTitle": "m",
    },
    {
      "id": "9",
      "subTitle": "Max Elev",
      "dataTitle": "224",
      "unitTitle": "m",
    },
  ];

  final bannerList = [
    'https://m.media-amazon.com/images/M/MV5BOTk5ODg0OTU5M15BMl5BanBnXkFtZTgwMDQ3MDY3NjM@._V1_QL50_SY1000_CR0,0,674,1000_AL_.jpg',
    'https://i1088.photobucket.com/albums/i324/chishono/Short%20North%20Chiropractic/shortnorthchiropractic8.jpg',
    'https://i1088.photobucket.com/albums/i324/chishono/Short%20North%20Chiropractic/shortnorthchiropractic10.jpg',
    'https://i1217.photobucket.com/albums/dd388/jnelson9r/J%20Nelson%20Real%20Estate/JNELSONREALESTATE2.jpg',
    'https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg',
  ];

  final popupMenuList01 = [
    PopupItem(
      iconURL: R.myIcons.blackAttachmentIcon02,
      iconSize: R.appRatio.appIconSize15,
      title: "Pin (Unpin) post",
    ),
    PopupItem(
      iconURL: R.myIcons.blackNewsFeedIcon,
      iconSize: R.appRatio.appIconSize18,
      title: "Report post",
    ),
    PopupItem(
      iconURL: R.myIcons.blackPostIcon,
      iconSize: R.appRatio.appIconSize18,
      title: "Turn off comment",
    ),
    PopupItem(
      iconURL: R.myIcons.blackEditIcon,
      iconSize: R.appRatio.appIconSize15,
      title: "Edit post",
    ),
    PopupItem(
      iconURL: R.myIcons.blackBlockIcon,
      iconSize: R.appRatio.appIconSize18,
      title: "Hide post",
    ),
    PopupItem(
      iconURL: R.myIcons.blackCloseIcon,
      iconSize: R.appRatio.appIconSize15,
      title: "Delete post",
    ),
  ];

  final popupMenuList02 = [
    PopupItem(
      iconURL: R.myIcons.blackAddIcon02,
      iconSize: R.appRatio.appIconSize15 + 1,
      title: "Invite new member",
    ),
    PopupItem(
      iconURL: R.myIcons.blackCloseIcon,
      iconSize: R.appRatio.appIconSize15,
      title: "Kick a member",
    ),
    PopupItem(
      iconURL: R.myIcons.blackBlockIcon,
      iconSize: R.appRatio.appIconSize15,
      title: "Block a person",
    ),
  ];

  final suggestedTeamList = [
    TeamSearchItem(
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      supportImageURL:
          "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
      teamName: "Trường Đại học Khoa học Tự nhiên TP. HCM",
      athleteQuantity: 67842,
      location: "Ho Chi Minh City, Viet Nam",
    ),
    TeamSearchItem(
      avatarImageURL:
          "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
      supportImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      teamName: "Trường Đại học Bách Khoa Hà Nội",
      athleteQuantity: 58192,
      location: "Ha Noi City, Viet Nam",
    ),
    TeamSearchItem(
      avatarImageURL:
          "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
      supportImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      teamName: "Viện John Von Neumann Institute",
      athleteQuantity: 18592,
      location: "Ho Chi Minh City, Viet Nam",
    ),
    TeamSearchItem(
      avatarImageURL:
          "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
      supportImageURL:
          "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
      teamName: "Trường Đại học Khoa học Tự nhiên Thành phố Đà Nẵng",
      athleteQuantity: 67842,
      location: "Đa Nang City, Viet Nam",
    ),
    TeamSearchItem(
      avatarImageURL:
          "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
      supportImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      teamName: "Câu lạc bộ chạy bộ đông đảo quốc gia Việt Nam",
      athleteQuantity: 1829572,
      location: "Viet Nam",
    ),
    TeamSearchItem(
      avatarImageURL:
          "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
      supportImageURL:
          "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
      teamName: "Học Viện Bưu Chính Viễn Thông Việt Nam",
      athleteQuantity: 9938,
      location: "Viet Nam",
    ),
    TeamSearchItem(
      avatarImageURL:
          "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
      supportImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      teamName: "Công ty Trách nhiệm Hữu hạn Minh Âu",
      athleteQuantity: 671982,
      location: "Hai Phong City, Viet Nam",
    ),
    TeamSearchItem(
      avatarImageURL:
          'https://fsa.zobj.net/crop.php?r=Jpxw0sc1BcrDUUhFmPojrSJwGldpurelLtyUo5aZfSedCBxQxUUSMl91wbzycYOPAancYe8Y1eViVrNu4Eqj-3IhWGNot1_J8OKDVoYBdbx7B4RAfYwVnAtw8yF-di-mAgGvseJ1A_d_M3LL',
      supportImageURL:
          'https://fsa.zobj.net/crop.php?r=Jpxw0sc1BcrDUUhFmPojrSJwGldpurelLtyUo5aZfSedCBxQxUUSMl91wbzycYOPAancYe8Y1eViVrNu4Eqj-3IhWGNot1_J8OKDVoYBdbx7B4RAfYwVnAtw8yF-di-mAgGvseJ1A_d_M3LL',
      teamName: "Run Club Quận 7",
      athleteQuantity: 6571,
      location: "Ho Chi Minh City, Viet Nam",
    ),
    TeamSearchItem(
      avatarImageURL:
          "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
      supportImageURL:
          'https://i.pinimg.com/originals/3f/e8/f3/3fe8f39d6470b4f5e6b95b63b41b032f.png',
      teamName: "DECKIA RUNNING SPORT CLUB",
      athleteQuantity: 18592,
      location: "Ho Chi Minh City, Viet Nam",
    ),
  ];

  final teamRankLead = [
    TeamRankItem(
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      name: "Quốc Trần Kiến Quốc Trần Kiến Quốc Trần Kiến Quốc Trần Kiến",
      distance: 421,
    ),
    TeamRankItem(
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      name: "Võ Thị Thanh Ngọc",
      distance: 358,
    ),
    TeamRankItem(
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      name: "Trần Trọng Phúc",
      distance: 285,
    ),
    TeamRankItem(
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      name: "Trần Minh Kha",
      distance: 246,
    ),
    TeamRankItem(
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      name: "Nguyễn Anh Huy",
      distance: 218,
    ),
    TeamRankItem(
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      name: "Ngô Hải Âu",
      distance: 195,
    ),
    TeamRankItem(
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      name: "Đặng Huyền Mỹ",
      distance: 175,
    ),
    TeamRankItem(
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      name: "Quách Ngọc Trang",
      distance: 125,
    ),
    TeamRankItem(
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      name: "Trân Quách Gia",
      distance: 119,
    ),
    TeamRankItem(
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      name: "Võ Minh Tú",
      distance: 98,
    ),
    TeamRankItem(
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      name: "Thiên Địa Tú Linh",
      distance: 63,
    ),
    TeamRankItem(
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      name: "La Thành Ái",
      distance: 38,
    ),
    TeamRankItem(
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      name: "Tô Thành Nghĩa",
      distance: 28,
    ),
    TeamRankItem(
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      name: "Trần Quang Hưng",
      distance: 24,
    ),
    TeamRankItem(
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      name: "Lý Diệp Gia",
      distance: 18,
    ),
  ];

  final allTeamMember = [
    TeamMemberItem(
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      supportImageURL:
          'https://i.pinimg.com/originals/3f/e8/f3/3fe8f39d6470b4f5e6b95b63b41b032f.png',
      name: "Quốc Trần Kiến",
      location: "Ho Chi Minh City, Viet Nam",
      isFollowing: true,
    ),
    TeamMemberItem(
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      supportImageURL:
          'https://i.pinimg.com/originals/3f/e8/f3/3fe8f39d6470b4f5e6b95b63b41b032f.png',
      name: "Võ Thị Thanh Ngọc",
      location: "Ho Chi Minh City, Viet Nam",
      isFollowing: true,
    ),
    TeamMemberItem(
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      supportImageURL:
          'https://i.pinimg.com/originals/3f/e8/f3/3fe8f39d6470b4f5e6b95b63b41b032f.png',
      name: "Trần Trọng Phúc",
      location: "Ho Chi Minh City, Viet Nam",
      isFollowing: false,
    ),
    TeamMemberItem(
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      supportImageURL:
          'https://i.pinimg.com/originals/3f/e8/f3/3fe8f39d6470b4f5e6b95b63b41b032f.png',
      name: "Trần Minh Kha",
      location: "Ho Chi Minh City, Viet Nam",
      isFollowing: false,
    ),
    TeamMemberItem(
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      supportImageURL:
          'https://i.pinimg.com/originals/3f/e8/f3/3fe8f39d6470b4f5e6b95b63b41b032f.png',
      name: "Nguyễn Anh Huy",
      location: "Ho Chi Minh City, Viet Nam",
      isFollowing: false,
    ),
    TeamMemberItem(
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      supportImageURL:
          'https://i.pinimg.com/originals/3f/e8/f3/3fe8f39d6470b4f5e6b95b63b41b032f.png',
      name: "Ngô Hải Âu",
      location: "Ho Chi Minh City, Viet Nam",
      isFollowing: true,
    ),
    TeamMemberItem(
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      supportImageURL:
          'https://i.pinimg.com/originals/3f/e8/f3/3fe8f39d6470b4f5e6b95b63b41b032f.png',
      name: "Đặng Huyền Mỹ",
      location: "Ho Chi Minh City, Viet Nam",
      isFollowing: false,
    ),
    TeamMemberItem(
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      supportImageURL:
          'https://i.pinimg.com/originals/3f/e8/f3/3fe8f39d6470b4f5e6b95b63b41b032f.png',
      name: "Quách Ngọc Trang",
      location: "Ho Chi Minh City, Viet Nam",
      isFollowing: false,
    ),
    TeamMemberItem(
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      supportImageURL:
          'https://i.pinimg.com/originals/3f/e8/f3/3fe8f39d6470b4f5e6b95b63b41b032f.png',
      name: "Trân Quách Gia",
      location: "Ho Chi Minh City, Viet Nam",
      isFollowing: false,
    ),
    TeamMemberItem(
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      supportImageURL:
          'https://i.pinimg.com/originals/3f/e8/f3/3fe8f39d6470b4f5e6b95b63b41b032f.png',
      name: "Võ Minh Tú",
      location: "Ho Chi Minh City, Viet Nam",
      isFollowing: false,
    ),
  ];

  final requestingTeamMember = [
    TeamMemberItem(
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      supportImageURL:
          'https://i.pinimg.com/originals/3f/e8/f3/3fe8f39d6470b4f5e6b95b63b41b032f.png',
      name: "Thiên Địa Tú Linh",
      location: "Ho Chi Minh City, Viet Nam",
    ),
    TeamMemberItem(
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      supportImageURL:
          'https://i.pinimg.com/originals/3f/e8/f3/3fe8f39d6470b4f5e6b95b63b41b032f.png',
      name: "La Thành Ái",
      location: "Ho Chi Minh City, Viet Nam",
    ),
    TeamMemberItem(
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      supportImageURL:
          'https://i.pinimg.com/originals/3f/e8/f3/3fe8f39d6470b4f5e6b95b63b41b032f.png',
      name: "Tô Thành Nghĩa",
      location: "Ho Chi Minh City, Viet Nam",
    ),
    TeamMemberItem(
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      supportImageURL:
          'https://i.pinimg.com/originals/3f/e8/f3/3fe8f39d6470b4f5e6b95b63b41b032f.png',
      name: "Trần Quang Hưng",
      location: "Ho Chi Minh City, Viet Nam",
    ),
    TeamMemberItem(
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      supportImageURL:
          'https://i.pinimg.com/originals/3f/e8/f3/3fe8f39d6470b4f5e6b95b63b41b032f.png',
      name: "Lý Diệp Gia",
      location: "Ho Chi Minh City, Viet Nam",
    ),
    TeamMemberItem(
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      supportImageURL:
          'https://i.pinimg.com/originals/3f/e8/f3/3fe8f39d6470b4f5e6b95b63b41b032f.png',
      name: "Thiên Địa Tú Linh",
      location: "Ho Chi Minh City, Viet Nam",
    ),
    TeamMemberItem(
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      supportImageURL:
          'https://i.pinimg.com/originals/3f/e8/f3/3fe8f39d6470b4f5e6b95b63b41b032f.png',
      name: "La Thành Ái",
      location: "Ho Chi Minh City, Viet Nam",
    ),
    TeamMemberItem(
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      supportImageURL:
          'https://i.pinimg.com/originals/3f/e8/f3/3fe8f39d6470b4f5e6b95b63b41b032f.png',
      name: "Lý Diệp Gia",
      location: "Ho Chi Minh City, Viet Nam",
    ),
    TeamMemberItem(
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      supportImageURL:
          'https://i.pinimg.com/originals/3f/e8/f3/3fe8f39d6470b4f5e6b95b63b41b032f.png',
      name: "Thiên Địa Tú Linh",
      location: "Ho Chi Minh City, Viet Nam",
    ),
    TeamMemberItem(
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      supportImageURL:
          'https://i.pinimg.com/originals/3f/e8/f3/3fe8f39d6470b4f5e6b95b63b41b032f.png',
      name: "La Thành Ái",
      location: "Ho Chi Minh City, Viet Nam",
    ),
  ];

  final blockingTeamMember = [
    TeamMemberItem(
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      supportImageURL:
          'https://i.pinimg.com/originals/3f/e8/f3/3fe8f39d6470b4f5e6b95b63b41b032f.png',
      name: "Thiên Địa Tú Linh",
      location: "Ho Chi Minh City, Viet Nam",
    ),
    TeamMemberItem(
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      supportImageURL:
          'https://i.pinimg.com/originals/3f/e8/f3/3fe8f39d6470b4f5e6b95b63b41b032f.png',
      name: "La Thành Ái",
      location: "Ho Chi Minh City, Viet Nam",
    ),
    TeamMemberItem(
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      supportImageURL:
          'https://i.pinimg.com/originals/3f/e8/f3/3fe8f39d6470b4f5e6b95b63b41b032f.png',
      name: "Tô Thành Nghĩa",
      location: "Ho Chi Minh City, Viet Nam",
    ),
    TeamMemberItem(
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      supportImageURL:
          'https://i.pinimg.com/originals/3f/e8/f3/3fe8f39d6470b4f5e6b95b63b41b032f.png',
      name: "Trần Quang Hưng",
      location: "Ho Chi Minh City, Viet Nam",
    ),
    TeamMemberItem(
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      supportImageURL:
          'https://i.pinimg.com/originals/3f/e8/f3/3fe8f39d6470b4f5e6b95b63b41b032f.png',
      name: "Lý Diệp Gia",
      location: "Ho Chi Minh City, Viet Nam",
    ),
    TeamMemberItem(
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      supportImageURL:
          'https://i.pinimg.com/originals/3f/e8/f3/3fe8f39d6470b4f5e6b95b63b41b032f.png',
      name: "Thiên Địa Tú Linh",
      location: "Ho Chi Minh City, Viet Nam",
    ),
    TeamMemberItem(
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      supportImageURL:
          'https://i.pinimg.com/originals/3f/e8/f3/3fe8f39d6470b4f5e6b95b63b41b032f.png',
      name: "La Thành Ái",
      location: "Ho Chi Minh City, Viet Nam",
    ),
    TeamMemberItem(
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      supportImageURL:
          'https://i.pinimg.com/originals/3f/e8/f3/3fe8f39d6470b4f5e6b95b63b41b032f.png',
      name: "Lý Diệp Gia",
      location: "Ho Chi Minh City, Viet Nam",
    ),
    TeamMemberItem(
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      supportImageURL:
          'https://i.pinimg.com/originals/3f/e8/f3/3fe8f39d6470b4f5e6b95b63b41b032f.png',
      name: "Thiên Địa Tú Linh",
      location: "Ho Chi Minh City, Viet Nam",
    ),
    TeamMemberItem(
      avatarImageURL:
          "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      supportImageURL:
          'https://i.pinimg.com/originals/3f/e8/f3/3fe8f39d6470b4f5e6b95b63b41b032f.png',
      name: "La Thành Ái",
      location: "Ho Chi Minh City, Viet Nam",
    ),
  ];
}
