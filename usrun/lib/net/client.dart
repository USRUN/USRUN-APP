import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/core/define.dart';

import 'package:usrun/model/mapper_object.dart';
import 'package:usrun/model/response.dart';

import 'package:usrun/util/json_paser.dart';
import 'package:usrun/util/network_detector.dart';

//const String API_VERSION = "1.0.2";
//const String API_VERSION = "1.1.2";
const String API_VERSION = "1.1.3";

class Client {
//  static String _domain = 'http://localhost:8000';
//  static String _domain = 'http://uprace.rongcondihoc.com';
//  static String _domain = 'http://uprace_dev.123go.vn';
  static String _domain = 'http://usrun.herokuapp.com';

  static String imageUrl(String endpoint) {
    if (endpoint == null || endpoint.isEmpty) {
      return null;
    }

    if (endpoint.startsWith('http')) {
      return endpoint;
    }

    return _domain + "/cdn" + endpoint;
  }

  static String certificateUrl(int userId, String accessToken, int eventId) {
    return "$_domain/api/$API_VERSION/certificate?userId=$userId&accessToken=$accessToken&eventId=$eventId";
  }

  static Future<Response> nPost<T, E>(String endpoint, Map<String, dynamic> params) async {
    try {
      HttpClient client = new HttpClient();
      client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);

      String url = _domain + "/api/$API_VERSION" + endpoint;

      HttpClientRequest request = await client.postUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.headers.set('accept', 'application/json');
      request.headers.set('Accept-Encoding', 'gzip');

      var requestMultipart = http.MultipartRequest("", Uri.parse("uri"));

      for (var key in params.keys) {
        var val = params[key];
        if (val is File) {
          var multipart = await http.MultipartFile.fromPath(key, val.path);
          requestMultipart.files.add(multipart);
        } else {
          if (val is List) {
            String typeStr = val.runtimeType.toString();
            if (typeStr == 'List<File>') {
              for (File f in val) {
                var multipart = await http.MultipartFile.fromPath("$key[]", f.path);
                requestMultipart.files.add(multipart);
              }
            } else {
              int i = 0;
              for (var s in val) {
                requestMultipart.fields["$key[$i]"] = s.toString();
                i++;
              }
            }
          } else {
            requestMultipart.fields[key] = val.toString();
          }
        }
      }

      var msStream = requestMultipart.finalize();

      int byteCount = 0;
      var totalByteLength = requestMultipart.contentLength;

      request.contentLength = totalByteLength;

      request.headers.set(HttpHeaders.contentTypeHeader, requestMultipart.headers[HttpHeaders.contentTypeHeader]);

      Stream<List<int>> streamUpload = msStream.transform(
        new StreamTransformer.fromHandlers(
          handleData: (data, sink) {
            sink.add(data);

            byteCount += data.length;

//            print("upload $byteCount/$totalByteLength");
          },
          handleError: (error, stack, sink) {
            throw error;
          },
          handleDone: (sink) {
            sink.close();
            // UPLOAD DONE;
          },
        ),
      );

      await request.addStream(streamUpload);

      HttpClientResponse response = await request.close().timeout(Duration(seconds: 30));
      String reply = await response.transform(utf8.decoder).join();

//      print("post url: $url");
//      print(params);
//      print(reply);

      return _handleResponse<T, E>(response, reply);
    }
    on TimeoutException catch (_) {
      return Response<T>(success: false, errorMessage: R.strings.requestTimeOut);
    }
    on SocketException catch (e) {
      if (e.osError.errorCode == 60) {
        return Response<T>(success: false, errorMessage: R.strings.requestTimeOut);
      }
      return Response<T>(success: false, errorMessage: R.strings.errorNetworkUnstable);
    }
  }

  static Future<Response> post<T, E>(String endpoint, params) async {
    try {
      HttpClient client = new HttpClient();
      client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);

      String url = _domain + "/api/$API_VERSION" + endpoint;

      HttpClientRequest request = await client.postUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.headers.set('accept', 'application/json');
      request.headers.set('Accept-Encoding', 'gzip');

      request.add(utf8.encode(json.encode(params)));

      HttpClientResponse response = await request.close().timeout(Duration(seconds: 30));
      String reply = await response.transform(utf8.decoder).join();

//      print("post url: $url");
//      print(params);
//      print(reply);

      return _handleResponse<T, E>(response, reply);
    }
    on TimeoutException catch (_) {
      return Response<T>(success: false, errorMessage: R.strings.requestTimeOut);
    }
    on SocketException catch (e) {
      if (e.osError.errorCode == 60) {
        return Response<T>(success: false, errorMessage: R.strings.requestTimeOut);
      }
      return Response<T>(success: false, errorMessage: R.strings.errorNetworkUnstable);
    }
  }

  static Future<Response> get<T, E>(String endpoint, Map<String, String> params) async {
    String url = _domain + "/api/$API_VERSION" + endpoint;
    String query = "";
    params.forEach((key, value) {
      if (value is List) {
        List<String> l = value as List<String>;
        query = query + "&" + key + "=" + l.join(',');
      } else {
        query = query + "&" + key + "=" + value;
      }
    });

    if (query != "") {
      query = query.substring(1);
      url = url + '?' + query;
    }

    try {
      HttpClient client = new HttpClient();
      client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);

      HttpClientRequest request = await client.getUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.headers.set('accept', 'application/json');
      request.headers.set('Accept-Encoding', 'gzip');

      HttpClientResponse response = await request.close().timeout(Duration(seconds: 30));

      String reply = await response.transform(utf8.decoder).join();

      print("get url: $url");
      print(params);
      print(reply);
      //104385113951232765836 - quangthequyen@gmail.com

      return _handleResponse<T, E>(response, reply);
    }
    on TimeoutException catch (_) {
      return Response<T>(success: false, errorMessage: R.strings.requestTimeOut);
    }
    on SocketException catch (e) {
      if (e.osError.errorCode == 60) {
        return Response<T>(success: false, errorMessage: R.strings.requestTimeOut);
      }
      return Response<T>(success: false, errorMessage: R.strings.errorNetworkUnstable);
    }
  }

  static Future<Response> _handleResponse<T, E>(HttpClientResponse response, String reply) async {
    Response<T> result = Response<T>();

    Map<String, dynamic> body = json.decode(reply);

    if (response.statusCode == 200) {
      try {
        int code = body['code'];
        if (code == 0) {
          result.success = true;

          dynamic data = body['data']; // data just can be List or Map type.
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
          result.errorCode = code;
          result.object = body['data'];
          result.errorMessage = R.strings.errorMessages["$code"];

          switch (code) {
            case ACCESS_DENY:
            case MAINTENANCE:
            case FORCE_UPDATE:
              restartApp(code);
          }
        }
      } catch (ex) {
        print('Client throw exception: $ex');
        if (result == null) {
          result.success = false;
          result.errorCode = -1;
          result.errorMessage = R.strings.errorNetworkUnstable;
        } else {
          result.success = false;
          result.errorCode = -1;
          result.errorMessage = R.strings.errorNetworkUnstable;
        }
      }
    } else {
      result.success = false;
      result.errorCode = -1;
      result.errorMessage = R.strings.errorNetworkUnstable;
    }

    return result;
  }

  static dynamic _parse<E>(dynamic obj) {
    String className = E.toString();
    // if E is reflection class => parse with MapperObject
    if (objectParser.isMapperObject(className)) {
      return MapperObject.create<E>(obj);
    } else {
      return obj;
    }
  }
}
