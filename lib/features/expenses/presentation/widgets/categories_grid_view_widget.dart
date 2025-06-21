import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovola_flutter_task/core/constants/category_enum.dart';
import 'package:inovola_flutter_task/core/theme/app_theme.dart';
import 'package:inovola_flutter_task/features/expenses/presentation/bloc/add_expense/add_expense_cubit.dart';

class CategoriesGridViewWidget extends StatelessWidget {
  const CategoriesGridViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: CategoryType.values.length + 1,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            if (index == CategoryType.values.length) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blueAccent, width: 2),
                    ),
                    padding: const EdgeInsets.all(14),
                    child: const Icon(
                      Icons.add,
                      color: Colors.blueAccent,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Add Category',
                    style: TextStyle(color: Colors.grey[700], fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            }

            final cat = CategoryType.values[index];

            return GestureDetector(
              onTap: () => context.read<AddExpenseCubit>().updateCategory(cat),
              child: BlocBuilder<AddExpenseCubit, AddExpenseState>(
                builder: (_, state) {
                  final isSelected = state.selectedCategory == cat;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primaryColor
                              : cat.color.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(14),
                        child: Icon(
                          cat.icon,
                          color: isSelected ? Colors.white : cat.color,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        cat.name,
                        style: TextStyle(
                          color: isSelected
                              ? AppTheme.primaryColor
                              : Colors.grey[700],
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
