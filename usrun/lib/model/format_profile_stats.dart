import 'package:intl/intl.dart';
import 'package:usrun/core/R.dart';

class FormatProfileStats {
  static List<dynamic> formatDayObject(dynamic userActivity) {
    if (userActivity == null) return null;

    List<dynamic> result = List();

    result.add({
      "id": "0",
      "title": "Activities",
      "data": "4",
      "unit": "",
      "iconURL": R.myIcons.activitiesStatsIcon,
      "enableCircleStyle": true,
    });

    // double minute = (DateTime.parse(obj['totalTime']).millisecondsSinceEpoch / 1000) / 60;
    result.add({
      "id": "1",
      "title": "Total Time",
      "data": "123", //minute.toString(),
      "unit": "min",
      "iconURL": R.myIcons.timeStatsIcon,
    });

    result.add({
      "id": "2",
      "title": "AVG Time",
      "data": "148",
      "unit": "min",
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
          .format(userActivity['totalDistance']),
      "unit": "km",
      "iconURL": R.myIcons.roadStatsIcon,
    });

    result.add({
      "id": "6",
      "title": "AVG Pace",
      "data": NumberFormat("#,##0.##", "en_US").format(userActivity['avgPace']),
      "unit": "/km",
      "iconURL": R.myIcons.paceStatsIcon,
      "enableImageStyle": true,
      "imageURL": R.images.staticStatsChart01,
    });

    result.add({
      "id": "7",
      "title": "Total Cal",
      "data": userActivity['calories'].toString(),
      "unit": "kcal",
      "iconURL": R.myIcons.caloriesStatsIcon,
      "enableCircleStyle": true,
    });

    result.add({
      "id": "8",
      "title": "AVG Elev",
      "data": userActivity['elevGain'].toString(),
      "unit": "meters",
      "iconURL": R.myIcons.elevationStatsIcon,
      "enableImageStyle": true,
      "imageURL": R.images.staticStatsChart03,
    });

    result.add({
      "id": "9",
      "title": "Max Elev",
      "data": userActivity['elevMax'].toString(),
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
      "dataTitle": "104",
      "unitTitle": "",
    });

    result.add({
      "id": "1",
      "subTitle": "Total Dist",
      "dataTitle": NumberFormat("#,##0.00", "en_US")
          .format(userActivity['totalDistance']),
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
      "dataTitle": "18502", //minute.toString(),
      "unitTitle": "min",
    });

    result.add({
      "id": "4",
      "subTitle": "AVG Time",
      "dataTitle": "142",
      "unitTitle": "min",
    });

    result.add({
      "id": "5",
      "subTitle": "AVG Pace",
      "dataTitle":
          NumberFormat("#,##0.##", "en_US").format(userActivity['avgPace']),
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
      "dataTitle": userActivity['calories'].toString(),
      "unitTitle": "kcal",
    });

    result.add({
      "id": "8",
      "subTitle": "AVG Elev",
      "dataTitle": userActivity['elevGain'].toString(),
      "unitTitle": "m",
    });

    result.add({
      "id": "9",
      "subTitle": "Max Elev",
      "dataTitle": userActivity['elevMax'].toString(),
      "unitTitle": "m",
    });

    return result;
  }

  static List<dynamic> formatStatsSectionObject(dynamic userActivity) {
    if (userActivity == null) return null;

    List<dynamic> result = List();

    result.add({
      "title": "Activities",
      "data": "104",
      "unit": "",
      "iconURL": R.myIcons.activitiesStatsIconByTheme,
      "enableBottomBorder": true,
      "isSuffixIcon": true,
      "enableMarginBottom": true,
    });

    result.add({
      "title": "Total Dist",
      "data": NumberFormat("#,##0.00", "en_US")
          .format(userActivity['totalDistance']),
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
      "data": "37188", //minute.toString(),
      "unit": "min",
      "iconURL": R.myIcons.timeStatsIconByTheme,
      "enableBottomBorder": true,
      "isSuffixIcon": true,
      "enableMarginBottom": true,
    });

    result.add({
      "title": "Avg Time",
      "data": "131",
      "unit": "min",
      "iconURL": R.myIcons.timeStatsIconByTheme,
      "enableBottomBorder": false,
      "isSuffixIcon": true,
      "enableMarginBottom": true,
    });

    result.add({
      "title": "Avg Pace",
      "data": NumberFormat("#,##0.##", "en_US").format(userActivity['avgPace']),
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
      "data": userActivity['calories'].toString(),
      "unit": "/kcal",
      "iconURL": R.myIcons.caloriesStatsIconByTheme,
      "enableBottomBorder": true,
      "isSuffixIcon": false,
      "enableMarginBottom": true,
    });

    result.add({
      "title": "Avg Elev",
      "data": userActivity['elevGain'].toString(),
      "unit": "m",
      "iconURL": R.myIcons.elevationStatsIconByTheme,
      "enableBottomBorder": true,
      "isSuffixIcon": false,
      "enableMarginBottom": true,
    });

    result.add({
      "title": "Max Elev",
      "data": userActivity['elevMax'].toString(),
      "unit": "m",
      "iconURL": R.myIcons.elevationStatsIconByTheme,
      "enableBottomBorder": false,
      "isSuffixIcon": false,
      "enableMarginBottom": true,
    });

    return result;
  }
}
