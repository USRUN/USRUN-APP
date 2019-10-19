import 'dart:io';

class NetworkDetector {
  static Future<bool> isNetworkConnected()async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // print('connected');
        return true;
      }
    } on SocketException catch (_) {
      print('network not connected');
    }
    return false;
  }
}