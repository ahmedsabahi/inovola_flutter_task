part of 'add_expense_cubit.dart';

class AddExpenseState extends Equatable {
  final CategoryType selectedCategory;
  final String selectedCurrency;
  final String amount;
  final DateTime? selectedDate;
  final List<String> currencies;
  final bool isLoadingCurrencies;

  const AddExpenseState({
    required this.selectedCategory,
    required this.selectedCurrency,
    required this.amount,
    required this.selectedDate,
    required this.currencies,
    this.isLoadingCurrencies = false,
  });

  AddExpenseState copyWith({
    CategoryType? selectedCategory,
    String? selectedCurrency,
    String? amount,
    DateTime? selectedDate,
    List<String>? currencies,
    bool? isLoadingCurrencies,
    String? currencyError,
  }) {
    return AddExpenseState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedCurrency: selectedCurrency ?? this.selectedCurrency,
      amount: amount ?? this.amount,
      selectedDate: selectedDate ?? this.selectedDate,
      currencies: currencies ?? this.currencies,
      isLoadingCurrencies: isLoadingCurrencies ?? this.isLoadingCurrencies,
    );
  }

  @override
  List<Object?> get props => [
    selectedCategory,
    selectedCurrency,
    amount,
    selectedDate,
    currencies,
    isLoadingCurrencies,
  ];
}
