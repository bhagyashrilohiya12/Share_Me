class TimeTools {

  static bool isToday(DateTime date) {
    final DateTime localDate = date.toLocal();
    final now = DateTime.now();
    final diff = now.difference(localDate).inDays;
    return diff == 0 && now.day == localDate.day;
  }


  static bool isSameDate(DateTime date1, DateTime date2) {
    final DateTime localDate1 = date1.toLocal();
    final diff = date2.difference(localDate1).inDays;
    return diff == 0 && date2.day == localDate1.day;
  }


}