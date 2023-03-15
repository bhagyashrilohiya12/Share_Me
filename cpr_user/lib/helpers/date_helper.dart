import 'package:intl/intl.dart';

class DateHelper {
  static DateTime getStartOfTheMonth({required DateTime date}) {
    if (date == null) {
      date = DateTime.now();
    }
    return DateTime(date.year, date.month, 1);
  }

  static DateTime getEndOfTheMonth({required DateTime date}) {
    if (date == null) {
      date = DateTime.now();
    }
    //End of the last month
    var lastMonth = DateTime(date.year, date.month, 0);
    var nextMonth = lastMonth.add(Duration(days: 35));

    return DateTime(date.year, nextMonth.month, 0);
  }

  static String defaultFormat(DateTime date) {
    if (date == null) {
      return "";
    }
    var suffix = "th";
    var digit = date.day % 10;
    if ((digit > 0 && digit < 4) && (date.day < 11 || date.day > 13)) {
      suffix = ["st", "nd", "rd"][digit - 1];
    }
    return DateFormat('MMMM d\'$suffix\' yyyy').format(date);
  }
}
