import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_car_app/constants/routes.dart';
import 'package:smart_car_app/services/secure_storage.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'services/dio/dio_client.dart';

main() async {
  AndroidYandexMap.useAndroidViewSurface = false;
  await DioClient.init();
  SecureStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
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
        initialRoute: Routes.onBoarding,
      ),
    );
  }
}
