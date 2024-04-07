import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_car_app/components/app_text.dart';
import 'package:smart_car_app/constants/color.dart';
import 'package:smart_car_app/services/shared_prefs.dart';

import '../../models/charge_box/connector_types/ConnectorTypes.dart';

class FilterWidget extends StatefulWidget {
  final List<ConnectorTypes> connectorTypeList;
  final VoidCallback onFilterPressed;

  const FilterWidget({
    super.key,
    required this.connectorTypeList,
    required this.onFilterPressed,
  });

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  List<String> checkedConnectors = [
    /*'GB/T (AC)', 'GB/T (DC)'*/
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      MySharedPrefs().getConnectorTypeList().then((value) {
        log("Checked Connectors Value: $value");
        setState(() => checkedConnectors = value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(height: 10.h),
          Container(
              decoration: BoxDecoration(
                  color: AppColor.backgroundColor,
                  borderRadius: BorderRadius.circular(10)),
              height: 5,
              width: 80),
          SizedBox(height: 10.h),
          AppText("Choose connector type",
              textColor: AppColor.textColor,
              fontWeight: FontWeight.w700,
              size: 16.sp),
          SizedBox(height: 14.h),
          ListView.separated(
              shrinkWrap: true,
              primary: false,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) =>
                  _filterItem(widget.connectorTypeList[index]),
              separatorBuilder: (context, index) => const Divider(
                  color: AppColor.backgroundColorLight, height: 4),
              itemCount: widget.connectorTypeList.length)
        ]),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(10),
        child: MaterialButton(
            onPressed: widget.onFilterPressed,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.r)),
            color: AppColor.backgroundColorDark,
            height: 40.h,
            minWidth: ScreenUtil().screenWidth,
            child: AppText("Filter",
                size: 13.sp,
                textColor: AppColor.white,
                fontWeight: FontWeight.w500)),
      ),
    );
  }

  _filterItem(ConnectorTypes connectorType) {
    return SizedBox(
        width: ScreenUtil().screenWidth,
        child: CheckboxListTile(
          value: checkedConnectors.contains(connectorType.id),
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Image.network(connectorType.logos?[0].url ?? '',
                    height: 30, width: 30, fit: BoxFit.fitHeight),
              ),
              SizedBox(width: 10.w),
              AppText(connectorType.id ?? '',
                  size: 14.sp,
                  textColor: AppColor.textColor,
                  fontWeight: FontWeight.w500)
            ],
          ),
          activeColor: AppColor.backgroundColorDark,
          onChanged: (value) async {
            if (checkedConnectors.contains(connectorType.id)) {
              setState(() => checkedConnectors.remove(connectorType.id));
            } else {
              setState(() => checkedConnectors.add(connectorType.id ?? ''));
            }
            log("CheckedConnectors: $checkedConnectors");
            await MySharedPrefs()
                .saveConnectorTypeList(connectorTypeList: checkedConnectors);
          },
        ));
  }
}
