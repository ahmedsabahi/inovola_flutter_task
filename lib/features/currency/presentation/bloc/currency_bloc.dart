import 'package:flutter_bloc/flutter_bloc.dart';
import 'currency_event.dart';
import 'currency_state.dart';
import '../../domain/usecases/get_exchange_rates.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  final GetExchangeRates getExchangeRates;
  CurrencyBloc({required this.getExchangeRates}) : super(CurrencyInitial()) {
    on<LoadExchangeRates>((event, emit) async {
      emit(CurrencyLoading());
      try {
        final rates = await getExchangeRates();
        emit(CurrencyLoaded(rates));
      } catch (e) {
        emit(CurrencyError(e.toString()));
      }
    });
  }
}
