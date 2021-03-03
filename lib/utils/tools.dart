import '../config/Config.dart';

class Tools {
  static formatImgUrl(String path) {
    String url = Config.domain + path.replaceAll('\\', '/');
    return url;
  }

  static String listToString(List<String> list) {
    if (list == null) {
      return null;
    }
    String result;
    list.forEach((string) =>
        {if (result == null) result = string else result = '$result，$string'});
    return result.toString();
  }
}
