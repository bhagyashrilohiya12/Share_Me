import 'package:cpr_user/models/review.dart';
import 'package:cpr_user/models/review_like.dart';
import 'package:cpr_user/models/user.dart';
import 'package:cpr_user/services/review_like_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CPRLikeReviewButton extends StatefulWidget {
  Review review;
  CPRReviewLike? reviewLike;
  CPRUser loginedUser;

  CPRLikeReviewButton(this.review, this.reviewLike, this.loginedUser);

  @override
  _CPRLikeReviewButtonState createState() => _CPRLikeReviewButtonState();
}

class _CPRLikeReviewButtonState extends State<CPRLikeReviewButton> {
  bool showProgressLikeUnlike = false; // for prevent double like or unlike

  @override
  void initState() {
    _getLikedReview();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      right: 20,
      child: Row(
        children: <Widget>[
          Material(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
                height: 40,
                width: 40,
                child: GestureDetector(
                    onTap: () {
                      if (!showProgressLikeUnlike) {
                        if (widget.reviewLike != null)
                          _unlikeReview();
                        else
                          _likeReview();
                      }
                    },
                    child: showProgressLikeUnlike
                        ? Container(
                            width: 24,
                            height: 24,
                            child: Center(
                              child: SpinKitThreeBounce(
                                size: 8,
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                          )
                        : Icon(
                            widget.reviewLike != null ? FontAwesome.heart : FontAwesome.heart_o,
                            color: widget.reviewLike != null ? Colors.red : Colors.black,
                          ))),
          ),
        ],
      ),
    );
  }


  _getLikedReview() async {
    ReviewLikeService reviewLikeService = new ReviewLikeService();
    CPRReviewLike? reviewLikeTemp = await reviewLikeService.getLikedReview(widget.loginedUser.email!,
        widget.review.firebaseId! );
    setState(() {
      widget.reviewLike = reviewLikeTemp;
    });
  }


  _likeReview() async {
    setState(() {
      showProgressLikeUnlike = true;
    });
    ReviewLikeService reviewLikeService = new ReviewLikeService();

    var cpr = new CPRReviewLike(
        liker: widget.loginedUser,
        likerId: widget.loginedUser.email!,
        review: widget.review,
        reviewId: widget.review.firebaseId!
    );

    CPRReviewLike? reviewLikeTemp = await reviewLikeService.likeReview( cpr);
    if (reviewLikeTemp != null)
      setState(() {
        widget.reviewLike = reviewLikeTemp;
      });
    setState(() {
      showProgressLikeUnlike = false;
    });
  }

  _unlikeReview() async {
    setState(() {
      showProgressLikeUnlike = true;
    });
    ReviewLikeService reviewLikeService = new ReviewLikeService();
    bool unLiked = await reviewLikeService.unlikeReview(widget.reviewLike!.id!);
    if (unLiked)
      setState(() {
        setState(() {
          widget.reviewLike = null;
        });
      });
    setState(() {
      showProgressLikeUnlike = false;
    });
  }
}
