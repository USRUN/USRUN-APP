import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/page/record/bloc_provider.dart';
import 'package:usrun/page/record/record_bloc.dart';
import 'package:usrun/page/record/record_data.dart';
import 'package:usrun/widget/my_info_box/normal_info_box.dart';

class RecordReport extends StatelessWidget {
  RecordBloc bloc;

  BuildContext context;

  _buildInfoBox(title, data, {unit = ""}) {
    return NormalInfoBox(
      boxSize: 100,
      id: title,
      boxRadius: 5.0,
      firstTitleLine: title,
      dataLine: data.toString(),
      secondTitleLine: unit,
      disableBoxShadow: true,
      border: Border.all(
        color: Color(0xFFF0F0F0),
        width: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of(context);

    return StreamBuilder<RecordData>(
      stream: this.bloc.streamRecordData,
      initialData: RecordData(),
      builder: (context, snapshot) {
        return Container(
          height: 100,
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              SizedBox(width: 10),
              _buildInfoBox(
                R.strings.time,
                (Duration(seconds: snapshot.data.totalTime).toString())
                    .substring(0, 7),
                unit: "HH:MM:SS",
              ),
              SizedBox(width: 10),
              _buildInfoBox(
                R.strings.distance,
                snapshot.data.totalDistance,
                unit: "Meters",
              ),
              SizedBox(width: 10),
              _buildInfoBox(
                R.strings.avgPace,
                snapshot.data.avgPace == -1
                    ? "N/A"
                    : (Duration(seconds: snapshot.data.avgPace.toInt())
                            .toString())
                        .substring(0, 7),
                unit: "per KM",
              ),
              SizedBox(width: 10),
              _buildInfoBox(
                "Moving Time",
                (Duration(seconds: snapshot.data.totalMovingTime ~/ 1000)
                        .toString())
                    .substring(0, 7),
                unit: "HH:MM:SS",
              ),
              SizedBox(width: 10),
              _buildInfoBox(
                "Total Step",
                snapshot.data.totalStep == -1 ? "N/A" : snapshot.data.totalStep,
                unit: "steps",
              ),
              SizedBox(width: 10),
              _buildInfoBox(
                "Acceleration",
                snapshot.data.acceleration,
                unit: "m/s2",
              ),
              SizedBox(width: 10),
            ],
          ),
        );
      },
    );
  }
}
