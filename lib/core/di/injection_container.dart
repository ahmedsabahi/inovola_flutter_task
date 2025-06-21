import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inovola_flutter_task/core/constants/category_type_adapter.dart';
import 'package:inovola_flutter_task/features/currency/data/datasources/currency_cache_datasource.dart';
import 'package:inovola_flutter_task/features/currency/data/datasources/currency_remote_datasource.dart';
import 'package:inovola_flutter_task/features/currency/data/models/currency_cache_model.dart';
import 'package:inovola_flutter_task/features/currency/data/repositories/currency_repository_impl.dart';
import 'package:inovola_flutter_task/features/currency/domain/repositories/currency_repository.dart';
import 'package:inovola_flutter_task/features/currency/domain/usecases/get_exchange_rates.dart';
import 'package:inovola_flutter_task/features/currency/presentation/bloc/currency_bloc.dart';
import 'package:inovola_flutter_task/features/currency/services/currency_calculation_service.dart';
import 'package:inovola_flutter_task/features/expenses/data/datasources/expense_local_datasource.dart';
import 'package:inovola_flutter_task/features/expenses/data/models/expense_model.dart';
import 'package:inovola_flutter_task/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:inovola_flutter_task/features/expenses/domain/repositories/expense_repository.dart';
import 'package:inovola_flutter_task/features/expenses/domain/usecases/add_expense.dart';
import 'package:inovola_flutter_task/features/expenses/domain/usecases/get_expenses.dart';
import 'package:inovola_flutter_task/features/expenses/presentation/bloc/add_expense/add_expense_cubit.dart';
import 'package:inovola_flutter_task/features/expenses/presentation/bloc/expense/expense_bloc.dart';
import 'package:inovola_flutter_task/features/expenses/service/expense_calculation_service.dart';
import 'package:inovola_flutter_task/features/expenses/service/expense_filter_service.dart';
import 'package:inovola_flutter_task/features/expenses/service/expense_validation.dart';
import 'package:inovola_flutter_task/features/file_picker/data/datasources/file_picker_datasource.dart';
import 'package:inovola_flutter_task/features/file_picker/data/datasources/file_picker_datasource_impl.dart';
import 'package:inovola_flutter_task/features/file_picker/data/repositories/file_picker_repository_impl.dart';
import 'package:inovola_flutter_task/features/file_picker/domain/repositories/file_picker_repository.dart';
import 'package:inovola_flutter_task/features/file_picker/domain/usecases/clear_file_picker.dart';
import 'package:inovola_flutter_task/features/file_picker/domain/usecases/pick_file.dart';
import 'package:inovola_flutter_task/features/file_picker/domain/usecases/pick_image_from_camera.dart';
import 'package:inovola_flutter_task/features/file_picker/domain/usecases/pick_image_from_gallery.dart';
import 'package:inovola_flutter_task/features/file_picker/presentation/bloc/file_picker_bloc.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  // Register ImagePicker and FilePicker
  final imagePicker = ImagePicker();
  final filePicker = FilePicker.platform;

  // Register Hive adapters
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(ExpenseModelAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(CurrencyCacheModelAdapter());
  }
  // Register Hive adapters
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(CategoryTypeAdapter());
  }

  // Open Hive boxes
  final expenseBox = await Hive.openBox<ExpenseModel>('expenses');
  final currencyCacheBox = await Hive.openBox<CurrencyCacheModel>(
    'currency_cache',
  );

  // Dio
  sl.registerLazySingleton(() => Dio());

  // Currency Remote Data Source
  sl.registerLazySingleton<CurrencyRemoteDataSource>(
    () => CurrencyRemoteDataSourceImpl(dio: sl()),
  );

  // Currency Cache Data Source
  sl.registerLazySingleton<CurrencyCacheDataSource>(
    () => CurrencyCacheDataSourceImpl(box: currencyCacheBox),
  );

  // Currency Calculation Service
  sl.registerLazySingleton<CurrencyCalculationService>(
    () => CurrencyCalculationService(currencyRemoteDataSource: sl()),
  );

  // Expense Calculation Service
  sl.registerLazySingleton<ExpenseCalculationService>(
    () => ExpenseCalculationService(),
  );

  // Expense Validation Service
  sl.registerLazySingleton<ExpenseValidation>(() => ExpenseValidation());

  // Bloc
  sl.registerFactory(() => ExpenseBloc(getExpenses: sl(), addExpense: sl()));
  sl.registerFactory(() => AddExpenseCubit(getExchangeRates: sl()));
  sl.registerFactory(
    () => FilePickerBloc(
      pickImageFromGallery: sl(),
      pickImageFromCamera: sl(),
      pickFile: sl(),
      clearUpload: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetExpenses(sl()));
  sl.registerLazySingleton(() => AddExpense(sl()));
  sl.registerLazySingleton(() => PickImageFromGallery(sl()));
  sl.registerLazySingleton(() => PickImageFromCamera(sl()));
  sl.registerLazySingleton(() => PickFile(sl()));
  sl.registerLazySingleton(() => ClearFilePickerUseCase(sl()));

  // Register FilePickerDataSource
  sl.registerLazySingleton<FilePickerDataSource>(
    () => FilePickerDataSourceImpl(
      filePicker: filePicker,
      imagePicker: imagePicker,
    ),
  );

  // Repository
  sl.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<FilePickerRepository>(
    () => FilePickerRepositoryImpl(filePickerDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<ExpenseLocalDataSource>(
    () => ExpenseLocalDataSourceImpl(box: expenseBox),
  );

  // Currency Repository
  sl.registerLazySingleton<CurrencyRepository>(
    () => CurrencyRepositoryImpl(remoteDataSource: sl(), cacheDataSource: sl()),
  );
  // Currency Use Case
  sl.registerLazySingleton(() => GetExchangeRates(sl()));
  // Currency Bloc
  sl.registerFactory(() => CurrencyBloc(getExchangeRates: sl()));

  //  Expense Filter Service
  sl.registerLazySingleton<ExpenseFilterService>(() => ExpenseFilterService());
}
