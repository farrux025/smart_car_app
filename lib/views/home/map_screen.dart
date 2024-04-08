import 'dart:async';
import 'dart:collection';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smart_car_app/components/app_components.dart';
import 'package:smart_car_app/components/app_text.dart';
import 'package:smart_car_app/hive/hive_store.dart';
import 'package:smart_car_app/main.dart';
import 'package:smart_car_app/models/global/LocationModel.dart';
import 'package:smart_car_app/services/charge_box_service.dart';
import 'package:smart_car_app/services/shared_prefs.dart';
import 'package:smart_car_app/utils/functions.dart';
import 'package:smart_car_app/views/home/charge_box_details.dart';
import 'package:smart_car_app/views/home/filter.dart';
import 'package:smart_car_app/views/home/search.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../constants/color.dart';
import '../../constants/images.dart';
import '../../cubit/charge_box/charge_boxes_map_cubit.dart';
import '../../models/charge_box/ChargeBoxInfo.dart';
import '../../models/charge_box/connector_types/ConnectorTypes.dart';
import '../../translations/locale_keys.g.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

double? mainLat = LocationModel.latitude;
double? mainLon = LocationModel.longitude;

class _MapScreenState extends State<MapScreen> {
  final Completer<YandexMapController> _completer = Completer();
  final Point _initialPoint = Point(
      latitude: LocationModel.latitude!, longitude: LocationModel.longitude!);
  List<MapObject> mapObjects = [];
  final searchController = TextEditingController();
  List<ChargeBoxInfo> mainList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ChargeBoxesCubit(),
      child: BlocListener<ChargeBoxesCubit, ChargeBoxesMapState>(
        listener: (BuildContext context, state) {
          if (state is ChargeBoxesMapLoaded) {
            log("State is ChargeBoxesLoaded => ${state.list.length} ta");
            mainList = state.list;
          } else if (state is ChargeBoxesMapError) {
            log("State is ChargeBoxesError");
            List<ChargeBoxInfo>? list =
                MyHiveStore.chargeBox.get(MyHiveBoxName.chargeBox);
            mainList = list ?? [];
            log(state.error);
          }
          List<PlacemarkMapObject> mapObjList = [
            // _placeMarkMapObject(
            //     chargeBox: ChargeBoxInfo(
            //         id: "map_current",
            //         locationLatitude: LocationModel.latitude!,
            //         locationLongitude: LocationModel.longitude!),
            //     imagePath: AppImages.currentPosition),
          ];
          // for (var element in widget.list) {
          //   mapObjList.add(_placeMarkMapObject(chargeBox: element));
          // }

          separateChargeBoxList(mapObjList);
          var collection = ClusterizedPlacemarkCollection(
              mapId: const MapObjectId("ssssss"),
              placemarks: mapObjList,
              radius: 50,
              minZoom: 13,
              onClusterAdded: (self, cluster) async {
                return cluster.copyWith(
                    appearance: cluster.appearance.copyWith(
                  icon: PlacemarkIcon.single(PlacemarkIconStyle(
                      image: BitmapDescriptor.fromBytes(
                          await _buildClusterAppearance(cluster)),
                      scale: 3)),
                  opacity: 1,
                  onTap: (mapObject, point) {
                    _zoomIn();
                    // log("message");
                    // mapObject.copyWith();
                  },
                ));
              },
              onClusterTap: (self, cluster) {},
              onTap: (mapObject, point) {});

          mapObjects.add(collection);
        },
        child: BlocBuilder<ChargeBoxesCubit, ChargeBoxesMapState>(
          builder: (context, state) {
            var read = context.read<ChargeBoxesCubit>();
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
                          onCameraPositionChanged:
                              (cameraPosition, reason, finished) async {
                            if (finished) {
                              log("onCameraPositionChanged: ${cameraPosition.target.latitude}, ${cameraPosition.target.longitude}");
                              mainLat = cameraPosition.target.latitude;
                              mainLon = cameraPosition.target.longitude;
                              var zoom = cameraPosition.zoom;
                              _completer.future.then((ymController) {
                                ymController
                                    .getScreenPoint(cameraPosition.target)
                                    .then((screenPoint) {
                                  log("cameraPosition.target: ${cameraPosition.target.latitude}, ${cameraPosition.target.longitude}");
                                  log("ZOOM: $zoom");
                                  log("Screen Point: ${screenPoint?.x}, ${screenPoint?.y}");
                                  ymController
                                      .getPoint(const ScreenPoint(x: 0, y: 0))
                                      .then((sp) async {
                                    log("SP: $sp");
                                    var d = Geolocator.distanceBetween(
                                        sp!.latitude,
                                        sp.longitude,
                                        cameraPosition.target.latitude,
                                        cameraPosition.target.longitude);
                                    log("Distance: $d");
                                    await MySharedPrefs()
                                        .saveDistance(distance: d.toString());
                                    await read.getChargeBoxesForMap(
                                        lat: cameraPosition.target.latitude,
                                        lon: cameraPosition.target.longitude);
                                  });
                                });
                              });
                            }
                          },
                          // onTrafficChanged: (trafficLevel) {
                          //   log("onTrafficChanged: ${trafficLevel?.color} => ${trafficLevel?.level}");
                          // },
                          nightModeEnabled: true),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              bottom: 12.h, left: 12.w, right: 12.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                    height: 32.h,
                                    width: 32.h,
                                    child: FloatingActionButton(
                                      onPressed: () => openFilter(() {
                                        log("Filter pressed");
                                        popBack();
                                        read.getChargeBoxesForMap(
                                            lat: mainLat!, lon: mainLon!);
                                      }, context),
                                      heroTag: 'open-filter',
                                      backgroundColor:
                                          Colors.black.withOpacity(0.5),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.r)),
                                      child: Icon(Icons.filter_alt,
                                          color: AppColor.white, size: 20.sp),
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  SizedBox(
                                    height: 32.h,
                                    width: 32.h,
                                    child: FloatingActionButton(
                                      onPressed: () async =>
                                          await read.getChargeBoxesForMap(
                                              lat: mainLat!, lon: mainLon!),
                                      heroTag: 'refresh',
                                      backgroundColor:
                                          Colors.black.withOpacity(0.5),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.r)),
                                      child: state is ChargeBoxesMapLoading
                                          ? SizedBox(
                                              width: 14.h,
                                              height: 14.h,
                                              child: CircularProgressIndicator(
                                                  color: AppColor.white,
                                                  strokeWidth: 2.4.w),
                                            )
                                          : Icon(Icons.refresh,
                                              color: AppColor.white,
                                              size: 20.sp),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    height: 32.h,
                                    width: 32.h,
                                    child: FloatingActionButton(
                                      onPressed: () => _zoomIn(),
                                      heroTag: 'zoom-in',
                                      backgroundColor:
                                          Colors.black.withOpacity(0.5),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.r)),
                                      child: Icon(Icons.add,
                                          color: AppColor.white, size: 20.sp),
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  SizedBox(
                                    height: 32.h,
                                    width: 32.h,
                                    child: FloatingActionButton(
                                      onPressed: () => _zoomOut(),
                                      heroTag: 'zoom-out',
                                      backgroundColor:
                                          Colors.black.withOpacity(0.5),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.r)),
                                      child: Icon(Icons.remove,
                                          color: AppColor.white, size: 20.sp),
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  SizedBox(
                                    height: 32.h,
                                    width: 32.h,
                                    child: FloatingActionButton(
                                      onPressed: () => _goMyLocation(),
                                      heroTag: 'my-location',
                                      backgroundColor:
                                          Colors.black.withOpacity(0.5),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.r)),
                                      child: Icon(Icons.my_location,
                                          color: AppColor.white, size: 20.sp),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: ScreenUtil().screenWidth,
                          height: 50.h,
                          margin: EdgeInsets.only(
                              bottom: 20.h, left: 16.w, right: 16.h),
                          color: Colors.white,
                          child: MaterialButton(
                            onPressed: () => MySearch.openSearchView(
                                list: mainList,
                                isMap: true,
                                completer: _completer),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText(LocaleKeys.search_title.tr(),
                                    size: 14.sp,
                                    textColor: AppColor.backgroundColorDark
                                        .withOpacity(0.7),
                                    fontWeight: FontWeight.w500),
                                Icon(Icons.search,
                                    size: 20.sp,
                                    color: AppColor.backgroundColorDark)
                              ],
                            ),
                          ),
                        ),
                        state is ChargeBoxesMapError
                            ? Container(
                                color: AppColor.backgroundColorError,
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                width: ScreenUtil().screenWidth,
                                height: 36.h,
                                child: Center(
                                  child: AppText(state.error,
                                      size: 11.sp,
                                      textColor: AppColor.white,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      fontWeight: FontWeight.w400),
                                ),
                              )
                            : const SizedBox()
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _onMapCreated(YandexMapController controller) {
    _completer.complete(controller);
    controller.moveCamera(
        CameraUpdate.newCameraPosition(CameraPosition(target: _initialPoint)));
    controller.moveCamera(CameraUpdate.zoomTo(13));
    controller.toggleUserLayer(visible: true);
    // var screenPoint = controller.getScreenPoint(_initialPoint);
    // screenPoint.then((value) {
    //   log("Screen Point: ${value?.x}, ${value?.y}");
    // });
  }

  PlacemarkMapObject _placeMarkMapObject(
      {required ChargeBoxInfo chargeBox, String? imagePath}) {
    return PlacemarkMapObject(
      mapId: MapObjectId(chargeBox.id.toString() ?? ''),
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

  Future<Uint8List> _buildClusterAppearance(Cluster cluster) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const size = Size(80, 80);
    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = AppColor.textColorGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    const radius = 20.0;

    final textPainter = TextPainter(
        text: TextSpan(
            text: cluster.size.toString(),
            style: TextStyle(
                color: AppColor.textColorGreen,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600)),
        textDirection: ui.TextDirection.ltr);

    textPainter.layout(minWidth: 0, maxWidth: size.width);

    final textOffset = Offset((size.width - textPainter.width) / 2,
        (size.height - textPainter.height) / 2);
    final circleOffset = Offset(size.height / 2, size.width / 2);

    canvas.drawCircle(circleOffset, radius, fillPaint);
    canvas.drawCircle(circleOffset, radius, strokePaint);
    textPainter.paint(canvas, textOffset);

    final image = await recorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());
    final pngBytes = await image.toByteData(format: ui.ImageByteFormat.png);

    return pngBytes!.buffer.asUint8List();
  }

  void openDetails(ChargeBoxInfo chargeBox, PlacemarkMapObject mapObject) {
    if (mapObject.mapId.value != "map_current") {
      bottomSheet(
          list:
              _filterChargeBox(chargeBoxList: mainList, point: mapObject.point),
          chargeBoxId: chargeBox.id ?? 0,
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

  Future<void> _goMyLocation() async {
    YandexMapController yandexMapController = await _completer.future;
    Geolocator.getCurrentPosition().then((pos) {
      yandexMapController.moveCamera(
          CameraUpdate.newCameraPosition(CameraPosition(
              target: Point(latitude: pos.latitude, longitude: pos.longitude))),
          animation:
              const MapAnimation(type: MapAnimationType.linear, duration: 1));
    });
  }

  void separateChargeBoxList(List<MapObject> mapObjList) {
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
                        chargeBoxId: chargeBox.id ?? 0,
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

  static List<ConnectorTypes> connectorTypeList = [
    ConnectorTypes(
        id: "Type 1",
        logos: [ConnectorTypeLogos(url: "https://iili.io/JctlDkN.png")]),
    ConnectorTypes(
        id: "Type 2",
        logos: [ConnectorTypeLogos(url: "https://iili.io/JctlDkN.png")]),
    ConnectorTypes(
        id: "Type 3",
        logos: [ConnectorTypeLogos(url: "https://iili.io/JctlDkN.png")]),
  ];
}

openFilter(ui.VoidCallback onFilterPressed, BuildContext context) async {
  await ChargeBoxService.doGetConnectorTypes().then((response) {
    if (response.statusCode == 200) {
      List<ConnectorTypes> connectors = [];
      response.data.forEach((element) {
        ConnectorTypes connectorType = ConnectorTypes.fromJson(element);
        connectors.add(connectorType);
      });
      showModalBottomSheet(
        context: context,
        barrierColor: Colors.transparent.withOpacity(0.5),
        builder: (context) => BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: FilterWidget(
            connectorTypeList: connectors,
            onFilterPressed: onFilterPressed,
          ),
        ),
      );
    } else {
      openSnackBar(message: 'Error while getting connector types');
    }
  });
}

void bottomSheet({
  required List<ChargeBoxInfo> list,
  required num chargeBoxId,
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
    isScrollControlled: true,
    barrierColor: Colors.transparent.withOpacity(0.5),
    backgroundColor: Colors.transparent,
    builder: (context) => BackdropFilter(
      filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: ChargeBoxDetailsWidget(
          mainList: list,
          chargeBoxId: chargeBoxId,
          point: point,
          stationName: stationName,
          rating: rating,
          address: address,
          distance: distance),
    ),
  );
}
