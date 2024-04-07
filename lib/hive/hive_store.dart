import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_car_app/models/charge_box/ChargeBoxInfo.dart';

class MyHiveStore {
  static late Box<List<ChargeBoxInfo>> chargeBox;
  static late Box<List<ChargeBoxInfo>> chargeBoxForList;

  static init() async {
    log("Hive store init");
    await Hive.initFlutter();
    registerAdapters();
    await openBoxes();
  }

  static Future openBoxes() async {
    chargeBox = await Hive.openBox(MyHiveBoxName.chargeBox);
    chargeBoxForList = await Hive.openBox(MyHiveBoxName.chargeBoxForList);
  }

  static Future clearBoxes() async {
    log("Hive boxes are clear");
    await chargeBox.clear();
  }

  static registerAdapters() {
    Hive.registerAdapter(ChargeBoxInfoAdapter());
  }
}

class MyHiveBoxName {
  static const chargeBox = 'chargeBoxHive';
  static const chargeBoxForList = 'chargeBoxForListHive';
}

class MyHiveTypeId {
  static const chargeBoxId = 1;
}
