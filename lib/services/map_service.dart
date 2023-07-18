import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:smart_car_app/components/app_text.dart';
import 'package:smart_car_app/constants/color.dart';
import 'package:smart_car_app/main.dart';

class MapService {
  static launchMap(
      {required String title, required double lat, required double lon}) async {
    try {
      var availableMaps = await MapLauncher.installedMaps;
      log("Available maps: $availableMaps");
      var coords = Coords(lat, lon);
      showModalBottomSheet(
          context: MyApp.navigatorKey.currentState!.context,
          backgroundColor: AppColor.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r))),
          builder: (BuildContext context) {
            return SafeArea(
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Wrap(children: [
                      for (var map in availableMaps)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 24.h),
                          child: MaterialButton(
                            onPressed: () {
                              map.showMarker(
                                coords: coords,
                                title: title,
                              );
                              MyApp.navigatorKey.currentState?.pop();
                            },
                            padding: EdgeInsets.all(6.sp),
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  map.icon,
                                  height: 60.0,
                                  width: 60.0,
                                ),
                                SizedBox(height: 10.h),
                                AppText(map.mapName,
                                    size: 10.sp,
                                    textColor: AppColor.textColor,
                                    fontWeight: FontWeight.w500)
                              ],
                            ),
                          ),
                        )
                    ])));
          });
    } catch (e) {
      log("Map launcher exception: $e");
    }
  }
}
