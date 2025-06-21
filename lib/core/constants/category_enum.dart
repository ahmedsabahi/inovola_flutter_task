import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'category_enum.g.dart';

@HiveType(typeId: 3)
enum CategoryType {
  @HiveField(0)
  groceries,
  @HiveField(1)
  entertainment,
  @HiveField(2)
  gas,
  @HiveField(3)
  shopping,
  @HiveField(4)
  newsPaper,
  @HiveField(5)
  transport,
  @HiveField(6)
  rent,
}

extension CategoryTypeExtension on CategoryType {
  String get name {
    switch (this) {
      case CategoryType.groceries:
        return 'Groceries';
      case CategoryType.entertainment:
        return 'Entertainment';
      case CategoryType.gas:
        return 'Gas';
      case CategoryType.shopping:
        return 'Shopping';
      case CategoryType.newsPaper:
        return 'News Paper';
      case CategoryType.transport:
        return 'Transport';
      case CategoryType.rent:
        return 'Rent';
    }
  }
}

extension CategoryTypeExtensions on CategoryType {
  IconData get icon {
    switch (this) {
      case CategoryType.groceries:
        return Icons.shopping_cart_outlined;
      case CategoryType.entertainment:
        return Icons.local_activity_outlined;
      case CategoryType.gas:
        return Icons.local_gas_station_outlined;
      case CategoryType.shopping:
        return Icons.shopping_bag_outlined;
      case CategoryType.newsPaper:
        return Icons.article_outlined;
      case CategoryType.transport:
        return Icons.directions_car;
      case CategoryType.rent:
        return Icons.home_outlined;
    }
  }

  Color get color {
    switch (this) {
      case CategoryType.groceries:
        return const Color(0xFF26A69A);
      case CategoryType.entertainment:
        return const Color(0xFF7C4DFF);
      case CategoryType.gas:
        return const Color(0xFFFF7043);
      case CategoryType.shopping:
        return const Color(0xFFD81B60);
      case CategoryType.newsPaper:
        return const Color(0xFF039BE5);
      case CategoryType.transport:
        return const Color(0xFF00897B);
      case CategoryType.rent:
        return const Color(0xFFFFB300);
    }
  }
}

enum FilterType { thisMonth, last7Days, last30Days, thisYear, allTime }

extension FilterTypeExtension on FilterType {
  String get name {
    switch (this) {
      case FilterType.thisMonth:
        return 'This month';
      case FilterType.last7Days:
        return 'Last 7 days';
      case FilterType.last30Days:
        return 'Last 30 days';
      case FilterType.thisYear:
        return 'This year';
      case FilterType.allTime:
        return 'All time';
    }
  }
}
