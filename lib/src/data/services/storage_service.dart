import 'package:shared_preferences/shared_preferences.dart';

abstract class IStorageService {
  Future<void> saveString(String key, String value);
  Future<String?> getString(String key);
  Future<void> remove(String key);
}

class SharedPreferencesService implements IStorageService {
  late SharedPreferences _preferences;

  Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();
  }

  @override
  Future<void> saveString(String key, String value) async {
    await _preferences.setString(key, value);
  }

  @override
  Future<String?> getString(String key) async => _preferences.getString(key);

  @override
  Future<void> remove(String key) async {
    await _preferences.remove(key);
  }
}
