import 'package:cpr_user/models/user.dart';
import 'package:cpr_user/pages/user/profile/user_blocks_page.dart';
import 'package:cpr_user/pages/user/profile/user_followers_page.dart';
import 'package:cpr_user/pages/user/profile/user_followings_page.dart';
import 'package:cpr_user/services/block_service.dart';
import 'package:cpr_user/services/following_follower_service.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../models/review.dart';
import '../../../../services/social_profile_service.dart';
import '../../social_media/social_media_page.dart';

class FollowerFollowingCounterBar extends StatefulWidget {
  CPRUser user;

  FollowerFollowingCounterBar(this.user);

  @override
  _FollowerFollowingCounterBarState createState() =>
      _FollowerFollowingCounterBarState();
}

class _FollowerFollowingCounterBarState
    extends State<FollowerFollowingCounterBar> {
  int followingsCount = 0;
  int followersCount = 0;
  int blocksCount = 0;
  int connectedSocialsCount = 0;

  @override
  void initState() {
    _getFollowingsCount();
    _getFollowersCount();
    _getblocksCount();
    _getConnectedSocialsCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
        key: Key('my-widget-key'),
        onVisibilityChanged: (visibilityInfo) {
          if (visibilityInfo.visibleFraction == 1) {
            _getFollowingsCount();
            _getFollowersCount();
            _getblocksCount();
            _getConnectedSocialsCount();
          }
        },
        child: Container(
          padding: EdgeInsets.only(top: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) =>
                              UserFollowersPage(widget.user)));
                },
                child: Container(
                  padding: EdgeInsets.only(right: 20),
                  child: Column(
                    children: <Widget>[
                      Image(
                        image: AssetImage('assets/images/ic_followers.png'),
                        width: 24,
                        height: 24,
                        fit: BoxFit.contain,
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Followers",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                            followersCount != null
                                ? followersCount.toString()
                                : "...",
                            style: CPRTextStyles.cardTitle),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) =>
                              UserFollowingsPage(widget.user)));
                },
                child: Container(
                  padding: EdgeInsets.only(right: 20),
                  child: Column(
                    children: <Widget>[
                      Image(
                        image: AssetImage('assets/images/ic_followings.png'),
                        width: 24,
                        height: 24,
                        fit: BoxFit.contain,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Following",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                            followingsCount != null
                                ? followingsCount.toString()
                                : "...",
                            style: CPRTextStyles.cardTitle),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => UserBlocksPage(widget.user)));
                },
                child: Container(
                  padding: EdgeInsets.only(right: 20),
                  child: Column(
                    children: <Widget>[
                      Image(
                        image: AssetImage('assets/images/ic_blocks.png'),
                        width: 24,
                        height: 24,
                        fit: BoxFit.contain,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Blocks",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                            blocksCount != null
                                ? blocksCount.toString()
                                : "...",
                            style: CPRTextStyles.cardTitle),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SocialMediaPage(
                                review: Review(),
                              )));
                },
                child: Container(
                  padding: EdgeInsets.only(right: 0),
                  child: Column(
                    children: <Widget>[
                      Icon(
                        MaterialCommunityIcons.instagram,
                        size: 24,
                        color: CPRColors.cprButtonPink,
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Socials",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                            connectedSocialsCount != null
                                ? connectedSocialsCount.toString()
                                : "...",
                            style: CPRTextStyles.cardTitle),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  _getFollowingsCount() async {
    FollowingFollowerService followingFollowerService =
        new FollowingFollowerService();
    int count =
        await followingFollowerService.getFollowingsCount(widget.user.email!);
    if (mounted)
      setState(() {
        followingsCount = count;
      });
  }

  _getFollowersCount() async {
    FollowingFollowerService followingFollowerService =
        new FollowingFollowerService();
    int count =
        await followingFollowerService.getFollowersCount(widget.user.email!);
    if (mounted)
      setState(() {
        followersCount = count;
      });
  }

  _getblocksCount() async {
    BlockService blockService = new BlockService();
    int count = await blockService.getBlocksCount(widget.user.email!);
    if (mounted)
      setState(() {
        blocksCount = count;
      });
  }

  _getConnectedSocialsCount() async {
    SocialProfileService socialProfileService = SocialProfileService();
    String? user = widget.user.email;
    int count = await socialProfileService.getConnectedSocialsCount(user);
    if (mounted)
      setState(() {
        connectedSocialsCount = count;
      });
  }
}
