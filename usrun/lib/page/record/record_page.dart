import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/page/record/bloc_provider.dart';
import 'package:usrun/page/record/record_bloc.dart';
import 'package:usrun/page/record/record_button.dart';
import 'package:usrun/page/record/record_const.dart';
import 'package:usrun/widget/button_circle.dart';

class RecordPage extends StatefulWidget {
  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  final recordBloc = RecordBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(child: _RecordWidget(), bloc: recordBloc);
  }

  @override
  void dispose() {
    super.dispose();
    recordBloc.dispose();
  }
}

class _RecordWidget extends StatelessWidget {
  RecordBloc bloc;
  BuildContext context;
  LocationData test;


Set<Marker> getDefaultBeginMaker(LatLng defaultBegin) {
    Set<Marker> markers = Set();
    // if (this.bloc.currentRecordState != RecordState.StatusStart && this.bloc.currentRecordState != RecordState.StatusStop) {
    //   return markers;
    // }

   
    LocationData firstPoint = this.bloc.beginPoint;
    if (firstPoint != null) {
      defaultBegin = LatLng(firstPoint.latitude,firstPoint.longitude);
      // if (bloc.recordData.polylineList.isNotEmpty) {
      //   Polyline polyline = bloc.recordData.polylineList.first;
      //   if (polyline != null && polyline.points.isNotEmpty) {
      //     LatLng latLng = polyline.points.first;
      //     if (latLng != null) {
      //       defaultBegin = latLng;
      //     }
      //   }
      // }
      if (defaultBegin != null) {
        markers.addAll([
          Marker(
              markerId: MarkerId('begin'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed),
              position: defaultBegin),
        ]);
      }
    }
    return markers;
  }

  Widget buildGPSInfoSignal() {
    return StreamBuilder<GPSSignalStatus>(
      stream: this.bloc.streamGPSStatus,
      builder: (context, snapshot) {
        var textGPSStatus = "R.strings.gpsAcquiring";
        var colorBackground = R.colors.majorOrange;
        if (snapshot.hasData) {
          if (snapshot.data == GPSSignalStatus.READY) {
            textGPSStatus = "R.strings.gpsReady";
            colorBackground = R.colors.majorOrange;
          } else  if (snapshot.data == GPSSignalStatus.CHECKING) {
            textGPSStatus = "R.strings.gpsAcquiring";
            colorBackground = Color(0xff8d1f17);
          } else {
            textGPSStatus =  "R.strings.noGpsSignal";
            colorBackground = Color(0xff8d1f17);
          }
        }
        var isGone = snapshot.data != null && snapshot.data == GPSSignalStatus.HIDE;
        return Offstage(
          offstage: isGone,
          child: Container(
            padding: EdgeInsets.all(5),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(textGPSStatus, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white))
                ]),
            color: colorBackground,
          ),
        );
      }
    );
  }

    Widget buildRecordStateStatus() {
    return StreamBuilder<GPSSignalStatus>(
        stream: this.bloc.streamGPSStatus,
        builder: (context, snapshot) {
          var isGone = this.bloc.currentRecordState == RecordState.StatusStart || this.bloc.gpsStatus != GPSSignalStatus.HIDE;
          return Offstage(
            offstage: isGone,
            child: Container(
              padding: EdgeInsets.all(5),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("R.strings.pause", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white))
                  ]),
              color: R.colors.majorOrange,
            ),
          );
        }
    );
  }

  Widget buildMap(BuildContext context) {
    this.context = context;
    this.bloc = BlocProvider.of(context);
    return StreamBuilder<LocationData>(
        stream: bloc.streamLocation,
        builder: (BuildContext context, snapShot) {
          var defaultBegin = LatLng(10.763106, 106.682214);
          var markers = this.getDefaultBeginMaker(defaultBegin);
          return GestureDetector(
            //onHorizontalDragEnd: this.bloc.getReportVisibilityValue != ReportVisibility.Visible ? null: this.onOpenSplitView,
            child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: defaultBegin,
                  zoom: 13//bloc.recordData.currentZoomValue,
                ),
                //markers: markers,
                //onTap: this.onTapMap,
                onMapCreated: (controller) => bloc.onMapCreated(controller),
                myLocationEnabled: true,
                scrollGesturesEnabled: true,
                myLocationButtonEnabled: false,
                polylines: Set.of(bloc.lData),
                // onCameraMove: (value) {
                //   bloc.onCameraMove(value.zoom);
                // }
                ),
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    this.bloc = BlocProvider.of(context);
    return Container(
        child: Column(
          children: <Widget>[
            buildRecordStateStatus(),
            Expanded(
              child: Column(
                children: <Widget>[
                Expanded(
                    child: Stack(
                      children: <Widget>[
                        buildMap(context),
                        buildGPSInfoSignal(),
                        RecordButton(),
                        GestureDetector(child: Icon(Icons.location_on),onTap: ()async{
                          LocationData myLocation = await this.bloc.getCurrentLocation();
                          Scaffold.of(context).showSnackBar(SnackBar(
                             content: Text("lat: " + myLocation.latitude.toString() + " long: "+ myLocation.longitude.toString()),
                        ));},)
                    ])
                    )
            ],),
            )
          ])
    );
  }

}