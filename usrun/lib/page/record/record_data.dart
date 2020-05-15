
import 'dart:io';

import 'package:location/location.dart';

class RunningRoute{
  
  List<LocationData> locations;

  RunningRoute(){
    this.locations = [];
  }
}
class TrackRequest{
  int trackID;
  String sig;
  int createTime;
  List<RunningRoute> routes;

  TrackRequest(){
    this.trackID = 0;
    this.sig = "";
    this.createTime = 0;
    this.routes = [];
  }
}

class RecordData {

  int trackID;
  int totalTime;
  int totalMovingTime;
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
    this.trackID = 0;
    this.totalTime = 0;
    this.totalMovingTime = 0;
    this.createTime = 0;
    this.createTime = 0;
    this.totalDistance = 0;
    this.totalStep = -1;
    this.avgPace = 0;
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
    avgPace = totalMovingTime==0?0:totalDistance/totalTime;
    print(avgPace);
  }



  LocationData get lastLocation => this.trackRequest.routes.last.locations.last;

}