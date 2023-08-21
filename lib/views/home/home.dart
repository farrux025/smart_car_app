import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_car_app/components/app_text.dart';
import 'package:smart_car_app/constants/color.dart';
import 'package:smart_car_app/constants/routes.dart';
import 'package:smart_car_app/cubit/charge_box/charge_boxes_cubit.dart';
import 'package:smart_car_app/models/charge_box/ChargeBoxInfo.dart';
import 'package:smart_car_app/views/home/map_screen.dart';
import 'package:smart_car_app/views/home/station_list_screen.dart';

import '../../main.dart';

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
    return BlocProvider(
      create: (BuildContext context) => ChargeBoxesCubit(),
      child: BlocListener<ChargeBoxesCubit, ChargeBoxesState>(
        listener: (context, state) {
          if (state is ChargeBoxesError) {
            log("Error state: ${state.error}");
          }
        },
        child: BlocBuilder<ChargeBoxesCubit, ChargeBoxesState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: AppColor.backgroundColorDark,
              body: Stack(
                children: [
                  TabBarView(
                    controller: _tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      state is ChargeBoxesLoaded
                          ? MapScreen(list: state.list)
                          : const Center(
                              child: CircularProgressIndicator(
                                  color: AppColor.white),
                            ),
                      state is ChargeBoxesLoaded
                          ? StationListScreen(
                              list: state.list,
                            )
                          : const SizedBox()
                    ],
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
                        onPressed: () {
                          compareChargeBox();
                        },
                        height: 62.sp,
                        minWidth: 60.sp,
                        child: Icon(Icons.subject,
                            color: Colors.white, size: 30.sp)),
                    MaterialButton(
                        onPressed: () => MyApp.navigatorKey.currentState
                            ?.pushNamed(Routes.vehicles),
                        height: 62.sp,
                        child: Image.asset(
                          "assets/images/car_icon.png",
                        )),
                  ],
                ),
              ),
            );
          },
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
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.r),
          color: AppColor.ratingBackgroundColor),
      child: Row(
        children: [
          Icon(Icons.star_rate_rounded,
              size: 20.sp, color: AppColor.starRatingColor),
          SizedBox(width: 4.w),
          AppText(rating,
              textColor: AppColor.textColor,
              size: 11.sp,
              fontWeight: FontWeight.w500)
        ],
      ));
}
