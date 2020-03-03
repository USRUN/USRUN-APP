import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:usrun/core/R.dart';

class ProfilePage extends StatelessWidget {
  final _eventItemList = [
    {'eventID': '0', 'badgeImageURL': 'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Western%20Sydney%20Wanderers%20FC/WSWFCFlamesShortQuoteWallpaperbySunnyboiiii.jpg'},
    {'eventID': '1', 'badgeImageURL': 'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Western%20Sydney%20Wanderers%20FC/WSWFCFlamesShortQuoteWallpaperbySunnyboiiii.jpg'},
    {'eventID': '2', 'badgeImageURL': 'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Western%20Sydney%20Wanderers%20FC/WSWFCFlamesShortQuoteWallpaperbySunnyboiiii.jpg'},
    {'eventID': '3', 'badgeImageURL': 'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Western%20Sydney%20Wanderers%20FC/WSWFCFlamesShortQuoteWallpaperbySunnyboiiii.jpg'},
    {'eventID': '4', 'badgeImageURL': 'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Western%20Sydney%20Wanderers%20FC/WSWFCFlamesShortQuoteWallpaperbySunnyboiiii.jpg'},
    {'eventID': '5', 'badgeImageURL': 'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Western%20Sydney%20Wanderers%20FC/WSWFCFlamesShortQuoteWallpaperbySunnyboiiii.jpg'},
    {'eventID': '6', 'badgeImageURL': 'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Western%20Sydney%20Wanderers%20FC/WSWFCFlamesShortQuoteWallpaperbySunnyboiiii.jpg'},
    {'eventID': '7', 'badgeImageURL': 'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Western%20Sydney%20Wanderers%20FC/WSWFCFlamesShortQuoteWallpaperbySunnyboiiii.jpg'},
    {'eventID': '8', 'badgeImageURL': 'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Western%20Sydney%20Wanderers%20FC/WSWFCFlamesShortQuoteWallpaperbySunnyboiiii.jpg'},
    {'eventID': '9', 'badgeImageURL': 'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Western%20Sydney%20Wanderers%20FC/WSWFCFlamesShortQuoteWallpaperbySunnyboiiii.jpg'},
    {'eventID': '10', 'badgeImageURL': 'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Western%20Sydney%20Wanderers%20FC/WSWFCFlamesShortQuoteWallpaperbySunnyboiiii.jpg'}
  ];

  final _photoItemList = [
    {'thumbnailURL': 'https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg', 'imageURL': 'https://i.pinimg.com/originals/3f/e8/f3/3fe8f39d6470b4f5e6b95b63b41b032f.png'},
    {'thumbnailURL': 'https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg', 'imageURL': 'https://fsa.zobj.net/crop.php?r=Jpxw0sc1BcrDUUhFmPojrSJwGldpurelLtyUo5aZfSedCBxQxUUSMl91wbzycYOPAancYe8Y1eViVrNu4Eqj-3IhWGNot1_J8OKDVoYBdbx7B4RAfYwVnAtw8yF-di-mAgGvseJ1A_d_M3LL'},
    {'thumbnailURL': 'https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg', 'imageURL': 'https://m.media-amazon.com/images/M/MV5BOTk5ODg0OTU5M15BMl5BanBnXkFtZTgwMDQ3MDY3NjM@._V1_QL50_SY1000_CR0,0,674,1000_AL_.jpg'},
    {'thumbnailURL': 'https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg', 'imageURL': 'https://i113.photobucket.com/albums/n224/hazels_designs/rahne-1.gif'},
    {'thumbnailURL': 'https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg', 'imageURL': 'https://i1091.photobucket.com/albums/i395/ugg-boot/kid%20ugg%20boot/ugg-5991-kids-sand-boots_05.jpg'},
    {'thumbnailURL': 'https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg', 'imageURL': 'https://i1088.photobucket.com/albums/i324/chishono/Short%20North%20Chiropractic/shortnorthchiropractic8.jpg'},
    {'thumbnailURL': 'https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg', 'imageURL': 'https://i1088.photobucket.com/albums/i324/chishono/Short%20North%20Chiropractic/shortnorthchiropractic10.jpg'},
    {'thumbnailURL': 'https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg', 'imageURL': 'https://i1217.photobucket.com/albums/dd388/jnelson9r/J%20Nelson%20Real%20Estate/JNELSONREALESTATE2.jpg'},
    {'thumbnailURL': 'https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg', 'imageURL': 'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedFCAwayFlamesWallpaperbySunnyboiiii.jpg'},
    {'thumbnailURL': 'https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg', 'imageURL': 'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg'},
    {'thumbnailURL': 'https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg', 'imageURL': 'https://i1111.photobucket.com/albums/h465/johnmorris8755/RVApp%20Studios/catchatoySS.jpg'}
  ];

  final _ffItemList = [
    {
      "userCode": "0",
      "avatarImageURL": "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      "supportImageURL": "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
      "fullName": "Trần Kiến Quốc",
      "cityName": "Ho Chi Minh",
    },
    {
      "userCode": "1",
      "avatarImageURL": "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
      "supportImageURL": "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      "fullName": "Võ Thị Thanh Ngọc",
      "cityName": "Bà Rịa - Vũng Tàu",
    },
    {
      "userCode": "2",
      "avatarImageURL": "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
      "supportImageURL": "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      "fullName": "Trần Minh Kha",
      "cityName": "Mã Pí Lèng",
    },
    {
      "userCode": "3",
      "avatarImageURL": "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
      "supportImageURL": "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      "fullName": "Quách Ngọc Trang",
      "cityName": "Ha Noi",
    },
    {
      "userCode": "4",
      "avatarImageURL": "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
      "supportImageURL": "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      "fullName": "Trần Hải Âu Dương",
      "cityName": "Thừa Thiên Huế",
    },
    {
      "userCode": "5",
      "avatarImageURL": "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
      "supportImageURL": "https://i1121.photobucket.com/albums/l504/enriqueca03/Enrique%20Campos%20Homes/EnriqueCamposHomes1.jpg",
      "fullName": "Lê Trương Phú Đạt",
      "cityName": "Phía Bắc Việt Nam",
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colors.appBackground,
      body: Center(
        child: Container(
          height: 400,
          child: null,
        ),
      ),
    );
  }
}
