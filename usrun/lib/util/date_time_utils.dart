
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