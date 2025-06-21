import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovola_flutter_task/core/di/injection_container.dart';
import 'package:inovola_flutter_task/core/theme/app_theme.dart';
import 'package:inovola_flutter_task/core/transitions/page_transitions.dart';
import 'package:inovola_flutter_task/features/expenses/presentation/bloc/add_expense/add_expense_cubit.dart';
import 'package:inovola_flutter_task/features/expenses/presentation/bloc/expense/expense_bloc.dart';
import 'package:inovola_flutter_task/features/expenses/presentation/pages/add_expense_screen.dart';
import 'package:inovola_flutter_task/features/expenses/presentation/widgets/animated_expense_list_item.dart';
import 'package:inovola_flutter_task/features/expenses/presentation/widgets/home_header_delegate.dart';
import 'package:inovola_flutter_task/features/file_picker/presentation/bloc/file_picker_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(249, 251, 250, 1),
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                floating: true,
                delegate: HomeHeaderDelegate(minExtent: 330, maxExtent: 340),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Expenses',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'see all',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (state is ExpenseError)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading expenses',
                          style: TextStyle(
                            color: Colors.red[600],
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.message,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              if (state is ExpenseLoading)
                const SliverFillRemaining(
                  child: Center(child: CupertinoActivityIndicator()),
                ),
              if (state is ExpenseEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No expenses yet',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Tap the + button to add your first expense',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (state is ExpenseLoaded)
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) =>
                        AnimatedExpenseListItem(state.expenses[i], index: i),
                    childCount: state.expenses.length,
                  ),
                ),

              // Load More Button
              if (state is ExpenseLoaded && state.hasMore)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state.isLoadingMore
                            ? null
                            : () {
                                context.read<ExpenseBloc>().add(
                                  LoadMoreExpenses(),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: state.isLoadingMore
                            ? const CupertinoActivityIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Load More',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),

              const SliverToBoxAdapter(
                child: SizedBox(height: kBottomNavigationBarHeight + 10),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Expense",
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        elevation: 8,
        child: const Icon(Icons.add, size: 32),
        onPressed: () => Navigator.of(context).push(
          SlideUpPageRoute(
            child: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => FilePickerBloc(
                    pickImageFromGallery: sl(),
                    pickImageFromCamera: sl(),
                    pickFile: sl(),
                    clearUpload: sl(),
                  ),
                ),
                BlocProvider(create: (_) => AddExpenseCubit()),
              ],
              child: const AddExpenseScreen(),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.home_rounded,
                  color: AppTheme.primaryColor,
                  size: 40,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  Icons.bar_chart_rounded,
                  color: Colors.grey[400],
                  size: 40,
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 40), // space for FAB
              IconButton(
                icon: Icon(
                  Icons.list_alt_rounded,
                  color: Colors.grey[400],
                  size: 40,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  Icons.person_rounded,
                  color: Colors.grey[400],
                  size: 40,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
