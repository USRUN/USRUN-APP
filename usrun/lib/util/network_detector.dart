import 'dart:io';

import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/widget/custom_dialog/custom_alert_dialog.dart';

class NetworkDetector {
  static Future<bool> isNetworkConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // Connected
        print('[NETWORK] Connected');
        return true;
      }
    } on SocketException catch (_) {
      // Disconnected
      print('[NETWORK] Disconnected');
    }
    return false;
  }

  static Future<void> loopUntilHasNetwork() async {
    bool netStatus = false;

    await Future.doWhile(() async {
      await Future.delayed(
        Duration(milliseconds: 4000),
        () async {
          bool status = await NetworkDetector.isNetworkConnected();
          if (status) netStatus = true;
        },
      );

      // True: Continue doWhile
      // False: Stop doWhile
      return !netStatus;
    });
  }

  static Future<void> alertUntilHasNetwork(BuildContext context) async {
    bool netStatus = false;

    await Future.doWhile(() async {
      await Future.delayed(
        Duration(milliseconds: 2000),
        () async {
          bool status = await NetworkDetector.isNetworkConnected();

          if (status)
            netStatus = true;
          else {
            await showCustomAlertDialog(
              context,
              title: R.strings.caution,
              content: R.strings.errorNoInternetAccess,
              firstButtonText: R.strings.ok,
              firstButtonFunction: () => {if (context != null) pop(context)},
            );
          }
        },
      );

      // True: Continue doWhile
      // False: Stop doWhile
      return !netStatus;
    });
  }

  static Future<bool> checkNetworkAndAlert(BuildContext context) async {
    bool connection = await NetworkDetector.isNetworkConnected();
    if (!connection) {
      await showCustomAlertDialog(
        context,
        title: R.strings.caution,
        content: R.strings.errorNoInternetAccess,
        firstButtonText: R.strings.ok,
        firstButtonFunction: () {
          if (context != null) pop(context);
        },
      );
    }
    return connection;
  }
}
