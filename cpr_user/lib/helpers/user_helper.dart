import 'package:cpr_user/constants/weighting.dart';
import 'package:cpr_user/helpers/number_helper.dart';
import 'package:cpr_user/models/review.dart';
import 'package:flutter_launcher_icons/main.dart';

Weighting findWeightingByReviews(List<Review> reviews) {
  if (reviews == null || reviews.isEmpty || reviews.length < 5) {
    return Weighting.bronze;
  }
  int reviewsCounter = 0;
  for (var s in reviews) {
    try {
      var lastMonth = DateTime.now().subtract(new Duration(days: 30));
      if (lastMonth.isBefore(s.creationTime!)) {
        reviewsCounter++;
      }
    } catch (e) {}
  }
  if (reviewsCounter < 5) {
    return Weighting.bronze;
  } else if (reviewsCounter < 10) {
    return Weighting.silver;
  } else {
    return Weighting.gold;
  }
}

double findRealReviewByWeighting(Weighting weighting, {double review = 3}) {
  if(review==null){
    review = 3;
  }
  double realReview = review;

  int value = review.truncate();
  if (weighting == null) {
    weighting = Weighting.bronze;
  }

  switch (value) {
    case 1:
      realReview = value * _findArrayByWeighting(weighting)[0] * WeightValue.weight[0];
      break;
    case 2:
      realReview = value * _findArrayByWeighting(weighting)[1] * WeightValue.weight[1];
      break;
    case 3:
      realReview = value * _findArrayByWeighting(weighting)[2] * WeightValue.weight[2];
      break;
    case 4:
      realReview = value * _findArrayByWeighting(weighting)[3] * WeightValue.weight[3];
      break;
    case 5:
      realReview = value * _findArrayByWeighting(weighting)[4] * WeightValue.weight[4];
      break;
    default:
      break;
  }

  return NumberHelper.roundTo(realReview);
}

List<double> _findArrayByWeighting(Weighting level) {
  if (level == null) {
    level = Weighting.bronze;
  }

  switch (level) {
    case Weighting.gold:
      return WeightValue.gold;
      break;
    case Weighting.silver:
      return WeightValue.silver;
      break;
    default:
      return WeightValue.bronze;
  }
}
