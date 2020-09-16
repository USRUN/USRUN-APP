import 'package:flutter/services.dart';

import 'package:usrun/manager/user_manager.dart';
import 'package:usrun/manager/data_manager.dart';

import 'package:usrun/core/helper.dart';

import 'dart:io' show Platform;

class PushNotificationPlugin {
  static const MethodChannel _channel = const MethodChannel('plugins.flutter.io/push_notification');

  PushNotificationPlugin();

  static void initialize() {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  static void registerForPushNotification() async {
    if (Platform.isIOS) {
      try {
        _channel.invokeMethod('registerForPushNotification');
      }
      on PlatformException catch (e) {
        print("Failed to register for push notification: ${e.details}");
      }
    }
    else {
      if (await DataManager.getDeviceToken() == null) {
        try {
          _channel.invokeMethod('getDeviceToken');
        }
        on PlatformException catch (e) {
          print("Failed to register for push notification: ${e.details}");
        }
      }
    }
  }

  static Future _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case "onDeviceToken":
        String token = call.arguments;
        if (token == null) {
          print("onDeviceToken: Failed to get device token. Reason: Simulator");
        }
        else {
          print("onDeviceToken: ${call.arguments}");
          _updateDeviceToken(call.arguments);
        }
        break;
      case "onPushNotification":
        print("onPushNotification: ${call.arguments}");
        break;
      default:
        throw UnsupportedError("Method ${call.method} not implemented");
    }
  }

  static void _updateDeviceToken(String newDeviceToken) async {
    DataManager.setDeviceToken(newDeviceToken);
    Map<String, dynamic> param = {};
    // Update server data
    if (UserManager.currentUser.userId != null) {
      UserManager.updateProfileInfo(param);
    }
  }

}
