import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:smart_car_app/components/app_text.dart';
import 'package:smart_car_app/constants/color.dart';
import 'package:smart_car_app/constants/images.dart';
import 'package:smart_car_app/main.dart';
import 'package:smart_car_app/views/charging/connected_or_disconnected_screen.dart';

import '../../components/app_components.dart';

class ChargingDetailsScreen extends StatefulWidget {
  const ChargingDetailsScreen({super.key});

  @override
  State<ChargingDetailsScreen> createState() => _ChargingDetailsScreenState();
}

class _ChargingDetailsScreenState extends State<ChargingDetailsScreen> {
  double width = ScreenUtil().screenWidth;
  double _bottomPositioned = -300.h;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() => _bottomPositioned = -width * 0.3);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColorLight,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Container(
          margin: EdgeInsets.all(10.sp),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5.r)),
          child: IconButton(
              onPressed: () => MyApp.navigatorKey.currentState?.pop(),
              padding: const EdgeInsets.all(0),
              color: Colors.white,
              icon: Icon(Icons.close, color: Colors.black, size: 20.sp)),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding:
              EdgeInsets.symmetric(horizontal: ScreenUtil().screenWidth * 0.07),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: AppText(
                  "Your car is in charging mood. Don't unplug cable",
                  size: 14.sp,
                  textColor: AppColor.textSecondary,
                  fontWeight: FontWeight.w400,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 24.h),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(4.r)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _commonMaterials(isImage: true, info: 'AC 3.3kw'),
                    _commonMaterials(
                        isImage: false,
                        icon: Icons.calendar_today_outlined,
                        info: '10 Aug'),
                    _commonMaterials(
                        isImage: false,
                        icon: Icons.access_time,
                        info: '6:00 pm'),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _chargingMainInfo(
                      mainInfo: '100%',
                      info: 'Charging',
                      topWidget: Image.asset(
                        AppImages.stationPointer,
                        fit: BoxFit.cover,
                      )),
                  _chargingMainInfo(
                    mainInfo: '15:34',
                    info: 'Time left',
                  ),
                  _chargingMainInfo(
                      mainInfo: '55.99',
                      info: 'Amount left',
                      leftPositioned: 20.w,
                      topWidget: SizedBox(
                        width: 80.w,
                        height: 21.h,
                        child: MaterialButton(
                          onPressed: () {},
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          color: AppColor.textColorRed,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.r)),
                          child: AppText("Recharge now",
                              size: 9.sp, textColor: AppColor.white),
                        ),
                      )),
                ],
              ),
              SizedBox(height: 40.h),
              Container(
                padding: EdgeInsets.only(top: 1.h),
                height: ScreenUtil().screenHeight * 0.5,
                width: ScreenUtil().screenWidth,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    CircularPercentIndicator(
                      radius: 130.r,
                      percent: 0.9,
                      lineWidth: 10,
                      backgroundColor: Colors.white,
                      progressColor: AppColor.stationIndicatorColor,
                      center: Padding(
                        padding: EdgeInsets.only(bottom: 80.h),
                        child: AppText("90%",
                            size: 60.sp,
                            textColor: AppColor.white,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: const Duration(seconds: 2),
                      bottom: _bottomPositioned,
                      left: ScreenUtil().screenWidth * 0.13,
                      child: Image.asset(
                        AppImages.carImage,
                        fit: BoxFit.cover,
                        width: ScreenUtil().screenWidth * 0.5,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: MaterialButton(
        onPressed: () {
          toast(message: "STOP CHARGING");
          MyApp.navigatorKey.currentState?.push(MaterialPageRoute(
            builder: (context) => ConnectedOrDisconnectedScreen(
                title: 'CONNECTED',
                description:
                    'The connection is successfully established between your car and with the charger',
                icon: Icons.check,
                iconColor: AppColor.stationIndicatorColor),
          ));
        },
        color: AppColor.textColorRed,
        height: 57.sp,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        minWidth: ScreenUtil().screenWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText("STOP CHARGING",
                size: 14.sp,
                textColor: AppColor.white,
                fontWeight: FontWeight.w500),
            Icon(Icons.bolt, size: 24.sp, color: AppColor.white)
          ],
        ),
      ),
    );
  }

  _commonMaterials(
      {IconData? icon, required bool isImage, required String info}) {
    return Row(children: [
      isImage
          ? Image.asset(AppImages.switchIcon,
              fit: BoxFit.cover, height: 22, width: 22)
          : Icon(icon, size: 18.sp, color: AppColor.textSecondary),
      SizedBox(width: 6.w),
      AppText(info,
          textColor: AppColor.textSecondary,
          size: 11.sp,
          fontWeight: FontWeight.w500)
    ]);
  }

  _chargingMainInfo(
      {required String mainInfo,
      required String info,
      Widget? topWidget,
      double? leftPositioned}) {
    return SizedBox(
      height: 120.h,
      width: ScreenUtil().screenWidth * 0.28,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 98.h,
            width: 78.w,
            decoration: BoxDecoration(
                color: AppColor.textSecondary,
                borderRadius: BorderRadius.circular(6.r)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppText(mainInfo,
                    size: 18.sp,
                    fontFamily: 'Poppins Black',
                    textColor: AppColor.white,
                    fontWeight: FontWeight.w700),
                AppText(info,
                    size: 10.sp,
                    textColor: AppColor.unselectedIndicatorColor,
                    fontWeight: FontWeight.w400)
              ],
            ),
          ),
          topWidget != null
              ? Positioned(top: 0, left: leftPositioned, child: topWidget)
              : const SizedBox()
        ],
      ),
    );
  }
}
