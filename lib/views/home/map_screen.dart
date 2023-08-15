import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_car_app/components/app_components.dart';
import 'package:smart_car_app/components/app_text.dart';
import 'package:smart_car_app/models/global/LocationModel.dart';
import 'package:smart_car_app/services/charge_box_service.dart';
import 'package:smart_car_app/services/map_service.dart';
import 'package:smart_car_app/utils/functions.dart';
import 'package:smart_car_app/views/home/charge_box_details.dart';
import 'package:smart_car_app/views/home/home.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../components/app_text_form_field.dart';
import '../../constants/color.dart';
import '../../constants/images.dart';
import '../../models/charge_box/ChargeBoxInfo.dart';

class MapScreen extends StatefulWidget {
  final List<ChargeBoxInfo> list;

  const MapScreen({super.key, required this.list});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<YandexMapController> _completer = Completer();
  final Point _initialPoint = Point(
      latitude: LocationModel.latitude!, longitude: LocationModel.longitude!);
  List<MapObject> mapObjects = [];
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    List<MapObject> mapObjList = [
      _placeMarkMapObject(
          chargeBox: ChargeBoxInfo(
              id: "map_current",
              locationLatitude: LocationModel.latitude!,
              locationLongitude: LocationModel.longitude!),
          imagePath: AppImages.currentPosition),
    ];
    for (var element in widget.list) {
      mapObjList.add(_placeMarkMapObject(chargeBox: element));
    }
    mapObjects.addAll(mapObjList);
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

  PlacemarkMapObject _placeMarkMapObject(
      {required ChargeBoxInfo chargeBox, String? imagePath}) {
    return PlacemarkMapObject(
      mapId: MapObjectId(chargeBox.id ?? ''),
      point: Point(
          latitude: chargeBox.locationLatitude ?? 0,
          longitude: chargeBox.locationLongitude ?? 0),
      isDraggable: true,
      opacity: 1,
      icon: PlacemarkIcon.single(PlacemarkIconStyle(
        image: BitmapDescriptor.fromAssetImage(
            imagePath ?? AppImages.locationIndicator),
        scale: 3,
      )),
      onTap: (mapObject, point) async {
        toast(message: chargeBox.name.toString());
        log(chargeBox.id.toString());
        bottomSheet(
            chargeBoxId: chargeBox.id ?? '',
            point: Point(
                latitude: chargeBox.locationLatitude ?? 0,
                longitude: chargeBox.locationLongitude ?? 0),
            stationName: chargeBox.name ?? '',
            address: "${chargeBox.street},\n${chargeBox.city}",
            distance: distance(
                lat: chargeBox.locationLatitude ?? 0,
                lon: chargeBox.locationLongitude ?? 0),
            rating: "4.5");
      },
    );
  }

  void bottomSheet({
    required String chargeBoxId,
    required Point point,
    required String stationName,
    required String rating,
    required String address,
    required String distance,
  }) {
    closeKeyboard();
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ChargeBoxDetailsWidget(
          chargeBoxId: chargeBoxId,
          point: point,
          stationName: stationName,
          rating: rating,
          address: address,
          distance: distance),
    );
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
