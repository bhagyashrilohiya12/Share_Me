import 'package:cpr_user/constants/cpr_routes.dart';
import 'package:cpr_user/models/blocked_user.dart';
import 'package:cpr_user/models/follower_following.dart';
import 'package:cpr_user/models/review.dart';
import 'package:cpr_user/models/review_like.dart';
import 'package:cpr_user/models/user.dart';
import 'package:cpr_user/pages/common/components/cpr_button.dart';
import 'package:cpr_user/pages/user/report_review_page/report_review_page.dart';
import 'package:cpr_user/pages/user/search_user/components/serach_user__list_item.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:cpr_user/services/block_service.dart';
import 'package:cpr_user/services/following_follower_service.dart';
import 'package:cpr_user/services/review_like_service.dart';
import 'package:cpr_user/services/user_service.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:extended_image/extended_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart' as p;
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;

class ReviewDetail extends StatefulWidget {
  const ReviewDetail({

    required this.review,
    required this.loginedUser,
  })  ;

  final Review review;
  final CPRUser loginedUser;

  @override
  _ReviewDetailState createState() => _ReviewDetailState();
}

class _ReviewDetailState extends State<ReviewDetail> {
  CPRUser? user;
  bool showProgressLikeUnlike = false; // for prevent double like or unlike
  List<CPRReviewLike> reviewLikes = [];
  CPRReviewLike? reviewLike;

  @override
  void initState() {
    if (widget.review.userID != null) getUser();
    _getLikesOfReview();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 16, left: 0, bottom: 16),
      child: Column(
        children: <Widget>[
          user == null
              ? Shimmer.fromColors(
                  baseColor: Colors.grey,
                  highlightColor: Colors.grey.shade300,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: const Image(
                              image: AssetImage("assets/images/no_avatar_image_choosed.png"),
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 56,
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        "...........",
                                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        ".............................",
                                        style: TextStyle(fontSize: 10),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 96,
                          height: 36,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey, width: 1),
                              color: Colors.white),
                          child: const Center(
                            child: Text(
                              "",
                              style: TextStyle(fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                        Container(width: 48, child: Icon(Icons.more_vert_sharp)),
                      ],
                    ),
                  ),
                )
              : SearchUserListItem(
                  user!,
                  widget.loginedUser,
                  () {
                    if (user!.isBlockedYou!) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Can't Follow"),
                        duration: Duration(seconds: 1),
                      ));
                    } else if (!user!.followUnfollowProgress!) {
                      if (!user!.isFollowingByYou!) {
                        follow(context);
                      } else {
                        unFollow(false);
                      }
                    }
                  },
                  () {
                    Navigator.of(context).pop();
                    FocusScope.of(context).unfocus();
                    if (!user!.blockUnBlockProgress!) {
                      if (!user!.isBlockedByYou!) {
                        block(context);
                      } else {
                        unBlock();
                      }
                    }
                  },
                  (v) {},
                  isMiniItem: true,
                ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Icon(
                        MaterialCommunityIcons.calendar,
                        size: 18,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        widget.review != null && widget.review.creationTime != null
                            ? timeago.format(widget.review.creationTime!, locale: "en_long")
                            : 'N/A',
                        style: CPRTextStyles.reviewCardStarsTextStyle,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 4,),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Icon(
                        MaterialCommunityIcons.star,
                        size: 18,
                      ),
                    ),
                    RatingBarIndicator(
                      rating: widget.review.rating!,
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 16.0,
                      direction: Axis.horizontal,
                    )
                  ],
                ),
                SizedBox(height: 4,),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Icon(
                        MaterialCommunityIcons.clock,
                        size: 18,
                      ),
                    ),
                    RatingBarIndicator(
                      rating: widget.review.waiting!.toDouble(),
                      itemBuilder: (context, index) => Icon(
                        Icons.timer,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 16.0,
                      direction: Axis.horizontal,
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(24,16,24,0),
                  child: Text(
                    (widget.review.fullReview ?? widget.review.comments) ?? "",
                    textAlign: TextAlign.justify,
                    style: CPRTextStyles.reviewCardContentTextStyle,
                  ),
                ),
                if (widget.review.businessReply != null && widget.review.businessReply!.length > 0)
                  Container(
                    padding: EdgeInsets.fromLTRB(24, 16, 24, 0),
                    child: Text(
                      "Business reply :\n" + widget.review.businessReply!, //?? ""
                      textAlign: TextAlign.start,
                      style: CPRTextStyles.reviewCardContentTextStyle,
                    ),
                  ),
                if (widget.review != null && widget.review.downloadURLs != null)
                  ...widget.review.downloadURLs!
                      .map(
                        (image) => GestureDetector(
                      onTap: () {
                        CPRRoutes.photoView(context, url: image);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                        height: MediaQuery.of(context).size.width / 5,
                        width: MediaQuery.of(context).size.width / 5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: ExtendedNetworkImageProvider(image),
                            )),
                      ),
                    ),
                  )
                      .toList(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
//                        Padding(
//                          padding: const EdgeInsets.only(right: 8.0),
//                          child: CPRButton(
//                            borderRadius: 5,
//                            onPressed: () {
//                              showModalBottomSheet(
//                                context: context,
//                                builder: (modalContext) {
//                                  return ShareBottomSheet(review);
//                                },
//                              );
//                            },
//                            color: CPRColors.cprButtonGreen.withOpacity(0.25),
//                            verticalPadding: 5,
//                            horizontalPadding: 5,
//                            child: Row(
//                              children: <Widget>[
//                                Icon(
//                                  MaterialCommunityIcons.getIconData(
//                                      "share-variant"),
//                                  size: 18,
//                                  color: Colors.blue,
//                                ),
//                                Padding(
//                                  padding: const EdgeInsets.only(left: 5),
//                                  child: Text(
//                                    "Share",
//                                    style: CPRTextStyles
//                                        .reviewCardContentTextStyle,
//                                  ),
//                                )
//                              ],
//                            ),
//                          ),
//                        ),
                          // if (false)
                          CPRButton(
                            borderRadius: 5,
                            color: CPRColors.cprButtonPink.withOpacity(0.25),
                            verticalPadding: 5,
                            onPressed: () {
                              Get.to(ReportReviewPage(widget.review));
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
                          )
                        ],
                      ),
                      // if (false)
                      GestureDetector(
                        onTap: () {
                          if (reviewLike != null) {
                            _unlikeReview();
                          } else {
                            _likeReview();
                          }
                        },
                        child: Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                widget.review.businessLiked!
                                    ? "Liked by Business and ${reviewLikes.length} others"
                                    : "${reviewLikes.length} Like",
                                style: CPRTextStyles.reviewCardContentTextStyle,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Material(
                                elevation: 1,
                                borderRadius: BorderRadius.circular(40),
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
                                  child: showProgressLikeUnlike
                                      ? Padding(
                                          padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                                          child: SpinKitThreeBounce(
                                            size: 6,
                                            color: Theme.of(context).accentColor,
                                          ),
                                        )
                                      : Icon(
                                          MaterialCommunityIcons.heart,
                                          color: reviewLike != null ? Colors.red : Colors.black,
                                          size: 15,
                                        ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  getUser() async {
    UserService userService = UserService();
    CPRUser? userTemp = await userService.getUserById(widget.review.userID!);
    if (mounted) {
      setState(() {
        user = userTemp;
      });
    }

    _checkIsYourFollowing(context);
    _checkIsBlockedByYou(context);
    _checkIsBlockedYou(context);
  }

  follow(BuildContext context) async {
    setState(() {
      user!.followUnfollowProgress = true;
    });
    SessionProvider provider = p.Provider.of<SessionProvider>(context, listen: false);
    FollowingFollowerService followingFollowerService = new FollowingFollowerService();
    CPRFollowerFollowing? cPRFollowerFollowing = await followingFollowerService.follow(
        new CPRFollowerFollowing(follower: provider.user!, followerId: provider.user!.email!, following: user!, followingId: user!.email!));
    if (cPRFollowerFollowing != null && cPRFollowerFollowing.followingId != null) {
      setState(() {
        user!.isFollowingByYou = true;
      });
    }
    setState(() {
      user!.followUnfollowProgress = false;
    });
  }

  unFollow(bool remove) async {
    setState(() {
      user!.followUnfollowProgress = true;
    });
    FollowingFollowerService followingFollowerService = new FollowingFollowerService();
    bool isDeleted = await followingFollowerService.unFollow(null, followingEmail: user!.documentID!);
    if (isDeleted) {
      setState(() {
        user!.isFollowingByYou = false;
        if (remove) user;
      });
    }
    setState(() {
      user!.followUnfollowProgress = false;
    });
  }

  block(BuildContext context) async {
    SessionProvider provider = p.Provider.of<SessionProvider>(context, listen: false);
    BlockService blockService = new BlockService();
    CPRBlockedUser? cPRBlockedUser = await blockService.block(
        new CPRBlockedUser(blocker: provider.user!, blockerId: provider.user!.email!, blocked: user!, blockedId: user!.email!, id: '', documentID: '')
    );
    if (cPRBlockedUser != null && cPRBlockedUser.blocked != null) {
      setState(() {
        user!.isBlockedByYou = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("User Blocked"),
        duration: Duration(seconds: 1),
      ));
    }
  }

  unBlock() async {
    BlockService blockService = new BlockService();
    bool isDeleted = await blockService.unBlock(null, blockedEmail: user!.documentID);
    if (isDeleted) {
      setState(() {
        user!.isBlockedByYou = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("User Unblocked"),
        duration: Duration(seconds: 1),
      ));
    }
  }

  _checkIsYourFollowing(BuildContext context) async {
    SessionProvider provider = p.Provider.of<SessionProvider>(context, listen: false);
    FollowingFollowerService followingFollowerService = FollowingFollowerService();
    CPRFollowerFollowing? cPRFF = await followingFollowerService.isYourFollowing(provider.user!.email!, user!.email??"");
    if (cPRFF != null)
      if(mounted) {
        setState(() {
        user!.isFollowingByYou = true;
      });
      }
  }

  _checkIsBlockedByYou(BuildContext context) async {
    SessionProvider provider = p.Provider.of<SessionProvider>(context, listen: false);
    BlockService blockService = BlockService();
    CPRBlockedUser? isBlocked = await blockService.isBlockedByYou(provider.user!.email!, user!.email??"");
    if (isBlocked != null)
      if(mounted) {
        setState(() {
        user!.isBlockedByYou = true;
      });
      }
  }

  _checkIsBlockedYou(BuildContext context) async {
    SessionProvider provider = p.Provider.of<SessionProvider>(context, listen: false);
    BlockService? blockService = BlockService();
    CPRBlockedUser? isBlocked = await blockService.isBlockedYou(provider.user!.email!, user!.email??"");
    if (isBlocked != null)
      if(mounted) {
        setState(() {
        user!.isBlockedYou = true;
      });
      }
  }

  _getLikesOfReview() async {
    ReviewLikeService reviewLikeService = new ReviewLikeService();
    List<CPRReviewLike> reviewLikesTemp = await reviewLikeService.getLikesOfReview(widget.review.firebaseId!);
    if (mounted) {
      setState(() {
        if (reviewLikesTemp != null) reviewLikes = reviewLikesTemp;
        try {
          var reviewLikeTemp = reviewLikesTemp.firstWhere((element) => element.likerId == widget.loginedUser.email);
          if (reviewLikeTemp != null) reviewLike = reviewLikeTemp;
        } catch (e) {
          print(e);
        }
      });
    }
  }

  _likeReview() async {
    setState(() {
      showProgressLikeUnlike = true;
    });
    ReviewLikeService reviewLikeService = new ReviewLikeService();
    CPRReviewLike? reviewLikeTemp = await reviewLikeService.likeReview(
        new CPRReviewLike(
        liker: widget.loginedUser,
            likerId: widget.loginedUser.email!,
            review: widget.review,
            reviewId: widget.review.firebaseId!
        )
    );
    setState(() {
      if (reviewLikeTemp != null) {
        reviewLike = reviewLikeTemp;
        reviewLikes.add(reviewLikeTemp);
      }
      showProgressLikeUnlike = false;
    });
  }

  _unlikeReview() async {
    setState(() {
      showProgressLikeUnlike = true;
    });
    ReviewLikeService reviewLikeService = new ReviewLikeService();
    bool unLiked = await reviewLikeService.unlikeReview(reviewLike!.id! );
    setState(() {
      if (unLiked) {
        try {
          int index = reviewLikes.indexOf(reviewLikes.firstWhere((element) => element.reviewId == reviewLike!.reviewId ));
          reviewLikes.removeAt(index);
          reviewLike = null;
        } catch (e) {
          print(e);
        }
      }
      showProgressLikeUnlike = false;
    });
  }
}
