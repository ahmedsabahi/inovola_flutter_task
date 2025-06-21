import 'package:inovola_flutter_task/core/constants/category_enum.dart';
import 'package:inovola_flutter_task/features/expenses/domain/usecases/get_expenses.dart';

class ExpenseFilterService {
  GetExpensesParams getFilterParams(FilterType filterType) {
    final now = DateTime.now();
    DateTime? from;
    DateTime? to;

    switch (filterType) {
      case FilterType.thisMonth:
        from = DateTime(now.year, now.month, 1);
        to = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
        break;
      case FilterType.last7Days:
        from = now.subtract(const Duration(days: 7));
        from = DateTime(from.year, from.month, from.day, 0, 0, 0);
        to = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;
      case FilterType.last30Days:
        from = now.subtract(const Duration(days: 30));
        from = DateTime(from.year, from.month, from.day, 0, 0, 0);
        to = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;
      case FilterType.thisYear:
        from = DateTime(now.year, 1, 1);
        to = DateTime(now.year, 12, 31, 23, 59, 59);
        break;
      case FilterType.allTime:
        from = null;
        to = null;
        break;
    }

    return GetExpensesParams(page: 1, pageSize: 10, from: from, to: to);
  }

  FilterType getFilterTypeFromParams(GetExpensesParams params) {
    final now = DateTime.now();

    if (params.from == null && params.to == null) {
      return FilterType.allTime;
    }

    if (params.from != null && params.to != null) {
      final from = params.from!;
      final to = params.to!;

      // Helper function to compare dates at day level
      bool isSameDay(DateTime date1, DateTime date2) {
        return date1.year == date2.year &&
            date1.month == date2.month &&
            date1.day == date2.day;
      }

      // Check if it's this month
      final thisMonthStart = DateTime(now.year, now.month, 1);
      final thisMonthEnd = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
      if (isSameDay(from, thisMonthStart) && isSameDay(to, thisMonthEnd)) {
        return FilterType.thisMonth;
      }

      // Check if it's last 7 days
      final sevenDaysAgo = now.subtract(const Duration(days: 7));
      final sevenDaysAgoStart = DateTime(
        sevenDaysAgo.year,
        sevenDaysAgo.month,
        sevenDaysAgo.day,
        0,
        0,
        0,
      );
      final nowEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);
      if (isSameDay(from, sevenDaysAgoStart) && isSameDay(to, nowEnd)) {
        return FilterType.last7Days;
      }

      // Check if it's last 30 days
      final thirtyDaysAgo = now.subtract(const Duration(days: 30));
      final thirtyDaysAgoStart = DateTime(
        thirtyDaysAgo.year,
        thirtyDaysAgo.month,
        thirtyDaysAgo.day,
        0,
        0,
        0,
      );
      if (isSameDay(from, thirtyDaysAgoStart) && isSameDay(to, nowEnd)) {
        return FilterType.last30Days;
      }

      // Check if it's this year
      final thisYearStart = DateTime(now.year, 1, 1);
      final thisYearEnd = DateTime(now.year, 12, 31, 23, 59, 59);
      if (isSameDay(from, thisYearStart) && isSameDay(to, thisYearEnd)) {
        return FilterType.thisYear;
      }
    }

    return FilterType.allTime;
  }

  
}
