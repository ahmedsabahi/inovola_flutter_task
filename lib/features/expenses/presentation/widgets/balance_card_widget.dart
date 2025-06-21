import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovola_flutter_task/features/expenses/presentation/bloc/expense/expense_bloc.dart';
import 'package:inovola_flutter_task/features/expenses/presentation/widgets/summary_item_widget.dart';
import 'package:intl/intl.dart';

class BalanceCardWidget extends StatelessWidget {
  const BalanceCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 230,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(81, 109, 235, 1),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(
              81,
              109,
              235,
              1,
            ).withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Balance ^',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.more_horiz,
                  color: Colors.white,
                  size: 35,
                ),
              ),
            ],
          ),
          BlocBuilder<ExpenseBloc, ExpenseState>(
            builder: (context, state) {
              final balance = state is ExpenseLoaded ? state.balance : 0.0;
              return Text(
                NumberFormat.currency(
                  symbol: '\$ ',
                  decimalDigits: 2,
                ).format(balance),
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          const Spacer(),
          BlocBuilder<ExpenseBloc, ExpenseState>(
            builder: (_, state) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SummaryItemWidget(
                  label: 'Income',
                  value: state is ExpenseLoaded ? state.totalIncome : 0.0,
                  icon: Icons.arrow_downward_rounded,
                ),
                SummaryItemWidget(
                  label: 'Expenses',
                  value: state is ExpenseLoaded ? state.totalExpense : 0.0,
                  icon: Icons.arrow_upward_rounded,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
