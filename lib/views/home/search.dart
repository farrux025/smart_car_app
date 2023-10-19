import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_car_app/components/app_text.dart';
import 'package:smart_car_app/constants/images.dart';
import 'package:smart_car_app/models/charge_box/ChargeBoxInfo.dart';
import 'package:smart_car_app/utils/functions.dart';
import 'package:smart_car_app/views/home/map_screen.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../constants/color.dart';
import '../../main.dart';
import '../../translations/locale_keys.g.dart';

class SearchView extends StatefulWidget {
  final List<ChargeBoxInfo> searchList;
  final bool isMap;
  final Completer<YandexMapController>? completer;

  const SearchView(
      {Key? key, required this.searchList, required this.isMap, this.completer})
      : super(key: key);

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
                            decoration:  InputDecoration(
                              fillColor: Colors.black,
                              prefixIcon:
                                  const Icon(Icons.search, color: Colors.black),
                              hoverColor: Colors.black,
                              focusColor: Colors.black,
                              border: InputBorder.none,
                              hintText: LocaleKeys.search.tr(),
                              hintStyle: const TextStyle(
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
                    :  Center(
                        child: Text(
                          LocaleKeys.nothing_found.tr(),
                          style: const TextStyle(color: Colors.black45, fontSize: 16),
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
          leading: SvgPicture.asset(AppImages.stationPointerSvg, fit: BoxFit.fill),
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
                        .replaceAll(" ${LocaleKeys.away.tr()}", ""),
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

  _onItemTap(ChargeBoxInfo item) async {
    if (widget.isMap) {
      popBack();
      YandexMapController? yandexMapController = await widget.completer?.future;
      yandexMapController?.moveCamera(
          CameraUpdate.newCameraPosition(CameraPosition(
              target: Point(
                  latitude: item.locationLatitude ?? 0,
                  longitude: item.locationLongitude ?? 0))),
          animation:
              const MapAnimation(type: MapAnimationType.linear, duration: 1));
    } else {
      bottomSheet(
          list: [item],
          chargeBoxId: item.id ?? '',
          point: Point(
              latitude: item.locationLatitude ?? 0,
              longitude: item.locationLongitude ?? 0),
          stationName: item.name ?? '',
          address: "${item.street},\n${item.city}",
          distance: distance(
              lat: item.locationLatitude ?? 0,
              lon: item.locationLongitude ?? 0),
          rating: "4.5");
    }
  }
}

class MySearch {
  static void openSearchView(
      {required List<ChargeBoxInfo> list,
      required bool isMap,
      Completer<YandexMapController>? completer}) {
    var context = MyApp.navigatorKey.currentState!.context;
    showModalBottomSheet(
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        backgroundColor: AppColor.backgroundColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r))),
        builder: (context) {
          return SearchView(
              searchList: list, isMap: isMap, completer: completer);
        });
  }
}
