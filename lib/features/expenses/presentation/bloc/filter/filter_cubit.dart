import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovola_flutter_task/core/constants/category_enum.dart';

class FilterCubit extends Cubit<FilterType> {
  FilterCubit() : super(FilterType.thisMonth);

  void setFilter(FilterType filter) {
    emit(filter);
  }
}
