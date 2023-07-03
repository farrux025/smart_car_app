import 'package:flutter/cupertino.dart';
import 'package:smart_car_app/views/auth/register_screen.dart';
import 'package:smart_car_app/views/home/home.dart';

class Routes {
  static const home = "/home";
  static const register = "/register-screen";

  static Map<String, WidgetBuilder> routesMap() {
    return {
      // home
      Routes.home: (context) => const HomeScreen(),

      // register
      Routes.register: (context) => const RegisterScreen(),
    };
  }
}
