import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_car_app/components/app_text.dart';
import 'package:smart_car_app/constants/color.dart';
import 'package:smart_car_app/constants/language.dart';
import 'package:smart_car_app/main.dart';
import 'package:smart_car_app/models/global/UserModel.dart';
import 'package:smart_car_app/translations/locale_keys.g.dart';
import 'package:smart_car_app/utils/functions.dart';

import '../../constants/routes.dart';

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
              title: AppText(LocaleKeys.profile.tr(),
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
            title: LocaleKeys.language.tr(),
            subtitle: "Қазақ тілі, O'zbek, Русский язык, English",
            icon: Icons.language,
            onPressed: () {
              _changeLanguage();
            });
      case 2:
        return settingsItem(
            title: LocaleKeys.password.tr(),
            subtitle: LocaleKeys.change_password.tr(),
            icon: Icons.lock_reset,
            onPressed: () {});
      case 3:
        return settingsItem(
            title: LocaleKeys.about_app.tr(),
            subtitle: "${LocaleKeys.version.tr()} $appVersion",
            icon: Icons.info_outline,
            onPressed: () {});
      case 0:
        return settingsItem(
            title: LocaleKeys.charge_boxes.tr(),
            subtitle: "Saqlangan stansiyalar",
            icon: Icons.star_border_outlined,
            onPressed: () {});
      default:
        return const SizedBox();
    }
  }

  void _changeLanguage() {
    var context = MyApp.navigatorKey.currentState?.context;
    var groupValue = context?.locale;
    showModalBottomSheet(
      context: context!,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12.r))),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          minChildSize: 0.4,
          maxChildSize: 0.7,
          builder: (context, scrollController) {
            return StatefulBuilder(
              builder: (context, setState) =>  Column(
                children: [
                  SizedBox(height: 8.h),
                  Container(
                      height: 3.h,
                      width: 60.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: Colors.black26),
                      padding: EdgeInsets.symmetric(vertical: 8.h)),
                  SizedBox(height: 8.h),
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: AppText("Change language",
                          textColor: AppColor.textColor,
                          size: 16.sp,
                          fontWeight: FontWeight.w800)),
                  RadioListTile(
                      value: kkLocale,
                      groupValue: groupValue,
                      onChanged: (value) {
                        groupValue = value!;
                        context.setLocale(kkLocale);
                        MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
                            Routes.home, (route) => false);
                      },
                      controlAffinity: ListTileControlAffinity.trailing,
                      title: AppText("Қазақ тілі",
                          size: 14.sp,
                          textColor: AppColor.textColor,
                          fontWeight: FontWeight.w500)),
                  RadioListTile(
                      value: uzLocale,
                      groupValue: groupValue,
                      onChanged: (value) {
                        groupValue = value!;
                        context.setLocale(uzLocale);
                        MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
                            Routes.home, (route) => false);
                      },
                      controlAffinity: ListTileControlAffinity.trailing,
                      title: AppText("O'zbek",
                          size: 14.sp,
                          textColor: AppColor.textColor,
                          fontWeight: FontWeight.w500)),
                  RadioListTile(
                      value: ruLocale,
                      groupValue: groupValue,
                      onChanged: (value) {
                        var buildContext = MyApp.navigatorKey.currentState?.context;
                        groupValue = value!;
                        buildContext?.setLocale(ruLocale);
                        MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
                            Routes.home, (route) => false);
                      },
                      controlAffinity: ListTileControlAffinity.trailing,
                      title: AppText("Русский язык",
                          size: 14.sp,
                          textColor: AppColor.textColor,
                          fontWeight: FontWeight.w500)),
                  RadioListTile(
                      value: enLocale,
                      groupValue: groupValue,
                      onChanged: (value) {
                        var buildContext = MyApp.navigatorKey.currentState?.context;
                        setState(() {

                          groupValue = value!;
                          buildContext?.setLocale(enLocale);
                        });
                        MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
                            Routes.home, (route) => false);
                      },
                      controlAffinity: ListTileControlAffinity.trailing,
                      title: Row(
                        children: [
                          AppText("English",
                              size: 14.sp,
                              textColor: AppColor.textColor,
                              fontWeight: FontWeight.w500),
                        ],
                      )),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
