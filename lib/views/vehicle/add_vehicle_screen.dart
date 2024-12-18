import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_car_app/components/app_components.dart';
import 'package:smart_car_app/components/app_text.dart';
import 'package:smart_car_app/constants/color.dart';
import 'package:smart_car_app/constants/constants.dart';
import 'package:smart_car_app/constants/variables.dart';
import 'package:smart_car_app/cubit/vehicle/add_vehicle_cubit.dart';
import 'package:smart_car_app/models/vehicle/add_vehicle/req/ReqTag.dart';
import 'package:smart_car_app/models/vehicle/add_vehicle/req/RequestAddVehicle.dart';
import 'package:smart_car_app/services/image_service.dart';
import 'package:smart_car_app/services/secure_storage.dart';
import 'package:smart_car_app/services/shared_prefs.dart';
import 'package:smart_car_app/utils/functions.dart';

import '../../models/global/UserModel.dart';
import '../../translations/locale_keys.g.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  var govNumberController = TextEditingController();
  final vehicleTypeList = ["Car", "Scooter"];
  final brandList = ["BMW", "Audi", "Mercedes Benz", "BYD"];
  final modelList = ["Model 1", "Model 2", "Model 3", "Model 4"];
  String? vehicleTypeValue;
  String? brandValue;
  String? modelValue;
  File? file;

  @override
  void initState() {
    super.initState();
    vehicleTypeValue = vehicleTypeList[0];
    brandValue = brandList[0];
    modelValue = modelList[0];
    MySharedPrefs().delete(key: MySharedPrefs.vehicleImageKey);
    MySharedPrefs().delete(key: MySharedPrefs.vehicleImageUrlKey);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AddVehicleCubit(),
      child: BlocListener<AddVehicleCubit, AddVehicleState>(
        listener: (context, state) {
          if (state is AddVehicleError) {
            openSnackBar(
                message: LocaleKeys.error_retry_please.tr());
          }
        },
        child: BlocBuilder<AddVehicleCubit, AddVehicleState>(
          builder: (context, state) {
            AddVehicleCubit read = context.read<AddVehicleCubit>();
            return Scaffold(
              backgroundColor: AppColor.backgroundColorLight,
              body: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    leading: const BackButton(color: Colors.black),
                    expandedHeight: 100.h,
                    pinned: true,
                    floating: true,
                    elevation: 0,
                    backgroundColor: AppColor.backgroundColorLight,
                    flexibleSpace: FlexibleSpaceBar(
                      title: AppText(LocaleKeys.ADD_VEHICLE.tr(),
                          size: 16.sp,
                          textColor: AppColor.textColor,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.w, vertical: 20.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                              LocaleKeys.upload_image_desc.tr(),
                              size: 13.sp,
                              maxLines: 4,
                              textColor: AppColor.textColor.withOpacity(0.6),
                              fontWeight: FontWeight.w400),
                          SizedBox(height: 30.h),
                          MaterialButton(
                            onPressed: () => _pickImage(),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.camera_alt_outlined,
                                            color: AppColor.white, size: 30.sp),
                                        SizedBox(width: 8.w),
                                        AppText(LocaleKeys.upload_image_btn_text.tr(),
                                            textColor: AppColor.white,
                                            size: 12.sp,
                                            fontWeight: FontWeight.w400)
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 12,
                                    child: AppText(LocaleKeys.optional.tr(),
                                        size: 12.sp,
                                        textColor:
                                            AppColor.stationIndicatorColor,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          ValueListenableBuilder(
                            valueListenable:
                                MyValueNotifiers.uploadImageLoading,
                            builder: (context, String value, child) {
                              if (value == "uploadImageLoaded") {
                                return file != null
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        child: Image.file(
                                          file!,
                                          height: 80.h,
                                          width: 80.w,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : const SizedBox();
                              } else if (value == "uploadImageLoading") {
                                return const Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.black));
                              } else if (value == "uploadImageError") {
                                return Center(
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        bottom: 20.h, left: 20.w, right: 20.w),
                                    child: AppText(
                                        LocaleKeys.error_retry_please.tr(),
                                        size: 12.sp,
                                        textAlign: TextAlign.center,
                                        textColor: AppColor.errorColor,
                                        maxLines: 3),
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                          SizedBox(height: file == null ? 0 : 20.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(LocaleKeys.vehicle_type.tr(),
                                  size: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  textColor: AppColor.textColor),
                              SizedBox(height: 4.h),
                              Container(
                                padding:
                                    EdgeInsets.only(right: 8.w, bottom: 4.h),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.black, width: 2.h))),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: vehicleTypeValue,
                                    items: vehicleTypeList
                                        .map(_buildMenuItem)
                                        .toList(),
                                    isExpanded: true,
                                    iconSize: 20.sp,
                                    icon: const Icon(Icons.arrow_downward,
                                        color: Colors.black),
                                    onChanged: (value) {
                                      setState(() {
                                        vehicleTypeValue = value.toString();
                                      });
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 30.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(LocaleKeys.company_name.tr(),
                                  size: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  textColor: AppColor.textColor),
                              SizedBox(height: 4.h),
                              Container(
                                padding:
                                    EdgeInsets.only(right: 8.w, bottom: 4.h),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.black, width: 2.h))),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: brandValue,
                                    items:
                                        brandList.map(_buildMenuItem).toList(),
                                    isExpanded: true,
                                    iconSize: 20.sp,
                                    icon: const Icon(Icons.arrow_downward,
                                        color: Colors.black),
                                    onChanged: (value) {
                                      setState(() {
                                        brandValue = value.toString();
                                      });
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 30.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(LocaleKeys.brand_name.tr(),
                                  size: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  textColor: AppColor.textColor),
                              SizedBox(height: 4.h),
                              Container(
                                padding:
                                    EdgeInsets.only(right: 8.w, bottom: 4.h),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.black, width: 2.h))),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: modelValue,
                                    items:
                                        modelList.map(_buildMenuItem).toList(),
                                    isExpanded: true,
                                    iconSize: 20.sp,
                                    icon: const Icon(Icons.arrow_downward,
                                        color: Colors.black),
                                    onChanged: (value) {
                                      setState(() {
                                        modelValue = value.toString();
                                      });
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 30.h),
                          _enterNumberField(),
                          SizedBox(height: 30.h),
                          _addButton(
                            read,
                            child: state is AddVehicleLoading
                                ? SizedBox(
                                    height: 18.h,
                                    width: 18.h,
                                    child: const CircularProgressIndicator(
                                        color: AppColor.white, strokeWidth: 4))
                                : AppText(LocaleKeys.ADD_NOW.tr(),
                                    textColor: AppColor.white,
                                    fontWeight: FontWeight.w500,
                                    size: 14.sp),
                          ),
                          SizedBox(height: 30.h),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  DropdownMenuItem<String> _buildMenuItem(String item) {
    return DropdownMenuItem(
        value: item,
        child: AppText(item,
            textColor: AppColor.textColor,
            fontWeight: FontWeight.w400,
            size: 15.sp));
  }

  _addButton(AddVehicleCubit read, {required Widget child}) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [AppColor.buttonLeftColor, AppColor.buttonRightColor])),
      child: MaterialButton(
        onPressed: () async {
          closeKeyboard();
          String? imageUrl;
          await MySharedPrefs()
              .getVehicleImage(key: MySharedPrefs.vehicleImageUrlKey)
              .then((value) {
            imageUrl = value;
            log("Image Url: $imageUrl");
          });
          Global.userModel.username =
              await SecureStorage.read(key: SecureStorage.phone);
          if (_formKey.currentState!.validate()) {
            var requestAddVehicle = RequestAddVehicle(
                modelId: 0,
                manufactureId: 0,
                imageUrl: imageUrl ?? '',
                status: 'NEW',
                username: Global.userModel.username ?? '',
                carNumber: govNumberController.text.replaceAll(" ", ""),
                tag: ReqTag(id: 2901));
            await read.addVehicle(request: requestAddVehicle);
          }
        },
        height: 57.sp,
        minWidth: ScreenUtil().screenWidth,
        child: child,
      ),
    );
  }

  _enterNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(LocaleKeys.gov_number.tr(),
            size: 16.sp,
            fontWeight: FontWeight.w500,
            textColor: AppColor.textColor),
        SizedBox(height: 4.h),
        Form(
            key: _formKey,
            child: TextFormField(
              maxLines: 1,
              validator: (value) => AppTextValidator(govNumberController.text,
                  required: true, minLength: 11),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 6.w),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2.h)),
                  hintText: '01 A 000 AA',
                  hintStyle: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black26,
                      fontWeight: FontWeight.w400)),
              keyboardType: TextInputType.text,
              controller: govNumberController,
              textCapitalization: TextCapitalization.characters,
              autofocus: false,
              inputFormatters: [Mask.GOV_NUMBER],
            )),
      ],
    );
  }

  _pickImage() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.backgroundMain,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(16.r), topLeft: Radius.circular(16.r))),
      builder: (context) => Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r)),
          child: Wrap(
            children: [
              Center(
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: 6.h),
                  height: 5,
                  width: 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: Colors.grey),
                ),
              ),
              Container(height: 4.h),
              MaterialButton(
                onPressed: () async {
                  file = await ImageService.pickImage(
                      imageSource: ImageSource.camera);
                  setState(() {});
                },
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(children: [
                  Icon(Icons.camera_alt_outlined,
                      color: AppColor.textColor, size: 28.sp),
                  SizedBox(width: 12.w),
                  AppText(LocaleKeys.camera.tr(),
                      size: 16.sp,
                      textColor: AppColor.textColor,
                      fontWeight: FontWeight.w400)
                ]),
              ),
              MaterialButton(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                onPressed: () async {
                  file = await ImageService.pickImage(
                      imageSource: ImageSource.gallery);
                  setState(() {});
                },
                child: Row(children: [
                  Icon(Icons.image_outlined,
                      color: AppColor.textColor, size: 28.sp),
                  SizedBox(width: 12.w),
                  AppText(LocaleKeys.gallery.tr(),
                      size: 16.sp,
                      textColor: AppColor.textColor,
                      fontWeight: FontWeight.w400)
                ]),
              ),
              Container(height: 10.h)
            ],
          )),
    );
  }
}
