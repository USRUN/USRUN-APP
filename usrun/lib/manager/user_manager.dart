
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/define.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/manager/data_manager.dart';
import 'package:usrun/manager/login/login_adapter.dart';
import 'package:usrun/model/event.dart';
import 'package:usrun/model/mapper_object.dart';
import 'package:usrun/model/response.dart';
import 'package:usrun/model/team.dart';
import 'package:usrun/model/user.dart';
import 'package:usrun/core/net/client.dart';

class UserManager {
  static User currentUser = User(); // NOTE: doesn't set currentUser = new VALUE, just use currentUser.copy(new user) because user is used in all app
  static ValueNotifier<List<Event>> events = ValueNotifier([]);
  static ValueNotifier<List<Team>> teams = ValueNotifier([]);

  static void initialize() {
    User user = DataManager.loadUser();
    currentUser.copy(user);
  }

  static void saveUser(User info) {
    currentUser.copy(info);

    DataManager.saveUser(currentUser);
  }

  static void clear() {
    DataManager.removeUser();
    DataManager.removeLoginChannel();
    DataManager.removeLatestNotificationId();
    currentUser = User(); // don't set currentUser = null when clear
    teams = ValueNotifier([]);
    events = ValueNotifier([]);
  }

  static Future<Response<User>> create(Map<String, dynamic> params) async {
    params['language'] = DataManager.loadLanguage();
    params['os'] = getPlatform().toString();

    // send device token
    String deviceToken = DataManager.getDeviceToken();
    if (deviceToken != null) {
      params['deviceToken'] = deviceToken;
    }
    Response<Map<String, dynamic>> response = await Client.post<Map<String, dynamic>, Map<String, dynamic>>('/user/signup', params);

    Response<User> result = Response();

    if (response.success) {
      result.success = true;
      result.object = MapperObject.create<User>(response.object);

      saveUser(result.object);
      DataManager.setLoginChannel(int.parse(params["type"]));
      sendDeviceToken();
      DataManager.setLastLoginUserId(result.object.userId);

      //appsflyer
      // Map<String, dynamic> afParams = {
      //   "type": int.parse(params["type"]) ?? "",
      //   "userId": result.object.userId ?? "",
      //   "openId": result.object.openId ?? "",
      //   "email": result.object.email ?? "",
      // };
      // AppsflyerTrack.sendEvent("signUp", afParams);
    } else {
      result.success = false;
      result.errorCode = response.errorCode;

      if (response.object != null) {
        // if fail update error message
        result.errorMessage = emailIsUserMessage(params['email']);
      } else {
        result.errorMessage = response.errorMessage;
      }
      await logout();
    }

    return result;
  }

  static Future<Response<User>> signIn(Map<String, dynamic> params) async {
    Response<Map<String, dynamic>> response = await Client.post<Map<String, dynamic>, Map<String, dynamic>>('/user/login', params);

    Response<User> result = Response();
    if (response.success) {
      result.success = true;
      result.object = MapperObject.create<User>(response.object);

      saveUser(result.object);
      DataManager.setLoginChannel(int.parse(params["type"]));
      sendDeviceToken();
      DataManager.setLastLoginUserId(result.object.userId);
    } else {
      result.success = false;
      result.errorCode = response.errorCode;
      await logout();
    }

    return result;
  }


   static Future<Response<User>> check(Map<String, dynamic> params) async {
    Response<Map<String, dynamic>> res = await Client.post<Map<String, dynamic>, Map<String, dynamic>>('/user/check', params);

    if (res.errorCode == USER_EMAIL_IS_USED) {
      res.errorMessage = emailIsUserMessage(params['email']);
    }


    Response<User> response = Response(success: res.success, errorCode: res.errorCode, errorMessage: res.errorMessage);
    if (res.success) {
      response.object = MapperObject.create<User>(res.object);
    }

    return response;
  }
  
  static Future<Map<String, dynamic>> adapterLogin(LoginChannel channel, Map<String, dynamic> params) async {
    LoginAdapter adapter = LoginAdapter.adapterWithChannel(channel);
    Map<String, dynamic> res = await adapter.login(params);
    return res;
  }


  static Future<Response<User>> updateProfile(Map<String, dynamic> params) async {
    params['userId'] = currentUser.userId.toString();
    params['accessToken'] = currentUser.accessToken;

    Response<User> response = await Client.nPost<User, User>('/user/update', params);
    if (response.success) {
      // save data
      UserManager.saveUser(response.object);
    }
    return response;
  }

  static void sendDeviceToken() async {
    if (currentUser.userId == null) {
      return;
    }

    String deviceToken = DataManager.getDeviceToken();
    int lastUserId = DataManager.getLastLoginUserId();

    if (lastUserId == null || lastUserId != currentUser.userId || deviceToken != currentUser.deviceToken) {
      Map<String, String> newData = {
        'os': getPlatform().toString(),
        'deviceToken': deviceToken ?? "",
        'language': DataManager.loadLanguage(),
      };

      Response response = await updateProfile(newData);
      if (response.success) {
        saveUser(response.object);
      }
    }
  }

  static Future<void> logout() async {
    DataManager.clearAskEventJoin();

    Response res = Response();
    //RecordCache.clearCurrentActivity();
    //RecordCache.deleteAllFiles();

    //appsflyer
    // Map<String, dynamic> afParams = {
    //   "type": currentUser.type.toString() ?? "",
    //   "userId": currentUser.userId ?? "",
    //   "openId": currentUser.openId ?? "",
    //   "email": currentUser.email ?? "",
    // };
    // AppsflyerTrack.sendEvent("signOut", afParams);

    if (currentUser != null) {
      // User.type will be removed soon
      // Use login channel in SharedPreferences instead
      for (LoginChannel channel in LoginChannel.values) {
        //LoginAdapter adapter = LoginAdapter.adapterWithChannel(channel);

        //await adapter.logout();
      }

      clear();
    }
    res.success = true;
  }

  static String emailIsUserMessage(String email) {
    String message = "";
    message = sprintf(R.strings.errorEmailIsUsed, [email]);
    return message;
  }

  
}