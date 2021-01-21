import '../config/Config.dart';

class Tools {
  static formatImgUrl(String path) {
    String url = Config.domain + path.replaceAll('\\', '/');
    return url;
  }
}
