import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:smart_car_app/components/app_components.dart';
import 'package:smart_car_app/components/app_text.dart';
import 'package:smart_car_app/constants/color.dart';
import 'package:smart_car_app/constants/images.dart';
import 'package:smart_car_app/views/vehicle/vehicle_detail_screen.dart';

import '../../constants/routes.dart';
import '../../main.dart';
import '../../models/vehicle/VehicleModel.dart';
import '../../translations/locale_keys.g.dart';

class VehiclesScreen extends StatelessWidget {
  const VehiclesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<VehicleModel> vehicleList = [];
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: const BackButton(color: Colors.black)),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.h),
                child: AppText(LocaleKeys.MY_VEHICLES.tr(),
                    textColor: AppColor.textColor,
                    size: 22.sp,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.h),
                child: AppText(
                    "Monotonectally implement resource-leveling experiences",
                    textColor: AppColor.buttonRightColor,
                    size: 14.sp,
                    maxLines: 3,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 20.h),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: 180.h, crossAxisCount: 2),
                itemCount: vehicleList.length + 1,
                itemBuilder: (context, index) {
                  return index == vehicleList.length
                      ? _addVehicle()
                      : _itemGridView(
                          vehicle: vehicleList[index], index: index);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemGridView({required VehicleModel vehicle, required int index}) {
    return GestureDetector(
      onTap: () => _onCarPressed(index),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: AppColor.backgroundColorLight),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: AppText(vehicle.vehicleName ?? '',
                      textColor: Colors.black,
                      size: 16.sp,
                      fontWeight: FontWeight.w400),
                ),
                Image.asset(vehicle.imagePath ?? AppImages.currentPosition,
                    height: 100.h, fit: BoxFit.cover)
              ],
            ),
            Positioned(
              bottom: 16.h,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  color: AppColor.white,
                ),
                padding: EdgeInsets.symmetric(vertical: 4.h),
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                width: ScreenUtil().screenWidth * 0.35,
                child: Row(
                  children: [
                    Flexible(
                      flex: 5,
                      child: LinearPercentIndicator(
                        barRadius: Radius.circular(10.r),
                        percent: vehicle.chargeValue,
                        lineHeight: 5.h,
                        backgroundColor: AppColor.backgroundColor,
                        progressColor: AppColor.stationIndicatorColor,
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: AppText("${(vehicle.chargeValue * 100).toInt()}%",
                          size: 10.sp,
                          textColor: AppColor.buttonLeftColor,
                          fontWeight: FontWeight.w400),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _onCarPressed(int index) {
    switch (index) {
      case 0:
        MyApp.navigatorKey.currentState?.push(MaterialPageRoute(
          builder: (context) => const VehicleDetailScreen(),
        ));
        break;
    }
  }

  Widget _addVehicle() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: AppColor.backgroundColorLight),
      child: MaterialButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        onPressed: () {
          toast(message: "Ishlab chiqish jarayonida");
          // toast(message: LocaleKeys.ADD_VEHICLE.tr());
          // MyApp.navigatorKey.currentState?.pushNamed(Routes.addVehicle);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Colors.black, size: 36.sp),
            SizedBox(height: 12.h),
            AppText(LocaleKeys.ADD_VEHICLE.tr(),
                size: 14.sp,
                textColor: Colors.black,
                fontWeight: FontWeight.w500,
                maxLines: 2)
          ],
        ),
      ),
    );
  }
}
