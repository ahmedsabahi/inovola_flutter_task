import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SummaryItemWidget extends StatelessWidget {
  const SummaryItemWidget({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });
  final String label;
  final double value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: label == 'Income'
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.white70),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          NumberFormat.currency(symbol: '\$ ', decimalDigits: 2).format(value),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
