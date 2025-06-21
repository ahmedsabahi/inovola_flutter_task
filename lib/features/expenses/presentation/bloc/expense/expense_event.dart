part of 'expense_bloc.dart';

abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();
  @override
  List<Object?> get props => [];
}

class LoadExpenses extends ExpenseEvent {
  final GetExpensesParams params;
  final bool refresh;
  const LoadExpenses({required this.params, this.refresh = false});
  @override
  List<Object?> get props => [params, refresh];
}

class LoadMoreExpenses extends ExpenseEvent {}

class ChangeExpenseFilter extends ExpenseEvent {
  final GetExpensesParams params;
  const ChangeExpenseFilter(this.params);
  @override
  List<Object?> get props => [params];
}

class AddExpenseEvent extends ExpenseEvent {
  final double originalAmount;
  final String originalCurrency;
  final DateTime date;
  final CategoryType category;
  final String? imagePath;

  const AddExpenseEvent({
    required this.originalAmount,
    required this.originalCurrency,
    required this.date,
    required this.category,
    this.imagePath,
  });

  @override
  List<Object?> get props => [
    originalAmount,
    originalCurrency,
    date,
    category,
    imagePath,
  ];
}
