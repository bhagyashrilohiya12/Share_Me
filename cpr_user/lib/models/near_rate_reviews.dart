import 'package:cpr_user/models/place.dart';
import 'package:cpr_user/models/review.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';

class NearRateReviews {
  String? reviewId;
  double? dis;
  var rate;  //total review values
  Review? review;

  NearRateReviews({this.reviewId, this.dis, this.rate, this.review});

  NearRateReviews.fromJson(Map<String, dynamic> json) {
    reviewId = json['reviewId'];
    dis = json['dis'];
    rate = json['rate'];
    review = json['review'] != null ? new Review.fromJSON(json['review']) : null;


    //check rate is not found at "review"
    if(review != null  ) {
      bool isEmptyRating =  review!.rating == null || review!.rating == 0;
      if( isEmptyRating ) {
        /**
         * set rate of "near rate review" result
         */
        review!.rating = rate;
        Log.i( "NearRateReviews - fix rate of review is empty");
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reviewId'] = this.reviewId;
    data['dis'] = this.dis;
    data['rate'] = this.rate;
    if (this.review != null) {
      data['review'] = this.review!.toJSON();
    }
    return data;
  }

  @override
  String toString() {
    return 'NearRateReviews{reviewId: $reviewId, dis: $dis, rate: $rate, review: $review}';
  }
}