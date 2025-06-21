// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_enum.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CategoryTypeAdapter extends TypeAdapter<CategoryType> {
  @override
  final int typeId = 3;

  @override
  CategoryType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CategoryType.groceries;
      case 1:
        return CategoryType.entertainment;
      case 2:
        return CategoryType.gas;
      case 3:
        return CategoryType.shopping;
      case 4:
        return CategoryType.newsPaper;
      case 5:
        return CategoryType.transport;
      case 6:
        return CategoryType.rent;
      default:
        return CategoryType.groceries;
    }
  }

  @override
  void write(BinaryWriter writer, CategoryType obj) {
    switch (obj) {
      case CategoryType.groceries:
        writer.writeByte(0);
        break;
      case CategoryType.entertainment:
        writer.writeByte(1);
        break;
      case CategoryType.gas:
        writer.writeByte(2);
        break;
      case CategoryType.shopping:
        writer.writeByte(3);
        break;
      case CategoryType.newsPaper:
        writer.writeByte(4);
        break;
      case CategoryType.transport:
        writer.writeByte(5);
        break;
      case CategoryType.rent:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
