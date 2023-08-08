import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static late FlutterSecureStorage secureStorage;

  // keys
  static const phone = 'phone';
  static const otp = 'otp';

  static init() {
    secureStorage = const FlutterSecureStorage();
  }

  static Future  write({required String key, required String value}) async {
    return await secureStorage.write(key: key, value: value);
  }

  static Future read({required String key}) async {
    return await secureStorage.read(key: key);
  }

  static Future delete({required String key}) async {
    return await secureStorage.delete(key: key);
  }
}
