import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_car_app/components/app_text.dart';
import 'package:smart_car_app/views/home/home.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../components/app_text_form_field.dart';
import '../../constants/color.dart';
import '../../constants/images.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<YandexMapController> _completer = Completer();
  final Point _initialPoint =
      const Point(latitude: 41.328158265919704, longitude: 69.2353407464624);
  List<MapObject> mapObjects = [];
  final searchController = TextEditingController();

  PlacemarkMapObject _placeMarkMapObject(
      {required String mapObjectId, required double lat, required double lon}) {
    return PlacemarkMapObject(
      mapId: MapObjectId(mapObjectId),
      point: Point(latitude: lat, longitude: lon),
      isDraggable: true,
      opacity: 1,
      icon: PlacemarkIcon.single(PlacemarkIconStyle(
        image: BitmapDescriptor.fromAssetImage(AppImages.locationIndicator),
        scale: 3,
      )),
      onTap: (mapObject, point) {
        log(point.latitude.toString());
        bottomSheet(stationName: "Charging station name goes here",address: "9502 Belmont Ave. Saint Augustine, FL 32084",distance: "5km Away",rating: "4.5");
      },
    );
  }

  @override
  void initState() {
    super.initState();
    List<MapObject> list = [
      _placeMarkMapObject(
          mapObjectId: "map_1", lat: 41.355190986894705, lon: 69.2516485364611),
      _placeMarkMapObject(
          mapObjectId: "map_2",
          lat: 41.344301926904556,
          lon: 69.20916234695063),
      _placeMarkMapObject(
          mapObjectId: "map_3",
          lat: 41.324838834978976,
          lon: 69.23027669567703),
      _placeMarkMapObject(
          mapObjectId: "map_4", lat: 41.32064899838631, lon: 69.25345098086459),
      _placeMarkMapObject(
          mapObjectId: "map_5", lat: 41.34372198505876, lon: 69.23190747870876),
    ];
    mapObjects.addAll(list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: SizedBox(
              height: ScreenUtil().screenHeight,
              child: YandexMap(
                  onMapCreated: _onMapCreated,
                  mapObjects: mapObjects,
                  nightModeEnabled: true),
            ),
          ),
          Positioned(
            bottom: 4,
            right: 4,
            left: 4,
            child: Container(
              width: ScreenUtil().screenWidth,
              margin: EdgeInsets.only(bottom: 24.h, left: 24.w, right: 24.h),
              color: Colors.white,
              child: AppTextFormField(
                hint: "Where you are going to",
                keyboardType: TextInputType.text,
                textEditingController: searchController,
                autoFocus: false,
                suffixIcon: Icon(Icons.search,
                    size: 20.sp, color: AppColor.backgroundColorDark),
              ),
            ),
          )
        ],
      ),
    );
  }

  void bottomSheet({
    required String stationName,
    required String rating,
    required String address,
    required String distance,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Scaffold(
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  // name & rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(stationName,
                          size: 24.sp,
                          textColor: AppColor.textColor,
                          fontWeight: FontWeight.w600),
                      ratingWidget(rating: rating)
                    ],
                  ),
                  SizedBox(height: 20.h),
                  // address & distance
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 7,
                        child: Row(
                          children: [
                            Icon(Icons.location_on,
                                size: 24.sp, color: Colors.black),
                            SizedBox(width: 8.w),
                            AppText(address,
                                textColor: AppColor.textColor,
                                size: 12.sp,
                                fontWeight: FontWeight.w400,
                                maxLines: 3)
                          ],
                        ),
                      ),
                      Flexible(
                          flex: 3,
                          child: AppText(distance,
                              textColor: AppColor.textColor,
                              size: 12.sp,
                              fontWeight: FontWeight.w700))
                    ],
                  ),
                  SizedBox(height: 20.h),
                  // available connector
                  AppText("Available Connector",
                      textColor: AppColor.textColor.withOpacity(0.8),
                      size: 11.sp,
                      fontWeight: FontWeight.w400),
                  SizedBox(height: 6.h),
                  Row(
                    children: [connectorItem(power: "AC 3.3kw",iconPath: AppImages.switchIconGreen,textColor: AppColor.textColorGreen)],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onMapCreated(YandexMapController controller) {
    _completer.complete(controller);
    controller.moveCamera(
        CameraUpdate.newCameraPosition(CameraPosition(target: _initialPoint)));
    controller.moveCamera(CameraUpdate.zoomTo(13));
  }

  Future<void> _zoomIn() async {
    YandexMapController yandexMapController = await _completer.future;
    yandexMapController.moveCamera(CameraUpdate.zoomIn());
    // setState(() {
    //   mapObjects.add(placeMarkMapObject);
    // });
  }

  Future<void> _zoomOut() async {
    YandexMapController yandexMapController = await _completer.future;
    yandexMapController.moveCamera(CameraUpdate.zoomOut());
  }

  connectorItem(
      {required String power,
      required String iconPath,
      Color? background,
      Color? textColor}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
          color: background ?? AppColor.white,
          borderRadius: BorderRadius.circular(3.r)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(iconPath, fit: BoxFit.fill),
          AppText(
            power,
            textColor: textColor ?? Colors.black,
            size: 14.sp,
            fontWeight: FontWeight.w500,
          )
        ],
      ),
    );
  }
}
