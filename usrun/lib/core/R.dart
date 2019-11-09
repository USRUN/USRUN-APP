import 'package:flutter/material.dart';
import 'package:usrun/util/reflector.dart';
import 'package:usrun/model/mapper_object.dart';

class R {
  static final _Color colors = _Color();
  static Strings strings = Strings();
  static final _Images images = _Images();
  static final Styles styles = Styles();

  static void initLocalized(String jsonContent){
    R.strings = MapperObject.create<Strings>(jsonContent);
  }
}

class _Color{
  final Color blue = Color(0xFF03318C);

  final Gradient uiGradient = LinearGradient(
    colors: [

      Color(0xFFFC8800), Color(0xFFF26B30),Color(0xFFEE4C3E), Color(0xFFDA2A16)
    ],
    stops: [0.0, 0.25, 0.5, 1.0]
  );

  final Color red = Color(0xFFDA2A16);
  final Color pinkRed = Color(0xFFEE4C3E);
  final Color majorOrange = Color(0xFFF26B30);
  final Color yellow = Color(0xFFFC8800);
  final Color labelText = Color(0xFFFD632C);
}

class _Images{
  final String logoUsRun = 'assets/images/logo_text.png';

  final String welcomeBanner = 'assets/images/welcome.png';

  final String loginFacebook = 'assets/images/login_fb.png';
  final String loginGoogle = 'assets/images/login_gg.png';
  final String loginEmail = 'assets/images/login_email.png';
  final String orLine = 'assets/images/or_line.png';

  final String drawer_bg = 'assets/images/drawer_background.png';
  final String drawer_bg_darker = 'assets/images/drawer_background_darker.jpg';

  final String avatar = 'assets/images/avatar.png';
  final String icImageDefault = 'assets/images/ic_image_default.png';

  final String icRecord = 'assets/images/ic_record.png';
  final String icEvent = 'assets/images/ic_event.png';
  final String icUfeed = 'assets/images/ic_ufeed.png';
  final String icProfile = 'assets/images/ic_profile.jpg';
  final String icTeam = 'assets/images/ic_team.png';
  final String icSettings = 'assets/images/ic_settings.png';

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

  String profile;
  String record;
  String uFeed;
  String events;
  String teams;
  String settings;
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
  final TextStyle labelStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: R.colors.labelText);
}