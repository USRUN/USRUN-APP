import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/core/define.dart';
import 'package:usrun/manager/user_manager.dart';
import 'package:usrun/model/mapper_object.dart';
import 'package:usrun/model/response.dart';
import 'package:usrun/util/json_paser.dart';
import 'package:usrun/util/validator.dart';

class Client {
  static String _domain = 'http://128.199.168.137:8080';

  static Future<Response> post<T, E>(
      String endpoint, Map<String, dynamic> params) async {
    try {
      HttpClient client = new HttpClient();
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);

      String url = _domain + endpoint;

      HttpClientRequest request = await client.postUrl(Uri.parse(url));
      request.headers.set('Content-Type', 'application/json');

      if (UserManager.currentUser.accessToken != null &&
          UserManager.currentUser.accessToken != "") {
        request.headers.set(
            'Authorization', 'Bearer ${UserManager.currentUser.accessToken}');
      }

      if (params != null) {
        request.add(utf8.encode(json.encode(params)));
      } else {
        request.add(utf8.encode(""));
      }

      HttpClientResponse response =
          await request.close().timeout(Duration(seconds: 30));

      bool result = _handleServerError(response);
      if (!result) {
        return Response<T>(
          success: false,
          errorCode: -1,
          errorMessage: R.strings.errorOccurred,
          object: null,
        );
      }

      String reply = await response.transform(utf8.decoder).join();
      return _handleResponse<T, E>(response, reply);
    } on TimeoutException catch (_) {
      return Response<T>(
        success: false,
        errorMessage: R.strings.requestTimeOut,
        object: null,
      );
    } on SocketException catch (e) {
      if (e.osError.errorCode == 60) {
        return Response<T>(
          success: false,
          errorMessage: R.strings.requestTimeOut,
          object: null,
        );
      }
      return Response<T>(
        success: false,
        errorMessage: R.strings.errorNetworkUnstable,
        object: null,
      );
    }
  }

  static Future<Response> get<T, E>(
      String endpoint, Map<String, String> queries) async {
    String url = _domain + endpoint;
    String query = "";
    if (queries != null && queries.length > 0) {
      queries.forEach((key, value) {
        if (value is List) {
          List<String> l = value as List<String>;
          query = query + "&" + key + "=" + l.join(',');
        } else {
          query = query + "&" + key + "=" + value;
        }
      });
    }

    if (query != "") {
      query = query.substring(1);
      url = url + '?' + query;
    }

    try {
      HttpClient client = new HttpClient();
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);

      HttpClientRequest request = await client.getUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.headers.set('accept', 'application/json');
      request.headers.set('Accept-Encoding', 'gzip');

      HttpClientResponse response =
          await request.close().timeout(Duration(seconds: 30));

      bool result = _handleServerError(response);
      if (!result) {
        return Response<T>(
          success: false,
          errorCode: -1,
          errorMessage: R.strings.errorOccurred,
          object: null,
        );
      }

      String reply = await response.transform(utf8.decoder).join();
      return _handleResponse<T, E>(response, reply);
    } on TimeoutException catch (_) {
      return Response<T>(
        success: false,
        errorMessage: R.strings.requestTimeOut,
        object: null,
      );
    } on SocketException catch (e) {
      if (e.osError.errorCode == 60) {
        return Response<T>(
          success: false,
          errorMessage: R.strings.requestTimeOut,
          object: null,
        );
      }
      return Response<T>(
        success: false,
        errorMessage: R.strings.errorNetworkUnstable,
        object: null,
      );
    } on HttpException catch (_) {
      return Response<T>(
        success: false,
        errorMessage: R.strings.errorOccurred,
        object: null,
      );
    }
  }

  static dynamic _parse<E>(dynamic obj) {
    String className = E.toString();
    // If E is reflection class => parse with MapperObject
    if (objectParser.isMapperObject(className)) {
      return MapperObject.create<E>(obj);
    } else {
      return obj;
    }
  }

  static Future<Response> _handleResponse<T, E>(
      HttpClientResponse response, String reply) async {
    if (checkStringNullOrEmpty(reply)) {
      Response<T> result = Response<T>();
      result.success = false;
      result.object = null;
      result.errorCode = -1;
      result.errorMessage = R.strings.errorOccurred;
      return result;
    }

    Map<String, dynamic> body = json.decode(reply);
    Response<T> result = Response<T>();

    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        int code = body['code'];
        if (code == 0) {
          result.success = true;

          // "data" can be a List (Array [...]) or Map (JSON {...}) type.
          dynamic data = body['data'];
          if (data != null) {
            if (data is List) {
              List<E> list = [];
              data.forEach((obj) {
                list.add(_parse<E>(obj));
              });
              result.object = list as T;
            } else {
              result.object = _parse<E>(data);
            }
          }
        } else {
          result.success = false;
          result.object = null;
          result.errorCode = code;
          result.errorMessage = R.strings.errorMessages["$code"];

          switch (code) {
            case ACCESS_DENY:
            case MAINTENANCE:
            case FORCE_UPDATE:
              restartApp(code);
              break;
            default:
              break;
          }
        }
      } catch (ex) {
        print('[CLIENT NETWORK] Client throw exception: $ex');
        result.success = false;
        result.object = null;
        result.errorCode = -1;
        result.errorMessage = R.strings.errorNetworkUnstable;
      }
    } else {
      result.success = false;
      result.object = null;
      result.errorCode = -1;
      result.errorMessage = R.strings.errorOccurred;
    }

    return result;
  }

  static bool _handleServerError(HttpClientResponse response) {
    if (response.statusCode >= 500 && response.statusCode < 600) {
      restartApp(MAINTENANCE);
      print("Server is under maintenance");
      return false;
    }

    return true;
  }
}
