import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:inovola_flutter_task/core/constants/category_enum.dart';
import 'package:inovola_flutter_task/core/di/injection_container.dart';
import 'package:inovola_flutter_task/core/theme/app_theme.dart';
import 'package:inovola_flutter_task/features/currency/services/currency_initialization_service.dart';
import 'package:inovola_flutter_task/features/expenses/presentation/bloc/expense/expense_bloc.dart';
import 'package:inovola_flutter_task/features/expenses/presentation/bloc/filter/filter_cubit.dart';
import 'package:inovola_flutter_task/features/expenses/presentation/pages/home_screen.dart';
import 'package:inovola_flutter_task/features/expenses/service/expense_filter_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  await Hive.initFlutter();
  await setupDependencies();

  // Initialize currencies in the background
  CurrencyInitializationService.initializeCurrencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ExpenseBloc>(
          create: (_) => sl<ExpenseBloc>()
            ..add(
              LoadExpenses(
                params: sl<ExpenseFilterService>().getFilterParams(
                  FilterType.thisMonth,
                ),
              ),
            ),
        ),
        BlocProvider(create: (_) => FilterCubit()),
      ],
      child: MaterialApp(
        title: 'Expense Tracker',
        theme: AppTheme.lightTheme,
        themeMode: ThemeMode.light,
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
