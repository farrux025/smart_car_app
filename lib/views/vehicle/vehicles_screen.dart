import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:smart_car_app/components/app_text.dart';
import 'package:smart_car_app/constants/color.dart';
import 'package:smart_car_app/constants/images.dart';

class VehiclesScreen extends StatelessWidget {
  const VehiclesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: const BackButton(color: Colors.black)),
      body: SingleChildScrollView(
        child: Container(
          height: ScreenUtil().screenHeight,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.h),
                  child: AppText("MY VEHICLES",
                      textColor: AppColor.textColor,
                      size: 22.sp,
                      fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(height: 16.h),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.h),
                  child: AppText(
                      "Monotonectally implement resource-leveling experiences",
                      textColor: AppColor.buttonRightColor,
                      size: 14.sp,
                      maxLines: 3,
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(height: 20.h),
              Flexible(
                flex: 10,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return _itemGridView(
                        vehicleName: "BMW X5",
                        imagePath: AppImages.currentPosition);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemGridView(
      {required String vehicleName, required String imagePath}) {
    return Container(
      height: 200.h,
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: AppColor.backgroundColorLight),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                child: AppText(vehicleName,
                    textColor: Colors.black,
                    size: 16.sp,
                    fontWeight: FontWeight.w400),
              ),
              Image.asset(imagePath, fit: BoxFit.cover)
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
                    flex: 4,
                    child: LinearPercentIndicator(
                      barRadius: Radius.circular(10.r),
                      percent: 0.8,
                      lineHeight: 5.h,
                      backgroundColor: AppColor.backgroundColor,
                      progressColor: AppColor.stationIndicatorColor,
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: AppText("80%",
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
    );
  }
}
