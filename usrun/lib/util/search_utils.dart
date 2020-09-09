class SearchUtils {
  static String _cleanAccents(String str) {
    if (str == null || str.length == 0) return "";

    str = str.replaceAll(RegExp("à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ"), "a");
    str = str.replaceAll(RegExp("è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ"), "e");
    str = str.replaceAll(RegExp("ì|í|ị|ỉ|ĩ"), "i");
    str = str.replaceAll(RegExp("ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ"), "o");
    str = str.replaceAll(RegExp("ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ"), "u");
    str = str.replaceAll(RegExp("ỳ|ý|ỵ|ỷ|ỹ"), "y");
    str = str.replaceAll(RegExp("đ"), "d");

    // Combining Diacritical Marks
    str = str.replaceAll(
        "\u0300|\u0301|\u0303|\u0309|\u0323", ""); // huyền, sắc, hỏi, ngã, nặng
    str =
        str.replaceAll("\u02C6|\u0306|\u031B", ""); // mũ â (ê), mũ ă, mũ ơ (ư)

    return str;
  }

  static bool hasContainData(List<String> data, String key,
      {bool includeEmptyKey: false, bool includeNullKey: false}) {
    if (data == null || data.length == 0) return false;
    if (key == null && includeNullKey) {
      return true;
    }

    if (key.length == 0 && includeEmptyKey) {
      return true;
    }

    key = _cleanAccents(key.toLowerCase());
    for (int i = 0; i < data.length; ++i) {
      String element = data[i];
      if (element == null || element.length == 0) {
        continue;
      }

      String item = _cleanAccents(element.toLowerCase());
      if (item.contains(key) || key.contains(item)) {
        return true;
      }
    }
    return false;
  }
}
