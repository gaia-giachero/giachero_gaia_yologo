import 'package:intl/intl.dart';

class DateFormatter {
  static String formatta(DateTime? dataEsterna) {
    if (dataEsterna == null) return '-';
    return DateFormat('dd/MM/yy').format(dataEsterna);
  }

  static String formatRange(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) return '-';
    final formatter = DateFormat('dd/MM/yy');
    final start = formatter.format(startDate);
    final end = formatter.format(endDate);
    return '$start - $end';
  }
}