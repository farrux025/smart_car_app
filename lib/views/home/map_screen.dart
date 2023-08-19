import 'dart:async';
import 'dart:collection';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_car_app/components/app_components.dart';
import 'package:smart_car_app/components/app_text.dart';
import 'package:smart_car_app/main.dart';
import 'package:smart_car_app/models/global/LocationModel.dart';
import 'package:smart_car_app/utils/functions.dart';
import 'package:smart_car_app/views/home/charge_box_details.dart';
import 'package:smart_car_app/views/home/search.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

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
    // for (var element in widget.list) {
    //   mapObjList.add(_placeMarkMapObject(chargeBox: element));
    // }
    separateChargeBoxList(mapObjList);
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
              height: 50.h,
              margin: EdgeInsets.only(bottom: 24.h, left: 16.w, right: 16.h),
              color: Colors.white,
              child: MaterialButton(
                onPressed: () => openSearchView(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText("Where you are going to",
                        size: 14.sp,
                        textColor:
                            AppColor.backgroundColorDark.withOpacity(0.7),
                        fontWeight: FontWeight.w500),
                    Icon(Icons.search,
                        size: 20.sp, color: AppColor.backgroundColorDark)
                  ],
                ),
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
        openDetails(chargeBox, mapObject);
      },
    );
  }

  void openSearchView() {
    showModalBottomSheet(
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        backgroundColor: AppColor.backgroundColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r))),
        builder: (context) {
          return SearchView(searchList: widget.list);
        });
  }

  void openDetails(ChargeBoxInfo chargeBox, PlacemarkMapObject mapObject) {
    if (mapObject.mapId.value != "map_current") {
      bottomSheet(
          list: _filterChargeBox(
              chargeBoxList: widget.list, point: mapObject.point),
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
    }
    //   if (_filterChargeBox(chargeBoxList: widget.list, point: mapObject.point)
    //           .length >
    //       1) {
    //     openChargeBoxListAlert(_filterChargeBox(
    //         chargeBoxList: widget.list, point: mapObject.point));
    //   } else {
    //     bottomSheet(
    //         chargeBoxId: chargeBox.id ?? '',
    //         point: Point(
    //             latitude: chargeBox.locationLatitude ?? 0,
    //             longitude: chargeBox.locationLongitude ?? 0),
    //         stationName: chargeBox.name ?? '',
    //         address: "${chargeBox.street},\n${chargeBox.city}",
    //         distance: distance(
    //             lat: chargeBox.locationLatitude ?? 0,
    //             lon: chargeBox.locationLongitude ?? 0),
    //         rating: "4.5");
    //   }
    // }
  }

  List<ChargeBoxInfo> _filterChargeBox(
      {required List<ChargeBoxInfo> chargeBoxList, required Point point}) {
    List<ChargeBoxInfo> list = [];
    log("Charge box count: ${chargeBoxList.length}");
    for (var element in chargeBoxList) {
      if (element.locationLatitude == point.latitude &&
          element.locationLongitude == point.longitude) {
        list.add(element);
      }
    }
    for (var element in list) {
      log("Filtered charge box: ${element.name} => ${element.locationLatitude}, ${element.locationLongitude}");
    }
    log("Count of charge boxes: ${list.length}");
    return list;
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

  void separateChargeBoxList(List<MapObject> mapObjList) {
    List<ChargeBoxInfo> mainList = widget.list;
    Set<ChargeBoxInfo> set = HashSet();
    for (var element in mainList) {
      set.add(element);
    }
    for (var element in set) {
      log("Set element: ${element.name} => Lat: ${element.locationLatitude}, Lon: ${element.locationLongitude}");
      mapObjList.add(_placeMarkMapObject(chargeBox: element));
    }
    log("====================================================================");
    log("Set length: ${set.length}");
  }

  void openChargeBoxListAlert(List<ChargeBoxInfo> list) {
    showMenu(
        context: context,
        position: RelativeRect.fill,
        items: List.generate(list.length, (index) {
          ChargeBoxInfo chargeBox = list[index];
          return PopupMenuItem(
              child: MaterialButton(
                  onPressed: () {
                    bottomSheet(
                        list: list,
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
                  child: AppText(list[index].name ?? '')));
        }));
  }
}

void bottomSheet({
  required List<ChargeBoxInfo> list,
  required String chargeBoxId,
  required Point point,
  required String stationName,
  required String rating,
  required String address,
  required String distance,
}) {
  var context = MyApp.navigatorKey.currentState!.context;
  closeKeyboard();
  showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    builder: (context) => ChargeBoxDetailsWidget(
        mainList: list,
        chargeBoxId: chargeBoxId,
        point: point,
        stationName: stationName,
        rating: rating,
        address: address,
        distance: distance),
  );
}
