import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_car_app/components/app_text.dart';
import 'package:smart_car_app/constants/color.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final list = ["Ford", "BMW", "Audi"];
  String? ddValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColorLight,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: const BackButton(color: Colors.black),
            expandedHeight: 100.h,
            backgroundColor: AppColor.backgroundColorLight,
            flexibleSpace: FlexibleSpaceBar(
              title: AppText("ADD YOUR VEHICLE",
                  size: 16.sp,
                  textColor: AppColor.textColor,
                  fontWeight: FontWeight.w500),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
              child: Column(
                children: [
                  AppText(
                      "Take picture of your car with makers and model number the system Ai will do the rest of the things.",
                      size: 13.sp,
                      maxLines: 4,
                      textColor: AppColor.textColor.withOpacity(0.6),
                      fontWeight: FontWeight.w400),
                  SizedBox(height: 30.h),
                  MaterialButton(
                    onPressed: () {},
                    height: 100.h,
                    minWidth: ScreenUtil().screenWidth,
                    color: AppColor.textColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.sp)),
                    child: SizedBox(
                      height: 100.h,
                      child: Stack(
                        children: [
                          Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt_outlined,
                                    color: AppColor.white, size: 30.sp),
                                SizedBox(width: 8.w),
                                AppText("Click here to take photo",
                                    textColor: AppColor.white,
                                    size: 12.sp,
                                    fontWeight: FontWeight.w400)
                              ],
                            ),
                          ),
                          Positioned(
                            top: 12,
                            child: AppText("Optional",
                                size: 12.sp,
                                textColor: AppColor.stationIndicatorColor,
                                fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  dropDown(title: "Vehicle type", elements: list)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  dropDown({required String title, required List<String> elements}) {
    return Column(
      children: [
        AppText(title,
            size: 16.sp,
            fontWeight: FontWeight.w500,
            textColor: AppColor.textColor),
        DropdownButton<String>(
          items: elements.map(buildMenuItem).toList(),
          onChanged: (value) {
            setState(() {
              ddValue = value;
            });
          },
        )
      ],
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) {
    return DropdownMenuItem(
        value: item,
        child: AppText(item,
            textColor: AppColor.textColor,
            fontWeight: FontWeight.w400,
            size: 14.sp));
  }
}
