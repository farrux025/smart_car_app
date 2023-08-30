import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_car_app/components/app_text.dart';
import 'package:smart_car_app/constants/color.dart';
import 'package:smart_car_app/models/global/UserModel.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColorLight,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 100.h,
            leading: const BackButton(color: Colors.black),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.logout, color: Colors.black, size: 22.sp))
            ],
            pinned: true,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              title: AppText("Profile",
                  size: 22.sp,
                  textColor: AppColor.backgroundColorDark,
                  fontWeight: FontWeight.w500),
              centerTitle: true,
            ),
            elevation: 0,
            backgroundColor: AppColor.backgroundColorLight,
          ),
          SliverToBoxAdapter(
            child: Container(
              color: AppColor.backgroundColorLight,
              child: Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: AppText("+${Global.userModel.username}",
                          size: 20.sp,
                          fontWeight: FontWeight.w500,
                          textColor: AppColor.textColorBlue),
                    ),
                    ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => settingsItem(
                            title: "Title $index",
                            subtitle: "Subtitle $index",
                            icon: Icons.person),
                        separatorBuilder: (context, index) => SizedBox(
                              height: 10.h,
                            ),
                        itemCount: 4)
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  settingsItem(
      {required String title,
      required String subtitle,
      required IconData icon}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
          color: AppColor.white, borderRadius: BorderRadius.circular(12.r)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 4.h,horizontal: 16.w),
        leading: CircleAvatar(
            backgroundColor: AppColor.backgroundColorLight,
            child: Icon(icon,
                size: 22.sp, color: AppColor.unselectedIndicatorColor)),
        title: AppText(title,
            size: 18.sp,
            textColor: AppColor.backgroundColorDark,
            fontWeight: FontWeight.w600),
        horizontalTitleGap: 16.w,
        focusNode: FocusNode(descendantsAreFocusable: true),
        subtitle: AppText(subtitle,
            size: 14.sp,
            textColor: AppColor.buttonRightColor.withOpacity(0.7),
            fontWeight: FontWeight.w400),
        trailing:
            Icon(Icons.chevron_right, color: AppColor.unselectedIndicatorColor, size: 20.sp),
      ),
    );
  }
}
