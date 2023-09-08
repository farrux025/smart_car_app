import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:smart_car_app/components/app_text.dart';
import 'package:smart_car_app/constants/color.dart';
import 'package:smart_car_app/constants/images.dart';

class StartChargingScreen extends StatefulWidget {
  const StartChargingScreen({super.key});

  @override
  State<StartChargingScreen> createState() => _StartChargingScreenState();
}

class _StartChargingScreenState extends State<StartChargingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: AppText("Connection established",
              size: 12.sp,
              textColor: AppColor.textSecondary,
              fontWeight: FontWeight.w400),
          centerTitle: true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: ScreenUtil().screenHeight * 0.4,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                        AppColor.backgroundColorLight, BlendMode.color),
                    child: Image.asset(
                      AppImages.connectorImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                    width: ScreenUtil().screenWidth,
                    bottom: 24.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(AppImages.switchIcon,
                            fit: BoxFit.cover, height: 24, width: 24),
                        SizedBox(width: 10.w),
                        AppText("AC 3.3kw",
                            size: 12.sp,
                            textColor: AppColor.textSecondary,
                            fontWeight: FontWeight.w500)
                      ],
                    ))
              ],
            ),
          ),
          SizedBox(
            height: ScreenUtil().screenHeight * 0.4,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                CircularPercentIndicator(
                  radius: 100.r,
                  percent: 0,
                  lineWidth: 10,
                  backgroundColor: Colors.white,
                  progressColor: AppColor.stationIndicatorColor,
                  center: Padding(
                    padding: EdgeInsets.only(bottom: 70.h),
                    child: AppText("03",
                        size: 70.sp,
                        textColor: AppColor.white,
                        fontWeight: FontWeight.w900),
                  ),
                ),
                Positioned(
                    bottom: -90,
                    left: 20,
                    child: AnimatedScale(
                        duration: const Duration(seconds: 5),
                        scale: 1,
                        child: Image.asset(
                          AppImages.carImage,
                        )))
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: MaterialButton(
        onPressed: () {},
        color: AppColor.stationIndicatorColor,
        height: 57.sp,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        minWidth: ScreenUtil().screenWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText("START CHARGING",
                size: 14.sp,
                textColor: AppColor.white,
                fontWeight: FontWeight.w500),
            Icon(Icons.bolt, size: 24.sp, color: AppColor.white)
          ],
        ),
      ),
    );
  }
}
