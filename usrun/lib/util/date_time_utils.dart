
import 'dart:core';

import 'package:intl/intl.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/util/validator.dart';

const String formatDateConst = "dd/MM/yyyy";
const String formatDateTimeConst = "dd/MM/yyyy HH:mm";
const String formatTimeConst = "HH:mm";
const String formatTimeDateConst = "HH:mm dd/MM/yyyy";
const String formatTimeDateBreakLineConst = "HH:mm\ndd/MM";
const String formatDateNoYearConst = "dd/MM";

String formatDateTime(DateTime dateTime,
    {String formatDisplay = formatDateConst}) {
  if (dateTime == null) {
    return "";
  }
  return DateFormat(formatDisplay).format(dateTime).toString();
}

String secondToTimeFormat(int sec)
{
  if (sec == -1)
    return "00:00:00";
  int hh = sec~/(60*60);
  int mm = sec~/60 - hh*60;
  int ss = sec - hh*3600 - mm*60;
  if (hh>24)
    {
      int dd = hh~/24;
      return '$dd';
    }

  return '${hh<10?"0$hh":hh}:${mm<10?"0$mm":mm}:${ss<10?"0$ss":ss}';
}

String secondToMinFormat(int sec)
{
  if (sec == -1)
    return "00:00";
  int mm = sec~/60;
  int ss = sec - mm*60;

  return '${mm<10?"0$mm":mm}:${ss<10?"0$ss":ss}';
}

String formatDateTimeToLocal(DateTime dateTime,
    {String formatDisplay = formatDateConst}) {
  if (dateTime == null) return "";
  var dateUtc = dateTime.toUtc();
  final convertDate = dateUtc.toLocal();
  return DateFormat(formatDisplay).format(convertDate);
}

bool isSameDate(DateTime start, DateTime end) {
  if (start.year == end.year &&
      start.month == end.month &&
      start.day == end.day) {
    return true;
  }
  return false;
}

DateTime convertString2DateTime(String src, {String formatConvert = formatDateTimeConst}) {
  if (checkStringNullOrEmpty(src)) return null;
  try {
    return DateFormat(formatConvert).parse(src);
  } on Exception catch(e) {
    print("convertString2DateTime failed ${e.toString()}");
    return null;
  }
}


String millisecondToDateString(int ts){
  var d = new DateTime.fromMillisecondsSinceEpoch(ts,isUtc: true);
  return formatDateTimeToLocal(d, formatDisplay: formatDateTimeConst);
}

DateTime localToUtc(DateTime d)
{
  DateTime date = DateTime.utc(d.year,d.month,d.day,d.hour,d.minute,d.second);
  return date;
}