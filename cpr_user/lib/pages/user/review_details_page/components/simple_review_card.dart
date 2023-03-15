import 'package:cpr_user/constants/cpr_routes.dart';
import 'package:cpr_user/helpers/date_helper.dart';
import 'package:cpr_user/models/blocked_user.dart';
import 'package:cpr_user/models/follower_following.dart';
import 'package:cpr_user/models/place.dart';
import 'package:cpr_user/models/review.dart';
import 'package:cpr_user/models/user.dart';
import 'package:cpr_user/pages/common/components/cpr_button.dart';
import 'package:cpr_user/pages/common/components/cpr_card.dart';
import 'package:cpr_user/pages/common/components/cpr_separator.dart';
import 'package:cpr_user/pages/common/components/review_detail_simple.dart';
import 'package:cpr_user/pages/common/components/reviews/video_thumbnail_widget.dart';
import 'package:cpr_user/pages/common/video_view_page.dart';
import 'package:cpr_user/pages/user/search_user/components/serach_user__list_item.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:cpr_user/resource/toast/ToolsToast.dart';
import 'package:cpr_user/services/block_service.dart';
import 'package:cpr_user/services/following_follower_service.dart';
import 'package:cpr_user/services/places_service.dart';
import 'package:cpr_user/services/user_service.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart' as p;
import 'package:shimmer/shimmer.dart';

class SimpleReviewCard extends StatefulWidget {
  final key;

  //final GlobalKey<ScaffoldState> state;
  final Review review;
  final bool showMore;
  final CPRUser loginedUser;

  //final List<Review> reviews;
  const SimpleReviewCard({
    this.key,
    //required this.place,
    //this.state,
    required this.review,
    required this.loginedUser,
    this.showMore = false,
  }) : super(key: key);

  @override
  _SimpleReviewCardState createState() => _SimpleReviewCardState();
}

class _SimpleReviewCardState extends State<SimpleReviewCard> {
  /**
   * #abdo
      //target
   */
  CPRUser? user;

  @override
  void initState() {
    if (widget.review.userID != null) getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CPRCard(
      // height: 350+90,
      icon: MaterialCommunityIcons.comment_text_multiple_outline,
      title: Text(
        "Review",
        style: CPRTextStyles.cardTitleBlack,
      ),
      subtitle: Text(
        "Create on ${DateHelper.defaultFormat(widget.review.creationTime!)}",
        style: CPRTextStyles.cardSubtitleBlack,
      ),
      backgroundColor: Colors.white,
      iconOnClick: () async {
        Place? place;
        try {
          place = await PlacesService().findPlaceById(widget.review.placeID!);
        } catch (e) {}

        if( place == null ) {
          ToolsToast.i(context,  "Place not found!");
          return;
        }

        Navigator.of(context).push(CPRRoutes.reviewDetailPage(widget.review, place));
      },
      child: Container(
        //color: Colors.green,
        //height: 250,
        padding: EdgeInsets.only(bottom: 5),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                child: user == null
                    ? Shimmer.fromColors(
                        baseColor: Colors.grey,
                        highlightColor: Colors.grey.shade300,
                        child: Container(
                          width: Get.width,
                          margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        width:  56,
                                        height: 56,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(100),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(100),
                                          child: Image(
                                            image:AssetImage("assets/images/no_avatar_image_choosed.png"),
                                            width:  56,
                                            height:  56,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          height: 38,
                                          width: Get.width,
                                          margin: EdgeInsets.fromLTRB(44, 8, 4, 8),
                                          padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                                          decoration: BoxDecoration(color: Get.theme.accentColor, borderRadius: BorderRadius.circular(20)),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "",
                                                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14,color: Colors.white),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                                  SizedBox(width: 16,),
                                  Container(
                                    width: 96,
                                    height: 36,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        color: Colors.white),
                                    child: GestureDetector(
                                        onTap: () {
                                        },
                                        onLongPress: () {
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            content: Text("Follow - Unfollow User"),
                                          ));
                                        },
                                        child: Center(
                                          child:  Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                                Container(
                                                  margin: EdgeInsets.only(right: 8),
                                                  child: Image(
                                                    image: AssetImage("assets/images/ic_link.png"),
                                                    width: 24,
                                                    height: 24,
                                                  ),
                                                ),
                                              Text("Follow",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.normal,
                                                    color:  Colors.blue),
                                              ),
                                                SizedBox(width: 8,)
                                            ],
                                          ),
                                        )),
                                  ),
                                InkWell(
                                    onTap: () async {
                                    },
                                    child: Container(width: 48, child: Icon(Icons.more_vert_sharp, color: Colors.white))),
                            ],
                          ),
                        ),
                      )
                    : SearchUserListItem(
                        user!,
                        widget.loginedUser,
                        () {
                          if (user!.isBlockedYou! ) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
              ),
              CPRSeparator(),
              ReviewDetailSimple(
                review: widget.review,
              ),
              Container(
                margin: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      if (widget.review != null && widget.review.downloadURLs != null)
                        ...widget.review.downloadURLs!
                            .map(
                              (image) => GestureDetector(
                                onTap: () {
                                  CPRRoutes.photoView(context, url: image);
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                  height: MediaQuery.of(context).size.width / 4,
                                  width: MediaQuery.of(context).size.width / 4,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: ExtendedNetworkImageProvider(image),
                                      )),
                                ),
                              ),
                            )
                            .toList()
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      if (widget.review != null && widget.review.videoDownloadURLs != null)
                        ...widget.review.videoDownloadURLs!
                            .map(
                              (video) => GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => VideoViewPage(
                                        videoUrl: video,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                  child: VideoThumbnailWidget(
                                    video,
                                    height: MediaQuery.of(context).size.width / 4,
                                    width: MediaQuery.of(context).size.width / 4,
                                  ),
                                ),
                              ),
                            )
                            .toList()
                    ],
                  ),
                ),
              ),
              if (widget.showMore)
                CPRButton(
                  color: CPRColors.cprButtonPink,
                  width: MediaQuery.of(context).size.width / 3,
                  horizontalPadding: 1,
                  verticalPadding: 10,
                  borderRadius: 10,
                  onPressed: () async {
                    Place? place;
                    try {
                      place = await PlacesService().findPlaceById(widget.review.placeID!);
                    } catch (e) {}

                    //#abdo
                    if( place ==null ) {
                      ToolsToast.i(context,  "Place not found");
                      return ;
                    }
                    Navigator.of(context).push(CPRRoutes.reviewDetailPage(widget.review, place));
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "View Details",
                        style: CPRTextStyles.buttonMediumWhite,
                      ),
                      Icon(
                        MaterialCommunityIcons.arrow_right_bold_circle_outline,
                        color: Colors.white,
                      )
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  getUser() async {
    UserService userService = new UserService();
    CPRUser? userTemp = await userService.getUserById(widget.review.userID!);
    if (mounted)
      setState(() {
        if (userTemp != null) user = userTemp;
      });

    _checkIsYourFollowing(context);
    _checkIsBlockedByYou(context);
    _checkIsBlockedYou(context);
  }

  follow(BuildContext context) async {
    setState(() {
      user!.followUnfollowProgress = true;
    });
    SessionProvider provider = p.Provider.of<SessionProvider>(context, listen: false);
    FollowingFollowerService followingFollowerService = FollowingFollowerService();
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
    bool isDeleted = await followingFollowerService.unFollow(null, followingEmail: user!.documentID! );
    if (isDeleted)
      setState(() {
        user!.isFollowingByYou = false;
        if (remove) user;
      });
    setState(() {
      user!.followUnfollowProgress = false;
    });
  }

  block(BuildContext context) async {
    SessionProvider provider = p.Provider.of<SessionProvider>(context, listen: false);
    BlockService blockService = new BlockService();
    CPRBlockedUser? cPRBlockedUser = await blockService
        .block(new CPRBlockedUser(blocker: provider.user!, blockerId: provider.user!.email!, blocked: user!,
        blockedId: user!.email!, documentID: '', id: '' ));
    if (cPRBlockedUser != null && cPRBlockedUser.blocked != null) {
      setState(() {
        user!.isBlockedByYou = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("User Blocked"),
        duration: Duration(seconds: 1),
      ));
    }
  }

  unBlock() async {
    BlockService blockService = new BlockService();
    bool isDeleted = await blockService.unBlock(null, blockedEmail: user!.documentID!);
    if (isDeleted) {
      setState(() {
        user!.isBlockedByYou = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("User Unblocked"),
        duration: Duration(seconds: 1),
      ));
    }
  }

  _checkIsYourFollowing(BuildContext context) async {
    SessionProvider provider = p.Provider.of<SessionProvider>(context, listen: false);
    FollowingFollowerService? followingFollowerService = new FollowingFollowerService();
    CPRFollowerFollowing? cPRFF = await followingFollowerService.isYourFollowing(provider.user!.email!, user!.email!);
    if (cPRFF != null)
      setState(() {
        user!.isFollowingByYou = true;
      });
  }

  _checkIsBlockedByYou(BuildContext context) async {
    SessionProvider provider = p.Provider.of<SessionProvider>(context, listen: false);
    BlockService blockService = new BlockService();
    CPRBlockedUser? isBlocked = await blockService.isBlockedByYou(provider.user!.email!, user!.email!);
    if (isBlocked != null)
      setState(() {
        user!.isBlockedByYou = true;
      });
  }

  _checkIsBlockedYou(BuildContext context) async {
    SessionProvider provider = p.Provider.of<SessionProvider>(context, listen: false);
    BlockService blockService = new BlockService();
    CPRBlockedUser? isBlocked = await blockService.isBlockedYou(provider.user!.email!, user!.email!);
    if (isBlocked != null)
      setState(() {
        user!.isBlockedYou = true;
      });
  }
}
