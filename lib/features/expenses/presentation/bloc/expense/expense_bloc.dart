import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovola_flutter_task/core/constants/category_enum.dart';
import 'package:inovola_flutter_task/core/di/injection_container.dart';
import 'package:inovola_flutter_task/features/currency/services/currency_calculation_service.dart';
import 'package:inovola_flutter_task/features/expenses/domain/entities/expense.dart';
import 'package:inovola_flutter_task/features/expenses/domain/usecases/add_expense.dart';
import 'package:inovola_flutter_task/features/expenses/domain/usecases/get_expenses.dart';
import 'package:inovola_flutter_task/features/expenses/service/expense_calculation_service.dart';

part 'expense_event.dart';
part 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final GetExpenses getExpenses;
  final AddExpense addExpense;
  final ExpenseCalculationService _calculationService;

  List<Expense> _allExpenses = [];
  int _currentPage = 1;
  bool _hasMore = true;
  GetExpensesParams? _lastParams;

  static const int pageSize = 10;

  ExpenseBloc({
    required this.getExpenses,
    required this.addExpense,
    ExpenseCalculationService? calculationService,
  }) : _calculationService =
           calculationService ?? sl<ExpenseCalculationService>(),
       super(ExpenseInitial()) {
    on<LoadExpenses>(_onLoadExpenses);
    on<LoadMoreExpenses>(_onLoadMoreExpenses);
    on<ChangeExpenseFilter>(_onChangeExpenseFilter);
    on<AddExpenseEvent>(_onAddExpense);
  }

  Future<void> _onLoadExpenses(
    LoadExpenses event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(ExpenseLoading());
    try {
      _currentPage = event.params.page;
      _lastParams = event.params;
      final expenses = await getExpenses(event.params);
      _allExpenses = expenses;
      _hasMore = expenses.length == event.params.pageSize;

      if (_allExpenses.isEmpty) {
        emit(ExpenseEmpty());
      } else {
        final summary = _calculationService.calculateFinancialSummary(
          _allExpenses,
        );
        emit(
          ExpenseLoaded(
            _allExpenses,
            hasMore: _hasMore,
            totalIncome: summary.totalIncome,
            totalExpense: summary.totalExpense,
            balance: summary.balance,
          ),
        );
      }
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }

  Future<void> _onLoadMoreExpenses(
    LoadMoreExpenses event,
    Emitter<ExpenseState> emit,
  ) async {
    if (!_hasMore || _lastParams == null) return;

    // Emit loading state with current metrics
    final currentSummary = _calculationService.calculateFinancialSummary(
      _allExpenses,
    );
    emit(
      ExpenseLoaded(
        _allExpenses,
        hasMore: _hasMore,
        isLoadingMore: true,
        totalIncome: currentSummary.totalIncome,
        totalExpense: currentSummary.totalExpense,
        balance: currentSummary.balance,
      ),
    );

    try {
      final nextPage = _currentPage + 1;
      final params = GetExpensesParams(
        page: nextPage,
        pageSize: pageSize,
        from: _lastParams!.from,
        to: _lastParams!.to,
        category: _lastParams!.category,
      );
      final moreExpenses = await getExpenses(params);
      _allExpenses.addAll(moreExpenses);
      _currentPage = nextPage;
      _hasMore = moreExpenses.length == pageSize;

      // Calculate updated metrics
      final updatedSummary = _calculationService.calculateFinancialSummary(
        _allExpenses,
      );
      emit(
        ExpenseLoaded(
          _allExpenses,
          hasMore: _hasMore,
          totalIncome: updatedSummary.totalIncome,
          totalExpense: updatedSummary.totalExpense,
          balance: updatedSummary.balance,
        ),
      );
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }

  Future<void> _onChangeExpenseFilter(
    ChangeExpenseFilter event,
    Emitter<ExpenseState> emit,
  ) async {
    add(LoadExpenses(params: event.params));
  }

  Future<void> _onAddExpense(
    AddExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      double usdAmount = event.originalAmount;
      if (event.originalCurrency != 'USD') {
        final currencyCalculationService = sl<CurrencyCalculationService>();
        usdAmount = await currencyCalculationService.convertToUSD(
          amount: event.originalAmount,
          fromCurrency: event.originalCurrency,
        );
      }
      // Make usdAmount negative for expenses (money going out)
      usdAmount = -usdAmount.abs();
      final expense = Expense(
        originalAmount: event.originalAmount,
        originalCurrency: event.originalCurrency,
        usdAmount: usdAmount,
        date: event.date,
        category: event.category,
        imagePath: event.imagePath,
      );
      await addExpense(expense);
      // Reload first page with last filter
      add(
        LoadExpenses(
          params: _lastParams ?? GetExpensesParams(page: 1, pageSize: pageSize),
        ),
      );
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }
}
