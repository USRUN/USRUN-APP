import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pedometer/pedometer.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/life_cycle.dart';
import 'package:usrun/page/record/bloc_provider.dart';
import 'package:usrun/page/record/helper/record_helper.dart';
import 'package:usrun/page/record/kalman_filter.dart';
import 'package:usrun/page/record/record_const.dart';
import 'package:usrun/page/record/record_data.dart';
import 'package:usrun/page/record/timer.dart';

import 'package:android_intent/android_intent.dart';
import 'package:location/location.dart';
import 'package:location/location_background.dart';

import 'dart:ui' as ui;

class RecordBloc extends BlocBase {
  RecordData recordData;

  GoogleMapController mapController;

  MyStreamController<LocationData> _streamLocationController;

  MyStreamController<ReportVisibility> _streamSplitStateController;

  MyStreamController<RecordState> _streamRecordStateController;

  MyStreamController<EventVisibility> _streamEventtVisibilityController;
  MyStreamController<RecordData> _streamRecorData;

  MyStreamController<GPSSignalStatus> _streamGPSSignal;
  MyStreamController<ReportVisibility> _streamReportVisibilityController;

  Location _locationListener;
  LocationData beginPoint;
  StreamSubscription<LocationData> _locationSubscription;
  LocationBackground _locationBackground;
  TimerService _timeService;

  Pedometer _pedometer;
  StreamSubscription<int> _subscription;

  LifecycleEventHandler lifecycleEventHandler;

  //test
  List<LatLng> polylineCoordinates = List<LatLng>();
  List<Polyline> lData = List<Polyline>();
  List<Marker> mData = List<Marker>();
  Uint8List markerIcon;

  //end test

  RecordBloc() {
    setCustomMapPin();

    this.recordData = RecordData();
    this._streamSplitStateController = MyStreamController<ReportVisibility>(
        defaultValue: ReportVisibility.Gone, activeBroadcast: true);
    this._streamRecorData = MyStreamController<RecordData>(
        defaultValue: recordData, activeBroadcast: true);
    this._streamLocationController = MyStreamController<LocationData>(
        defaultValue: null, activeBroadcast: true);
    this._streamRecordStateController = MyStreamController<RecordState>(
        defaultValue: RecordState.StatusNone, activeBroadcast: true);
    this._streamReportVisibilityController =
        MyStreamController<ReportVisibility>(
            defaultValue: ReportVisibility.Visible, activeBroadcast: true);
    this._streamEventtVisibilityController =
        MyStreamController<EventVisibility>(
            defaultValue: EventVisibility.Visible, activeBroadcast: true);
    this._streamGPSSignal = MyStreamController<GPSSignalStatus>(
        defaultValue: GPSSignalStatus.CHECKING, activeBroadcast: true);
    // this._streamSportType =  MyStreamController<ReportVisibility>(defaultValue: ReportVisibility.Gone, activeBroadcast: true);
    this._locationListener = Location();

    this._pedometer = Pedometer();
    this._locationBackground = LocationBackground();

    _initTimeService(0);
    initListeners();

    kalmanFilter = new KalmanLatLong(3);
  }

  Stream<LocationData> get streamLocation => _streamLocationController.stream;

  Stream<ReportVisibility> get streamSplit =>
      _streamSplitStateController.stream;

  ReportVisibility get currentSplitState =>
      this._streamSplitStateController.value;

  ReportVisibility get getReportVisibilityValue =>
      this._streamReportVisibilityController.value;

  EventVisibility get getEventVisibilityValue =>
      this._streamEventtVisibilityController.value;

  Stream<ReportVisibility> get streamReportVisibility =>
      _streamReportVisibilityController.stream;

  Stream<EventVisibility> get streamEventVisibility =>
      _streamEventtVisibilityController.stream;

  Stream<RecordState> get streamRecordState =>
      _streamRecordStateController.stream;

  Stream<GPSSignalStatus> get streamGPSStatus => _streamGPSSignal.stream;

  RecordState get currentRecordState => this._streamRecordStateController.value;

  GPSSignalStatus get gpsStatus => this._streamGPSSignal.value;

  Stream<RecordData> get streamRecordData => _streamRecorData.stream;

  @override
  void dispose() {
    // TODO: implement dispose
    if (this._locationSubscription != null) {
      this._locationSubscription.cancel();
    }
    if (_streamReportVisibilityController != null) {
      this._streamReportVisibilityController.close();
    }
    if (_streamEventtVisibilityController != null) {
      this._streamEventtVisibilityController.close();
    }
    if (_streamLocationController != null) {
      this._streamLocationController.close();
    }
    if (_streamRecordStateController != null) {
      this._streamRecordStateController.close();
    }
    if (_timeService != null) {
      this._timeService.close();
    }
  }

  Future<void> initPlatformState() async {
    startListening();
  }

  void startListening() {
    _pedometer = new Pedometer();
    _subscription = _pedometer.pedometerStream.listen(_onData,
        onError: _onError, onDone: _onDone, cancelOnError: true);
  }

  int deviceStep = 0;

  void _onData(int stepCountValue) async {
    if (deviceStep == 0) deviceStep = stepCountValue;
    recordData.totalStep = stepCountValue - deviceStep;
    print("step: " + stepCountValue.toString());
  }

  void _onDone() => print("Finished pedometer tracking");

  void _onError(error) => print("Flutter Pedometer Error: $error");

  void stopListening() {
    _subscription.cancel();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  void setCustomMapPin() async {
    markerIcon = await getBytesFromAsset(R.myIcons.icCurrentSpot, 80);
  }

  void drawLines(List<LocationData> myLocations, String id) {
    List<LatLng> list = [];
    myLocations.forEach((loc) {
      list.add(LatLng(loc.latitude, loc.longitude));
    });
    Polyline polyline = Polyline(
        polylineId: PolylineId(id),
        color: R.colors.majorOrange,
        width: 5,
        points: []);
    lData.add(polyline);
    lData.last.points.addAll(list);
  }

  void drawMaker(LatLng curLocation) {
    mData.removeWhere((m) => m.markerId.value == 'tracking');
    if (curLocation != null) {
      mData.addAll([
        Marker(
            markerId: MarkerId('tracking'),
            icon: BitmapDescriptor.fromBytes(markerIcon),
            position: curLocation,
            flat: true,
            anchor: Offset(0.5, 0.5),
            consumeTapEvents: true),
      ]);
    }
  }

//   double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
//     double theta = lon1 - lon2;
//     double dist = sin(deg2rad(lat1))
//                     * sin(deg2rad(lat2))
//                     + cos(deg2rad(lat1))
//                     * cos(deg2rad(lat2))
//                     * cos(deg2rad(theta));
//     dist = acos(dist);
//     dist = rad2deg(dist);
//     dist = dist * 60 * 1.1515;
//     return (dist*1000);
// }
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    double earthRadius = 6371000; //meters
    double dLat = deg2rad(lat2 - lat1);
    double dLng = deg2rad(lon2 - lon1);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * sin(dLng / 2) * sin(dLng / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double dist = (earthRadius * c);

    return dist;
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

  void onTotalTimeChange(int duration) async {
    print("tick + " + duration.toString());

    this.recordData.totalTime = duration;
    this.recordData.endTime = DateTime.now().millisecondsSinceEpoch;
    this._streamRecorData.add(recordData);
    this.onMapUpdate();
    // // update activity every 15 seconds;
    if (duration % 15 == 0) {
      Map<String, dynamic> content = RecordHelper.toJSON(recordData);
      RecordHelper.saveFile(content);
    }
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

  onMapUpdate({forceUpdate: false}) {
    try {
      LocationData locationData = this.recordData.lastLocation;
      if ((this.recordData.totalTime % MAX_TIME_MAP_UPDATE == 0 &&
              locationData != null) ||
          forceUpdate) {
        this._streamLocationController.add(locationData);
        this._updatePositionCamera(
            LatLng(locationData.latitude, locationData.longitude),
            zoom: 18);
      }
    } catch (error) {
      print('[RecordBloc][onMapUpdate] ${error}');
    }
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

  onMapCreated(GoogleMapController controller) {
    this.mapController = controller;
  }

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
    return await this._locationListener.requestPermission() ==
        PermissionStatus.granted;
  }

  Future<bool> hasApprovedGPSPermission() async {
    return await this._locationListener.hasPermission() ==
        PermissionStatus.granted;
  }

  Future<bool> hasServiceEnabled() async {
    return await this._locationListener.serviceEnabled();
  }

  Future<void> requestService() async {
    final AndroidIntent intent = new AndroidIntent(
      action: 'android.settings.LOCATION_SOURCE_SETTINGS',
    );
    await intent.launch();
  }

  Future<void> showCurrentLocation() async {
    LocationData myLocation = await getCurrentLocation();
    this._updatePositionCamera(
        LatLng(myLocation.latitude, myLocation.longitude));
  }

  void updateRecordStatus(RecordState recordState) {
    this._streamRecordStateController.add(recordState);
  }

  void updateGPSStatus(GPSSignalStatus gpsSignalStatus) {
    this._streamGPSSignal.add(gpsSignalStatus);
  }

  void showTrackingReport() {
    if (this._streamReportVisibilityController.value !=
        ReportVisibility.Visible) {
      this.updateReportVisibility(ReportVisibility.Visible);
    }
  }

  void hideTrackingReport() {
    if (this._streamReportVisibilityController.value != ReportVisibility.Gone) {
      this.updateReportVisibility(ReportVisibility.Gone);
    }
  }

  void updateReportVisibility(ReportVisibility value) {
    this._streamReportVisibilityController.add(value);
  }

  void showEventPicker() {
    if (this._streamEventtVisibilityController.value !=
        EventVisibility.Visible) {
      this.updateEventVisibility(EventVisibility.Visible);
    }
  }

  void hideEventPicker() {
    if (this._streamEventtVisibilityController.value != EventVisibility.Gone) {
      this.updateEventVisibility(EventVisibility.Gone);
    }
  }

  void updateEventVisibility(EventVisibility value) {
    this._streamEventtVisibilityController.add(value);
  }

  void _updatePositionCamera(LatLng latlng, {double zoom = 15}) {
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        bearing: 0.0,
        target: latlng,
        tilt: 0.0,
        zoom: zoom //this.recordData.currentZoomValue,
        )));
  }

  void onRecordStageChange(RecordState newState) async {
    print("State: " + newState.toString());
    if (newState == RecordState.StatusStart) {
      //this.recordData.createTrack();
      // BackgroundLocation.getLocationUpdates((location) {
      //     print("Latitude: ${location.latitude} and Long: ${location.longitude}" );
      //   });

      this._locationBackground.startBackgroundLocation();
      // if (this.recordData.startDate == null) {
      //   this.beginPoint = await this.getCurrentLocation();
      //   this.recordData.latestLocation = this.beginPoint;
      //   this.onMapUpdate(forceUpdate: true);
      //   this.recordData.startDate = DateTime.now();
      // }
      this.updateReportVisibility(ReportVisibility.Visible);
      this.recordData.beginNewRoute();
      lastLoc = await getCurrentLocation();
      drawMaker(LatLng(lastLoc.latitude, lastLoc.longitude));
      recordData.addLocation(lastLoc, 0);
      polylineCoordinates.add(LatLng(lastLoc.latitude, lastLoc.longitude));
      Polyline polyline = Polyline(
          polylineId: PolylineId('${recordData.trackRequest.routes.length}'),
          color: R.colors.majorOrange,
          width: 5,
          points: []);

      lData.add(polyline);
      lData.last.points.add(LatLng(lastLoc.latitude, lastLoc.longitude));
      this._timeService.start();

      _updatePositionCamera(LatLng(lastLoc.latitude, lastLoc.longitude),
          zoom: 18);
      if (this._locationSubscription != null) {
        this._locationSubscription.cancel();
      }

      this._locationSubscription = this
          ._locationListener
          .onLocationChanged
          .listen(this.onLocationChanged);
    }
    if (newState == RecordState.StatusStop) {
      finishedUpdateSplits();
      this.recordData.endTime = DateTime.now().millisecondsSinceEpoch;
      this._timeService.stop();
      this.stopListening();
      Map<String, dynamic> content = RecordHelper.toJSON(recordData);
      RecordHelper.saveFile(content);
      // this.recordData.clearLatestTime();
      this._locationBackground.stopBackgroundLocation();
      if (this._locationSubscription != null) {
        this._locationSubscription.cancel();
        this._locationSubscription = null;
      }

      this.updateReportVisibility(ReportVisibility.Visible);
    }
    if (newState == RecordState.StatusResume) {
      // this.recordData.beginNewLine();
      this._timeService.start();
    }
    if (newState == RecordState.StatusNone) {
      this.updateReportVisibility(ReportVisibility.Gone);
      this._timeService.reset();
    }
  }

  void initListeners() async {
    // setup rawRecordPath
    // this._locationBackground.setRawRecordPath(await RecordCache.rawRecordPath());
    this.initPlatformState();
    this._streamRecordStateController.listenValueChange();
    this._streamReportVisibilityController.listenValueChange();
    this._streamEventtVisibilityController.listenValueChange();
    this._streamRecorData.listenValueChange();
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
    this.lifecycleEventHandler =
        new LifecycleEventHandler(resumeCallBack: () async {
      mapController.setMapStyle("[]");
      if (gpsStatus == GPSSignalStatus.NOT_AVAILABLE) {
        await this.onGpsStatusChecking();
      }
      return;
    }, detachedCallBack: () {
      return;
    });
    WidgetsBinding.instance.addObserver(lifecycleEventHandler);
    this.streamSplit.listen((data) {
      //onMapUpdate(forceUpdate: true);
    });
    await this.onGpsStatusChecking();
    await this.loadLatestRecord();
    //await this.onResumeFromBackground();

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

  var time = DateTime.now().millisecondsSinceEpoch;
  var totalTimeElapsed = 0;

  onLocationChanged(LocationData myLocation) {
    if (this.currentRecordState != RecordState.StatusStart) {
      return;
    }
    var timePassed = (DateTime.now().millisecondsSinceEpoch - time);
    totalTimeElapsed += timePassed;
    print("Location change in " + timePassed.toString());

    if (timePassed < 1000) {
      print("To close");
      return;
    }

    time = DateTime.now().millisecondsSinceEpoch;

    ///GPS CHECKING
    if (myLocation.accuracy <= 0) {
      print("Latitidue and longitude values are invalid.");
      invalidCount++;
      return;
    }

    //setAccuracy(newLocation.getAccuracy());
    double horizontalAccuracy = myLocation.accuracy;
    if (horizontalAccuracy > 25) {
      //10meter filter
      print("Accuracy is too low. " + horizontalAccuracy.toString());
      invalidCount++;
      return;
    }

    /* Kalman Filter */
    double Qvalue;

    int elapsedTimeInMillis = timePassed;

    if (currentSpeed == 0) {
      Qvalue = 1; //1 meters per second
    } else {
      Qvalue = currentSpeed; // meters per second
    }

    kalmanFilter.Process(myLocation.latitude, myLocation.longitude,
        myLocation.accuracy, elapsedTimeInMillis, Qvalue);
    double predictedLat = kalmanFilter.get_lat();
    double predictedLng = kalmanFilter.get_lng();

    double predictedDeltaInMeters = calculateDistance(predictedLat,
            predictedLng, myLocation.latitude, myLocation.longitude)
        .abs();

    print("Kalman Filter: " + predictedDeltaInMeters.toString());

    if (predictedDeltaInMeters > 6) {
      print(
          "Kalman Filter detects mal GPS, we should probably remove this from track: " +
              predictedDeltaInMeters.toString());
      kalmanFilter.consecutiveRejectCount += 1;

      if (kalmanFilter.consecutiveRejectCount > 3) {
        kalmanFilter = new KalmanLatLong(
            3); //reset Kalman Filter if it rejects more than 3 times in raw.
      }
      invalidCount++;
      return;
    } else {
      kalmanFilter.consecutiveRejectCount = 0;
    }
    currentSpeed = myLocation.speed;
    var distance = calculateDistance(lastLoc.latitude, lastLoc.longitude,
            myLocation.latitude, myLocation.longitude)
        .abs();
    print("Dist: " + distance.toString());
    //min speed 1m/s

    //Check acceleration (max avg aclr is 3.5)
    var v1 = recordData.latestPace;
    var v2 = distance / (totalTimeElapsed / 1000);
    var a = (v2 - v1) / (totalTimeElapsed / 1000);
    print("acceleration: " + a.toString());

    print("total meters have to pass: " + (timePassed / 1000).toString());
    if (distance < 1 * timePassed / 1000)
    //||calculateDistance(lastLoc.latitude, lastLoc.longitude, myLocation.latitude, myLocation.longitude).abs()>3)
    {
      print("Distance is less than required (1m/s) after: " +
          timePassed.toString());
      invalidCount++;
      return;
    }

    lastLoc = myLocation;
    //geolocator.Position pos = await geolocator.Geolocator().getCurrentPosition(desiredAccuracy: geolocator.LocationAccuracy.bestForNavigation);

    print("1 min + lat: " +
        myLocation.latitude.toString() +
        " long: " +
        myLocation.longitude.toString() +
        "acc: " +
        myLocation.accuracy.toString() +
        "speed: " +
        myLocation.speed.toString());
    polylineCoordinates.add(LatLng(myLocation.latitude, myLocation.longitude));
    Polyline polyline = Polyline(
        polylineId: PolylineId('${recordData.trackRequest.routes.length}'),
        color: R.colors.majorOrange,
        width: 5,
        points: polylineCoordinates);

    invalidCount = 0;
    //lData.add(polyline);
    drawMaker(LatLng(myLocation.latitude, myLocation.longitude));
    this._streamLocationController.add(myLocation);
    recordData.totalDistance += distance.toInt();
    recordData.acceleration = a;
    recordData.latestPace = v2;
    recordData.addLocation(myLocation, timePassed);
    lData.last.points.add(LatLng(myLocation.latitude, myLocation.longitude));

    print("Add Location: " + recordData.lastLocation.toString());

    totalTimeElapsed = 0;
  }

  loadLatestRecord() async {
    try {
      RecordData data = await RecordHelper.loadFromFile();
      if (data == null) return;

      this.recordData = data;
      recordData.trackRequest.routes.asMap().forEach((index, route) {
        drawLines(route.locations, '$index');
      });
      this._streamReportVisibilityController.add(ReportVisibility.Visible);
      _initTimeService(data.totalTime);

      this._streamLocationController.add(recordData.lastLocation);
      this._streamRecorData.add(this.recordData);
      this._streamGPSSignal.add(GPSSignalStatus.HIDE);
      this.updateRecordStatus(RecordState.StatusStop);
    } catch (error) {
      print(error);
    }
  }

  finishedUpdateSplits() {
    var currentDistance1 = (this.recordData.totalDistance ~/ 1000);
    var currentDistance2 = (this.recordData.totalDistance / 1000);
    double x = currentDistance2 - currentDistance1;
    this.recordData.splitData.forEach((key, value) {
      print(key);
      if (key == currentDistance2.ceil().toString() || currentDistance2 == 0) {
        key = (currentDistance1 + (x * 100).ceil() / 100).toString();
        return;
      }
    });
    this
            .recordData
            .splitData[(currentDistance1 + (x * 100).ceil() / 100).toString()] =
        this.recordData.avgPace;
  }

  void resetAll() {
    this.recordData = RecordData();
    this._streamRecorData.add(this.recordData);
    this.onGpsStatusChecking();
    this.updateRecordStatus(RecordState.StatusNone);
    if (this._timeService != null) {
      this._timeService.close();
    }
    this._timeService = new TimerService(0, this.onTotalTimeChange);
  }
}
