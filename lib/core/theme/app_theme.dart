import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AmountColors extends ThemeExtension<AmountColors> {
  final Color income;
  final Color expense;
  const AmountColors({required this.income, required this.expense});

  @override
  AmountColors copyWith({Color? income, Color? expense}) {
    return AmountColors(
      income: income ?? this.income,
      expense: expense ?? this.expense,
    );
  }

  @override
  AmountColors lerp(ThemeExtension<AmountColors>? other, double t) {
    if (other is! AmountColors) return this;
    return AmountColors(
      income: Color.lerp(income, other.income, t)!,
      expense: Color.lerp(expense, other.expense, t)!,
    );
  }
}

class AppTheme {
  static const primaryColor = Color(0xff1d57f1);
  static const _secondaryColor = Color(0xFF4CAF50);
  static const _errorColor = Color(0xFFE57373);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: _secondaryColor,
      error: _errorColor,
      surface: Colors.white,
    ),
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      labelSmall: TextStyle(
        color: Colors.grey[700],
        fontSize: 10,
        fontWeight: FontWeight.normal,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: const CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 0,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF0F1F6),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
    ),
    extensions: const <ThemeExtension<dynamic>>[
      AmountColors(income: Colors.green, expense: Colors.red),
    ],
  );
}
