import 'package:flutter/cupertino.dart';

class AppUrl {
  static const baseUrl = "https://v220.uz";

  // ***************************************************************************

  static const registerUrl = "/api/register";
  static const loginUrl = "/api/authenticate";
  static const otpActivateUrl = "/api/activate";

  static chargeBoxListUrl(String lat, String lon, String distance) {
    return "/api/charge-boxes/public/distance/$lat/$lon/$distance";
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
}

class MyValueNotifiers {
  static ValueNotifier<String> uploadImageLoading = ValueNotifier("Default");
}
