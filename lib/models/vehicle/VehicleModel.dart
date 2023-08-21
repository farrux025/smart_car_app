class VehicleModel {
  String? vehicleName;
  String? imagePath;
  double? _chargeValue;

  set chargeValue(double value) {
    if (value <= 1) {
      _chargeValue = value;
    } else {
      _chargeValue = 0;
    }
  }

  double get chargeValue => _chargeValue ?? 0;

  VehicleModel(this.vehicleName, this.imagePath, this._chargeValue);
}
