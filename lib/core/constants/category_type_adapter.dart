import 'package:hive/hive.dart';
import 'package:inovola_flutter_task/core/constants/category_enum.dart';

class CategoryTypeAdapter extends TypeAdapter<CategoryType> {
  @override
  final typeId = 2;

  @override
  CategoryType read(BinaryReader reader) {
    return CategoryType.values[reader.readInt()];
  }

  @override
  void write(BinaryWriter writer, CategoryType obj) {
    writer.writeInt(obj.index);
  }
}
