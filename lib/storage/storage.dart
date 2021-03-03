import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static saveStorage(String key, String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(key, value);
  }
  /* static getString() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _storageString = sharedPreferences.get(STORAGE_KEY);
    });
  } */
}
