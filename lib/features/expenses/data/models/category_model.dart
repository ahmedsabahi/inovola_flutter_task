import 'package:flutter/material.dart';
import 'package:inovola_flutter_task/core/constants/category_enum.dart';

class CategoryModel {
  final CategoryType type;
  final IconData icon;
  final Color color;

  const CategoryModel({
    required this.type,
    required this.icon,
    required this.color,
  });

  String get displayLabel => type.name;
}
