import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_car_app/components/app_text.dart';
import 'package:smart_car_app/constants/color.dart';
import 'package:smart_car_app/constants/images.dart';
import 'package:smart_car_app/cubit/charge_box/charge_boxes_list_cubit.dart';
import 'package:smart_car_app/cubit/charge_box/charge_boxes_map_cubit.dart';
import 'package:smart_car_app/hive/hive_store.dart';
import 'package:smart_car_app/models/global/LocationModel.dart';
import 'package:smart_car_app/services/charge_box_service.dart';
import 'package:smart_car_app/utils/functions.dart';
import 'package:smart_car_app/views/home/home.dart';
import 'package:smart_car_app/views/home/search.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../components/app_components.dart';
import '../../models/charge_box/ChargeBoxInfo.dart';
import '../../translations/locale_keys.g.dart';
import 'map_screen.dart';

class StationListScreen extends StatefulWidget {
  const StationListScreen({super.key});

  @override
  State<StationListScreen> createState() => _StationListScreenState();
}

class _StationListScreenState extends State<StationListScreen> {
  List<ChargeBoxInfo> chargeBoxList = [];
  String address = '';
  int _page = 0;
  bool hasMore = true;

  // bool hasData = false;
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      _getAddress().then((value) {
        var placemark = value[0];
        setState(() {
          log("Address: $placemark");
          address =
              "${placemark.subLocality} ${placemark.locality}, ${placemark.country}";
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var box = Hive.box<List<ChargeBoxInfo>>(MyHiveBoxName.chargeBoxForList);
    return BlocProvider(
      create: (BuildContext context) => ChargeBoxesListCubit(),
      child: BlocListener<ChargeBoxesListCubit, ChargeBoxesListState>(
        listener: (BuildContext context, state) {
          if (state is ChargeBoxesListLoading) {
            log("State is ChargeBoxesListLoading");
          } else if (state is ChargeBoxesListLoaded) {
            log("State is ChargeBoxesListLoaded => ${state.list.length} ta");
            chargeBoxList.addAll(state.list);
            hasMore = false;
            // if (state.list.length < _page) {
            //   hasMore = false;
            // }
          } else if (state is ChargeBoxesListError) {
            log("State is ChargeBoxesListError");
            List<ChargeBoxInfo>? list = MyHiveStore.chargeBoxForList
                .get(MyHiveBoxName.chargeBoxForList);
            chargeBoxList = list ?? [];
            log(state.error);
            openSnackBar(message: state.error);
          }
        },
        child: BlocBuilder<ChargeBoxesListCubit, ChargeBoxesListState>(
          builder: (context, state) {
            var read = context.read<ChargeBoxesListCubit>();
            // scrollController.addListener(() {
            //   if (scrollController.position.maxScrollExtent ==
            //       scrollController.offset) {
            //     if (hasMore) {
            //       _page++;
            //       read.getChargeBoxesForList(
            //           lat: LocationModel.latitude!,
            //           lon: LocationModel.longitude!,
            //           page: _page);
            //     }
            //   }
            // });
            return Scaffold(
              backgroundColor: AppColor.backgroundColorLight,
              body: Column(
                children: [
                  SizedBox(height: 100.h),
                  Flexible(
                    flex: 2,
                    child: ListTile(
                      leading: Padding(
                        padding: EdgeInsets.only(left: 18.w),
                        child: SvgPicture.asset(AppImages.locationPointerSvg,
                            height: 18.sp,
                            alignment: Alignment.centerRight,
                            fit: BoxFit.cover,
                            width: 15.sp),
                      ),
                      title: Padding(
                        padding: EdgeInsets.only(right: 30.w),
                        child: AppText(address,
                            maxLines: 3,
                            size: 12.sp,
                            fontWeight: FontWeight.w400,
                            textColor: AppColor.textColor),
                      ),
                      trailing: Container(
                        height: 26.h,
                        width: 74.w,
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColor.textColor),
                            borderRadius: BorderRadius.circular(3.r)),
                        child: MaterialButton(
                          onPressed: () {
                            openFilter(() {
                              chargeBoxList.clear();
                              log("Filter pressed");
                              popBack();
                              read.getChargeBoxesForList(
                                  lat: mainLat, lon: mainLon);
                            }, context);
                            // ChargeBoxService.doGetChargeBoxesForList(
                            //     distance: '1000000',
                            //     lat: '41.2154',
                            //     lon: '69.12514');
                            // MySearch.openSearchView(
                            //   list: list ?? [], isMap: false);
                          },
                          child: AppText(LocaleKeys.filter.tr(),
                              textColor: AppColor.textColor,
                              size: 12.sp,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 22,
                    child: RefreshIndicator(
                      onRefresh: () async {
                        hasMore = true;
                        _page = 0;
                        chargeBoxList.clear();
                        read.getChargeBoxesForList(
                            lat: LocationModel.latitude,
                            lon: LocationModel.longitude,
                            page: _page);
                        // await ChargeBoxesCubit()
                        //     .getChargeBoxesForMap(lat: mainLat!, lon: mainLon!);
                      },
                      color: AppColor.backgroundColorDark,
                      child: ListView.builder(
                          controller: scrollController,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            if (index < chargeBoxList.length) {
                              var chargeBox = chargeBoxList[index];
                              return GestureDetector(
                                onTap: () => _onItemTap(chargeBox),
                                child: chargingStation(
                                    stationName: chargeBox.name ?? '',
                                    distance: distance(
                                            lat:
                                                chargeBox.locationLatitude ?? 0,
                                            lon: chargeBox.locationLongitude ??
                                                0)
                                        .replaceAll(
                                            " ${LocaleKeys.away.tr()}", ""),
                                    rating: "4.4",
                                    energyPower: "AC 3.3kw"),
                              );
                            } else {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 18.h),
                                child: Center(
                                    child: hasMore
                                        ? const CircularProgressIndicator(
                                            color: AppColor.backgroundColorDark)
                                        : const SizedBox()),
                              );
                            }
                          },
                          itemCount: chargeBoxList.length + 1),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
    // return ValueListenableBuilder(
    //   valueListenable: box.listenable(),
    //   builder: (context, value, child) {
    //     list = box.get(MyHiveBoxName.chargeBoxForList);
    //     log("Charge boxes count: ${list?.length}");
    //     return ;
    //   },
    // );
  }

  _onItemTap(ChargeBoxInfo item) {
    bottomSheet(
        list: [item],
        chargeBoxId: item.id ?? 0,
        point: Point(
            latitude: item.locationLatitude ?? 0,
            longitude: item.locationLongitude ?? 0),
        stationName: item.name ?? '',
        address: "${item.street},\n${item.city}",
        distance: distance(
            lat: item.locationLatitude ?? 0, lon: item.locationLongitude ?? 0),
        rating: "4.5");
  }

  chargingStation({
    required String stationName,
    required String distance,
    required String rating,
    required String energyPower,
  }) {
    return Column(
      children: [
        Card(
          margin: EdgeInsets.symmetric(horizontal: 12.sp),
          elevation: 2.sp,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
          child: Container(
            padding: EdgeInsets.all(12.sp),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.r),
                color: AppColor.white),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                    flex: 2,
                    child: SvgPicture.asset(AppImages.stationPointerSvg,
                        height: 30.h, width: 26.w, fit: BoxFit.fill)),
                SizedBox(width: 4.w),
                Flexible(
                  flex: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // station name
                      AppText(stationName,
                          textColor: AppColor.textColor,
                          size: 16.sp,
                          fontFamily: 'RobotoCondense',
                          fontWeight: FontWeight.w400,
                          maxLines: 3),
                      SizedBox(height: 12.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // rating
                          ratingWidget(rating: rating),
                          // energy power
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(AppImages.switchIcon,
                                  fit: BoxFit.fill),
                              SizedBox(width: 6.w),
                              AppText(energyPower,
                                  textColor: AppColor.textColor,
                                  size: 12.sp,
                                  fontWeight: FontWeight.w500),
                              Icon(Icons.keyboard_arrow_down,
                                  color: AppColor.textColor, size: 20.sp)
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 4.w),
                Card(
                  child: Container(
                    width: 70.w,
                    decoration: BoxDecoration(
                        color: AppColor.lightBlue,
                        borderRadius: BorderRadius.circular(4.r)),
                    padding:
                        EdgeInsets.symmetric(horizontal: 6.w, vertical: 12.h),
                    child: AppText(distance,
                        textAlign: TextAlign.center,
                        textColor: AppColor.textColor,
                        fontWeight: FontWeight.w600,
                        size: 11.sp),
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(height: 10.h),
      ],
    );
  }

  Future<List<Placemark>> _getAddress() async {
    try {
      double latitude = 0;
      double longitude = 0;
      await Geolocator.getCurrentPosition().then((pos) {
        latitude = pos.latitude;
        longitude = pos.longitude;
      });
      return await placemarkFromCoordinates(latitude, longitude);
    } catch (error) {
      log("Error while get address: $error");
      openSnackBar(message: error.toString());
      return [];
    }
  }
}
