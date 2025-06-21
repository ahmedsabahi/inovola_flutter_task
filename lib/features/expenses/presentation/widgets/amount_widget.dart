import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovola_flutter_task/features/expenses/presentation/bloc/add_expense/add_expense_cubit.dart';
import 'package:inovola_flutter_task/features/expenses/service/expense_validation.dart';

class AmountWidget extends StatelessWidget {
  const AmountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Amount',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(
                controller: context.watch<AddExpenseCubit>().amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$')),
                ],
                decoration: const InputDecoration(hintText: '\$50,000'),
                validator: (v) => ExpenseValidation.validateAmount(v),
              ),
            ),
            const SizedBox(width: 12),
            BlocBuilder<AddExpenseCubit, AddExpenseState>(
              builder: (context, state) {
                if (state.isLoadingCurrencies) {
                  return const Center(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                }

                return SizedBox(
                  width: 100,
                  child: DropdownButtonFormField<String>(
                    value: state.selectedCurrency,
                    items: state.currencies
                        .map(
                          (cur) => DropdownMenuItem<String>(
                            value: cur,
                            child: Text(
                              cur,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        context.read<AddExpenseCubit>().updateCurrency(val);
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
