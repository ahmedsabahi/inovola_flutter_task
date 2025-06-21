import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovola_flutter_task/core/constants/category_enum.dart';
import 'package:inovola_flutter_task/core/di/injection_container.dart';
import 'package:inovola_flutter_task/features/expenses/presentation/bloc/expense/expense_bloc.dart';
import 'package:inovola_flutter_task/features/expenses/presentation/bloc/filter/filter_cubit.dart';
import 'package:inovola_flutter_task/features/expenses/service/expense_filter_service.dart';

class FilterWidget extends StatelessWidget {
  const FilterWidget({super.key});

  void _onFilterChanged(BuildContext context, FilterType filterType) {
    context.read<FilterCubit>().setFilter(filterType);
    context.read<ExpenseBloc>().add(
      ChangeExpenseFilter(
        sl<ExpenseFilterService>().getFilterParams(filterType),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...ListTile.divideTiles(
            color: Colors.grey.withValues(alpha: 0.2),
            tiles: [
              ListTile(
                title: const Text('This Month'),
                leading: const Icon(Icons.calendar_month),
                onTap: () => _onFilterChanged(context, FilterType.thisMonth),
              ),
              ListTile(
                title: const Text('Last 7 Days'),
                leading: const Icon(Icons.today),
                onTap: () => _onFilterChanged(context, FilterType.last7Days),
              ),
              ListTile(
                title: const Text('Last 30 Days'),
                leading: const Icon(Icons.calendar_view_month),
                onTap: () => _onFilterChanged(context, FilterType.last30Days),
              ),
              ListTile(
                title: const Text('This Year'),
                leading: const Icon(Icons.calendar_today),
                onTap: () => _onFilterChanged(context, FilterType.thisYear),
              ),
              ListTile(
                title: const Text('All Time'),
                leading: const Icon(Icons.all_inclusive),
                onTap: () => _onFilterChanged(context, FilterType.allTime),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
