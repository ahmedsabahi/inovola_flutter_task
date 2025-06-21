import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovola_flutter_task/core/constants/category_enum.dart';
import 'package:inovola_flutter_task/core/di/injection_container.dart';
import 'package:inovola_flutter_task/features/currency/domain/usecases/get_exchange_rates.dart';

part 'add_expense_state.dart';

class AddExpenseCubit extends Cubit<AddExpenseState> {
  final _amountController = TextEditingController();
  final GetExchangeRates getExchangeRates;

  TextEditingController get amountController => _amountController;

  AddExpenseCubit({GetExchangeRates? getExchangeRates})
    : getExchangeRates = getExchangeRates ?? sl<GetExchangeRates>(),
      super(
        const AddExpenseState(
          selectedCategory: CategoryType.entertainment,
          selectedCurrency: 'USD',
          amount: '',
          selectedDate: null,
          currencies: ['USD'],
          isLoadingCurrencies: true,
        ),
      ) {
    _loadCurrencies();
  }

  Future<void> _loadCurrencies() async {
    emit(state.copyWith(isLoadingCurrencies: true, currencyError: null));
    try {
      final rates = await getExchangeRates();
      final currencies = ['USD', ...rates.keys.where((key) => key != 'USD')];
      emit(state.copyWith(currencies: currencies, isLoadingCurrencies: false));
    } catch (e) {
      emit(
        state.copyWith(isLoadingCurrencies: false, currencyError: e.toString()),
      );
    }
  }

  void updateCategory(CategoryType cat) {
    emit(state.copyWith(selectedCategory: cat));
  }

  void updateCurrency(String currency) {
    emit(state.copyWith(selectedCurrency: currency));
  }

  void updateAmount(String amount) {
    emit(state.copyWith(amount: amount));
  }

  void updateDate(DateTime? date) {
    emit(state.copyWith(selectedDate: date));
  }

  @override
  Future<void> close() {
    _amountController.dispose();
    return super.close();
  }
}
