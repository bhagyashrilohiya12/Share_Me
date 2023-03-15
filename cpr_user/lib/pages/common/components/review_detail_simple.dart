import 'package:cpr_user/models/review.dart';
import 'package:cpr_user/pages/common/components/cpr_button.dart';
import 'package:cpr_user/pages/user/report_review_page/report_review_page.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';

class ReviewDetailSimple extends StatelessWidget {
    ReviewDetailSimple({

    required this.review,
  })  ;

  final Review review;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 16, left: 16, bottom: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              (review.fullReview ?? review.comments) ?? "",
              textAlign: TextAlign.justify,
              style: CPRTextStyles.reviewCardContentTextStyle,
            ),
          ),
          SizedBox(height: 16,),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Business Reply :\n" + (review.businessReply ?? "No reply yet"),
              textAlign: TextAlign.start,
              style: CPRTextStyles.reviewCardContentTextStyle,
            ),
          ),
          SizedBox(height: 16,),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    (review.businessLiked??false)?"Business liked this review":"Business don't liked this review",
                    textAlign: TextAlign.start,
                    style: CPRTextStyles.reviewCardContentTextStyle,
                  ),
                ),
                (review.businessLiked??false)?Icon(Icons.favorite,color: Colors.red,):Icon(Icons.favorite_border)
              ],
            ),
          ),
          SizedBox(height: 16,),
          Container(
            margin: EdgeInsets.only(left: 16),
            child: CPRButton(
              width: 85,
              borderRadius: 5,
              color: CPRColors.cprButtonPink.withOpacity(0.25),
              verticalPadding: 5,
              onPressed: () {
                Get.to(ReportReviewPage(review));
              },
              horizontalPadding: 5,
              child: Row(
                children: <Widget>[
                  Icon(
                    MaterialCommunityIcons.flag,
                    size: 18,
                    color: Colors.red,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text("Report", style: CPRTextStyles.reviewCardContentTextStyle),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 16,),
        ],
      ),
    );
  }
}
