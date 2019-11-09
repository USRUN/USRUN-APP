import 'package:flutter/foundation.dart';

import 'package:usrun/core/define.dart';

import 'package:usrun/manager/data_manager.dart';
import 'package:usrun/manager/login/facebook_adapter.dart';
import 'package:usrun/manager/login/google_adapter.dart';
import 'package:usrun/manager/login/strava_adapter.dart';
import 'package:usrun/manager/login/usrun_adapter.dart';

// import 'package:upraceapp/manager/login/strava_adapter.dart';
// import 'package:upraceapp/manager/login/facebook_adapter.dart';
// import 'package:upraceapp/manager/login/google_adapter.dart';
// import 'package:upraceapp/manager/login/uprace_adapter.dart';
// import 'package:upraceapp/manager/login/garmin_adapter.dart';

abstract class LoginAdapter {
  Future<Map<String, dynamic>> login(Map params) {
    throw "${this.runtimeType} need override login(Map param) method";
  }
  Future<void> logout() {
    throw "${this.runtimeType} need override logout() method";
  }

  @protected
  void saveOpenData(LoginChannel type, Map data) {
    DataManager.setMap(type.toString(), data);
  }

  static Map<String, dynamic> getOpenData(LoginChannel type) {
    return DataManager.getMap(type.toString());
  }

  static void logoutChannel(LoginChannel type) {
    LoginAdapter adapter = adapterWithChannel(type);
    adapter.logout();
  }


  static LoginAdapter adapterWithChannel(LoginChannel channel) {
    switch (channel) {
      case LoginChannel.Facebook:
        return FacebookLoginAdapter();
      case LoginChannel.Google:
        return GoogleLoginAdapter();
      case LoginChannel.Strava:
        return StravaLoginAdapter();
      case LoginChannel.UsRun:
       return UsRunLoginAdapter();
    }
    throw "does not support: $channel";
  }
}