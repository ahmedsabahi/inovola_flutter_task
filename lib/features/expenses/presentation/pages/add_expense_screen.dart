import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovola_flutter_task/features/expenses/presentation/bloc/add_expense/add_expense_cubit.dart';
import 'package:inovola_flutter_task/features/expenses/presentation/bloc/expense/expense_bloc.dart';
import 'package:inovola_flutter_task/features/expenses/presentation/widgets/amount_widget.dart';
import 'package:inovola_flutter_task/features/expenses/presentation/widgets/categories_grid_view_widget.dart';
import 'package:inovola_flutter_task/features/expenses/presentation/widgets/category_widget.dart';
import 'package:inovola_flutter_task/features/expenses/presentation/widgets/date_widget.dart';
import 'package:inovola_flutter_task/features/file_picker/presentation/bloc/file_picker_bloc.dart';
import 'package:inovola_flutter_task/features/file_picker/presentation/widgets/file_picker_widget.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();

  void _submitForm(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final cubit = context.read<AddExpenseCubit>();
      final uploadState = context.read<FilePickerBloc>().state;

      context.read<ExpenseBloc>().add(
        AddExpenseEvent(
          originalAmount: double.parse(cubit.amountController.text),
          originalCurrency: cubit.state.selectedCurrency,
          date: cubit.state.selectedDate ?? DateTime.now(),
          category: cubit.state.selectedCategory,
          imagePath: uploadState.model.file?.path,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExpenseBloc, ExpenseState>(
      listener: (context, state) {
        if (state is ExpenseLoaded) {
          Navigator.of(context).pop();
        }
        if (state is ExpenseError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Add Expense')),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Form(
            key: _formKey,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ListView(
                  padding: const EdgeInsets.only(
                    bottom: kBottomNavigationBarHeight + 20,
                  ),
                  children: const [
                    CategoryWidget(),
                    SizedBox(height: 20),
                    AmountWidget(),
                    SizedBox(height: 20),
                    DateWidget(),
                    SizedBox(height: 20),
                    UploadReceiptWidget(),
                    SizedBox(height: 24),
                    CategoriesGridViewWidget(),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => _submitForm(context),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
