import 'package:cpr_user/models/near_rate_places.dart';
import 'package:cpr_user/models/near_rate_reviews.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';

class GetTopRateNearReview {
  List<NearRateReviews>? nearRateReviews;

  // GetTopRateNearReview({this.nearRateReviews});

  GetTopRateNearReview.fromJson(Map<String, dynamic> json) {
    if (json['nearRateReviews'] != null) {
      nearRateReviews = [];
      json['nearRateReviews'].forEach((v) {
        var near = new NearRateReviews.fromJson(v);
        Log.i( "GetTopRateNearReview - nearRateReviews - near: " +  near.toString() );
        nearRateReviews!.add( near );
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.nearRateReviews != null) {
      data['nearRateReviews'] =
          this.nearRateReviews!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
