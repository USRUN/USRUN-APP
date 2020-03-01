import 'dart:async';

import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sensors/sensors.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/page/record/bloc_provider.dart';
import 'package:usrun/page/record/location_background.dart';
import 'package:usrun/page/record/record_const.dart';
import 'package:usrun/page/record/timer.dart';

class RecordBloc extends BlocBase {
  GoogleMapController mapController;

  MyStreamController<LocationData> _streamLocationController;

  MyStreamController<RecordState> _streamRecordStateController;

  MyStreamController<GPSSignalStatus> _streamGPSSignal;

  Location _locationListener;
  LocationData beginPoint;
  StreamSubscription<LocationData> _locationSubscription;
  LocationBackground _locationBackground;

  TimerService _timeService;


  //test
  List<LatLng> polylineCoordinates = List<LatLng>();
  List<Polyline> lData = List<Polyline>();

  //end test

  RecordBloc() {
    // this._streamSplitStateController = MyStreamController<ReportVisibility>(defaultValue: ReportVisibility.Gone, activeBroadcast: true);
    // this._streamDuration = MyStreamController<int>(defaultValue: 0, activeBroadcast: true);
    this._streamLocationController = MyStreamController<LocationData>(
        defaultValue: null, activeBroadcast: true);
    this._streamRecordStateController = MyStreamController<RecordState>(
        defaultValue: RecordState.StatusNone, activeBroadcast: true);
    // this._streamReportVisibilityController = MyStreamController<ReportVisibility>(defaultValue: ReportVisibility.Visible, activeBroadcast: true);
    this._streamGPSSignal = MyStreamController<GPSSignalStatus>(
        defaultValue: GPSSignalStatus.CHECKING, activeBroadcast: true);
    // this._streamSportType =  MyStreamController<ReportVisibility>(defaultValue: ReportVisibility.Gone, activeBroadcast: true);
    this._locationListener = Location();
     this._locationBackground = LocationBackground();
    // this.recordData = RecordData();
     _initTimeService(0);
     initListeners();
  }

  Stream<LocationData> get streamLocation => _streamLocationController.stream;


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

  void onTotalTimeChange(int duration) async{
    print("tick + " + duration.toString());
    // this.recordData.totalTime = duration;
    // this.recordData.endDate = DateTime.now();
    // this._streamDuration.add(duration);
    // this.onMapUpdate();
    // // update activity every 15 seconds;
    
     if (duration % 5 == 0) {
      //  accelerometerEvents.listen((AccelerometerEvent event) {
      //     if (event.z.abs() >3 && event.x.abs() >3 && event.y.abs() >3)
      //      print(event.toString());
      //   });
       LocationData myLocation = await getCurrentLocation();
       
       geolocator.Position pos = await geolocator.Geolocator().getCurrentPosition(desiredAccuracy: geolocator.LocationAccuracy.bestForNavigation);
       
       print("1 min + lat: " + pos.latitude.toString() + " long: " + pos.longitude.toString() + "acc: " + pos.accuracy.toString() + "speed: "+ pos.speed.toString()) ;
       this._streamLocationController.add(myLocation);
       polylineCoordinates.add(LatLng(pos.latitude,pos.longitude));
       Polyline polyline = Polyline(
         polylineId: PolylineId("poly"),
         color: R.colors.majorOrange,
         width: 5,
         points: polylineCoordinates
      );

       lData.add(polyline);
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
    return await this._locationListener.requestPermission()==PermissionStatus.GRANTED;
  }

  Future<bool> hasApprovedGPSPermission() async {
    return await this._locationListener.hasPermission()==PermissionStatus.GRANTED;
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

  void _updatePositionCamera(LatLng latlng) {
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      bearing: 0.0,
      target: latlng,
      tilt: 0.0,
      zoom: 13//this.recordData.currentZoomValue,
    )));
  }

  void onRecordStageChange(RecordState newState) async{
    if (newState == RecordState.StatusStart) {
      //this._locationBackground.startBackgroundLocation();
      // if (this.recordData.startDate == null) {
      //   this.beginPoint = await this.getCurrentLocation();
      //   this.recordData.latestLocation = this.beginPoint;
      //   this.onMapUpdate(forceUpdate: true);
      //   this.recordData.startDate = DateTime.now();
      // }
      // this.recordData.beginNewLine();
      this._timeService.start();
      // if (this._locationSubscription != null) {
      //   this._locationSubscription.cancel();
      // }

      //this._locationSubscription = this._locationListener.onLocationChanged().listen(this.onLocationChanged);
    }
    if (newState == RecordState.StatusStop) {
      // this.recordData.endDate = DateTime.now();
      // this._timeService.stop();
      // this.recordData.clearLatestTime();
      // this._locationBackground.stopBackgroundLocation();
      // if (this._locationSubscription != null) {
      //   this._locationSubscription.cancel();
      //   this._locationSubscription = null;
      // }
      // this.onUpdateActivity();
      // try {
      //   this.onResumeFromBackground();
      // } catch(error) {
      //   print("uprace_app error $error");
      // }

    }
    if (newState == RecordState.StatusResume) {
      // this.recordData.beginNewLine();
      // this._timeService.start();
    }
    if (newState == RecordState.StatusNone) {
      // this._timeService.reset();
    }
  }


  void initListeners() async{
    // setup rawRecordPath
    // this._locationBackground.setRawRecordPath(await RecordCache.rawRecordPath());

    this._streamRecordStateController.listenValueChange();
    // this._streamReportVisibilityController.listenValueChange();
    // this._streamDuration.listenValueChange();
    this._streamGPSSignal.listenValueChange();
    // this._streamSplitStateController.listenValueChange();
    this.streamRecordState.listen(this.onRecordStageChange);
    // this.streamReportVisibility.listen((data) {
    //   if (data == ReportVisibility.Gone) {
    //     this._streamSplitStateController.add(ReportVisibility.Gone);
    //   }
    //   if (data == ReportVisibility.Visible) {
    //     this._streamSplitStateController.add(ReportVisibility.Gone);
    //   }
    //   onMapUpdate(forceUpdate: true);
    // });
    // this.streamSplit.listen((data) {
    //   onMapUpdate(forceUpdate: true);
    // });
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
}
