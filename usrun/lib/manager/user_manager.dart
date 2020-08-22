import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
import 'package:usrun/model/user_activity.dart';
import 'package:usrun/page/record/helper/record_helper.dart';
import 'package:usrun/util/date_time_utils.dart';

class UserManager {
  // static User currentUser = User(); // NOTE: doesn't set currentUser = new VALUE, just use currentUser.copy(new user) because user is used in all app

  // test tạm thời
  static User currentUser = new User();

  // ----------

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
    Response<Map<String, dynamic>> response =
        await Client.post<Map<String, dynamic>, Map<String, dynamic>>(
            '/user/signup', params);

    Response<User> result = Response();

    if (response.success) {
      result.success = true;
      result.object = MapperObject.create<User>(response.object);

      saveUser(result.object);
      DataManager.setLoginChannel(int.parse(params["type"]));
      //sendDeviceToken();
      DataManager.setLastLoginUserId(result.object.userId);
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
    Response<Map<String, dynamic>> response =
        await Client.post<Map<String, dynamic>, Map<String, dynamic>>(
            '/user/login', params);

    Response<User> result = Response();
    if (response.success) {
      result.success = true;
      result.object = MapperObject.create<User>(response.object);

      saveUser(result.object);
      DataManager.setLoginChannel(int.parse(params["type"]));
      //sendDeviceToken();
      DataManager.setLastLoginUserId(result.object.userId);
    } else {
      result.success = false;
      result.errorCode = response.errorCode;
      result.errorMessage = response.errorMessage;
      await logout();
    }

    return result;
  }

  static Future<Map<String, dynamic>> adapterLogin(
      LoginChannel channel, Map<String, dynamic> params) async {
    LoginAdapter adapter = LoginAdapter.adapterWithChannel(channel);
    Map<String, dynamic> res = await adapter.login(params);
    return res;
  }

  static Future<Response<User>> getUser(int userID) async {
    Map<String, dynamic> params = {};
    params["userId"] = userID;
    Response<Map<String, dynamic>> response = await Client.post<Map<String, dynamic>, Map<String, dynamic>>('/user/login', params);

    Response<User> result = Response();
    if (response.success) {
      result.success = true;
      result.object = MapperObject.create<User>(response.object);

      saveUser(result.object);
      DataManager.setLoginChannel(int.parse(params["type"]));
      //sendDeviceToken();
      DataManager.setLastLoginUserId(result.object.userId);
    } else {
      result.success = false;
      result.errorCode = response.errorCode;
      result.errorMessage = response.errorMessage;
      await logout();
    }

    return result;
  }

  static Future<Response<User>> updateProfileInfo(Map<String, dynamic> params) async {
    params['userId'] = currentUser.userId.toString();
    params['accessToken'] = currentUser.accessToken;

    Response<Map<String, dynamic>> response =
        await Client.post<Map<String, dynamic>, Map<String, dynamic>>(
            '/user/update', params);

    Response<User> result = Response();

    if (response.success) {
      // save data
      result.success = true;
      String accessToken = currentUser.accessToken;
      result.object = MapperObject.create<User>(response.object);
      saveUser(result.object);
      if (accessToken != null) currentUser.accessToken = accessToken;
    } else {
      result.success = false;
      result.errorCode = response.errorCode;
      result.errorMessage = response.errorMessage;
    }
    return result;
  }

//  static void sendDeviceToken() async {
//    if (currentUser.userId == null) {
//      return;
//    }
//
//    String deviceToken = DataManager.getDeviceToken();
//    int lastUserId = DataManager.getLastLoginUserId();
//
//    if (lastUserId == null ||
//        lastUserId != currentUser.userId ||
//        deviceToken != currentUser.deviceToken) {
//      Map<String, String> newData = {
//        'os': getPlatform().toString(),
//        'deviceToken': deviceToken ?? "",
//        'language': DataManager.loadLanguage(),
//      };
//
//      Response response = await updateProfile(newData);
//      if (response.success) {
//        saveUser(response.object);
//      }
//    }
//  }

  static Future<void> logout() async {
    DataManager.clearAskEventJoin();
    await RecordHelper.removeFile();

    if (currentUser != null) {
      // User.type will be removed soon
      // Use login channel in SharedPreferences instead
      for (LoginChannel channel in LoginChannel.values) {
        if (channel == LoginChannel.Strava)
          continue;
        LoginAdapter adapter = LoginAdapter.adapterWithChannel(channel);

        await adapter.logout();
      }

      clear();
    }
  }

  static String emailIsUserMessage(String email) {
    String message = "";
    message = sprintf(R.strings.errorEmailIsUsed, [email]);
    return message;
  }

  static Future<List<dynamic>> getActivityTimelineList(int userID,
      {int limit = 30, int offset = 0}) async {
    Map<String, dynamic> params = Map<String, dynamic>();
    params['userId'] = userID;
    params['limit'] = limit;
    params['offset'] = offset;

    Response<dynamic> response =
        await Client.post('/activity/getActivityByUser', params);

    if (response.object == null || !response.success) {
      return null;
    }

    List<dynamic> result = List();
    List<dynamic> obj = response.object;

    for (var i = 0; i < obj.length; ++i) {
      result.add({
        "activityID": obj[i]['userActivityId'].toString(),
        "dateTime": millisecondToDateString(obj[i]['createTime']),
        "title": obj[i]['title'] ?? "Let's run!",
        "calories": obj[i]['calories'].toString(),
        "distance": double.tryParse(obj[i]['totalDistance'].toString()),
        "elevation": obj[i]['elevGain'].toString() + "m",
        "pace": secondToMinFormat(obj[i]['avgPace'] ~/ 1) + "/km",
        "time": secondToTimeFormat(obj[i]['totalTime']),
        "isLoved": false,
        "loveNumber": obj[i]['totalLove'],
      });
    }

    return result;
  }

  static Future<dynamic> getUserActivityByTimeWithSum(int userID,
      DateTime fromTime, DateTime toTime) async {
    Map<String, dynamic> params = Map<String, dynamic>();
    params['userId'] = userID;
    params['fromTime'] = fromTime.millisecondsSinceEpoch;
    params['toTime'] = toTime.millisecondsSinceEpoch;
    Response<dynamic> response =
        await Client.post('/activity/getStatUser', params);

    if (response.object == null || !response.success) {
      return null;
    }

    return response.object;
  }


  static Future<dynamic> getUserActivity(int userID,
      {int limit = 30, int offset = 0}) async {
    Map<String, dynamic> params = Map<String, dynamic>();
    params['userId'] = userID;
    params['limit'] = limit;
    params['offset'] = offset;

    Response<dynamic> response =
    await Client.post('/activity/getUserFeed', params);

    if (response.object == null || !response.success) {
      return null;
    }

    List<UserActivity> obj = [];
    if (response.object != null)
      obj = (response.object as List)
          .map((item)=> MapperObject.create<UserActivity>(item)).toList();

    return obj;
  }


  static Future<dynamic> changePassword(
      String oldPassword, String newPassword) async {
    Map<String, dynamic> params = {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    };

    Response<dynamic> response =
        await Client.post('/user/changePassword', params);
    return response;
  }

  static Future<dynamic> resetPassword(String email) async {
    Map<String, dynamic> params = {
      'email': email,
    };

    Response<dynamic> response =
        await Client.post('/user/resetPassword', params);
    return response;
  }

  static Future<dynamic> verifyAccount(String OTP) async {
    Map<String, dynamic> params = {
      'otp': OTP,
    };

    Response<dynamic> response =
        await Client.post('/user/verifyStudentHcmus', params);
    return response;
  }

  static Future<dynamic> resendOTP() async {
    Response<dynamic> response = await Client.post('/user/resendOTP', null);
    return response;
  }
}
