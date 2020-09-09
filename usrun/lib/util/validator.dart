import 'package:usrun/core/R.dart';

bool validateEmail(String email) {
  String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp regExp = new RegExp(p);

  return regExp.hasMatch(email) ? true : false;
}

String validatePassword(String pass) {
  if (checkStringNullOrEmpty(pass.trim())) {
    return R.strings.errorEmptyPassword;
  }

  if (pass.length < 8 || !hasUppercase(pass) || !hasDigits(pass)) {
    return R.strings.errorInvalidPassword;
  }

  return null;
}

bool hasUppercase(String content) {
  return content.contains(new RegExp(r'[A-Z]'));
}

bool hasLowercase(String content) {
  return content.contains(new RegExp(r'[a-z]'));
}

bool hasSpecialCharacters(String content) {
  return content.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
}

bool hasDigits(String content) {
  return content.contains(new RegExp(r'[0-9]'));
}

bool checkStringNullOrEmpty(String src) {
  return src == null || src.isEmpty;
}

bool checkListIsNullOrEmpty(List lst) {
  return lst == null || lst.isEmpty;
}

bool checkMapIstNullOrEmpty(Map map) {
  return map == null || map.isEmpty;
}
