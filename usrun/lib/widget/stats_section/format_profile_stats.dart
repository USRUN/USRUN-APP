import 'package:intl/intl.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/util/date_time_utils.dart';

class FormatProfileStats {
  static List<dynamic> formatDayObject(dynamic userActivity) {
    if (userActivity == null) return null;

    List<dynamic> result = List();

    result.add({
      "id": "0",
      "title": "Activities",
      "data": userActivity["numberActivity"].toString(),
      "unit": "",
      "iconURL": R.myIcons.activitiesStatsIcon,
      "enableCircleStyle": true,
    });

    // double minute = (DateTime.parse(obj['totalTime']).millisecondsSinceEpoch / 1000) / 60;
    result.add({
      "id": "1",
      "title": "Total Time",
      "data": secondToTimeFormat(userActivity["totalTime"]), //minute.toString(),
      "unit": secondToTimeFormat(userActivity["totalTime"]).contains(":")?"":R.strings.day,
      "iconURL": R.myIcons.timeStatsIcon,
    });

    result.add({
      "id": "2",
      "title": "AVG Time",
      "data": secondToMinFormat(userActivity["avgTime"]),
      "unit": "",
      "iconURL": R.myIcons.timeStatsIcon,
    });

    result.add({
      "id": "3",
      "title": "AVG Heart",
      "data": userActivity['avgHeart'].toString(),
      "unit": "bpm",
      "iconURL": R.myIcons.heartBeatStatsIcon,
      "enableImageStyle": true,
      "imageURL": R.images.staticStatsChart02,
    });

    result.add({
      "id": "4",
      "title": "Total Steps",
      "data": userActivity['totalStep'].toString(),
      "unit": "",
      "iconURL": R.myIcons.footStepStatsIcon,
      "enableCircleStyle": true,
    });

    result.add({
      "id": "5",
      "title": "Total Distance",
      "data": NumberFormat("#,##0.00", "en_US")
          .format(userActivity['totalDistance']/1000),
      "unit": "km",
      "iconURL": R.myIcons.roadStatsIcon,
    });

    result.add({
      "id": "6",
      "title": "AVG Pace",
      "data": secondToMinFormat(userActivity['avgPace']),
      "unit": "/km",
      "iconURL": R.myIcons.paceStatsIcon,
      "enableImageStyle": true,
      "imageURL": R.images.staticStatsChart01,
    });

    result.add({
      "id": "7",
      "title": "Total Cal",
      "data": userActivity['totalCal'].toString(),
      "unit": "kcal",
      "iconURL": R.myIcons.caloriesStatsIcon,
      "enableCircleStyle": true,
    });

    result.add({
      "id": "8",
      "title": "AVG Elev",
      "data": userActivity['avgElev'].toString(),
      "unit": "meters",
      "iconURL": R.myIcons.elevationStatsIcon,
      "enableImageStyle": true,
      "imageURL": R.images.staticStatsChart03,
    });

    result.add({
      "id": "9",
      "title": "Max Elev",
      "data": userActivity['maxElev'].toString(),
      "unit": "meters",
      "iconURL": R.myIcons.elevationStatsIcon,
    });

    return result;
  }

  static List<dynamic> formatChartObject(dynamic userActivity) {
    if (userActivity == null) return null;

    List<dynamic> result = List();

    result.add({
      "id": "0",
      "subTitle": "Activities",
      "dataTitle": userActivity["numberActivity"].toString(),
      "unitTitle": "",
    });

    result.add({
      "id": "1",
      "subTitle": "Total Dist",
      "dataTitle": NumberFormat("#,##0.00", "en_US")
          .format(userActivity['totalDistance']/1000),
      "unitTitle": "km",
    });

    result.add({
      "id": "2",
      "subTitle": "Total Steps",
      "dataTitle": userActivity['totalStep'].toString(),
      "unitTitle": "",
    });

    // double minute = (DateTime.parse(obj['totalTime']).millisecondsSinceEpoch / 1000) / 60;
    result.add({
      "id": "3",
      "subTitle": "Total Time",
      "dataTitle": secondToTimeFormat(userActivity["totalTime"]), //minute.toString(),
      "unitTitle": secondToTimeFormat(userActivity["totalTime"]).contains(":")?"":R.strings.day,
    });

    result.add({
      "id": "4",
      "subTitle": "AVG Time",
      "dataTitle": secondToTimeFormat(userActivity["avgTime"]),
      "unitTitle": "",
    });

    result.add({
      "id": "5",
      "subTitle": "AVG Pace",
      "dataTitle":secondToMinFormat(userActivity['avgPace']),
      "unitTitle": "/km",
    });

    result.add({
      "id": "6",
      "subTitle": "AVG Heart",
      "dataTitle": userActivity['avgHeart'].toString(),
      "unitTitle": "bpm",
    });

    result.add({
      "id": "7",
      "subTitle": "Total Cal",
      "dataTitle": userActivity['totalCal'].toString(),
      "unitTitle": "kcal",
    });

    result.add({
      "id": "8",
      "subTitle": "AVG Elev",
      "dataTitle": userActivity['avgElev'].toString(),
      "unitTitle": "m",
    });

    result.add({
      "id": "9",
      "subTitle": "Max Elev",
      "dataTitle": userActivity['maxElev'].toString(),
      "unitTitle": "m",
    });

    return result;
  }

  static List<dynamic> formatStatsSectionObject(dynamic userActivity) {
    if (userActivity == null) return null;

    List<dynamic> result = List();

    result.add({
      "title": "Activities",
      "data": userActivity["numberActivity"].toString(),
      "unit": "",
      "iconURL": R.myIcons.activitiesStatsIconByTheme,
      "enableBottomBorder": true,
      "isSuffixIcon": true,
      "enableMarginBottom": true,
    });

    result.add({
      "title": "Total Dist",
      "data": NumberFormat("#,##0.00", "en_US")
          .format(userActivity['totalDistance']/1000),
      "unit": "km",
      "iconURL": R.myIcons.roadStatsIconByTheme,
      "enableBottomBorder": true,
      "isSuffixIcon": true,
      "enableMarginBottom": true,
    });

    result.add({
      "title": "Total Steps",
      "data": userActivity['totalStep'].toString(),
      "unit": "",
      "iconURL": R.myIcons.footStepStatsIconByTheme,
      "enableBottomBorder": true,
      "isSuffixIcon": true,
      "enableMarginBottom": true,
    });

    // double minute = (DateTime.parse(obj['totalTime']).millisecondsSinceEpoch / 1000) / 60;
    result.add({
      "title": "Total Time",
      "data":  secondToTimeFormat(userActivity["totalTime"]), //minute.toString(),
      "unit": secondToTimeFormat(userActivity["totalTime"]).contains(":")?"":R.strings.day,
      "iconURL": R.myIcons.timeStatsIconByTheme,
      "enableBottomBorder": true,
      "isSuffixIcon": true,
      "enableMarginBottom": true,
    });

    result.add({
      "title": "Avg Time",
      "data": secondToMinFormat(userActivity["avgTime"]),
      "unit": "min",
      "iconURL": R.myIcons.timeStatsIconByTheme,
      "enableBottomBorder": false,
      "isSuffixIcon": true,
      "enableMarginBottom": true,
    });

    result.add({
      "title": "Avg Pace",
      "data": secondToMinFormat(userActivity['avgPace']),
      "unit": "/km",
      "iconURL": R.myIcons.paceStatsIconByTheme,
      "enableBottomBorder": true,
      "isSuffixIcon": false,
      "enableMarginBottom": true,
    });

    result.add({
      "title": "Avg Heart",
      "data": userActivity['avgHeart'].toString(),
      "unit": "bpm",
      "iconURL": R.myIcons.heartBeatStatsIconByTheme,
      "enableBottomBorder": true,
      "isSuffixIcon": false,
      "enableMarginBottom": true,
    });

    result.add({
      "title": "Total Cal",
      "data": userActivity['totalCal'].toString(),
      "unit": "/kcal",
      "iconURL": R.myIcons.caloriesStatsIconByTheme,
      "enableBottomBorder": true,
      "isSuffixIcon": false,
      "enableMarginBottom": true,
    });

    result.add({
      "title": "Avg Elev",
      "data": userActivity['avgElev'].toString(),
      "unit": "m",
      "iconURL": R.myIcons.elevationStatsIconByTheme,
      "enableBottomBorder": true,
      "isSuffixIcon": false,
      "enableMarginBottom": true,
    });

    result.add({
      "title": "Max Elev",
      "data": userActivity['maxElev'].toString(),
      "unit": "m",
      "iconURL": R.myIcons.elevationStatsIconByTheme,
      "enableBottomBorder": false,
      "isSuffixIcon": false,
      "enableMarginBottom": true,
    });

    return result;
  }
}
