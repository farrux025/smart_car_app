import 'package:shared_preferences/shared_preferences.dart';

class MySharedPrefs {
  final Future<SharedPreferences> _sharedPrefs =
      SharedPreferences.getInstance();

  static const vehicleImageKey = "vehicleImageKey";
  static const vehicleImageUrlKey = "vehicleImageUrlKey";
  static const connectorTypeListKey = "connectorTypeListKey";
  static const distanceKey = "distanceKey";

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

  saveConnectorTypeList({required List<String> connectorTypeList}) async {
    final instance = await _sharedPrefs;
    instance.setStringList(connectorTypeListKey, connectorTypeList);
  }

  getConnectorTypeList() async {
    final instance = await _sharedPrefs;
    List<String>? list = instance.getStringList(connectorTypeListKey);
    return list;
  }

  saveDistance({required String distance}) async {
    final instance = await _sharedPrefs;
    instance.setString(distanceKey, distance);
  }

  getDistance() async {
    final instance = await _sharedPrefs;
    var string = instance.getString(distanceKey);
    return string ?? "100000";
  }
}
