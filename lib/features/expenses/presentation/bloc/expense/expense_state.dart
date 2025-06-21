part of 'expense_bloc.dart';

abstract class ExpenseState extends Equatable {
  const ExpenseState();
  @override
  List<Object?> get props => [];
}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpenseLoaded extends ExpenseState {
  final List<Expense> expenses;
  final bool hasMore;
  final bool isLoadingMore;
  final double totalIncome;
  final double totalExpense;
  final double balance;
  const ExpenseLoaded(
    this.expenses, {
    required this.hasMore,
    this.isLoadingMore = false,
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
  });
  @override
  List<Object?> get props => [
    expenses,
    hasMore,
    isLoadingMore,
    totalIncome,
    totalExpense,
    balance,
  ];
}

class ExpenseError extends ExpenseState {
  final String message;
  const ExpenseError(this.message);
  @override
  List<Object?> get props => [message];
}

class ExpenseEmpty extends ExpenseState {}
