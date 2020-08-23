class StringUtils {
  static String uppercaseFirstLetterEachWord({
    String content,
    Pattern pattern,
    bool lowercaseExceptFirstLetter: true,
  }) {
    if (content == null ||
        content.length == 0 ||
        pattern == null ||
        pattern == "" ||
        lowercaseExceptFirstLetter == null) {
      return "";
    }

    content = content.trim();

    List<String> stringArray = content.split(pattern);
    if (stringArray.length == 1) {
      return stringArray[0];
    }

    String result = "";
    for (int i = 0; i < stringArray.length; ++i) {
      String element = stringArray[i];
      if (lowercaseExceptFirstLetter) {
        element = element.toLowerCase();
      }

      String firstLetter = element[0];
      firstLetter = firstLetter.toUpperCase();

      String subString = element.substring(1);
      result = result + firstLetter + subString + " ";
    }

    return result;
  }

  static String uppercaseOnlyFirstLetterOfFirstWord({
    String content,
  }) {
    if (content == null || content.length == 0) {
      return "";
    }

    String firstLetter = content[0];
    String newFirstLetter = firstLetter.toUpperCase();

    String longString = "";
    if (content.length > 1) {
      longString = content.substring(1)[1];
    }

    return newFirstLetter + longString;
  }
}
