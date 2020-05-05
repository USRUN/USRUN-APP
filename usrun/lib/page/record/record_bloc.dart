import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sensors/sensors.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/page/record/bloc_provider.dart';
import 'package:usrun/page/record/kalman_filter.dart';
import 'package:usrun/page/record/location_background.dart';
import 'package:usrun/page/record/record_const.dart';
import 'package:usrun/page/record/timer.dart';

import 'package:location/location.dart';

import 'dart:ui' as ui;

class RecordBloc extends BlocBase {
  GoogleMapController mapController;

  MyStreamController<LocationData> _streamLocationController;

  MyStreamController<ReportVisibility> _streamSplitStateController;

  MyStreamController<RecordState> _streamRecordStateController;

  MyStreamController<GPSSignalStatus> _streamGPSSignal;
  MyStreamController<ReportVisibility> _streamReportVisibilityController;

  Location _locationListener;
  LocationData beginPoint;
  StreamSubscription<LocationData> _locationSubscription;
  LocationBackground _locationBackground;
  TimerService _timeService;


  //test
  List<LatLng> polylineCoordinates = List<LatLng>();
  List<Polyline> lData = List<Polyline>();
  List<Marker> mData = List<Marker>();
  Uint8List markerIcon;
  //end test

  RecordBloc() {
    this._streamSplitStateController = MyStreamController<ReportVisibility>(defaultValue: ReportVisibility.Gone, activeBroadcast: true);
    // this._streamDuration = MyStreamController<int>(defaultValue: 0, activeBroadcast: true);
    this._streamLocationController = MyStreamController<LocationData>(
        defaultValue: null, activeBroadcast: true);
    this._streamRecordStateController = MyStreamController<RecordState>(
        defaultValue: RecordState.StatusNone, activeBroadcast: true);
    this._streamReportVisibilityController = MyStreamController<ReportVisibility>(defaultValue: ReportVisibility.Visible, activeBroadcast: true);
    this._streamGPSSignal = MyStreamController<GPSSignalStatus>(
        defaultValue: GPSSignalStatus.CHECKING, activeBroadcast: true);
    // this._streamSportType =  MyStreamController<ReportVisibility>(defaultValue: ReportVisibility.Gone, activeBroadcast: true);
    this._locationListener = Location();
     this._locationBackground = LocationBackground();
    // this.recordData = RecordData();
     _initTimeService(0);
     initListeners();
     
    setCustomMapPin();
    
    kalmanFilter = new KalmanLatLong(3);
  }

  Stream<LocationData> get streamLocation => _streamLocationController.stream;


  Stream<ReportVisibility> get streamSplit => _streamSplitStateController.stream;
  ReportVisibility get currentSplitState =>  this._streamSplitStateController.value;
  ReportVisibility get getReportVisibilityValue => this._streamReportVisibilityController.value;
  Stream<ReportVisibility> get streamReportVisibility => _streamReportVisibilityController.stream;

  Stream<RecordState> get streamRecordState =>
      _streamRecordStateController.stream;

  Stream<GPSSignalStatus> get streamGPSStatus => _streamGPSSignal.stream;

  RecordState get currentRecordState =>  this._streamRecordStateController.value;

  GPSSignalStatus get gpsStatus => this._streamGPSSignal.value;



  @override
  void dispose() {
    // TODO: implement dispose
    if (this._locationSubscription != null) {
      this._locationSubscription.cancel();
    }
  }

Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
}

   void setCustomMapPin() async {
     markerIcon = await getBytesFromAsset(R.myIcons.icCurrentSpot, 100);
   }

void drawMaker(LatLng curLocation) {
    // if (this.bloc.currentRecordState != RecordState.StatusStart && this.bloc.currentRecordState != RecordState.StatusStop) {
    //   return markers;
    // }

   
    // LocationData firstPoint = beginPoint;
    // if (firstPoint != null) {
    //   curLocation = LatLng(firstPoint.latitude,firstPoint.longitude);
    //   // if (bloc.recordData.polylineList.isNotEmpty) {
    //   //   Polyline polyline = bloc.recordData.polylineList.first;
    //   //   if (polyline != null && polyline.points.isNotEmpty) {
    //   //     LatLng latLng = polyline.points.first;
    //   //     if (latLng != null) {
    //   //       defaultBegin = latLng;
    //   //     }
    //   //   }
    //   // }
    //   if (curLocation != null) {
    //     markers.addAll([
    //       Marker(
    //           markerId: MarkerId('tracking'),
    //           icon: pinLocationIcon,
    //           position: defaultBegin),
    //     ]);
    //   }
        // }
    mData.removeWhere(
          (m) => m.markerId.value == 'tracking');
    if (curLocation != null) {
        mData.addAll([
          Marker(
              markerId: MarkerId('tracking'),
              icon: BitmapDescriptor.fromBytes(markerIcon),
              position: curLocation,
              flat: true,
              anchor: Offset(0.5,0.5),
              consumeTapEvents: true
              ),      
        ]);
      }
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    double theta = lon1 - lon2;
    double dist = sin(deg2rad(lat1)) 
                    * sin(deg2rad(lat2))
                    + cos(deg2rad(lat1))
                    * cos(deg2rad(lat2))
                    * cos(deg2rad(theta));
    dist = acos(dist);
    dist = rad2deg(dist);
    dist = dist * 60 * 1.1515;
    return (dist*1000);
}

 double deg2rad(double deg) {
    return (deg * pi / 180.0);
}

 double rad2deg(double rad) {
    return (rad * 180.0 / pi);
}
  
  // static double calculateDistance(lat1, lon1, lat2, lon2){
  //   var p = 0.017453292519943295;
  //   var c = cos;
  //   var a = 0.5 - c((lat2 - lat1) * p)/2 +
  //       c(lat1 * p) * c(lat2 * p) *
  //           (1 - c((lon2 - lon1) * p))/2;
  //   return 12742000 * asin(sqrt(a));
  // }
  
  int invalidCount = 0;

    double currentSpeed = 0; 

    KalmanLatLong kalmanFilter;

    LocationData lastLoc;

  void onTotalTimeChange(int duration) async{
    print("tick + " + duration.toString());
    // this.recordData.totalTime = duration;
    // this.recordData.endDate = DateTime.now();
    // this._streamDuration.add(duration);
    // this.onMapUpdate();
    // // update activity every 15 seconds;
    
     if (duration % 1 == 0) {
      //  accelerometerEvents.listen((AccelerometerEvent event) {
      //     if (event.z.abs() >3 && event.x.abs() >3 && event.y.abs() >3)
      //      print(event.toString());
      //   });
       //LocationData myLocation = await getCurrentLocation();

     




     }
//    if (this.recordData.isNotCorrectTotalTime) {
//      _initTimeService(this.recordData.totalTime);
//      this._streamDuration.add(this.recordData.totalTime);
//      this._timeService.start();
//    }
  }

  void _initTimeService(int totalTime) {
    if (_timeService != null) {
      _timeService.close();
    }

    _timeService = TimerService(totalTime, this.onTotalTimeChange);
  }

  Future<bool> isGPSEnable() {
    return this._locationListener.serviceEnabled();
  }

  Future<bool> onGpsStatusChecking() async {
    this._streamGPSSignal.add(GPSSignalStatus.CHECKING);
    bool isServiceAvailable = await this.hasServiceEnabled();
    if (!isServiceAvailable) {
      this._streamGPSSignal.add(GPSSignalStatus.NOT_AVAILABLE);
      return false;
    }
    bool hasPermission = await this.hasApprovedGPSPermission();
    if (!hasPermission) {
      hasPermission = await this.requestGPSPermission();
    }
    if (!hasPermission) {
      this._streamGPSSignal.add(GPSSignalStatus.NOT_AVAILABLE);
      return false;
    }
    this.beginPoint = await this.getCurrentLocation();
    if (beginPoint != null) {
      this._streamLocationController.add(beginPoint);
      this._updatePositionCamera(
          LatLng(beginPoint.latitude, beginPoint.longitude));
      this._streamGPSSignal.add(GPSSignalStatus.READY);
      drawMaker(LatLng(beginPoint.latitude, beginPoint.longitude));
      return true;
    } else {
      this._streamGPSSignal.add(GPSSignalStatus.NOT_AVAILABLE);
      return false;
    }
  }

  onMapCreated(GoogleMapController controller)  {
    this.mapController = controller;
  }

  // onCameraMove(double zoomValue) =>
  //     this.recordData.currentZoomValue = zoomValue;

  Future<LocationData> getCurrentLocation() async {
    LocationData myLocation;
    bool granted = await this.hasApprovedGPSPermission();
    if (granted) {
      myLocation = await this._locationListener.getLocation();
    }
    return myLocation;
  }


  void hideGPSView() {
    this._streamGPSSignal.add(GPSSignalStatus.HIDE);
  }

  Future<bool> requestGPSPermission() async {
    return await this._locationListener.requestPermission()==PermissionStatus.granted;
  }

  Future<bool> hasApprovedGPSPermission() async {
    return await this._locationListener.hasPermission()==PermissionStatus.granted;
  }

  Future<bool> hasServiceEnabled() async {
    return await this._locationListener.serviceEnabled();
  }

  Future<void> showCurrentLocation() async {
    LocationData myLocation = await getCurrentLocation();
    this._updatePositionCamera(
        LatLng(myLocation.latitude, myLocation.longitude));
  }

  void updateRecordStatus(RecordState recordState) {
    this._streamRecordStateController.add(recordState);
  }

  void _updatePositionCamera(LatLng latlng, {double zoom = 15}) {
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      bearing: 0.0,
      target: latlng,
      tilt: 0.0,
      zoom: zoom//this.recordData.currentZoomValue,
    )));
  }

  void onRecordStageChange(RecordState newState) async{
    print("State: " + newState.toString());
    if (newState == RecordState.StatusStart) {
      //this._locationBackground.startBackgroundLocation();
      // if (this.recordData.startDate == null) {
      //   this.beginPoint = await this.getCurrentLocation();
      //   this.recordData.latestLocation = this.beginPoint;
      //   this.onMapUpdate(forceUpdate: true);
      //   this.recordData.startDate = DateTime.now();
      // }
      // this.recordData.beginNewLine();
      lastLoc = await getCurrentLocation();
       polylineCoordinates.add(LatLng(lastLoc.latitude,lastLoc.longitude));
       Polyline polyline = Polyline(
         polylineId: PolylineId("poly"),
         color: R.colors.majorOrange,
         width: 5,
         points: polylineCoordinates
      );

       lData.add(polyline);
      this._timeService.start();

      _updatePositionCamera(LatLng(lastLoc.latitude,lastLoc.longitude),zoom:25 );
      if (this._locationSubscription != null) {
        this._locationSubscription.cancel();
      }

      this._locationSubscription = this._locationListener.onLocationChanged.listen(this.onLocationChanged);
    }
    if (newState == RecordState.StatusStop) {
      // this.recordData.endDate = DateTime.now();
      this._timeService.stop();
      // this.recordData.clearLatestTime();
      // this._locationBackground.stopBackgroundLocation();
      if (this._locationSubscription != null) {
        this._locationSubscription.cancel();
        this._locationSubscription = null;
      }
      // this.onUpdateActivity();
      // try {
      //   this.onResumeFromBackground();
      // } catch(error) {
      //   print("uprace_app error $error");
      // }

    }
    if (newState == RecordState.StatusResume) {
      // this.recordData.beginNewLine();
      this._timeService.start();
    }
    if (newState == RecordState.StatusNone) {
      this._timeService.reset();
    }
  }


  void initListeners() async{
    // setup rawRecordPath
    // this._locationBackground.setRawRecordPath(await RecordCache.rawRecordPath());

    this._streamRecordStateController.listenValueChange();
    this._streamReportVisibilityController.listenValueChange();
    // this._streamDuration.listenValueChange();
    this._streamGPSSignal.listenValueChange();
    this._streamSplitStateController.listenValueChange();
    this.streamRecordState.listen(this.onRecordStageChange);
    this.streamReportVisibility.listen((data) {
      if (data == ReportVisibility.Gone) {
        this._streamSplitStateController.add(ReportVisibility.Gone);
      }
      if (data == ReportVisibility.Visible) {
        this._streamSplitStateController.add(ReportVisibility.Gone);
      }
      //onMapUpdate(forceUpdate: true);
    });
    this.streamSplit.listen((data) {
      //onMapUpdate(forceUpdate: true);
    });
    await this.onGpsStatusChecking();
    // await this.onLoadActivity();
    // await this.onResumeFromBackground();
    // this.lifecycleEventHandler = new LifecycleEventHandler(
    //     resumeCallBack: () {
    //       this.onResumeFromBackground();
    //       return;
    //     },
    //     suspendingCallBack: () {
    //       this.onGoToBackground();
    //       return;
    //     }
    // );
    // WidgetsBinding.instance.addObserver(lifecycleEventHandler);

    // KhaVN print raw gps data
//    List<List<LocationData>> polylines = await RecordCache.loadRawRecord();
//    for (List<LocationData> line in polylines) {
//      for(LocationData p in line) {
//        print("${p.longitude}, ${p.latitude},");
//      }
//    }
  }

   void updateSplitState(ReportVisibility newValue) {
    this._streamSplitStateController.add(newValue);
  }



  var time=DateTime.now().millisecondsSinceEpoch;
  var totalTimeElapsed = 0;

   onLocationChanged(LocationData myLocation) {
    if (this.currentRecordState != RecordState.StatusStart) {
      return;
    }
    var timePassed = (DateTime.now().millisecondsSinceEpoch - time);
    totalTimeElapsed+=timePassed;
    print("Location change in " + timePassed.toString());
    time = DateTime.now().millisecondsSinceEpoch;
    ///GPS CHECKING
       if(myLocation.accuracy <= 0){
            print( "Latitidue and longitude values are invalid.");
            invalidCount++;
            return;
        }


        //setAccuracy(newLocation.getAccuracy());
        double horizontalAccuracy = myLocation.accuracy;
        if(horizontalAccuracy > 25){ //10meter filter
           print("Accuracy is too low. " + horizontalAccuracy.toString());
            invalidCount++;
            return;
        }


        /* Kalman Filter */
        double Qvalue;

       
        int elapsedTimeInMillis = timePassed;

        if(currentSpeed == 0){
            Qvalue = 3; //3 meters per second
        }else{
            Qvalue = currentSpeed; // meters per second
        }

        kalmanFilter.Process(myLocation.latitude, myLocation.longitude, myLocation.accuracy, elapsedTimeInMillis, Qvalue);
        double predictedLat = kalmanFilter.get_lat();
        double predictedLng = kalmanFilter.get_lng();

        
        double predictedDeltaInMeters =  calculateDistance(predictedLat, predictedLng, myLocation.latitude, myLocation.longitude).abs();
        
        print( "Kalman Filter: " + predictedDeltaInMeters.toString());

        if(predictedDeltaInMeters > 6 ){
            print( "Kalman Filter detects mal GPS, we should probably remove this from track: " + predictedDeltaInMeters.toString());
            kalmanFilter.consecutiveRejectCount += 1;

            if(kalmanFilter.consecutiveRejectCount > 3){
                kalmanFilter = new KalmanLatLong(3); //reset Kalman Filter if it rejects more than 3 times in raw.
            }
            invalidCount++;
            return;
        }else{
            kalmanFilter.consecutiveRejectCount = 0;
        }
       
       currentSpeed = myLocation.speed;
       print("Dist: " + calculateDistance(lastLoc.latitude, lastLoc.longitude, myLocation.latitude, myLocation.longitude).abs().toString());
       //min speed 1m/s
       print("total meters have to pass: " + (totalTimeElapsed/1000).toString());
       if (calculateDistance(lastLoc.latitude, lastLoc.longitude, myLocation.latitude, myLocation.longitude).abs()<1*timePassed/1000)
        //||calculateDistance(lastLoc.latitude, lastLoc.longitude, myLocation.latitude, myLocation.longitude).abs()>3)
        {
          print("Distance is less than required (1m/s) after: " + timePassed.toString());
            invalidCount++;
          return;
        }
       lastLoc = myLocation;
      //geolocator.Position pos = await geolocator.Geolocator().getCurrentPosition(desiredAccuracy: geolocator.LocationAccuracy.bestForNavigation);
       
       totalTimeElapsed = 0;
       print("1 min + lat: " + myLocation.latitude.toString() + " long: " + myLocation.longitude.toString() + "acc: " + myLocation.accuracy.toString() + "speed: "+ myLocation.speed.toString()) ;
       polylineCoordinates.add(LatLng(myLocation.latitude,myLocation.longitude));
       Polyline polyline = Polyline(
         polylineId: PolylineId("poly"),
         color: R.colors.majorOrange,
         width: 5,
         points: polylineCoordinates
      );

      invalidCount = 0;
       lData.add(polyline);
       drawMaker(LatLng(myLocation.latitude,myLocation.longitude));
      print("Add Location to stream!");
      this._streamLocationController.add(myLocation);

     
  }
}
