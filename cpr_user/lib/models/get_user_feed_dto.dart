import 'package:cpr_user/models/feed_review.dart';

class GetUserFeedDto {
  List<FeedReview>? reviews;
  int? count;

  GetUserFeedDto({this.reviews, this.count});

  GetUserFeedDto.fromJson(Map<String, dynamic> json) {
    if (json['reviews'] != null) {
      reviews =    [];
      json['reviews'].forEach((v) {
        reviews!.add(new FeedReview.fromJson(v));
      });
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.reviews != null) {
      data['reviews'] = this.reviews!.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    return data;
  }
}
