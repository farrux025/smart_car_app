import 'package:flutter/cupertino.dart';
import 'package:smart_car_app/views/auth/login_screen.dart';
import 'package:smart_car_app/views/auth/otp_screen.dart';
import 'package:smart_car_app/views/auth/otp_waiting_screem.dart';
import 'package:smart_car_app/views/auth/register_screen.dart';
import 'package:smart_car_app/views/home/home.dart';
import 'package:smart_car_app/views/onboarding/onboarding_screen.dart';
import 'package:smart_car_app/views/profile/profile_screen.dart';
import 'package:smart_car_app/views/vehicle/add_vehicle_screen.dart';
import 'package:smart_car_app/views/vehicle/vehicles_screen.dart';

class Routes {
  // home
  static const home = "/home";
  static const onBoarding = "/on-boarding-screen";

  // auth
  static const register = "/register-screen";
  static const otpWaiting = "/otp-waiting-screen";
  static const otp = "/otp-screen";
  static const login = "/login-screen";

  // vehicle
  static const vehicles = "/vehicles";
  static const addVehicle = "/add-vehicle";

  // profile
  static const profile = "/profile";

  static Map<String, WidgetBuilder> routesMap() {
    return {
      // home
      Routes.home: (context) => const HomeScreen(),
      Routes.onBoarding: (context) => const OnBoardingScreen(),

      // auth
      Routes.register: (context) => const RegisterScreen(),
      Routes.otpWaiting: (context) => const OtpWaitingScreen(),
      Routes.otp: (context) => const OtpScreen(),
      Routes.login: (context) => const LoginScreen(),

      // vehicles
      Routes.vehicles: (context) => const VehiclesScreen(),
      Routes.addVehicle: (context) => const AddVehicleScreen(),

      // profile
      Routes.profile: (context) => const ProfileScreen(),
    };
  }
}
