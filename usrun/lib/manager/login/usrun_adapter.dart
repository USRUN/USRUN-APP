import 'package:usrun/manager/login/login_adapter.dart';

import 'package:usrun/core/define.dart';

class UsRunLoginAdapter extends LoginAdapter {
  Future<Map<String, dynamic>> login(Map params) async {
    return _generateLoginParams(params['email'], params['displayName'], params['password']);
  }

  logout() async {
//    currentUser = null;
//    strava.deAuthorize();
  }

  Map<String, String> _generateLoginParams(String email, String displayName, String password) {
    Map<String, String> res = {
      "type": LoginChannel.UsRun.index.toString(),
      "email": email,
      "name": displayName,
      "password": password
    };

    //saveOpenData(LoginChannel.UsRun, res);

    return res;
  }
}