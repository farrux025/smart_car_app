import 'dart:async';
import 'dart:collection';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:popup_menu/popup_menu.dart' as popMenu;
import 'package:smart_car_app/components/app_components.dart';
import 'package:smart_car_app/models/global/LocationModel.dart';
import 'package:smart_car_app/utils/functions.dart';
import 'package:smart_car_app/views/home/charge_box_details.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../components/app_text_form_field.dart';
import '../../constants/color.dart';
import '../../constants/images.dart';
import '../../models/charge_box/ChargeBoxInfo.dart';

class MapScreen extends StatefulWidget {
  final List<ChargeBoxInfo> list;

  MapScreen({super.key, required this.list});

  final targetWidgetKey = GlobalKey();

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
    Set<ChargeBoxInfo> set = HashSet(
      equals: (p0, p1) {
        bool check = p0.locationLatitude != p1.locationLatitude &&
            p0.locationLatitude != p1.locationLatitude;
        return check;
      },
    );
    for (var element in widget.list) {
      set.add(element);
      mapObjList.add(_placeMarkMapObject(chargeBox: element));
    }
    List<ChargeBoxInfo> restList = [];
    for (var set in set) {
      for (var list in widget.list) {
        if (set.locationLatitude != list.locationLatitude &&
            set.locationLongitude != list.locationLongitude) {
          restList.add(list);
          mapObjList.add(_placeMarkMapObject(chargeBox: list));
        }
      }
    }
    // for (var element in set) {
    //   mapObjList.add(_placeMarkMapObject(chargeBox: element));
    // }
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
        _filterChargeBox(chargeBoxList: widget.list, point: mapObject.point);

        var menu = popMenu.PopupMenu(
          context: context,
          items: [
            popMenu.MenuItem(title: "sd", image: const Icon(Icons.add)),
            popMenu.MenuItem(title: "sd", image: const Icon(Icons.add)),
          ],
        );
        menu.show(rect: Rect.largest);

        // ContextualMenu(
        //     targetWidgetKey: widget.targetWidgetKey,
        //     items: [
        //       CustomPopupMenuItem(
        //           image: Icon(Icons.add),
        //           press: () {},
        //           textStyle: TextStyle(fontSize: 12.sp),
        //           textAlign: TextAlign.center,
        //           title: "Add"),
        //       CustomPopupMenuItem(
        //           image: Icon(Icons.add),
        //           press: () {},
        //           textStyle: TextStyle(fontSize: 12.sp),
        //           textAlign: TextAlign.center,
        //           title: "Add"),
        //     ],
        //     ctx: context,
        //     child: const SizedBox());

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

  List<ChargeBoxInfo> _filterChargeBox(
      {required List<ChargeBoxInfo> chargeBoxList, required Point point}) {
    List<ChargeBoxInfo> list = [];
    for (var element in chargeBoxList) {
      // log("Lat1: ${element.locationLatitude} <=> Lat2: ${point.latitude}\nLon1: ${element.locationLongitude} <=> Lon2: ${point.longitude}\n");
      if (element.locationLatitude == point.latitude &&
          element.locationLongitude == point.longitude) {
        list.add(element);
      }
    }
    for (var element in list) {
      log("Filtered charge box: ${element.name} => ${element.locationLatitude}, ${element.locationLongitude}");
    }
    return list;
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
