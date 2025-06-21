import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovola_flutter_task/features/expenses/presentation/bloc/add_expense/add_expense_cubit.dart';
import 'package:inovola_flutter_task/features/expenses/service/expense_validation.dart';

class DateWidget extends StatelessWidget {
  const DateWidget({super.key});

  Future<void> _pickDate(BuildContext context) async {
    final cubit = context.read<AddExpenseCubit>();
    final picked = await showDatePicker(
      context: context,
      initialDate: cubit.state.selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      cubit.updateDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        BlocBuilder<AddExpenseCubit, AddExpenseState>(
          builder: (context, state) {
            return TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                hintText: state.selectedDate == null
                    ? 'Select date'
                    : '${state.selectedDate!.month.toString().padLeft(2, '0')}/${state.selectedDate!.day.toString().padLeft(2, '0')}/${state.selectedDate!.year.toString().substring(2)}',
                hintStyle: TextStyle(
                  color: state.selectedDate == null
                      ? Colors.grey
                      : Colors.grey[700],
                ),
                suffixIcon: const Icon(Icons.calendar_month_outlined, size: 22),
              ),
              onTap: () => _pickDate(context),
              validator: (value) {
                final date = state.selectedDate;
                return ExpenseValidation.validateDate(date);
              },
            );
          },
        ),
      ],
    );
  }
}
