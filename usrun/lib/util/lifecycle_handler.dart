import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:usrun/util/network_detector.dart';

class NetworkObserver extends WidgetsBindingObserver {
  final BuildContext context;

  NetworkObserver({@required this.context});

  @override
  Future<Null> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        NetworkDetector.checkNetworkAndAlert(context);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
//        if (onSuspendingCallBack != null) {
//          await onSuspendingCallBack();
//        }
        break;
    }
  }
}