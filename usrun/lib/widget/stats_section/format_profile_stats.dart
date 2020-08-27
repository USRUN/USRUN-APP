import 'package:intl/intl.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/define.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/manager/data_manager.dart';
import 'package:usrun/util/date_time_utils.dart';

class FormatProfileStats {
  static List<dynamic> formatDayObject(dynamic userActivity) {
    if (userActivity == null) return null;

    List<dynamic> result = List();

    result.add({
      "id": "0",
      "title": R.strings.activityTitle,
      "data": userActivity["numberActivity"].toString(),
      "unit": "",
      "iconURL": R.myIcons.activitiesStatsIcon,
      "enableCircleStyle": true,
    });

    // double minute = (DateTime.parse(obj['totalTime']).millisecondsSinceEpoch / 1000) / 60;
    result.add({
      "id": "1",
      "title": R.strings.time,
      "data": secondToTimeFormat(userActivity["totalTime"]), //minute.toString(),
      "unit": secondToTimeFormat(userActivity["totalTime"]).contains(":")?"":R.strings.day,
      "iconURL": R.myIcons.timeStatsIcon,
    });

    result.add({
      "id": "2",
      "title": R.strings.avgTime,
      "data": secondToMinFormat(userActivity["avgTime"]),
      "unit": R.strings.minutes,
      "iconURL": R.myIcons.timeStatsIcon,
    });

    result.add({
      "id": "3",
      "title": R.strings.avgHeart,
      "data": userActivity['avgHeart'].toString(),
      "unit": R.strings.avgHeartUnit,
      "iconURL": R.myIcons.heartBeatStatsIcon,
      "enableImageStyle": true,
      "imageURL": R.images.staticStatsChart02,
    });

    result.add({
      "id": "4",
      "title": R.strings.totalStep,
      "data": userActivity['totalStep'].toString(),
      "unit": "",
      "iconURL": R.myIcons.footStepStatsIcon,
      "enableCircleStyle": true,
    });

    result.add({
      "id": "5",
      "title": R.strings.distance,
      "data": DataManager.getUserRunningUnit() == RunningUnit.KILOMETER? NumberFormat("#,##0.00", "en_US")
          .format(switchBetweenMeterAndKm(userActivity['totalDistance'])) : switchBetweenMeterAndKm(userActivity['totalDistance']),
      "unit": R.strings.distanceUnit[DataManager.getUserRunningUnit().index],
      "iconURL": R.myIcons.roadStatsIcon,
    });

    result.add({
      "id": "6",
      "title": R.strings.avgPace,
      "data": secondToMinFormat(userActivity['avgPace']),
      "unit": R.strings.avgPaceUnit,
      "iconURL": R.myIcons.paceStatsIcon,
      "enableImageStyle": true,
      "imageURL": R.images.staticStatsChart01,
    });

    result.add({
      "id": "7",
      "title": R.strings.calories,
      "data": userActivity['totalCal'].toString(),
      "unit": R.strings.caloriesUnit,
      "iconURL": R.myIcons.caloriesStatsIcon,
      "enableCircleStyle": true,
    });

    result.add({
      "id": "8",
      "title": R.strings.avgElev,
      "data": switchBetweenMeterAndKm(userActivity['avgElev'] ~/1),
      "unit": R.strings.distanceUnit[DataManager.getUserRunningUnit().index],
      "iconURL": R.myIcons.elevationStatsIcon,
      "enableImageStyle": true,
      "imageURL": R.images.staticStatsChart03,
    });

    result.add({
      "id": "9",
      "title": R.strings.maxElev,
      "data": switchBetweenMeterAndKm(userActivity['maxElev'] ~/1),
      "unit": R.strings.distanceUnit[DataManager.getUserRunningUnit().index],
      "iconURL": R.myIcons.elevationStatsIcon,
    });

    return result;
  }

  static List<dynamic> formatChartObject(dynamic userActivity) {
    if (userActivity == null) return null;

    List<dynamic> result = List();

    result.add({
      "id": "0",
      "subTitle": R.strings.activityTitle,
      "dataTitle": userActivity["numberActivity"].toString(),
      "unitTitle": "",
    });

    result.add({
      "id": "1",
      "subTitle": R.strings.distance,
      "dataTitle":  DataManager.getUserRunningUnit() == RunningUnit.KILOMETER? NumberFormat("#,##0.00", "en_US")
          .format(switchBetweenMeterAndKm(userActivity['totalDistance'])) : switchBetweenMeterAndKm(userActivity['totalDistance']),
      "unitTitle": R.strings.distanceUnit[DataManager.getUserRunningUnit().index],
    });

    result.add({
      "id": "2",
      "subTitle": R.strings.totalStep,
      "dataTitle": userActivity['totalStep'].toString(),
      "unitTitle": "",
    });

    // double minute = (DateTime.parse(obj['totalTime']).millisecondsSinceEpoch / 1000) / 60;
    result.add({
      "id": "3",
      "subTitle": R.strings.time,
      "dataTitle": secondToTimeFormat(userActivity["totalTime"]), //minute.toString(),
      "unitTitle": secondToTimeFormat(userActivity["totalTime"]).contains(":")?"":R.strings.day,
    });

    result.add({
      "id": "4",
      "subTitle": R.strings.avgTime,
      "dataTitle": secondToTimeFormat(userActivity["avgTime"]),
      "unitTitle": "",
    });

    result.add({
      "id": "5",
      "subTitle": R.strings.avgPace,
      "dataTitle":secondToMinFormat(userActivity['avgPace']),
      "unitTitle": R.strings.avgPaceUnit,
    });

    result.add({
      "id": "6",
      "subTitle": R.strings.avgHeart,
      "dataTitle": userActivity['avgHeart'].toString(),
      "unitTitle": R.strings.avgHeartUnit,
    });

    result.add({
      "id": "7",
      "subTitle": R.strings.calories,
      "dataTitle": userActivity['totalCal'].toString(),
      "unitTitle": R.strings.caloriesUnit,
    });

    result.add({
      "id": "8",
      "subTitle": R.strings.avgElev,
      "dataTitle":  switchBetweenMeterAndKm(userActivity['avgElev']~/1),
      "unitTitle": R.strings.distanceUnit[DataManager.getUserRunningUnit().index],
    });

    result.add({
      "id": "9",
      "subTitle": R.strings.maxElev,
      "dataTitle":  switchBetweenMeterAndKm(userActivity['maxElev']~/1),
      "unitTitle": R.strings.distanceUnit[DataManager.getUserRunningUnit().index],
    });

    return result;
  }

  static List<dynamic> formatStatsSectionObject(dynamic userActivity) {
    if (userActivity == null) return null;

    List<dynamic> result = List();

    result.add({
      "title": R.strings.activityTitle,
      "data": userActivity["numberActivity"].toString(),
      "unit": "",
      "iconURL": R.myIcons.activitiesStatsIconByTheme,
      "enableBottomBorder": true,
      "isSuffixIcon": true,
      "enableMarginBottom": true,
    });

    result.add({
      "title": R.strings.distance,
      "data": DataManager.getUserRunningUnit() == RunningUnit.KILOMETER? NumberFormat("#,##0.00", "en_US")
          .format(switchBetweenMeterAndKm(userActivity['totalDistance'])) : switchBetweenMeterAndKm(userActivity['totalDistance']),
      "unit": R.strings.distanceUnit[DataManager.getUserRunningUnit().index],
      "iconURL": R.myIcons.roadStatsIconByTheme,
      "enableBottomBorder": true,
      "isSuffixIcon": true,
      "enableMarginBottom": true,
    });

    result.add({
      "title": R.strings.totalStep,
      "data": userActivity['totalStep'].toString(),
      "unit": "",
      "iconURL": R.myIcons.footStepStatsIconByTheme,
      "enableBottomBorder": true,
      "isSuffixIcon": true,
      "enableMarginBottom": true,
    });

    // double minute = (DateTime.parse(obj['totalTime']).millisecondsSinceEpoch / 1000) / 60;
    result.add({
      "title": R.strings.time,
      "data":  secondToTimeFormat(userActivity["totalTime"]), //minute.toString(),
      "unit": secondToTimeFormat(userActivity["totalTime"]).contains(":")?"":R.strings.day,
      "iconURL": R.myIcons.timeStatsIconByTheme,
      "enableBottomBorder": true,
      "isSuffixIcon": true,
      "enableMarginBottom": true,
    });

    result.add({
      "title": R.strings.avgTime,
      "data": secondToMinFormat(userActivity["avgTime"]),
      "unit": R.strings.minutes,
      "iconURL": R.myIcons.timeStatsIconByTheme,
      "enableBottomBorder": false,
      "isSuffixIcon": true,
      "enableMarginBottom": true,
    });

    result.add({
      "title": R.strings.avgPace,
      "data": secondToMinFormat(userActivity['avgPace']),
      "unit": R.strings.avgPaceUnit,
      "iconURL": R.myIcons.paceStatsIconByTheme,
      "enableBottomBorder": true,
      "isSuffixIcon": false,
      "enableMarginBottom": true,
    });

    result.add({
      "title": R.strings.avgHeart,
      "data": userActivity['avgHeart'].toString(),
      "unit": R.strings.avgHeartUnit,
      "iconURL": R.myIcons.heartBeatStatsIconByTheme,
      "enableBottomBorder": true,
      "isSuffixIcon": false,
      "enableMarginBottom": true,
    });

    result.add({
      "title": R.strings.calories,
      "data": userActivity['totalCal'].toString(),
      "unit": R.strings.caloriesUnit,
      "iconURL": R.myIcons.caloriesStatsIconByTheme,
      "enableBottomBorder": true,
      "isSuffixIcon": false,
      "enableMarginBottom": true,
    });

    result.add({
      "title": R.strings.avgElev,
      "data": switchBetweenMeterAndKm(userActivity['avgElev'] ~/1),
      "unit": R.strings.distanceUnit[DataManager.getUserRunningUnit().index],
      "iconURL": R.myIcons.elevationStatsIconByTheme,
      "enableBottomBorder": true,
      "isSuffixIcon": false,
      "enableMarginBottom": true,
    });

    result.add({
      "title": R.strings.maxElev,
      "data": switchBetweenMeterAndKm(userActivity['maxElev'] ~/1),
      "unit": R.strings.distanceUnit[DataManager.getUserRunningUnit().index],
      "iconURL": R.myIcons.elevationStatsIconByTheme,
      "enableBottomBorder": false,
      "isSuffixIcon": false,
      "enableMarginBottom": true,
    });

    return result;
  }
}
