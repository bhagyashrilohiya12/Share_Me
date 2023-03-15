import 'dart:math';

import 'package:cpr_user/models/review.dart';
import 'package:cpr_user/helpers/date_helper.dart';

String formatMaxString(String val, int length) {
  if (val == null) {
    return "";
  }
  if (val.length <= length) {
    return val;
  }
  return val.substring(0, length - 3) + "...";
}

String formatReview(Review review) {
  String whenSentence =
      "I was there on ${DateHelper.defaultFormat(review.when!)}"; // ?? review.creationTime!)}";
  String withSentence =
      review.companion != null ? " with ${review.companion}" : "";
  String whySentence =
      review.reasonOfVisit != null ? " for a ${review.reasonOfVisit}" : "";
  String whoSentence =
      "${review.serverName != null && review.serverName!.isNotEmpty ? " I was served by  " + review.serverName! : review.server != null ? " I was served by " + review.server!.firstName! + " " + review.server!.surname! : ""}";
  String whatSentence =
      review.service != null ? " and ordered ${review.service}" : "";
  String message =
      "$whenSentence$withSentence$whySentence.$whoSentence$whatSentence. \n${review.comments}";
  return message;
}

String getRandomCouponCode() {
  int length = 7;
  const ch = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
  Random r = Random();
  return String.fromCharCodes(
      Iterable.generate(length, (_) => ch.codeUnitAt(r.nextInt(ch.length))));
}

extension StringExtension on String {
  String capitalize() {
    if (this.length > 0)
      return "${this[0].toUpperCase()}${this.substring(1)}";
    else
      return this;
  }
}
