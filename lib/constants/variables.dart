import 'package:flutter/cupertino.dart';

class AppUrl {
  static const baseUrl = "https://v220.uz";

  // ***************************************************************************

  static const registerUrl = "/api/register";
  static const loginUrl = "/api/authenticate";
  static const otpActivateUrl = "/api/activate";

  static chargeBoxListUrlForMap(String lat, String lon, String distance) {
    return "/api/charge-boxes/public/distance/$lat/$lon/$distance"; // ?connectorId.in=GB/T (AC)&connectorId.in=GB/T (DC)";
  }

  static chargeBoxListUrl(){
    return "/api/charge-boxes/public/filter";
  }

  static chargeBoxImageUrl(String id) {
    return "/api/images/$id";
  }

  static chargeBoxPublicDetails() {
    return "/api/charge-boxes/public/details";
  }

  static addVehicleUrl() {
    return "/api/vehicles";
  }

  static uploadImage() {
    return "/api/images/upload";
  }

  static connectorTypes() {
    return "/api/connector-types";
  }
}

class MyValueNotifiers {
  static ValueNotifier<String> uploadImageLoading = ValueNotifier("Default");
}
