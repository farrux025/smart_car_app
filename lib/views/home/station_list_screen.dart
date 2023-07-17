import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_car_app/components/app_text.dart';
import 'package:smart_car_app/constants/color.dart';
import 'package:smart_car_app/constants/images.dart';
import 'package:smart_car_app/views/home/home.dart';

class StationListScreen extends StatelessWidget {
  const StationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColorLight,
      body: Column(
        children: [
          SizedBox(height: 100.h),
          Flexible(
            flex: 2,
            child: ListTile(
              leading: Icon(Icons.location_on,
                  color: AppColor.backgroundColorDark, size: 24.sp),
              title: Padding(
                padding: EdgeInsets.only(right: 30.w),
                child: AppText("9502 Belmont Ave. Saint Augustine, FL 32084",
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
                    log("Filter");
                  },
                  child: AppText("Filter",
                      textColor: AppColor.textColor,
                      size: 12.sp,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 20,
            child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) => chargingStation(
                    stationName: "Charging station name goes here $index",
                    distance: "15.4 km",
                    rating: "4.4",
                    energyPower: "AC 3.3kw"),
                itemCount: 10),
          )
        ],
      ),
    );
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
                    child: Image.asset(AppImages.stationPointer,
                        fit: BoxFit.fill)),
                SizedBox(width: 4.w),
                Flexible(
                  flex: 8,
                  child: Column(
                    children: [
                      // station name
                      AppText(stationName,
                          textColor: AppColor.textColor,
                          size: 16.sp,
                          fontWeight: FontWeight.w400,
                          maxLines: 3),
                      SizedBox(height: 12.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // rating
                          ratingWidget(rating: rating),
                          // energy power
                          Row(
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
                Flexible(
                  flex: 3,
                  child: Card(
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColor.lightBlue,
                          borderRadius: BorderRadius.circular(4.r)),
                      padding:
                          EdgeInsets.symmetric(horizontal: 6.w, vertical: 12.h),
                      child: AppText(distance,
                          textColor: AppColor.textColor,
                          fontWeight: FontWeight.w500,
                          size: 12.sp),
                    ),
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
}
