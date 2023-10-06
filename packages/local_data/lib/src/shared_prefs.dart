import 'package:shared_preferences/shared_preferences.dart';

/// {@template local_data_api}
/// The interface for an API providing access to local data storage.
/// {@endtemplate}
class SharedPrefs {
  /// {@macro local_data_api}
  SharedPrefs._create();

  /// Public factory
  static Future<SharedPrefs> init() async {
    final sharedPref = SharedPrefs._create();
    await sharedPref._init();
    return sharedPref;
  }

  late SharedPreferences _preferences;

  Future<void> _init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  /// Sets a [value] into shared preferences with the key of [key]. If does not
  /// match any of the supported types, will not set the [value].
  Future<void> set(String key, dynamic value) async {
    if (value is String) {
      await _preferences.setString(key, value);
    } else if (value is int) {
      await _preferences.setInt(key, value);
    } else if (value is bool) {
      await _preferences.setBool(key, value);
    } else if (value is double) {
      await _preferences.setDouble(key, value);
    } else if (value is List<String>) {
      await _preferences.setStringList(key, value);
    }
  }

  /// Get string saved into the provided [key].
  Future<String?> getString(String key, {String? defaultValue}) async =>
      _preferences.getString(key) ?? defaultValue;

  /// Get int saved into the provided [key].
  Future<int?> getInt(String key, {int? defaultValue}) async =>
      _preferences.getInt(key) ?? defaultValue;

  /// Get bool saved into the provided [key].
  Future<bool?> getBool(String key, {bool? defaultValue}) async =>
      _preferences.getBool(key) ?? defaultValue;

  /// Get double saved into the provided [key].
  Future<double?> getDouble(String key, {double? defaultValue}) async =>
      _preferences.getDouble(key) ?? defaultValue;

  /// Get string saved into the provided [key].
  Future<List<String>?> getStringList(
    String key, {
    List<String>? defaultValue,
  }) async =>
      _preferences.getStringList(key) ?? defaultValue;

  /// Delete value stored with key [key].
  Future<bool> deleteValue(String key) async => _preferences.remove(key);
}
