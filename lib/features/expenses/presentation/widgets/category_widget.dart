import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovola_flutter_task/core/constants/category_enum.dart';
import 'package:inovola_flutter_task/features/expenses/presentation/bloc/add_expense/add_expense_cubit.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key});

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
        const SizedBox(height: 8),
        BlocBuilder<AddExpenseCubit, AddExpenseState>(
          builder: (_, state) {
            return DropdownButtonFormField<CategoryType>(
              value: state.selectedCategory,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: CategoryType.values
                  .map(
                    (cat) => DropdownMenuItem<CategoryType>(
                      value: cat,
                      child: Text(
                        cat.name,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (cat) {
                if (cat != null) {
                  context.read<AddExpenseCubit>().updateCategory(cat);
                }
              },
              validator: (value) {
                if (value == null) {
                  return 'Category is required';
                }
                return null;
              },
            );
          },
        ),
      ],
    );
  }
}
