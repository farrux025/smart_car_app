import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_car_app/cubit/charge_box/details_cubit.dart';
import 'package:smart_car_app/models/charge_box/details/Images.dart';
import 'package:smart_car_app/models/charge_box/details/PublicDetails.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../components/app_text.dart';
import '../../constants/color.dart';
import '../../constants/images.dart';
import '../../services/map_service.dart';
import 'home.dart';

class ChargeBoxDetailsWidget extends StatefulWidget {
  final String chargeBoxId;
  final Point point;
  final String stationName;
  final String rating;
  final String address;
  final String distance;

  const ChargeBoxDetailsWidget({
    super.key,
    required this.chargeBoxId,
    required this.point,
    required this.stationName,
    required this.rating,
    required this.address,
    required this.distance,
  });

  @override
  State<ChargeBoxDetailsWidget> createState() => _ChargeBoxDetailsWidgetState();
}

class _ChargeBoxDetailsWidgetState extends State<ChargeBoxDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenUtil().screenHeight,
      width: ScreenUtil().screenWidth,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
                backgroundColor: Colors.transparent,
                toolbarHeight: 20.h,
                leading: const SizedBox(),
                elevation: 0),
            body: Container(
              color: AppColor.white,
              child: BlocProvider(
                create: (context) => DetailsCubit(widget.chargeBoxId),
                child: BlocListener<DetailsCubit, DetailsState>(
                  listener: (context, state) {},
                  child: BlocBuilder<DetailsCubit, DetailsState>(
                    builder: (context, state) {
                      if (state is DetailsInitial) {
                        return const Center(
                            child: CircularProgressIndicator(
                                color: AppColor.backgroundColorDark));
                      } else if (state is DetailsError) {
                        return Center(
                            child: AppText("Error",
                                textColor: AppColor.errorColor,
                                size: 14.sp,
                                fontWeight: FontWeight.w500));
                      }
                      PublicDetails? details =
                          state is DetailsLoaded ? state.details : null;
                      return Container(
                        color: AppColor.white,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 32.h),
                                // name & rating
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 2,
                                      child: AppText(widget.stationName,
                                          size: 24.sp,
                                          textColor: AppColor.textColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      width: 70.sp,
                                      child:
                                          ratingWidget(rating: widget.rating),
                                    )
                                  ],
                                ),
                                SizedBox(height: 24.h),
                                // address & distance
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      flex: 7,
                                      child: Row(
                                        children: [
                                          Icon(Icons.location_on,
                                              size: 24.sp, color: Colors.black),
                                          SizedBox(width: 8.w),
                                          SizedBox(
                                            width:
                                                ScreenUtil().screenWidth * 0.5,
                                            child: AppText(widget.address,
                                                textColor: AppColor.textColor,
                                                size: 12.sp,
                                                fontWeight: FontWeight.w400,
                                                maxLines: 6),
                                          )
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                        flex: 3,
                                        child: AppText(widget.distance,
                                            textColor: AppColor.textColor,
                                            size: 12.sp,
                                            textAlign: TextAlign.center,
                                            fontWeight: FontWeight.w700))
                                  ],
                                ),
                                SizedBox(height: 40.h),
                                // available connector
                                AppText("Available Connector",
                                    textColor:
                                        AppColor.textColor.withOpacity(0.9),
                                    size: 12.sp,
                                    fontWeight: FontWeight.w500),
                                SizedBox(height: 16.h),
                                Row(
                                  children: [
                                    Expanded(
                                        child: connectorItem(
                                            power: "AC 3.3kw",
                                            bottomText: "Available",
                                            iconPath: AppImages.switchIconGreen,
                                            textColor: AppColor.textColorGreen,
                                            background:
                                                AppColor.backgroundColorGreen)),
                                    SizedBox(width: 6.w),
                                    Expanded(
                                        child: connectorItem(
                                            power: "DC 3.3kw",
                                            bottomText: "Occupied",
                                            iconPath: AppImages.switchIconRed,
                                            textColor: AppColor.textColorRed,
                                            background:
                                                AppColor.backgroundColorRed)),
                                  ],
                                ),
                                SizedBox(height: 16.h),
                                _imageList(details?.data?.images),
                                SizedBox(height: 24.h),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Row(
              children: [
                Expanded(
                    child: MaterialButton(
                  onPressed: () {
                    log("BOOK NOW");
                  },
                  height: 48.h,
                  color: AppColor.errorColor,
                  child: AppText("BOOK NOW",
                      size: 14.sp,
                      textColor: AppColor.white,
                      fontWeight: FontWeight.w500),
                )),
                SizedBox(width: 2.w),
                Expanded(
                    child: MaterialButton(
                  onPressed: () {
                    log("NAVIGATE");
                    // MyApp.navigatorKey.currentState?.pop();
                    MapService.launchMap(
                        title: "Test",
                        lat: widget.point.latitude,
                        lon: widget.point.longitude);
                  },
                  color: AppColor.textColor,
                  height: 48.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText("NAVIGATE",
                          size: 14.sp,
                          textColor: AppColor.white,
                          fontWeight: FontWeight.w500),
                      SizedBox(width: 8.w),
                      Image.asset(AppImages.navigatorIcon, fit: BoxFit.fill)
                    ],
                  ),
                )),
              ],
            ),
          ),
          Positioned(
              left: 30,
              child: Image.asset(AppImages.stationPointer,
                  fit: BoxFit.fill, height: 44.h, width: 36.w)),
        ],
      ),
    );
  }

  connectorItem(
      {required String power,
      required String iconPath,
      String? bottomText,
      Color? background,
      Color? textColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
        ),
        SizedBox(height: 6.h),
        AppText(bottomText ?? '',
            size: 10.sp,
            textColor: AppColor.buttonRightColor,
            fontWeight: FontWeight.w400)
      ],
    );
  }

  _imageList(List<Images>? images) {
    return images != null
        ? SizedBox(
            height: 60.h,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return images[index].url != null
                      ? Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r)),
                          child: Image.network(images[index].url ?? '',
                              fit: BoxFit.fill),
                        )
                      : const SizedBox();
                },
                separatorBuilder: (context, index) => SizedBox(width: 10.w),
                itemCount: images.length),
          )
        : const SizedBox();
  }
}
