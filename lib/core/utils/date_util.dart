class DateUtil {
  static DateTime getStartOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime getEndOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  static String getWeekdayVietnamese(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        return "Thứ Hai";
      case DateTime.tuesday:
        return "Thứ Ba";
      case DateTime.wednesday:
        return "Thứ Tư";
      case DateTime.thursday:
        return "Thứ Năm";
      case DateTime.friday:
        return "Thứ Sáu";
      case DateTime.saturday:
        return "Thứ Bảy";
      case DateTime.sunday:
        return "Chủ Nhật";
      default:
        return "";
    }
  }

  static String format(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
