import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_car_app/components/app_text.dart';
import 'package:smart_car_app/constants/color.dart';
import 'package:smart_car_app/constants/images.dart';

import '../../translations/locale_keys.g.dart';

class VehicleDetailScreen extends StatelessWidget {
  const VehicleDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var height = ScreenUtil().screenHeight;
    return Scaffold(
      backgroundColor: AppColor.backgroundMain,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120.h,
            backgroundColor: Colors.transparent,
            pinned: true,
            elevation: 0,
            floating: true,
            leading: const BackButton(color: AppColor.textSecondary),
            flexibleSpace: FlexibleSpaceBar(
              title: AppText("BMW X5",
                  size: 24.sp,
                  textColor: AppColor.textSecondary,
                  fontWeight: FontWeight.w500),
              centerTitle: true,
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                AppText(LocaleKeys.car_info_page_desc.tr(),
                    size: 12.sp,
                    textColor: AppColor.textSecondary,
                    fontWeight: FontWeight.w400),
                SizedBox(height: 40.h),
                Image.asset(
                  AppImages.carImage,
                  fit: BoxFit.fitWidth,
                  width: ScreenUtil().screenWidth,
                  height: height * 0.25,
                ),
                SizedBox(height: 40.h),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _infoWidget(
                            icon: Icons.device_thermostat_outlined,
                            subtitle: LocaleKeys.temperature.tr(),
                            mainInfo: _textInfo(
                                text: '18', textColor: AppColor.textColorBlue)),
                        const SizedBox(width: 18),
                        _infoWidget(
                            icon: Icons.bolt,
                            subtitle: LocaleKeys.charge.tr(),
                            mainInfo: _textInfo(
                                text: '65%',
                                textColor: AppColor.stationIndicatorColor)),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _infoWidget(
                            icon: Icons.camera_rounded,
                            subtitle: LocaleKeys.tire_pressure.tr(),
                            mainInfo: _textInfo(
                                text: '19%', textColor: AppColor.textColorRed)),
                        const SizedBox(width: 18),
                        _infoWidget(
                            icon: Icons.cable,
                            subtitle: LocaleKeys.electrical_wiring.tr(),
                            mainInfo: Icon(
                              Icons.check_circle,
                              color: AppColor.stationIndicatorColor,
                              size: 30.sp,
                            )),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 60.h),
              ],
            ),
          )
        ],
      ),
    );
  }

  _infoWidget(
      {required IconData icon,
      required String subtitle,
      required Widget mainInfo}) {
    return Container(
      height: 146.h,
      width: 120.w,
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
          color: AppColor.white, borderRadius: BorderRadius.circular(6.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(icon, size: 36.sp, color: Colors.black),
          mainInfo,
          AppText(subtitle,
              textAlign: TextAlign.center,
              size: 11.sp,
              textColor: Colors.black,
              fontWeight: FontWeight.w400)
        ],
      ),
    );
  }

  _textInfo({required String text, Color? textColor}) {
    return AppText(text,
        size: 28.sp, textColor: textColor, fontWeight: FontWeight.w400);
  }
}
