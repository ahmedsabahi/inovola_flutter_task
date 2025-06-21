import 'package:hive/hive.dart';
import 'package:inovola_flutter_task/core/constants/category_enum.dart';
import 'package:inovola_flutter_task/features/expenses/domain/entities/expense.dart';

part 'expense_model.g.dart';

@HiveType(typeId: 0)
class ExpenseModel extends Expense {
  @override
  @HiveField(0)
  final String id;

  @override
  @HiveField(1)
  final double originalAmount;

  @override
  @HiveField(2)
  final String originalCurrency;

  @override
  @HiveField(3)
  final double usdAmount;

  @override
  @HiveField(4)
  final DateTime date;

  @override
  @HiveField(5)
  final CategoryType category;

  @override
  @HiveField(6)
  final String? imagePath;

  @HiveField(7)
  final DateTime createdAt;

  ExpenseModel({
    required this.id,
    required this.originalAmount,
    required this.originalCurrency,
    required this.usdAmount,
    required this.date,
    required this.category,
    this.imagePath,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       super(
         id: id,
         originalAmount: originalAmount,
         originalCurrency: originalCurrency,
         usdAmount: usdAmount,
         date: date,
         category: category,
         imagePath: imagePath,
       );

  factory ExpenseModel.fromEntity(Expense expense) {
    return ExpenseModel(
      id: expense.id,
      originalAmount: expense.originalAmount,
      originalCurrency: expense.originalCurrency,
      usdAmount: expense.usdAmount,
      date: expense.date,
      category: expense.category,
      imagePath: expense.imagePath,
      createdAt: DateTime.now(),
    );
  }
}
