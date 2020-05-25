import 'package:usrun/core/R.dart';
import 'package:usrun/page/record/activity_data.dart';
import 'package:usrun/page/record/record_data.dart';

class RecordHelper{

  static String toJSON(RecordData data){

    List<String> routes = [];
    data.trackRequest.routes.forEach((route) {
      routes.add(route.locations.toString());
    });

    Map track = {
      'trackID': data.trackId,
      'sig': data.trackRequest.sig,
      'createTime': data.trackRequest.createTime,
      'routes': routes
    };


    Map res = {
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

    return res.toString();
  }

  static Map generateParamsForRequest(ActivityData activityData){

    RecordData data = activityData.recordData;
    List<String> routes = [];
      data.trackRequest.routes.forEach((route) {
        routes.add(route.locations.toString());
      });
      
    Map res = {
      "userActivityId": data.trackId,
      "createTime": data.createTime,
      "totalDistance": data.totalDistance,
      "totalTime": data.totalTime,
      "totalStep": data.totalStep,
      "avgPace": data.avgPace,
      "avgHeart": data.avgHeart,
      "maxHeart": data.maxHeart,
      "calories": data.calories,
      "elevGain": data.elevGain,
      "elevMax": data.elevMax,
      "photo": null,
      "title": activityData.title,
      "description": activityData.description,
      "totalLike": activityData.totalLike,
      "totalComment": activityData.totalLike,
      "totalShare": activityData.totalShare,
      "processed": true,
      "deleted": 0,
      "privacy": 0,
      "trackRequest":{
      "trackId": data.trackId,
      "time": data.createTime,
      "sig": data.trackRequest.sig,
      "locations": routes[0]
      },
      "sig": activityData.sig
    };

    return res;

  }

}