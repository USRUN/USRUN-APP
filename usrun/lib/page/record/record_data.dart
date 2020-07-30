
import 'dart:io';

import 'package:location/location.dart';
import 'package:usrun/core/crypto.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/core/net/client.dart';
import 'package:usrun/manager/user_manager.dart';
import 'package:usrun/model/mapper_object.dart';
import 'package:usrun/model/response.dart';
import 'package:usrun/model/track.dart';
import 'package:usrun/model/user.dart';
import 'package:usrun/util/date_time_utils.dart';
import 'package:usrun/util/reflector.dart';

class RunningRoute{
  
  List<LocationData> locations;

  RunningRoute(){
    this.locations = [];
  }
}

class TrackRequest{
  int trackId;
  String sig;
  String createTime;
  List<RunningRoute> routes;

  TrackRequest(){
    this.trackId = 0;
    this.sig = "";
    this.createTime = localToUtc(DateTime.now()).millisecondsSinceEpoch.toString();
    this.routes = [];
  }
}

class RecordData {

  int eventId;
  int trackId;
  int totalTime;
  int totalMovingTime;
  Map<String, double> splitData;
  int createTime;
  int totalDistance;
  int totalStep;
  double avgPace;
  double latestPace;
  double acceleration;
  int avgHeart;
  int maxHeart;
  int calories;
  int elevGain;
  int elevMax;
  int endTime;
  File map;
  TrackRequest trackRequest;

  RecordData(){
    this.eventId = null;
    this.trackId = 0;
    this.totalTime = 0;
    this.totalMovingTime = 0;
    this.splitData = Map<String, double>();
    this.createTime = localToUtc( DateTime.now()).millisecondsSinceEpoch;
    this.totalDistance = 0;
    this.totalStep = -1;
    this.avgPace = -1;
    this.latestPace = 0;
    this.acceleration = 0;
    this.avgHeart = -1;
    this.maxHeart = 0;
    this.calories = -1;
    this.elevGain = 0;
    this.elevMax = 0;
    this.endTime = 0;
    this.trackRequest = new TrackRequest();
  }

  void beginNewRoute(){
    trackRequest.routes.add(RunningRoute());
  }


  void addLocation(LocationData data, int duration)
  {
    totalMovingTime+=duration;
    trackRequest.routes.last.locations.add(data);
    if (totalDistance==0||totalTime==0)
      return;
    avgPace = 1000*(totalTime)/totalDistance;
    print(avgPace);
    updateSplit();
  }


  void updateSplit() {
    var km = (this.totalDistance / 1000).ceil();
    var pace = this.avgPace;
    this.splitData[km.toString()] = pace;
  }



  LocationData get lastLocation => this.trackRequest.routes.last.locations.last;

   static Future<Response<Track>> requestTrackID() async {
    Map<String, dynamic> params = {
      'userID' : UserManager.currentUser.userId
    }; 

    Response<Map<String, dynamic>> response = await Client.post<Map<String, dynamic>, Map<String, dynamic>>('/track/create',params);

    Response<Track> result = Response();

    if (response.success) {
      result.success = true;
      result.object = MapperObject.create<Track>(response.object);
      print(result.object);
      
    } else {
      result.success = false;
      result.errorCode = response.errorCode;

    }
    return result;
  }

  createTrack() async{
    Response<Track> response = await requestTrackID();
    if (response.success)
    {
      this.trackId = response.object.trackId;
      this.trackRequest.trackId = response.object.trackId;
      this.trackRequest.createTime = response.object.time.toString();
      this.trackRequest.sig = UsrunCrypto.buildTrackSig(trackId, createTime);
      print(this.trackRequest.trackId.toString());
    }
    else
    {
      print("Create track error");
    }
  }


  _saveRecord()
  {

  }


}