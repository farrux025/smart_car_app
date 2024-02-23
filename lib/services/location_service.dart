import 'dart:async';
import 'dart:developer';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../components/app_components.dart';
import '../main.dart';

class LocationService {
  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // if (!serviceEnabled) {
    //   return Future.error('Location services are disabled.');
    // }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  static StreamSubscription<Position> getCurrentPositionStream() {
    late LocationSettings locationSettings;

    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 0,
          forceLocationManager: true,
          intervalDuration: const Duration(seconds: 10),
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationText:
                "Example app will continue to receive your location even when you aren't using it",
            notificationTitle: "Running in Background",
            enableWakeLock: true,
          ));
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.best,
        activityType: ActivityType.fitness,
        distanceFilter: 0,
        pauseLocationUpdatesAutomatically: true,
        showBackgroundLocationIndicator: false,
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 0,
      );
    }

    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      toast(
          message:
              "Lat: ${position?.latitude.toString()}, Lon: ${position?.longitude.toString()}");
      log(position == null
          ? 'Unknown'
          : 'AAAAA: ${position.latitude.toString()}, BBBBB: ${position.longitude.toString()}');
    });
    return positionStream;
  }

  static var listen = Geolocator.getServiceStatusStream().listen((status) {
    log("Location aaaa status: $status");
    if (status == ServiceStatus.disabled) {
      turnOffGPSAlert(status: status);
    } else if (status == ServiceStatus.enabled) {
      MyApp.navigatorKey.currentState?.pop();
    }
  });
}

turnOffGPSAlert({ServiceStatus? status}) {
  showDialog(
      context: MyApp.navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return alert(
            title: "Geolokatsiya o'chirilgan",
            content:
                "Iltimos, ilovadan foydalanish uchun geolokatsiyani yoqing!",
            buttonText: "OK",
            onPressed: () {
              AppSettings.openAppSettings(type: AppSettingsType.location);
              if (status == ServiceStatus.enabled) {
                MyApp.navigatorKey.currentState?.pop();
              }
            });
      });
}
