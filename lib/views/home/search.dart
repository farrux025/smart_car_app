import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_car_app/components/app_text.dart';
import 'package:smart_car_app/constants/images.dart';
import 'package:smart_car_app/models/charge_box/ChargeBoxInfo.dart';
import 'package:smart_car_app/utils/functions.dart';
import 'package:smart_car_app/views/home/map_screen.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../constants/color.dart';
import '../../main.dart';

class SearchView extends StatefulWidget {
  final List<ChargeBoxInfo> searchList;

  const SearchView({Key? key, required this.searchList}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  var editingController = TextEditingController();

  var _filteredList = <ChargeBoxInfo>[];

  void _search() {
    var text = editingController.text;
    if (text.isNotEmpty) {
      _filteredList = widget.searchList.where((ChargeBoxInfo chargeBoxInfo) {
        return (chargeBoxInfo.name ?? '')
            .toLowerCase()
            .contains(text.toLowerCase());
      }).toList();
    } else {
      _filteredList = [];
    }
    setState(() {});
  }

  @override
  void initState() {
    editingController.addListener(_search);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColor.backgroundColorLight,
        body: Column(
          children: [
            Flexible(
              flex: 2,
              child: Column(
                children: [
                  SizedBox(height: 40.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        flex: 8,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 10.h),
                          decoration: BoxDecoration(
                              color: AppColor.buttonRightColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12.r)),
                          child: TextField(
                            cursorColor: Colors.black,
                            cursorHeight: 24,
                            autofocus: true,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 18),
                            controller: editingController,
                            decoration: const InputDecoration(
                              fillColor: Colors.black,
                              prefixIcon:
                                  Icon(Icons.search, color: Colors.black),
                              hoverColor: Colors.black,
                              focusColor: Colors.black,
                              border: InputBorder.none,
                              hintText: "Search",
                              hintStyle: TextStyle(
                                  color: Colors.black38, fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                          flex: 1,
                          child: IconButton(
                              padding: EdgeInsets.only(right: 20.w),
                              onPressed: () =>
                                  MyApp.navigatorKey.currentState?.pop(),
                              icon: Icon(
                                Icons.close,
                                color: AppColor.buttonLeftColor,
                                size: 22.sp,
                              )))
                    ],
                  ),
                ],
              ),
            ),
            Flexible(
                flex: 11,
                child: _filteredList.isNotEmpty
                    ? ListView.separated(
                        itemCount: _filteredList.length,
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        itemBuilder: (context, index) {
                          var item = _filteredList[index];
                          return _itemWidget(item);
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 10.h))
                    : const Center(
                        child: Text(
                          "Nothing found!",
                          style: TextStyle(color: Colors.black45, fontSize: 16),
                        ),
                      )),
          ],
        ));
  }

  Widget _itemWidget(ChargeBoxInfo item) {
    return GestureDetector(
      onTap: () => _onItemTap(item),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 14.w),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        elevation: 1,
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 14.w),
          leading: Image.asset(AppImages.stationPointer, fit: BoxFit.fill),
          title: AppText(item.name ?? '',
              textColor: AppColor.textColor,
              size: 16.sp,
              maxLines: 1,
              fontWeight: FontWeight.w600),
          subtitle: AppText("${item.street}, ${item.city}",
              textColor: AppColor.textColor.withOpacity(0.6),
              size: 12.sp,
              maxLines: 1,
              fontWeight: FontWeight.w400),
          trailing: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.r)),
            child: Container(
              height: 46.h,
              width: 60.w,
              decoration: BoxDecoration(
                  color: AppColor.lightBlue,
                  borderRadius: BorderRadius.circular(4.r)),
              child: Center(
                child: AppText(
                    distance(
                            lat: item.locationLatitude ?? 0,
                            lon: item.locationLongitude ?? 0)
                        .replaceAll(" Away", ""),
                    size: 12.sp,
                    textAlign: TextAlign.center,
                    textColor: AppColor.textColor,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _onItemTap(ChargeBoxInfo item) {
    bottomSheet(
        list: [item],
        chargeBoxId: item.id ?? '',
        point: Point(
            latitude: item.locationLatitude ?? 0,
            longitude: item.locationLongitude ?? 0),
        stationName: item.name ?? '',
        address: "${item.street},\n${item.city}",
        distance: distance(
            lat: item.locationLatitude ?? 0, lon: item.locationLongitude ?? 0),
        rating: "4.5");
  }
}
