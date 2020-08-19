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
                unit: R.strings.timeUnit,
              ),
              SizedBox(width: 10),
              _buildInfoBox(
                R.strings.distance,
                snapshot.data.totalDistance,
                unit: R.strings.meters,
              ),
              SizedBox(width: 10),
              _buildInfoBox(
                R.strings.avgPace,
                snapshot.data.avgPace == -1
                    ? R.strings.na
                    : (Duration(seconds: snapshot.data.avgPace.toInt())
                            .toString())
                        .substring(0, 7),
                unit: R.strings.avgPaceUnit,
              ),
              SizedBox(width: 10),
              _buildInfoBox(
                R.strings.totalStep,
                snapshot.data.totalStep == -1 ? R.strings.na : snapshot.data.totalStep,
                unit: R.strings.totalStepsUnit,
              ),
              SizedBox(width: 10),
            ],
          ),
        );
      },
    );
  }
}
