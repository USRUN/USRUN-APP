
bool validateEmail(String email) {
  String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp regExp = new RegExp(p);

  return regExp.hasMatch(email) ? true : false;
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
