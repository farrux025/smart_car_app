import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_car_app/components/app_text.dart';
import 'package:smart_car_app/constants/color.dart';
import 'package:smart_car_app/models/global/UserModel.dart';
import 'package:smart_car_app/utils/functions.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? appVersion = Global.myPackageInfo.appVersion;

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
                  onPressed: () => logOut(context),
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
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          textColor: AppColor.textColorBlue),
                    ),
                    ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => _profileWidget(index),
                        separatorBuilder: (context, index) =>
                            Divider(height: 0.h),
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
      required VoidCallback onPressed,
      required IconData icon}) {
    return MaterialButton(
      onPressed: onPressed,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
        horizontalTitleGap: 18.w,
        leading: CircleAvatar(
            backgroundColor: AppColor.backgroundColor.withOpacity(0.3),
            child: Icon(icon,
                size: 22.sp,
                color: AppColor.backgroundColorDark.withOpacity(0.8))),
        title: AppText(title,
            size: 15.sp,
            textColor: AppColor.backgroundColorDark,
            fontWeight: FontWeight.w500),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 4.h),
          child: AppText(subtitle,
              size: 12.sp,
              textColor: AppColor.buttonRightColor.withOpacity(0.7),
              fontWeight: FontWeight.w400),
        ),
        trailing:
            Icon(Icons.chevron_right, color: AppColor.textColor, size: 20.sp),
      ),
    );
  }

  Widget _profileWidget(int index) {
    switch (index) {
      case 1:
        return settingsItem(
            title: "Til",
            subtitle: "O'zbek, English, Русский язык",
            icon: Icons.language,
            onPressed: () {});
      case 2:
        return settingsItem(
            title: "Parol",
            subtitle: "Parolni o'zgartirish",
            icon: Icons.lock_reset,
            onPressed: () {});
      case 3:
        return settingsItem(
            title: "Ilova haqida",
            subtitle: "Version $appVersion",
            icon: Icons.info_outline,
            onPressed: () {});
      case 0:
        return settingsItem(
            title: "Stansiyalar",
            subtitle: "Saqlangan stansiyalar",
            icon: Icons.star_border_outlined,
            onPressed: () {});
      default:
        return const SizedBox();
    }
  }
}