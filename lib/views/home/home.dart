import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:smart_car_app/components/app_text.dart';
import 'package:smart_car_app/constants/color.dart';
import 'package:smart_car_app/constants/images.dart';
import 'package:smart_car_app/constants/routes.dart';
import 'package:smart_car_app/services/stomp_client.dart';
import 'package:smart_car_app/views/home/map_screen.dart';
import 'package:smart_car_app/views/home/station_list_screen.dart';

import '../../components/app_components.dart';
import '../../main.dart';
import '../../models/global/LocationModel.dart';
import '../../models/global/UserModel.dart';
import '../../services/secure_storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool selected1 = true;
  bool selected2 = false;
  // String address = '';

  // List<ChargeBoxInfo> chargeBoxList = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {});
    // ChargeBoxesCubit().getChargeBoxes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColorDark,
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [MapScreen(), StationListScreen()],
          ),
          Container(
            margin: EdgeInsets.only(left: 24.w, right: 24.w, top: 52.h),
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.transparent,
              onTap: (index) => _onTabTap(index),
              tabs: [
                _tabBarItem(title: "Map", isSelected: selected1),
                _tabBarItem(title: "List View", isSelected: selected2),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        height: 62.sp,
        width: ScreenUtil().screenWidth,
        color: AppColor.backgroundColorDark,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MaterialButton(
                onPressed: () async {
                  await SecureStorage.read(key: SecureStorage.phone)
                      .then((value) {
                    Global.userModel.username = value;
                  });
                  MyApp.navigatorKey.currentState?.pushNamed(Routes.profile);
                },
                height: 62.sp,
                minWidth: 60.sp,
                child: Icon(Icons.subject, color: Colors.white, size: 30.sp)),
            MaterialButton(
                onPressed: () =>
                    MyApp.navigatorKey.currentState?.pushNamed(Routes.vehicles),
                height: 62.sp,
                child: SvgPicture.asset(AppImages.carIconSvg,
                    fit: BoxFit.cover, height: 22.sp, width: 50.sp)),
          ],
        ),
      ),
    );
  }

  _tabBarItem({required String title, bool? isSelected}) {
    return Container(
        color: (isSelected ?? false) ? Colors.white : Colors.black,
        height: 34.h,
        width: 130.w,
        child: Center(
          child: AppText(
            title,
            size: 16.sp,
            textColor: (isSelected ?? false) ? Colors.black : Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ));
  }

  void _onTabTap(index) {
    log("Tab index: $index");
    if (index == 0) {
      setState(() {
        selected1 = true;
        selected2 = false;
      });
    } else {
      setState(() {
        selected2 = true;
        selected1 = false;
      });
    }
  }
}

ratingWidget({required String rating}) {
  return Container(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.r),
          color: AppColor.ratingBackgroundColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(AppImages.starSvg,
              fit: BoxFit.cover, height: 16.sp, width: 16.sp),
          SizedBox(width: 5.w),
          AppText(rating,
              textColor: AppColor.textColor,
              size: 12.sp,
              fontWeight: FontWeight.w500)
        ],
      ));
}
