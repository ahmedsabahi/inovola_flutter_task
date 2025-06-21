// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_cache_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CurrencyCacheModelAdapter extends TypeAdapter<CurrencyCacheModel> {
  @override
  final int typeId = 1;

  @override
  CurrencyCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CurrencyCacheModel(
      rates: (fields[0] as Map).cast<String, double>(),
      lastUpdated: fields[1] as DateTime,
      baseCurrency: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CurrencyCacheModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.rates)
      ..writeByte(1)
      ..write(obj.lastUpdated)
      ..writeByte(2)
      ..write(obj.baseCurrency);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrencyCacheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
