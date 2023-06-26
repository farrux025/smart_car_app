import 'package:flutter/cupertino.dart';
import 'package:smart_car_app/views/home.dart';

class Routes {
  static const home = "/home";

  static Map<String, WidgetBuilder> routesMap() {
    return {
      // home
      Routes.home: (context) => const HomeScreen(),
    };
  }
}
