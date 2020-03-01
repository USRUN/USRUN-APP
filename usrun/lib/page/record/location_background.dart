import 'package:flutter/services.dart';

class LocationBackground {
  static const MethodChannel _channel = const MethodChannel('usrun/location');

  Future<bool> startBackgroundLocation() =>
      _channel.invokeMethod('startBackgroundLocation').then((result) => result == 1);

  Future<bool> stopBackgroundLocation() =>
      _channel.invokeMethod('stopBackgroundLocation').then((result) => result == 1);

  Future<bool> isStartLocationBackground() =>
      _channel.invokeMethod('isStartLocationBackground').then((result) => result == 1);


  Future<bool> setRawRecordPath(String rawPath) =>
      _channel.invokeMethod('setRawRecordPath', {'rawRecordPath': rawPath}).then((result) => result == 1);

  Future<bool> createRawRecord() =>
      _channel.invokeMethod('createRawRecord').then((result) => result == 1);
}