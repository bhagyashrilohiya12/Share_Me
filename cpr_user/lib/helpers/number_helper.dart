import 'package:intl/intl.dart';

class NumberHelper {

  static String? formattedDistance(double distance) {
    if (distance == null) {
      return null;
    }
    var formatter = NumberFormat.decimalPattern();
    formatter.maximumFractionDigits = 0;
    return formatter.format(distance);
  }

  static double roundTo(double value, {int decimals = 2}) {
    try {
      return double.parse(value.toStringAsFixed(decimals));
    } catch (e) {}
    return 0;
  }



}