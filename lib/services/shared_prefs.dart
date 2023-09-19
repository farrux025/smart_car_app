import 'package:shared_preferences/shared_preferences.dart';

class MySharedPrefs {
  final Future<SharedPreferences> _sharedPrefs =
      SharedPreferences.getInstance();

  static const vehicleImageKey = "vehicleImageKey";
  static const vehicleImageUrlKey = "vehicleImageUrlKey";

  saveVehicleImage({required String key, required String path}) async {
    final instance = await _sharedPrefs;
    instance.setString(key, path);
  }

  Future<String> getVehicleImage({required String key}) async {
    final instance = await _sharedPrefs;
    var imagePath = instance.getString(key);
    return imagePath ?? "";
  }

  delete({required String key}) async {
    final instance = await _sharedPrefs;
    instance.remove(key);
  }
}
