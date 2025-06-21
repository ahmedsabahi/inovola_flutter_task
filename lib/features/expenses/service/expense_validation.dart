class ExpenseValidation {
  static String? validateAmount(String? amount) {
    if (amount == null || amount.isEmpty) {
      return 'Amount is required';
    }

    final amountValue = double.tryParse(amount) ?? 0;

    if (amountValue <= 0) {
      return 'Amount must be greater than zero';
    }

    if (amountValue > 999999999.99) {
      return 'Amount cannot exceed \$999,999,999.99';
    }

    // Check for reasonable precision (max 2 decimal places)
    final decimalPlaces = _getDecimalPlaces(amountValue);
    if (decimalPlaces > 2) {
      return 'Amount cannot have more than 2 decimal places';
    }

    return null;
  }

  /// Validates the date value
  /// Returns a ValidationResult with success status and error message
  static String? validateDate(DateTime? date) {
    if (date == null) {
      return 'Date is required';
    }

    final now = DateTime.now();
    if (date.isAfter(now)) {
      return 'Date cannot be in the future';
    }

    // Allow dates exactly 100 years ago by year/month/day
    final hundredYearsAgo = DateTime(now.year - 100, now.month, now.day);
    if (date.isBefore(hundredYearsAgo)) {
      return 'Date cannot be more than 100 years ago';
    }

    return null;
  }

  /// Helper method to get decimal places of a number
  static int _getDecimalPlaces(double number) {
    final string = number.toString();
    final decimalIndex = string.indexOf('.');
    if (decimalIndex == -1) return 0;
    return string.length - decimalIndex - 1;
  }
}
