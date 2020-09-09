import 'package:flutter/cupertino.dart';
import 'package:usrun/model/mapper_object.dart';
import 'package:usrun/util/reflector.dart';

@reflector
class SplitModel with MapperObject {
  double km;
  int pace; // seconds
  double elevGain; // meters
  double boxWidth;

  SplitModel({
    this.km,
    this.pace,
    this.elevGain,
    this.boxWidth,
  });

  SplitModel computeWidthChart({
    @required int smallestPace, // seconds
    @required double availableChartWidth,
  }) {
    if (smallestPace == 0) {
      smallestPace = 1;
    }

    if (this.pace == 0) {
      this.pace = 1;
    }

    if (availableChartWidth <= 10) {
      availableChartWidth = 100.0;
    }

    return SplitModel(
      elevGain: this.elevGain,
      km: this.km,
      pace: this.pace,
      boxWidth: (smallestPace / this.pace) * availableChartWidth,
    );
  }
}
