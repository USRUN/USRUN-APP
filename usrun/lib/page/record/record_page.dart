import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/manager/event_manager.dart';
import 'package:usrun/page/record/bloc_provider.dart';
import 'package:usrun/page/record/record_bloc.dart';
import 'package:usrun/page/record/record_button.dart';
import 'package:usrun/page/record/record_const.dart';
import 'package:usrun/widget/button_circle.dart';
import 'package:usrun/page/record/record_report.dart';

class RecordPage extends StatefulWidget {
  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  RecordBloc recordBloc;

  @override
  Widget build(BuildContext context) {
    recordBloc = RecordBloc(context);
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

  BitmapDescriptor pinLocationIcon;

  Widget buildGPSInfoSignal() {
    return StreamBuilder<GPSSignalStatus>(
        stream: this.bloc.streamGPSStatus,
        builder: (context, snapshot) {
          var textGPSStatus = R.strings.gpsAcquiring;
          var colorBackground = R.colors.majorOrange;
          if (snapshot.hasData) {
            if (snapshot.data == GPSSignalStatus.READY) {
              textGPSStatus = R.strings.gpsReady;
              colorBackground = R.colors.majorOrange;
            } else if (snapshot.data == GPSSignalStatus.CHECKING) {
              textGPSStatus = R.strings.gpsAcquiring;
              colorBackground = Color(0xff8d1f17);
            } else {
              textGPSStatus = R.strings.gpsNotFound;
              colorBackground = Color(0xff8d1f17);
            }
          }
          var isGone =
              snapshot.data != null && snapshot.data == GPSSignalStatus.HIDE ||
                  (this.bloc.currentRecordState == RecordState.StatusStop &&
                      snapshot.data == GPSSignalStatus.READY);
          return Offstage(
            offstage: isGone,
            child: Container(
              padding: EdgeInsets.all(6),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(textGPSStatus,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white))
                  ]),
              color: colorBackground,
            ),
          );
        });
  }

  Widget buildRecordStateStatus() {
    return StreamBuilder<RecordState>(
        stream: this.bloc.streamRecordState,
        builder: (context, snapshot) {
          var isGone = this.bloc.currentRecordState != RecordState.StatusStop;
          return Offstage(
            offstage: isGone,
            child: Container(
              padding: EdgeInsets.all(5),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(R.strings.pause,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white))
                  ]),
              color: R.colors.majorOrange,
            ),
          );
        });
  }

  Widget buildMap(BuildContext context) {
    this.context = context;
    this.bloc = BlocProvider.of(context);

    return StreamBuilder<LocationData>(
      stream: bloc.streamLocation,
      builder: (BuildContext context, snapShot) {
        var defaultBegin = LatLng(10.763106, 106.682214);
        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: defaultBegin,
            zoom: 13,
          ),
          markers: Set.of(bloc.mData),
          onMapCreated: (controller) => bloc.onMapCreated(controller),
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
          compassEnabled: false,
          scrollGesturesEnabled: true,
          zoomControlsEnabled: false,
          polylines: Set.of(bloc.lData),
        );
      },
    );
  }

  Widget buildReportView() {
    return Container(
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.only(bottom: 110),
      child: StreamBuilder<ReportVisibility>(
        stream: this.bloc.streamReportVisibility,
        initialData: ReportVisibility.Gone,
        builder: (context, snapshot) {
          print(snapshot.data);
          return Offstage(
            offstage: snapshot.data == ReportVisibility.Gone,
            child: RecordReport(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    this.bloc = BlocProvider.of(context);
    return Container(
      child: Column(
        children: <Widget>[
          buildRecordStateStatus(),
          Expanded(
            child: Column(
              children: <Widget>[
                Expanded(
                    child: Stack(children: <Widget>[
                  buildMap(context),
                  buildReportView(),
                  buildGPSInfoSignal(),
                  RecordButton(),
                ]))
              ],
            ),
          )
        ],
      ),
    );
  }
}
