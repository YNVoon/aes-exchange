class Utility {

  static String truncateString (String str, int length, String ending) {
    if (ending == null) {
      ending = '...';
    } 
    if (str.length > length) {
      return str.substring(0, length - ending.length) + ending;
    } else {
      return str;
    }
  }
}