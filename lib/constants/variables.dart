class AppUrl {
  static const baseUrl = "https://v220.uz";
  static const registerUrl = "/api/register";
  static const loginUrl = "/api/authenticate";
  static const otpActivateUrl = "/api/activate";

  static chargeBoxListUrl(double lat, double lon, double distance) {
    return "/charge-boxes/public/distance/$lat/$lon/$distance";
  }

  static chargeBoxCountUrl() {
    return "/charge-boxes/count";
  }
}
