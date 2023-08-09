import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_car_app/constants/routes.dart';
import 'package:smart_car_app/models/global/LocationModel.dart';
import 'package:smart_car_app/models/global/UserModel.dart';
import 'package:smart_car_app/services/location_service.dart';
import 'package:smart_car_app/services/secure_storage.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'services/dio/dio_client.dart';

main() async {
  AndroidYandexMap.useAndroidViewSurface = false;
  WidgetsFlutterBinding.ensureInitialized();
  await DioClient.init();
  SecureStorage.init();
  Global.userModel.username =
      await SecureStorage.read(key: SecureStorage.phone);
  Global.userModel.otp = await SecureStorage.read(key: SecureStorage.otp);
  LocationService.listen;
  LocationService.getCurrentPositionStream();
  await LocationService.determinePosition().then((value) {
    LocationModel.latitude = value.latitude;
    LocationModel.longitude = value.longitude;
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final username = Global.userModel.username;

  @override
  Widget build(BuildContext context) {
    log("Username: $username");
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: () => MaterialApp(
        title: 'Smart Car App',
        debugShowCheckedModeBanner: false,
        navigatorKey: MyApp.navigatorKey,
        theme: ThemeData(primarySwatch: Colors.blue),
        routes: Routes.routesMap(),
        initialRoute: username == null ? Routes.onBoarding : Routes.home,
      ),
    );
  }
}
