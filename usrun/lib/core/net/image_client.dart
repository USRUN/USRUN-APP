import 'dart:convert';

import 'package:http/http.dart';
import 'package:usrun/model/response.dart' as model;

import '../R.dart';

class ImageClient {
  static String domain = 'https://api.imgur.com/3/image';
  static String clientID = 'Client-ID 7ae62eb80e09188';

  static Future<model.Response> uploadImage(String imagePath) async {
    var uri = Uri.parse(domain);
    var request = MultipartRequest('POST', uri)
      ..headers['Authorization'] = clientID
      ..fields['type'] = 'file'
      ..fields['image'] = imagePath;
    var response = await request.send();
    return handleResponse(response);
  }

  static Future<model.Response> handleResponse(
      StreamedResponse response) async {
    String body = await response.stream.bytesToString();
    Map<String, dynamic> reply = json.decode(body);

    if (reply['success'] == true) {
      return new model.Response(
        success: true,
        errorCode: -1,
        errorMessage: null,
        object: reply['data']['link'],
      );
    } else {
      return new model.Response(
        errorMessage: R.strings.errorImgur + 'Log: ${reply['data']['error']}',
        success: false,
        errorCode: -2,
        object: null,
      );
    }
  }
}
