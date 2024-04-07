import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_car_app/constants/routes.dart';
import 'package:smart_car_app/hive/hive_store.dart';
import 'package:smart_car_app/models/global/LocationModel.dart';
import 'package:smart_car_app/models/global/UserModel.dart';
import 'package:smart_car_app/services/location_service.dart';
import 'package:smart_car_app/services/secure_storage.dart';
import 'package:smart_car_app/services/shared_prefs.dart';
import 'package:smart_car_app/utils/functions.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'constants/language.dart';
import 'services/dio/dio_client.dart';
import 'translations/codegen_loader.g.dart';

main() async {
  AndroidYandexMap.useAndroidViewSurface = false;
  WidgetsFlutterBinding.ensureInitialized();
  await DioClient.init();
  await MyHiveStore.init();
  await EasyLocalization.ensureInitialized();
  SecureStorage.init();
  Global.userModel.username =
      await SecureStorage.read(key: SecureStorage.phone);
  Global.userModel.otp = await SecureStorage.read(key: SecureStorage.otp);
  LocationService.listen;
  // LocationService.getCurrentPositionStream();
  await LocationService.determinePosition().then((value) {
    LocationModel.latitude = value.latitude;
    LocationModel.longitude = value.longitude;
  });
  await packageInfo().then((value) {
    Global.myPackageInfo.appVersion = value.version;
  });
  // await StompClientInstance.connect();
  await MySharedPrefs()
      .saveConnectorTypeList(connectorTypeList: ['GB/T (AC)', 'GB/T (DC)']);
  // var list = await MySharedPrefs().getConnectorTypeList();
  // log("LIST: $list");
  runApp(EasyLocalization(
      path: 'assets/translations',
      fallbackLocale: uzLocale,
      assetLoader: const CodegenLoader(),
      supportedLocales: const [uzLocale, ruLocale, enLocale, kkLocale],
      child: const MyApp()));
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
      builder: (context, child) => MaterialApp(
        title: 'Smart Car App',
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        navigatorKey: MyApp.navigatorKey,
        theme: ThemeData(primarySwatch: Colors.blue),
        routes: Routes.routesMap(),
        initialRoute: username == null || username == ''
            ? Routes.onBoarding
            : Routes.home,
      ),
    );
  }
}
