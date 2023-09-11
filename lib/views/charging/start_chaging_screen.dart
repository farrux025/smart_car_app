import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:smart_car_app/components/app_components.dart';
import 'package:smart_car_app/components/app_text.dart';
import 'package:smart_car_app/constants/color.dart';
import 'package:smart_car_app/constants/images.dart';
import 'package:smart_car_app/constants/routes.dart';
import 'package:smart_car_app/main.dart';

class StartChargingScreen extends StatefulWidget {
  const StartChargingScreen({super.key});

  @override
  State<StartChargingScreen> createState() => _StartChargingScreenState();
}

class _StartChargingScreenState extends State<StartChargingScreen> {
  double _bottomPositioned = -240.h;
  double width = ScreenUtil().screenWidth;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() => _bottomPositioned = -width * 0.2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColorLight,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: AppText("Connection established",
              size: 12.sp,
              textColor: AppColor.textSecondary,
              fontWeight: FontWeight.w400),
          centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              // color: AppColor.backgroundColorDark,
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
                  // Positioned(
                  //     bottom: 1.w,
                  //     width: ScreenUtil().screenWidth * 0.505,
                  //     child: Container(
                  //       width: 1.w,
                  //       height: 70.h,
                  //       decoration: BoxDecoration(
                  //           color: Colors.transparent,
                  //           border: Border(
                  //               right: BorderSide(
                  //                   color: AppColor.stationIndicatorColor,
                  //                   width: 3.w,
                  //                   style: BorderStyle.solid))),
                  //     )),
                  Positioned(
                      width: ScreenUtil().screenWidth,
                      bottom: 32.h,
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
                      )),
                  Positioned(
                    bottom: 1.w,
                    width: ScreenUtil().screenWidth,
                    child: Center(
                        child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          color: AppColor.stationIndicatorColor,
                          borderRadius: BorderRadius.circular(40.r)),
                      child:
                          Icon(Icons.check, color: Colors.white, size: 18.sp),
                    )),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20.h),
              height: ScreenUtil().screenHeight * 0.45,
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
                  AnimatedPositioned(
                    duration: const Duration(seconds: 2),
                    bottom: _bottomPositioned,
                    left: 20,
                    child: Image.asset(
                      AppImages.carImage,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: MaterialButton(
        onPressed: () {
          toast(message: "START CHARGING");
          MyApp.navigatorKey.currentState?.pushNamed(Routes.chargingDetails);
        },
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

  Widget _line() {
    for (int i = 0; i < 10; i++) {
      return Container(
          width: 1.w, height: 3.h, color: AppColor.stationIndicatorColor);
    }
    return const SizedBox();
  }
}
