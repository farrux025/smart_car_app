import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:overscroll_pop/overscroll_pop.dart';
import 'package:popup_banner/popup_banner.dart';
import 'package:smart_car_app/cubit/charge_box/details_cubit.dart';
import 'package:smart_car_app/models/charge_box/details/Images.dart';
import 'package:smart_car_app/models/charge_box/details/PublicDetails.dart';
import 'package:smart_car_app/utils/functions.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../components/app_text.dart';
import '../../constants/color.dart';
import '../../constants/images.dart';
import '../../models/charge_box/ChargeBoxInfo.dart';
import '../../models/charge_box/details/Connectors.dart';
import '../../models/charge_box/details/Data.dart';
import '../../services/map_service.dart';
import '../../translations/locale_keys.g.dart';
import 'home.dart';

class ChargeBoxDetailsWidget extends StatefulWidget {
  final num chargeBoxId;
  final Point point;
  final String stationName;
  final String rating;
  final String address;
  final String distance;
  final List<ChargeBoxInfo> mainList;

  const ChargeBoxDetailsWidget({
    super.key,
    required this.mainList,
    required this.chargeBoxId,
    required this.point,
    required this.stationName,
    required this.rating,
    required this.address,
    required this.distance,
  });

  @override
  State<ChargeBoxDetailsWidget> createState() => _ChargeBoxDetailsWidgetState();
}

class _ChargeBoxDetailsWidgetState extends State<ChargeBoxDetailsWidget>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: widget.mainList.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.5,
      maxChildSize: 0.8,
      builder: (context, scrollController) => SizedBox(
        height: ScreenUtil().screenHeight,
        width: ScreenUtil().screenWidth,
        child: Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  toolbarHeight: 20.h,
                  leading: const SizedBox(),
                  elevation: 0),
              body: Container(
                color: AppColor.white,
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: widget.mainList.length > 1
                      ? SizedBox(
                          height: ScreenUtil().screenHeight * 0.7,
                          child: TabBarView(
                              controller: _tabController,
                              children: List.generate(widget.mainList.length,
                                  (index) {
                                var chargeBox = widget.mainList[index];
                                return _tabBarView(chargeBox);
                              })),
                        )
                      : SizedBox(
                          height: ScreenUtil().screenHeight * 0.7,
                          child: _tabBarView(widget.mainList[0])),
                ),
              ),
              bottomNavigationBar: Row(
                children: [
                  Expanded(
                      child: MaterialButton(
                    onPressed: () {
                      log("Tab index: ${_tabController?.index}");
                    },
                    height: 48.h,
                    color: AppColor.errorColor,
                    child: AppText(LocaleKeys.BOOK_NOW.tr(),
                        size: 14.sp,
                        textColor: AppColor.white,
                        fontWeight: FontWeight.w500),
                  )),
                  SizedBox(width: 2.w),
                  Expanded(
                      child: MaterialButton(
                    onPressed: () {
                      log("NAVIGATE");
                      // MyApp.navigatorKey.currentState?.pop();
                      MapService.launchMap(
                          title: "Test",
                          lat: widget.point.latitude,
                          lon: widget.point.longitude);
                    },
                    color: AppColor.textColor,
                    height: 48.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(LocaleKeys.NAVIGATE.tr(),
                            size: 14.sp,
                            textColor: AppColor.white,
                            fontWeight: FontWeight.w500),
                        SizedBox(width: 8.w),
                        SvgPicture.asset(AppImages.navigatorIconSvg,
                            fit: BoxFit.cover, height: 13.sp, width: 13.sp)
                      ],
                    ),
                  )),
                ],
              ),
            ),
            Positioned(
                left: widget.mainList.length > 1 ? 0 : 30,
                child: widget.mainList.length > 1
                    ? SizedBox(
                        height: 50.h,
                        width: ScreenUtil().screenWidth,
                        child: TabBar(
                            automaticIndicatorColorAdjustment: false,
                            indicatorColor: Colors.transparent,
                            labelColor: AppColor.yellow,
                            unselectedLabelColor: Colors.white.withOpacity(0.9),
                            tabs:
                                List.generate(widget.mainList.length, (index) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Stack(alignment: Alignment.center, children: [
                                    SvgPicture.asset(
                                        AppImages.backImageOfIndicatorSvg,
                                        fit: BoxFit.cover,
                                        height: 44.sp,
                                        width: 34.sp),
                                    Tab(
                                      child: AppText(
                                        "${index + 1}",
                                        size: 18.sp,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    )
                                  ]),
                                  // Tab(icon: Icon(Icons.circle,size: 8.sp),)
                                ],
                              );
                            }),
                            controller: _tabController),
                      )
                    : SvgPicture.asset(AppImages.stationPointerSvg,
                        fit: BoxFit.fill, height: 42.h, width: 34.w)),
          ],
        ),
      ),
    );
  }

  Widget _tabBarView(ChargeBoxInfo chargeBox) {
    return BlocProvider(
      create: (context) => DetailsCubit(chargeBox.id ?? 0),
      child: BlocListener<DetailsCubit, DetailsState>(
        listener: (context, state) {},
        child: BlocBuilder<DetailsCubit, DetailsState>(
          builder: (context, state) {
            if (state is DetailsInitial) {
              return const Center(
                  child: CircularProgressIndicator(
                      color: AppColor.backgroundColorDark));
            } else if (state is DetailsError) {
              return Center(
                  child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: AppText(state.error,
                    textColor: AppColor.errorColor,
                    size: 14.sp,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w500),
              ));
            }
            PublicDetails? details =
                state is DetailsLoaded ? state.details : null;
            return Container(
              color: AppColor.white,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: widget.mainList.length > 1 ? 40.h : 32.h),
                      // name & rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 2,
                            child: AppText(chargeBox.name ?? '',
                                size: 24.sp,
                                height: 1.2,
                                fontFamily: 'RobotoCondense',
                                textColor: AppColor.textColor,
                                fontWeight: FontWeight.w800),
                          ),
                          SizedBox(width: 10.w),
                          SizedBox(
                            width: 70.sp,
                            child: ratingWidget(rating: widget.rating),
                          )
                        ],
                      ),
                      SizedBox(height: 24.h),
                      // address & distance
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 7,
                            child: Row(
                              children: [
                                SvgPicture.asset(AppImages.locationPointerSvg,
                                    fit: BoxFit.cover,
                                    height: 22.sp,
                                    width: 18.sp),
                                SizedBox(width: 8.w),
                                SizedBox(
                                  width: ScreenUtil().screenWidth * 0.5,
                                  child: AppText(widget.address,
                                      textColor: AppColor.textColor,
                                      size: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      maxLines: 6),
                                )
                              ],
                            ),
                          ),
                          Flexible(
                              flex: 3,
                              child: AppText(widget.distance,
                                  textColor: AppColor.textColor,
                                  size: 12.sp,
                                  textAlign: TextAlign.center,
                                  fontWeight: FontWeight.w700))
                        ],
                      ),
                      SizedBox(height: 24.h),
                      // available connector
                      AppText(LocaleKeys.available_connector.tr(),
                          textColor: AppColor.textColor.withOpacity(0.9),
                          size: 12.sp,
                          fontWeight: FontWeight.w500),
                      SizedBox(height: 16.h),
                      _connectorList(details?.data),
                      SizedBox(height: 16.h),
                      _imageList(details?.data?.images),
                      SizedBox(height: 50.h),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _connectorList(Data? data) {
    List<Connectors>? list = data?.connectors;
    return list != null
        ? SizedBox(
            height: 90.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: list.length,
              itemBuilder: (context, index) {
                var connector = list[index];
                return connectorItem(
                    power: connector.connectorTypeId ?? '',
                    background: AppColor.backgroundColorGreen,
                    bottomText: LocaleKeys.available.tr(),
                    price: data?.chargeBox?.price.toString() ?? '',
                    textColor: AppColor.textColorGreen,
                    iconPath: connector.imageUrl ?? '');
              },
            ),
          )
        : AppText(LocaleKeys.no_connectors.tr(),
            size: 14.sp,
            fontWeight: FontWeight.w500,
            textColor: AppColor.errorColor);
  }

  connectorItem(
      {required String power,
      required String iconPath,
      required String price,
      String? bottomText,
      Color? background,
      Color? textColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(right: 10.w),
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
          decoration: BoxDecoration(
              color: background ?? AppColor.white,
              borderRadius: BorderRadius.circular(3.r)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ColorFiltered(
                colorFilter: const ColorFilter.mode(
                    AppColor.backgroundColorGreen, BlendMode.modulate),
                child: Image.network(iconPath,
                    fit: BoxFit.fill, height: 36, width: 36),
              ),
              SizedBox(width: 16.w),
              AppText(
                power,
                textColor: textColor ?? Colors.black,
                size: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(width: 30.w),
            ],
          ),
        ),
        // SizedBox(height: 6.h),
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(3.r)),
                  color: const Color(0xFFC8F4E4)),
              child: AppText("${separator(price)} uzs/kWt",
                  textColor: textColor ?? AppColor.textColor,
                  size: 11.sp,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0.w),
              child: AppText(bottomText ?? '',
                  size: 10.sp,
                  textColor: AppColor.buttonRightColor,
                  fontWeight: FontWeight.w400),
            ),
          ],
        )
      ],
    );
  }

  _imageList(List<Images>? images) {
    return images != null
        ? SizedBox(
            height: 60.h,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return images[index].url != null
                      ? GestureDetector(
                          onTap: () => openImage2(images),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6.r),
                            child: Image.network(images[index].url ?? '',
                                height: 60, width: 70, fit: BoxFit.fill),
                          ),
                        )
                      : SizedBox(height: 30.h);
                },
                separatorBuilder: (context, index) => SizedBox(width: 12.w),
                itemCount: images.length),
          )
        : const SizedBox();
  }

  openImage2(List<Images> imageList) {
    List<String> imageUrls = [];
    for (var element in imageList) {
      imageUrls.add(element.url ?? '');
    }
    PopupBanner(
        context: context,
        fit: BoxFit.cover,
        height: ScreenUtil().screenHeight * 0.8,
        dotsAlignment: Alignment.bottomCenter,
        dotsColorInactive: AppColor.white,
        customCloseButton: CircleAvatar(
            backgroundColor: Colors.black,
            child: Icon(
              Icons.cancel,
              color: Colors.white,
              size: 32.sp,
            )),
        images: imageUrls,
        onClick: (index) {
          log("CLICKED $index");
        }).show();
  }

  void openImage(Images image) {
    log(image.url ?? '');
    pushDragToPopRoute(
        context: context,
        child: OverscrollPop(
            scrollToPopOption: ScrollToPopOption.start,
            dragToPopDirection: DragToPopDirection.vertical,
            friction: 1.5,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                leading: IconButton(
                    onPressed: () => popBack(),
                    icon: const Icon(Icons.close, color: AppColor.white)),
              ),
              body: SizedBox(
                width: ScreenUtil().screenWidth,
                height: ScreenUtil().screenHeight,
                child: Center(
                  child: Image.network(image.url ?? '',
                      height: ScreenUtil().screenHeight * 0.8,
                      width: ScreenUtil().screenWidth,
                      fit: BoxFit.fill),
                ),
              ),
            )));
  }
}
