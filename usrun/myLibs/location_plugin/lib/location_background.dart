import 'dart:async';

import 'package:flutter/services.dart';

class LocationBackground {
  static const MethodChannel _channelusrun = const MethodChannel('usrun/location');

  Future<bool> startBackgroundLocation() =>
      _channelusrun.invokeMethod('startBackgroundLocation').then((result) => result == 1);

  Future<bool> stopBackgroundLocation() =>
      _channelusrun.invokeMethod('stopBackgroundLocation').then((result) => result == 1);

  Future<bool> isStartLocationBackground() =>
      _channelusrun.invokeMethod('isStartLocationBackground').then((result) => result == 1);
}