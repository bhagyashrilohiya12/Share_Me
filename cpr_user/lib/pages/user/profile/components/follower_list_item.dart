import 'package:cpr_user/models/follower_following.dart';
import 'package:cpr_user/models/follower_following_helper.dart';
import 'package:cpr_user/models/user.dart';
import 'package:cpr_user/pages/user/profile/user_profile_page.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:cpr_user/resource/validation/ImageProviderValidation.dart';
import 'package:cpr_user/services/following_follower_service.dart';
import 'package:cpr_user/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as p;

class FollowerListItem extends StatefulWidget {
  CPRFollowerFollowing follower;
  CPRFollowerFollowingHelper helper;
  Function showProgress;

  FollowerListItem(this.follower,this.helper,this.showProgress);

  @override
  _FollowerListItemState createState() => _FollowerListItemState();
}

class _FollowerListItemState extends State<FollowerListItem> {

  CPRFollowerFollowing? cPRFollowerFollowing;
  CPRUser? loginedUser;


  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    setState(() {
      loginedUser = p.Provider.of<SessionProvider>(context, listen: false).user;
    });
    if(widget.helper.isYourFollowing == null) _checkIsYourFollowing(context);
    return GestureDetector(
      onTap: () async {
        widget.showProgress(true);
        UserService userService = new UserService();
        CPRUser? user = await userService.getUserById(widget.follower.followerId!);
        Navigator.push(context, new MaterialPageRoute(builder: (context)=>UserProfilePage(user!)));
        widget.showProgress(false);
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image(
                  image: getImageProvider(),
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 64,
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.follower.follower!.username ?? "",
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            widget.follower.follower!.email!.substring(0, 4) +
                                "*******" +
                                widget.follower.follower!.email!
                                    .substring(widget.follower.follower!.email!.indexOf("@"),
                                    widget.follower.follower!.email!.length),
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
              height: 42,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(200),
                  border: Border.all(color: Colors.grey.shade500, width: 2),
                  color: widget.helper.isYourFollowing != null && widget.helper.isYourFollowing! ? Colors.white : Theme.of(context).accentColor),
              child: GestureDetector(
                  onTap: () {
                    if (!widget.helper.followUnfollowProgress! && widget.helper.isYourFollowing != null && loginedUser?.email != widget.follower.follower!.email) {
                      if (!widget.helper.isYourFollowing!)
                        follow(context);
                      else
                        unFollow();
                    }
                  },
                  child:Center(
                child: Text(
                  widget.helper.isYourFollowing == null
                      ? "Loading..."
                      : widget.helper.isYourFollowing!
                      ? "Unfollow"
                      : "Follow",
                  style: TextStyle(
                      color: widget.helper.isYourFollowing != null && widget.helper.isYourFollowing! ? Colors.black : Colors.white, fontSize: 14),
                  maxLines: 1,
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }


  follow(BuildContext context) async {
    setState(() {
      widget.helper.followUnfollowProgress = true;
    });
    SessionProvider provider = p.Provider.of<SessionProvider>(context, listen: false);
    FollowingFollowerService? followingFollowerService = new FollowingFollowerService();
    CPRFollowerFollowing? cPRFollowerFollowing = await followingFollowerService.follow(new CPRFollowerFollowing(
        follower: provider.user!,
        followerId: provider.user!.email!,
        following: widget.follower.follower!,
        followingId: widget.follower.follower!.email!));

    if (cPRFollowerFollowing != null && cPRFollowerFollowing.followingId != null)
      setState(() {
        widget.helper.isYourFollowing = true;
        _checkIsYourFollowing(context);
      });
    setState(() {
      widget.helper.followUnfollowProgress = false;
    });
  }


  unFollow() async {
    setState(() {
      widget.helper.followUnfollowProgress = true;
    });
    FollowingFollowerService followingFollowerService = new FollowingFollowerService();
    bool isDeleted = await followingFollowerService.unFollow(cPRFollowerFollowing!.documentID);
    if (isDeleted)
      setState(() {
        cPRFollowerFollowing = null;
        widget.helper.isYourFollowing = false;
      });
    setState(() {
      widget.helper.followUnfollowProgress = false;
    });
  }

  _checkIsYourFollowing(BuildContext context) async {
    SessionProvider provider = p.Provider.of<SessionProvider>(context, listen: false);
    FollowingFollowerService followingFollowerService = new FollowingFollowerService();
    CPRFollowerFollowing? cPRFF = await followingFollowerService.isYourFollowing(provider.user!.email!, widget.follower.follower!.email!);
    if (cPRFF != null)
      setState(() {
        cPRFollowerFollowing = cPRFF;
        widget.helper.isYourFollowing = true;
      });
    else {
      setState(() {
        cPRFollowerFollowing = null;
        widget.helper.isYourFollowing = false;
      });
    }
  }


  getImageProvider() {
    /**
     #abdo
        widget.follower.follower.profilePictureURL != null && widget.follower.follower.profilePictureURL.length > 0
        ? NetworkImage(widget.follower.follower.profilePictureURL)
        : AssetImage("assets/images/no_avatar_image_choosed.png")
     */

    return ImageProviderValidation.networkOrPlaceholder(widget.follower.follower!.profilePictureURL  );
  }


}
