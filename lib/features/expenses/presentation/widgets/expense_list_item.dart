import 'package:flutter/material.dart';
import 'package:inovola_flutter_task/core/constants/category_enum.dart';
import 'package:inovola_flutter_task/features/expenses/domain/entities/expense.dart';
import 'package:intl/intl.dart';

class ExpenseListItem extends StatelessWidget {
  final Expense expense;

  const ExpenseListItem(this.expense, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: expense.category.color.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(14),
            child: Icon(
              expense.category.icon,
              color: expense.category.color,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.category.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Manually',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                expense.usdAmount > 0
                    ? '+ ${NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(expense.usdAmount.abs())}'
                    : '- ${NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(expense.usdAmount.abs())}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                expense.usdAmount > 0
                    ? '+ ${NumberFormat.currency(customPattern: '${expense.originalCurrency} ', decimalDigits: 2).format(expense.originalAmount.abs())}'
                    : '- ${NumberFormat.currency(customPattern: '${expense.originalCurrency} ', decimalDigits: 2).format(expense.originalAmount.abs())}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                _formatDate(expense.date),
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final dateToCompare = DateTime(date.year, date.month, date.day);

    if (dateToCompare == today) {
      return 'Today ${DateFormat('h:mm a').format(date)}';
    } else if (dateToCompare == yesterday) {
      return 'Yesterday ${DateFormat('h:mm a').format(date)}';
    } else {
      return DateFormat('d MMM').format(date);
    }
  }
}
