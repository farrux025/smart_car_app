// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ChargeBoxInfo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChargeBoxInfoAdapter extends TypeAdapter<ChargeBoxInfo> {
  @override
  final int typeId = 1;

  @override
  ChargeBoxInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChargeBoxInfo(
      country: fields[0] as String?,
      city: fields[1] as String?,
      addressName: fields[2] as String?,
      street: fields[3] as String?,
      locationLatitude: fields[4] as double?,
      locationLongitude: fields[5] as double?,
      name: fields[6] as String?,
      id: fields[7] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, ChargeBoxInfo obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.country)
      ..writeByte(1)
      ..write(obj.city)
      ..writeByte(2)
      ..write(obj.addressName)
      ..writeByte(3)
      ..write(obj.street)
      ..writeByte(4)
      ..write(obj.locationLatitude)
      ..writeByte(5)
      ..write(obj.locationLongitude)
      ..writeByte(6)
      ..write(obj.name)
      ..writeByte(7)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChargeBoxInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
