import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:usrun/model/mapper_object.dart';
import 'package:usrun/model/user.dart';

import 'package:usrun/core/define.dart';

import 'package:sprintf/sprintf.dart';

class DataManager {
  static SharedPreferences _prefs;

  static Future initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static void removeAllData() {
    _prefs.clear();
  }

  static User loadUser() {
    String content = _prefs.getString(_PROFILE);

    User info;

    if (content != null) {
      info = MapperObject.create<User>(content);
    }
    return info;
  }

  static void saveUser(User info) {
    String obj = info.toJson();
    _prefs.setString(_PROFILE, obj);
  }

  static void removeUser() {
    _prefs.remove(_PROFILE);
  }

  static String getDeviceToken() {
    return _prefs.getString(_DEVICE_TOKEN);
  }

  static void setDeviceToken(String token) {
    print(token);
    _prefs.setString(_DEVICE_TOKEN, token);
  }

  static int getLastLoginUserId() {
    return _prefs.getInt(_LAST_LOGIN_USER_ID);
  }

  static void setLastLoginUserId(int userId) {
    _prefs.setInt(_LAST_LOGIN_USER_ID, userId);
  }

  static String loadLanguage() {
    String content = _prefs.getString(_LANGUAGE);
    return content;
  }

  static void saveLanguage(String lang) {
    _prefs.setString(_LANGUAGE, lang);
  }

  static bool loadSelectLanguageFirstTime() {
    return _prefs.getBool(_SELECT_LANGUAGE_FIRST_TIME);
  }

  static void saveSelectLanguageFirstTime(bool isFirstTime) {
    _prefs.setBool(_SELECT_LANGUAGE_FIRST_TIME, isFirstTime);
  }

  static LoginChannel getLoginChannel() {
    return LoginChannel.values[_prefs.getInt(_LOGIN_CHANNEL)];
  }

  static void setHEVCountDownTime(int timeValue) {
    if (timeValue == null) timeValue = 0;
    _prefs.setInt(_HCMUS_EMAIL_VERIFICATION_COUNT_DOWN_TIME, timeValue);
  }

  static int getHEVCountDownTime() {
    return _prefs.getInt(_HCMUS_EMAIL_VERIFICATION_COUNT_DOWN_TIME);
  }

  static int loadAppTheme() {
    return _prefs.getInt(_APP_THEME) ?? 0;
  }

  static void saveAppTheme(AppTheme appTheme) {
    _prefs.setInt(_APP_THEME, appTheme.index);
  }

  static void setLoginChannel(int channel) {
    _prefs.setInt(_LOGIN_CHANNEL, channel);
  }

  static void removeLoginChannel() {
    _prefs.remove(_LOGIN_CHANNEL);
  }

  static int getFeedSelectedTeamId() {
    return _prefs.getInt(_FEED_SELECTED_TEAM_ID);
  }

  static void setFeedSelectedTeamId(int teamId) {
    _prefs.setInt(_FEED_SELECTED_TEAM_ID, teamId);
  }

  static int getFeedSelectedEventId() {
    return _prefs.getInt(_EVENT_SELECTED_TEAM_ID);
  }

  static void setFeedSelectedEventId(int teamId) {
    _prefs.setInt(_EVENT_SELECTED_TEAM_ID, teamId);
  }

  static void setMap(String key, Map data) {
    String val = json.encode(data);
    _prefs.setString(key, val);
  }

  static Future<void> setMapSync(String key, Map data) async {
    String val = json.encode(data);
    await _prefs.setString(key, val);
  }

  static Map getMap(String key) {
    String val = _prefs.getString(key);
    if (val != null) {
      return json.decode(val);
    }
    return null;
  }

  static void setVersion(String version) {
    _prefs.setString(_LAST_VERSION, version);
  }

  static String getVersion() {
    return _prefs.getString(_LAST_VERSION) ?? "";
  }

  static void setCurrentActivity(int activity) {
    _prefs.setInt(_CURRENT_ACTIVITY_ID, activity);
  }

  static int getCurrentActivity() {
    return _prefs.getInt(_CURRENT_ACTIVITY_ID);
  }

  static void clearActivity() {
    _prefs.remove(_CURRENT_ACTIVITY_ID);
  }

  static void setLatestNotificationId(int noId) {
    _prefs.setInt(_LATEST_NOTIFICATION_ID, noId);
  }

  static int getLatestNotificationId() {
    return _prefs.getInt(_LATEST_NOTIFICATION_ID);
  }

  static void removeLatestNotificationId() {
    _prefs.remove(_LATEST_NOTIFICATION_ID);
  }

  static bool getAskEventJoin() {
    int time = _prefs.getInt(_EVENT_SHOW_EVENT_JOIN_NOTIFY);
    if (time == null) {
      return true;
    }

    DateTime date = new DateTime.fromMillisecondsSinceEpoch(time);
    DateTime now = DateTime.now();

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return false;
    }

    return true;
  }

  static void setAskEventJoin() {
    _prefs.setInt(
        _EVENT_SHOW_EVENT_JOIN_NOTIFY, DateTime.now().millisecondsSinceEpoch);
  }

  static void clearAskEventJoin() {
    _prefs.remove(_EVENT_SHOW_EVENT_JOIN_NOTIFY);
  }

  static String loadVersion() {
    String content = _prefs.getString(_VERSION);
    return content;
  }

  static void saveVersion(String index) {
    _prefs.setString(_VERSION, index);
  }

  static String loadDeviceName() {
    String content = _prefs.getString(_DEVICE_NAME);
    return content;
  }

  static void saveDeviceName(String index) {
    _prefs.setString(_DEVICE_NAME, index);
  }

  static String loadOsVersion() {
    String content = _prefs.getString(_OS_VERSION);
    return content;
  }

  static void saveOsVersion(String index) {
    _prefs.setString(_OS_VERSION, index);
  }

  static void setUserConnectNoticeList(List<String> list) {
    _prefs.setStringList(_USER_CONNECT_NOTICE_LIST, list);
  }

  static List<String> getUserConnectNoticeList() {
    return _prefs.getStringList(_USER_CONNECT_NOTICE_LIST);
  }

  static void setUserConnectCheckTime(int time) {
    _prefs.setInt(_USER_CONNECT_CHECK_TIME, time);
  }

  static int getUserConnectCheckTime() {
    return _prefs.getInt(_USER_CONNECT_CHECK_TIME);
  }

  static void setUserConnectCheckCount(LoginChannel channel, int count) {
    _prefs.setInt(
        sprintf(_USER_CONNECT_CHECK_COUNT,
            [channel.toString().replaceAll('LoginChannel.', '').toUpperCase()]),
        count);
  }

  static int getUserConnectCheckCount(LoginChannel channel) {
    return _prefs.getInt(sprintf(_USER_CONNECT_CHECK_COUNT,
        [channel.toString().replaceAll('LoginChannel.', '').toUpperCase()]));
  }

  static void setRefreshActivityTime(int time) {
    _prefs.setInt(_REFRESH_ACTIVITY_CHECK_TIME, time);
  }

  static int getRefreshActivityTime() {
    return _prefs.getInt(_REFRESH_ACTIVITY_CHECK_TIME);
  }

  static void setAppNotificationCount(String key, int count) {
    _prefs.setInt(key, count);
  }

  static int getAppNotificationCount(String key) {
    return _prefs.getInt(key);
  }

  static Future<void> saveActivityFromSync(
      String filename, int activityId, int startDate) async {
    Map data = DataManager.getMap(_SYNC_IDS);
    if (data == null) {
      data = Map<String, Map<String, dynamic>>();
    }
    Map<String, dynamic> params = {
      "activityId": activityId,
      "startDate": startDate
    };
    data[filename] = params;
    await DataManager.setMapSync(_SYNC_IDS, data);
    //print("uprace_app saveActivityFromSync $data");
  }

  static Map<String, dynamic> loadActivityFromSync(String filename) {
    Map data = DataManager.getMap(_SYNC_IDS);
    //print("uprace_app loadActivityFromSync $data");
    if (data == null) {
      //print("uprace_app loadActivityFromSync map is null");
      return null;
    }
    if (data.containsKey(filename)) {
      return data[filename];
    }
    //print("uprace_app loadActivityFromSync not contain ${filename}");
    return null;
  }

  static bool removeActivityFromSync(String filename) {
    Map data = DataManager.getMap(_SYNC_IDS);
    if (data == null) {
      return false;
    }
    if (data.containsKey(filename)) {
      data.remove(filename);
      return true;
    }
    return false;
  }

  static void setUserDefaultTab(int newDefault) {
    _prefs.setInt(_USER_DEFAULT_TAB, newDefault);
  }

  static int getUserDefaultTab() {
    return _prefs.getInt(_USER_DEFAULT_TAB) ?? 0;
  }

  static void setUserRunningUnit(RunningUnit newRunningUnit) {
    _prefs.setInt(_USER_RUNNING_UNIT, newRunningUnit.index);
  }

  static RunningUnit getUserRunningUnit() {
    return RunningUnit.values[(_prefs.getInt(_USER_RUNNING_UNIT) ?? 0)];
  }
}

const String _SYNC_IDS = "SYNC_IDS";
const String _PROFILE = "PROFILE";
const String _DEVICE_TOKEN = "USRUN_DEVICE_TOKEN";
const String _LAST_LOGIN_USER_ID = "LAST_LOGIN_USER_ID";
const String _LANGUAGE = "LANGUAGE";
const String _SELECT_LANGUAGE_FIRST_TIME = "SELECT_LANGUAGE_FIRST_TIME";
const String _HCMUS_EMAIL_VERIFICATION_COUNT_DOWN_TIME = "HEV_COUNT_DOWN_TIME";
const String _APP_THEME = "APP_THEME";
const String _VERSION = "VERSION";
const String _DEVICE_NAME = "DEVICE_NAME";
const String _OS_VERSION = "OS_VERSION";
const String _LOGIN_CHANNEL = "LOGIN_CHANNEL";

const String _FEED_SELECTED_TEAM_ID = "FEED_SELECTED_TEAM_ID";
const String _EVENT_SELECTED_TEAM_ID = "EVENT_SELECTED_TEAM_ID";

const String _LAST_VERSION = "latest_version";

const String _CURRENT_ACTIVITY_ID = "current_activity_id";

const String _LATEST_NOTIFICATION_ID = "LATEST_NOTIFICATION_ID";

const String _EVENT_SHOW_EVENT_JOIN_NOTIFY = "EVENT_SHOW_EVENT_JOIN_NOTIFY";

const String _USER_CONNECT_NOTICE_LIST = "USER_CONNECT_NOTICE_LIST";
const String _USER_CONNECT_CHECK_TIME = "USER_CONNECT_CHECK_TIME";
const String _USER_CONNECT_CHECK_COUNT = "%s_CONNECT_CHECK_COUNT";
const String _REFRESH_ACTIVITY_CHECK_TIME = "REFRESH_ACTIVITY_CHECK_TIME";

const String _USER_DEFAULT_TAB = "USER_DEFAULT_TAB";
const String _USER_RUNNING_UNIT = "_USER_RUNNING_UNIT";
