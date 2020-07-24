import 'dart:convert';

import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/define.dart';

import 'package:http/http.dart' as http;
import 'login_adapter.dart';

class FacebookLoginAdapter extends LoginAdapter {
  final facebook = FacebookLogin();
  var currentUser;
  String token;

  Future<Map<String, dynamic>> login(Map params) async {
    if (await facebook.isLoggedIn == false) {
      FacebookLoginResult result = await facebook.logIn(['email', 'public_profile', 'user_friends']);

      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          print('Logged in with token: ' + result.accessToken.token);
          token = result.accessToken.token;
          await getPublicProfile(result.accessToken.token);
          return _generateLoginParams();
          break;
        case FacebookLoginStatus.cancelledByUser:
          print('Login cancelled !!!');
          return { 'error': R.strings.errorUserCancelledLogin };
          break;
        case FacebookLoginStatus.error:
          print('Login failed with error: ' + result.errorMessage);
          return { 'error': result.errorMessage };
          break;
        default:
          return null;
          break;
      }
    }
    else {
      print('Already logged in !!!');
      token = (await facebook.currentAccessToken).token;
      await getPublicProfile(token);
      return _generateLoginParams();
    }
  }

  logout() async {
    currentUser = null;
    token = null;
    facebook.logOut();
  }

  getPublicProfile(String token) async {
    http.Response response = await http.get('https://graph.facebook.com/v3.2/me?fields=name,email,picture&access_token=$token');
    currentUser = json.decode(response.body);
  }

  Map<String, String> _generateLoginParams() {
    Map<String, String> res = {
      "type": LoginChannel.Facebook.index.toString(),
      "token": '$token'
    };

    // save open data
    saveOpenData(LoginChannel.Facebook, res);

    return res;
  }
}