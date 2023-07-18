import 'package:flutter/cupertino.dart';
import 'package:smart_car_app/views/auth/otp_screen.dart';
import 'package:smart_car_app/views/auth/otp_waiting_screem.dart';
import 'package:smart_car_app/views/auth/register_screen.dart';
import 'package:smart_car_app/views/home/home.dart';
import 'package:smart_car_app/views/onboarding/onboarding_screen.dart';

class Routes {
  // home
  static const home = "/home";
  static const onBoarding = "/on-boarding-screen";

  // register
  static const register = "/register-screen";
  static const otpWaiting = "/otp-waiting-screen";
  static const otp = "/otp-screen";

  static Map<String, WidgetBuilder> routesMap() {
    return {
      // home
      Routes.home: (context) => const HomeScreen(),
      Routes.onBoarding: (context) => const OnBoardingScreen(),

      // register
      Routes.register: (context) => RegisterScreen(),
      Routes.otpWaiting: (context) => const OtpWaitingScreen(),
      Routes.otp: (context) => const OtpScreen(),
    };
  }
}