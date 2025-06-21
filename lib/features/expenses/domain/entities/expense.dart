import 'package:equatable/equatable.dart';
import 'package:inovola_flutter_task/core/constants/category_enum.dart';
import 'package:uuid/uuid.dart';

class Expense extends Equatable {
  final String id;
  final double originalAmount;
  final String originalCurrency;
  final double usdAmount;
  final DateTime date;
  final CategoryType category;
  final String? imagePath;

  Expense({
    String? id,
    required this.originalAmount,
    required this.originalCurrency,
    required this.usdAmount,
    required this.date,
    required this.category,
    this.imagePath,
  }) : id = id ?? const Uuid().v4();

  @override
  List<Object?> get props => [
    id,
    originalAmount,
    originalCurrency,
    usdAmount,
    date,
    category,
    imagePath,
  ];
}
