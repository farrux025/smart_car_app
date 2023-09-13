import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_car_app/components/app_text.dart';
import 'package:smart_car_app/constants/color.dart';
import 'package:smart_car_app/constants/constants.dart';
import 'package:smart_car_app/cubit/vehicle/add_vehicle_cubit.dart';
import 'package:smart_car_app/models/vehicle/add_vehicle/req/ReqTag.dart';
import 'package:smart_car_app/models/vehicle/add_vehicle/req/RequestAddVehicle.dart';

import '../../models/global/UserModel.dart';

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

  @override
  void initState() {
    super.initState();
    vehicleTypeValue = vehicleTypeList[0];
    brandValue = brandList[0];
    modelValue = modelList[0];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AddVehicleCubit(),
      child: BlocListener<AddVehicleCubit, AddVehicleState>(
        listener: (context, state) {},
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
                      title: AppText("ADD YOUR VEHICLE",
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                        textColor:
                                            AppColor.stationIndicatorColor,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 30.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText('Vehicle type',
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
                              AppText('Company name',
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
                              AppText('Brand name',
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
                          _addButton(read),
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

  _addButton(AddVehicleCubit read) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [AppColor.buttonLeftColor, AppColor.buttonRightColor])),
      child: MaterialButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            var requestAddVehicle = RequestAddVehicle(
                modelId: 0,
                manufactureId: 0,
                imageUrl: 'test url',
                status: 'NEW',
                username: Global.userModel.username ?? '',
                carNumber: govNumberController.text.replaceAll(" ", ""),
                tag: ReqTag(id: 2901));
            read.addVehicle(request: requestAddVehicle);
          }
        },
        height: 57.sp,
        minWidth: ScreenUtil().screenWidth,
        child: AppText("ADD NOW",
            textColor: AppColor.white,
            fontWeight: FontWeight.w500,
            size: 14.sp),
      ),
    );
  }

  _enterNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText("Gov number",
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
}
