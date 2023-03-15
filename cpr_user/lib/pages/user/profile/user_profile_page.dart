import 'package:cpr_user/models/blocked_user.dart';
import 'package:cpr_user/models/follower_following.dart';
import 'package:cpr_user/models/review.dart';
import 'package:cpr_user/models/review_like.dart';
import 'package:cpr_user/models/user.dart';
import 'package:cpr_user/pages/common/components/cpr_container.dart';
import 'package:cpr_user/pages/common/components/cpr_loading.dart';
import 'package:cpr_user/pages/user/profile/components/bottom_sheet_options.dart';
import 'package:cpr_user/pages/user/profile/components/review_list_item.dart';
import 'package:cpr_user/pages/user/profile/user_followers_page.dart';
import 'package:cpr_user/pages/user/profile/user_followings_page.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:cpr_user/services/block_service.dart';
import 'package:cpr_user/services/following_follower_service.dart';
import 'package:cpr_user/services/review_like_service.dart';
import 'package:cpr_user/services/reviews_service.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart' as p;
import 'package:visibility_detector/visibility_detector.dart';

class UserProfilePage extends StatefulWidget {
  CPRUser user;

  UserProfilePage(this.user);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> with TickerProviderStateMixin {
  List<Review?>? reviews;
  List<CPRReviewLike>? reviewLikes;
  bool showProgress = false;
  bool isYourFollowing = false ;
  bool isBlockedByYou= false ;
  bool isBlockedYou= false ;
  bool followUnfollowProgress = false;
  int followingsCount= 0 ;
  int followersCount= 0 ;
  CPRFollowerFollowing? cPRFollowerFollowing;
  CPRBlockedUser? cPRBlockedUser;

  CPRUser? loginedUser;

  @override
  void initState() {
    _findUserReviews();
    _getFollowingsCount();
    _getFollowersCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Log.i("page - UserProfilePage - build - main page");

    getLoginedUser(context);
    _checkIsBlockedYou(context);
    _checkIsYourFollowing(context);
    _checkIsBlockedByYou(context);
    _getLikedReviews();

    return Scaffold(
      appBar: AppBar(
        title: Text("Account Info"),
        backgroundColor: Colors.black,
        elevation: 0.0,
        actions: [
          if (loginedUser?.email != widget.user.email)
            InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (ctx) {
                        return BottomSheetOptions(isBlockedByYou, () {
                          if (!isBlockedByYou)
                            block(context);
                          else
                            unBlock();
                        });
                      });
                },
                child: Container(
                    width: 42,
                    height: 42,
                    child: Icon(
                      Icons.more_vert_outlined,
                      color: Colors.white,
                    )))
        ],
      ),
      body: VisibilityDetector(
          key: Key('my-widget-key'),
          onVisibilityChanged: (visibilityInfo) {
            if (visibilityInfo.visibleFraction == 1) {
              _getFollowingsCount();
              _getFollowersCount();
              _getLikedReviews();
            }
          },
          child: CPRContainer(
              loadingWidget: CPRLoading(
                loading: showProgress,
              ),
              child: Container(
                  padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                        height: 128,
                        color: Colors.white,
                        child: Row(
                          children: [
                            Container(
                              width: 96,
                              height: 96,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(200),
                                  border: Border.all(
                                      color: Colors.grey.shade500, width: 2)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(200),
                                child: Image(
                                  image: getImageProvider(),
                                  width: 96,
                                  height: 96,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      (widget.user.username ?? ""),
                                      style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                    ),
                                    Expanded(
                                      child: Text(""),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if ((widget.user.setting == null || widget.user.setting!.otherUserCanFollowMe!) &&
                                            (isBlockedYou == null || !isBlockedYou)) {
                                          if (!followUnfollowProgress &&
                                              isYourFollowing != null &&
                                              loginedUser?.email != widget.user.email) {
                                            if (!isYourFollowing)
                                              follow(context);
                                            else
                                              unFollow();

                                            _getFollowingsCount();
                                            _getFollowersCount();
                                          }
                                        }
                                      },
                                      child: Container(
                                        width: 160,
                                        height: 42,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(200),
                                            border: Border.all(color: Colors.grey.shade500, width: 2),
                                            color: isYourFollowing == null ||
                                                    (isYourFollowing != null && isYourFollowing) ||
                                                    (widget.user.setting != null && !widget.user.setting!.otherUserCanFollowMe!) ||
                                                    isBlockedYou
                                                ? Colors.white
                                                : Theme.of(context).accentColor),
                                        child: Center(
                                          child: Text(
                                            loginedUser?.email != widget.user.email
                                                ? (widget.user.setting == null || widget.user.setting!.otherUserCanFollowMe!)
                                                    ? (isYourFollowing == null || isBlockedYou == null)
                                                        ? "Loading..."
                                                        : isBlockedYou
                                                            ? "Can't Follow"
                                                            : isYourFollowing
                                                                ? "Following"
                                                                : "Click To Follow"
                                                    : "Can't Follow"
                                                : "You !",
                                            style: TextStyle(
                                                color: isYourFollowing == null ||
                                                        (isYourFollowing != null && isYourFollowing) ||
                                                        (widget.user.setting != null && !widget.user.setting!.otherUserCanFollowMe!) ||
                                                        isBlockedYou
                                                    ? Colors.black
                                                    : Colors.white,
                                                fontSize: 14),
                                            maxLines: 1,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context, new MaterialPageRoute(builder: (context) => UserFollowingsPage(widget.user)));
                                      },
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Text(
                                              "Following",
                                              style: TextStyle(fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              followingsCount != null ? followingsCount.toString() : "...",
                                            )
                                          ],
                                        ),
                                      )),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context, new MaterialPageRoute(builder: (context) => UserFollowersPage(widget.user)));
                                      },
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Text(
                                              "Followers",
                                              style: TextStyle(fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              followersCount != null ? followersCount.toString() : "...",
                                            )
                                          ],
                                        ),
                                      )),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Text(
                                          "Reviews",
                                          style: TextStyle(fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          reviews != null ? reviews!.length.toString() : "...",
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
                        child: Text(
                          "Reviews",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      Expanded(
                        child: (isBlockedYou != null && !isBlockedYou)
                            ? reviews == null
                                ? Container(
                                    height: MediaQuery.of(context).size.height,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SpinKitSquareCircle(
                                          color: Theme.of(context).accentColor,
                                          size: 50.0,
                                          controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Text(
                                            "Loading",
                                            style: TextStyle(color: Theme.of(context).accentColor),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : reviews!.length == 0
                                    ? Container(
                                        height: MediaQuery.of(context).size.height,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                                              child: Text(
                                                "No Reviews Yet !",
                                                style: TextStyle(color: Theme.of(context).accentColor),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    : ListView.builder(
                                        itemBuilder: (context, i) {
                                          /**
                                           * #abdo
                                           *
                                              CPRReviewLike reviewLike
                                           */
                                          CPRReviewLike reviewLike = CPRReviewLike() ;
                                          try {
                                            reviewLike = reviewLikes!.firstWhere((element) => element.reviewId == reviews![i]!.firebaseId);
                                          } catch (e) {
                                            print(e);
                                          }
                                          return ReviewListItem(reviews![i]!, reviewLike, loginedUser!, (v) {
                                            setState(() {
                                              showProgress = v;
                                            });
                                          }, (reviewLike) {
                                            setState(() {
                                              reviewLikes!.add(reviewLike);
                                            });
                                          }, (reviewLike) {
                                            setState(() {
                                              reviewLikes!.remove(reviewLike);
                                            });
                                          });
                                        },
                                        shrinkWrap: true,
                                        itemCount: reviews!.length,
                                      )
                            : isBlockedYou == null
                                ? Container(
                                    height: MediaQuery.of(context).size.height,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SpinKitSquareCircle(
                                          color: Theme.of(context).accentColor,
                                          size: 50.0,
                                         // controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Text(
                                            "Loading",
                                            style: TextStyle(color: Theme.of(context).accentColor),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : Container(
                                    height: MediaQuery.of(context).size.height,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Text(
                                            "No Reviews Yet !",
                                            style: TextStyle(color: Theme.of(context).accentColor),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                      )
                    ],
                  )))),
    );
  }

  _findUserReviews() async {
    ReviewService reviewService = new ReviewService();
    List<Review> reviewsTemp = await reviewService.getUserReviewsList(widget.user);
    setState(() {
      reviews = reviewsTemp;
    });
  }

  _getLikedReviews() async {
    ReviewLikeService reviewLikeService = new ReviewLikeService();

    List<String> reviewsId = reviews!.map((e) => e!.firebaseId!).toList();

    List<CPRReviewLike> reviewLikesTemp =
        await reviewLikeService.getLikedReviews(loginedUser!.email!, reviewsId );
    if (mounted)
      setState(() {
        reviewLikes = reviewLikesTemp;
      });
  }

  _checkIsYourFollowing(BuildContext context) async {
    SessionProvider provider = p.Provider.of<SessionProvider>(context, listen: false);
    FollowingFollowerService followingFollowerService = new FollowingFollowerService();
    CPRFollowerFollowing? cPRFF = await followingFollowerService.isYourFollowing(provider.user!.email!, widget.user.email!);
    if (cPRFF != null)
      setState(() {
        cPRFollowerFollowing = cPRFF;
        isYourFollowing = true;
      });
    else {
      setState(() {
        cPRFollowerFollowing = null;
        isYourFollowing = false;
      });
    }
  }

  void getLoginedUser(BuildContext context) {
    SessionProvider provider = p.Provider.of<SessionProvider>(context, listen: false);
    if (mounted)
      setState(() {
        loginedUser = provider.user;
      });
  }

  follow(BuildContext context) async {
    setState(() {
      followUnfollowProgress = true;
    });
    SessionProvider provider = p.Provider.of<SessionProvider>(context, listen: false);
    FollowingFollowerService followingFollowerService = new FollowingFollowerService();
    CPRFollowerFollowing? cPRFollowerFollowing = await followingFollowerService.follow(new CPRFollowerFollowing(
        follower: provider.user!, followerId: provider.user!.email!, following: widget.user,
        followingId: widget.user.email!));
    if (cPRFollowerFollowing != null && cPRFollowerFollowing.followingId != null)
      setState(() {
        isYourFollowing = true;
        _checkIsYourFollowing(context);
      });
    setState(() {
      followUnfollowProgress = false;
    });
  }

  _getFollowingsCount() async {
    FollowingFollowerService followingFollowerService = new FollowingFollowerService();
    int count = await followingFollowerService.getFollowingsCount(widget.user.email!);
    if (mounted)
      setState(() {
        followingsCount = count;
      });
  }

  _getFollowersCount() async {
    FollowingFollowerService followingFollowerService = new FollowingFollowerService();
    int count = await followingFollowerService.getFollowersCount(widget.user.email!);
    if (mounted)
      setState(() {
        followersCount = count;
      });
  }

  unFollow() async {
    if (mounted)
      setState(() {
        followUnfollowProgress = true;
      });
    FollowingFollowerService followingFollowerService = new FollowingFollowerService();
    bool isDeleted = await followingFollowerService.unFollow(cPRFollowerFollowing!.documentID!);
    if (isDeleted) if (mounted)
      setState(() {
        cPRFollowerFollowing = null;
        isYourFollowing = false;
      });
    if (mounted)
      setState(() {
        followUnfollowProgress = false;
      });
  }

  block(BuildContext context) async {
    SessionProvider provider = p.Provider.of<SessionProvider>(context, listen: false);
    BlockService blockService = new BlockService();
    CPRBlockedUser? blocked = await blockService.block(
        new CPRBlockedUser(blocker: provider.user!, blockerId: provider.user!.email!, blocked: widget.user, blockedId: widget.user.email!, id: '', documentID: ''));
    if (blocked != null && blocked.blockedId != null) {
      if (mounted)
        setState(() {
          isBlockedByYou = true;
          _checkIsBlockedByYou(context);
        });
    }
  }

  unBlock() async {
    BlockService blockService = new BlockService();
    bool isDeleted = await blockService.unBlock(cPRBlockedUser!.documentID!);
    if (isDeleted)
      setState(() {
        cPRBlockedUser = null;
        isBlockedByYou = false;
      });
  }

  _checkIsBlockedByYou(BuildContext context) async {
    SessionProvider provider = p.Provider.of<SessionProvider>(context, listen: false);
    BlockService blockService = new BlockService();
    CPRBlockedUser? isBlocked = await blockService.isBlockedByYou(provider.user!.email!, widget.user.email!);
    if (isBlocked != null)
      setState(() {
        cPRBlockedUser = isBlocked;
        isBlockedByYou = true;
      });
    else {
      if (mounted)
        setState(() {
          cPRBlockedUser = null;
          isBlockedByYou = false;
        });
    }
  }

  _checkIsBlockedYou(BuildContext context) async {
    SessionProvider provider = p.Provider.of<SessionProvider>(context, listen: false);
    BlockService blockService = new BlockService();
    CPRBlockedUser? isBlocked = await blockService.isBlockedYou(provider.user!.email!, widget.user.email!);
    if (isBlocked != null) {
      if (mounted)
        setState(() {
          isBlockedYou = true;
        });
    } else {
      if (mounted)
        setState(() {
          isBlockedYou = false;
        });
    }
  }

  getImageProvider() {
    /**
     * #abdo
        widget.user != null && widget.user.profilePictureURL != null
        ? NetworkImage(widget.user.profilePictureURL)
        : AssetImage("assets/images/no_avatar_image_choosed.png")
     */

    if( widget.user  == null ) {
      return  AssetImage( "assets/images/no_avatar_image_choosed.png");
    }

    if( ToolsValidation.isValid( widget.user.profilePictureURL )  ) {
      return NetworkImage(widget.user.profilePictureURL !);
    }

    return  AssetImage( "assets/images/no_avatar_image_choosed.png");
  }
}
