import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../components/app_text_form_field.dart';
import '../../constants/color.dart';

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
        image: BitmapDescriptor.fromAssetImage(
            "assets/images/map_point_indicator.png"),
        scale: 3,
      )),
      onTap: (mapObject, point) {
        log(point.latitude.toString());
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
}
