import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static final UserPreferences _instance = UserPreferences._internal();

  factory UserPreferences() {
    return _instance;
  }

  UserPreferences._internal();

  SharedPreferences? _prefs;

  initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String get lastCity {
    return _prefs?.getString('lastCity') ?? '';
  }

  set lastCity(String value) {
    _prefs?.setString('lastCity', value);
  }
}
