import 'dart:convert';

import 'package:location/location.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/page/record/activity_data.dart';
import 'package:usrun/page/record/helper/record_cache.dart';
import 'package:usrun/page/record/record_data.dart';

class RecordHelper{

  static Map<String,dynamic> toJSON(RecordData data){

    List<List<Map<String,double>>> routes = [];
    data.trackRequest.routes.forEach((route) {
      List<Map<String,double>> loc = [];
      route.locations.forEach((location) {
        Map<String,double> map = {
          'latitude': location.latitude,
          'longitude': location.longitude,
          'accuracy': location.accuracy,
          'altitude': location.altitude,
          'speed': location.speed,
          'speed_accuracy': location.speedAccuracy,
          'heading': location.heading,
          'time': location.time
        };
        loc.add(map);
      });
      routes.add(loc);
    });

    Map<String,dynamic> track = {
      'trackID': data.trackId,
      'sig': data.trackRequest.sig,
      'createTime': data.trackRequest.createTime,
      'routes': routes,
      'splitDistance': json.encode(data.splitData)
    };


    Map<String,dynamic> res = {
      "eventId": data.eventId,
      'trackID': data.trackId,
      'totalTime': data.totalTime,
      'totalMovingTime': data.totalMovingTime,
      'createTime': data.createTime,
      'totalDistance': data.totalDistance,
      'totalStep': data.totalStep,
      'avgPace': data.avgPace,
      'latestPace': data.latestPace,
      'acceleration': data.acceleration,
      'avgHeart': data.avgHeart,
      'maxHeart': data.maxHeart,
      'calories': data.calories,
      'elevGain': data.elevGain,
      'elevMax': data.elevMax,
      'endTime': data.endTime,
      'map': data.map,
      'trackRequest': track
    };

    return res;
  }

  static Map<String,dynamic> generateParamsForRequest(ActivityData activityData, String requestTime){

    RecordData data = activityData.recordData;
    List<List<Map<String,double>>> routes = [];
    data.trackRequest.routes.forEach((route) {
      List<Map<String,double>> loc = [];
      route.locations.forEach((location) {
        Map<String,double> map = {
          'latitude': location.latitude,
          'longitude': location.longitude,
          'accuracy': location.accuracy,
          'altitude': location.altitude,
          'speed': location.speed,
          'speed_accuracy': location.speedAccuracy,
          'heading': location.heading,
          'time': location.time
        };
        loc.add(map);
      });
      routes.add(loc);
    });

    List<String> photos = [];
    activityData.photos.forEach((p) {
      String imageB64 = base64Encode(p.readAsBytesSync());
      photos.add(imageB64);
    });

    Map<String,dynamic> res = {
      "eventId": data.eventId,
      "totalDistance": data.totalDistance,
      "totalTime": data.totalTime,
      "totalStep": data.totalStep,
      "avgPace": data.avgPace,
      "avgHeart": data.avgHeart,
      "maxHeart": data.maxHeart,
      "calories": data.calories,
      "elevGain": data.elevGain,
      "elevMax": data.elevMax,
      "photo": photos,
      "title": activityData.title,
      "description": activityData.description,
      "totalLove": activityData.totalLove,
      "totalComment": activityData.totalComment,
      "totalShare": activityData.totalShare,
      "processed": true,
      "deleted": 0,
      "privacy": 0,
      "trackRequest":{
        "time": data.createTime,
        "locations": routes,
        "splitDistance": data.splitData
      },
      "time": requestTime,
      "sig": activityData.sig
    };

    return res;

  }

  static Future<RecordData> loadFromFile() async {
    RecordCache recordCache = new RecordCache();
    if (!(await recordCache.recordDataFileExists()))
      return null;

    Map<String,dynamic>  content = await recordCache.getRecordData();
    //Map<String,dynamic> data = jsonDecode(content);

    print(content);
    List<RunningRoute> r = [];


    List<dynamic> routes = content['trackRequest']['routes'];



    routes.forEach((route) {
      RunningRoute runningRoute = new RunningRoute();
      route.forEach((location) {
        Map<String,double> locationMap = new Map<String,double>.from(location);
        LocationData loc = LocationData.fromMap(locationMap);
        runningRoute.locations.add(loc);
      });
      r.add(runningRoute);
    });




    TrackRequest trackRequest = new TrackRequest();
    trackRequest.trackId = content['trackRequest']['trackID'];
    trackRequest.sig = content['trackRequest']['sig'];
    trackRequest.createTime = content['trackRequest']['createTime'];
    trackRequest.routes = r;



    RecordData data= new RecordData();

    data.splitData = Map<String, double>.from(json.decode(content['trackRequest']['splitDistance']));
    data.trackId = content['trackId'];
    data.totalTime = content['totalTime'];
    data.totalMovingTime = content['totalMovingTime'];
    data.createTime = content['createTime'];
    data.totalDistance = content['totalDistance'];
    data.totalStep = content['totalStep'];
    data.avgPace = content['avgPace'];
    data.latestPace = content['latestPace'];
    data.acceleration = content['acceleration'];
    data.avgHeart = content['avgHeart'];
    data.maxHeart = content['maxHeart'];
    data.calories = content['calories'];
    data.elevGain = content['elevGain'];
    data.elevMax = content['elevMax'];
    data.endTime = content['endTime'];
    data.map = content['map'];
    data.trackRequest = trackRequest;

    print(data.trackRequest.routes.last.locations.toString());


    return data;
  }

  static Future<void> saveFile(Map<String,dynamic> content) async{

    RecordCache recordCache = new RecordCache();
    await recordCache.writeRecordData(content);

  }

  static Future<void> removeFile() async {
    RecordCache recordCache = new RecordCache();
    if (await recordCache.recordDataFileExists())
      await recordCache.removeRecordDataFile();
  }
}