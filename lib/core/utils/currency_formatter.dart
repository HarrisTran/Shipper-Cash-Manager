import 'package:intl/intl.dart';

/// Utility class for formatting currency values in Vietnamese đồng (VND).
class CurrencyFormatter {
  CurrencyFormatter._(); // Prevent instantiation

  static final NumberFormat _compact = NumberFormat.compact(locale: 'vi_VN');
  static final NumberFormat _grouped = NumberFormat('#,###', 'vi_VN');
  static final NumberFormat _full = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: 'đ',
  );

  /// Format a number as VND with the `đ` symbol.
  /// Example: `1500000` → `"1.500.000đ"`
  static String format(num amount) {
    return '${_grouped.format(amount)}đ';
  }

  /// Format a number as full VND currency string using `intl`.
  /// Example: `1500000` → `"1.500.000 đ"`
  static String formatFull(num amount) {
    return _full.format(amount);
  }

  /// Format a number in compact notation.
  /// Example: `1500000` → `"1,5 Tr"` (locale-dependent)
  static String formatCompact(num amount) {
    return _compact.format(amount);
  }

  /// Format a number as VND and append a suffix label.
  /// Example: `formatWithLabel(5000, 'Phí')` → `"Phí: 5.000đ"`
  static String formatWithLabel(num amount, String label) {
    return '$label: ${format(amount)}';
  }

  /// Parse a formatted currency string back to an integer.
  /// Strips all non-digit characters before parsing.
  /// Returns `null` if parsing fails.
  static int? parse(String formatted) {
    final digitsOnly = formatted.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.isEmpty) return null;
    return int.tryParse(digitsOnly);
  }
}
