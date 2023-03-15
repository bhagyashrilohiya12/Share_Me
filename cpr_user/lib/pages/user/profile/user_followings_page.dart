import 'package:cpr_user/helpers/string_helper.dart';
import 'package:cpr_user/models/follower_following.dart';
import 'package:cpr_user/models/follower_following_helper.dart';
import 'package:cpr_user/models/user.dart';
import 'package:cpr_user/pages/common/components/cpr_container.dart';
import 'package:cpr_user/pages/common/components/cpr_loading.dart';
import 'package:cpr_user/pages/user/profile/components/following_list_item.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:cpr_user/services/following_follower_service.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart' as p;

class UserFollowingsPage extends StatefulWidget {
  CPRUser user;

  UserFollowingsPage(this.user);

  @override
  _UserFollowingsPageState createState() => _UserFollowingsPageState();
}

class _UserFollowingsPageState extends State<UserFollowingsPage> with TickerProviderStateMixin {
  List<CPRFollowerFollowing>? followings;
  List<CPRFollowerFollowingHelper> followingHelpers = [];
  bool showProgress = false;
  bool isYourFollowing = false ;
  bool followUnfollowProgress = false;
  int followingsCount = 0;
  int followersCount = 0;
  CPRFollowerFollowing? cPRFollowerFollowing;
  String searchKey = "";

  @override
  void initState() {
    _getFollowings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Log.i( "page - _UserFollowingsPageState - build");

    _checkIsYourFollowing(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Following"),
        backgroundColor: CPRColors.appBarBackground,
      ),
      body: CPRContainer(
          loadingWidget: CPRLoading(
            loading: showProgress ,
          ),
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
              child: Column(
                children: [
                  Container(
                    height: 42,
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                    padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 1, spreadRadius: 1)],
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        Expanded(
                            child: TextField(
                          onChanged: (v) {
                            setState(() {
                              searchKey = v;
                            });
                          },
                          decoration: InputDecoration.collapsed(hintText: "Search User ..."),
                        )),
                        Icon(
                          Icons.search,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: followings == null
                        ? Container(
                            height: MediaQuery.of(context).size.height,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SpinKitSquareCircle(
                                  color: Theme.of(context).accentColor,
                                  size: 50.0,
                                  // controller:
                                  //     AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
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
                        : getFilteredFollowers().length == 0
                            ? Container(
                                height: MediaQuery.of(context).size.height,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Text(
                                        "No Followings Found !",
                                        style: TextStyle(color: Theme.of(context).accentColor),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : ListView.builder(
                                itemBuilder: (context, i) {
                                  CPRFollowerFollowing following = getFilteredFollowers()[i];
                                  return FollowingListItem(following, followingHelpers[i], (v) {
                                    setState(() {
                                      showProgress = v;
                                    });

                                  });
                                },
                                shrinkWrap: true,
                                itemCount: getFilteredFollowers().length,
                              ),
                  )
                ],
              ))),
    );
  }

  List<CPRFollowerFollowing> getFilteredFollowers() {
    //print(searchKey.capitalize());
    return followings!
        .where((element) =>
            (element.following!.fullName != null && element.following!.fullName!.contains(searchKey.capitalize())) ||
            (element.following!.firstName != null && element.following!.firstName!.contains(searchKey.capitalize())) ||
            (element.following!.surname != null && element.following!.surname!.contains(searchKey.capitalize())) ||
            element.following!.email!.contains(searchKey))
        .toList();
  }

  Color rateColorPicker(double rate) {
    if (rate >= 4.0 && rate <= 5.0)
      return Colors.green;
    else if (rate >= 3.0 && rate <= 3.9)
      return Colors.amber;
    else if (rate < 3)
      return Colors.red;
    else
      return Colors.red;
  }

  _getFollowings() async {
    FollowingFollowerService followingFollowerService = new FollowingFollowerService();
    List<CPRFollowerFollowing> followingsTemp = await followingFollowerService.getFollowings(widget.user.email!);
    setState(() {
      followings = followingsTemp;
      followings!.forEach((element) {
        followingHelpers.add(CPRFollowerFollowingHelper());
      });
    });
  }

  _checkIsYourFollowing(BuildContext context) async {
    SessionProvider provider = p.Provider.of<SessionProvider>(context, listen: false);
    FollowingFollowerService? followingFollowerService = new FollowingFollowerService();
    CPRFollowerFollowing? cPRFF = await followingFollowerService.isYourFollowing(provider.user!.email!, widget.user.email!);
    if (cPRFF != null)
      setState(() {
        cPRFollowerFollowing = cPRFF;
        isYourFollowing = true;
      });
    else {
      cPRFollowerFollowing = null;
      isYourFollowing = false;
    }
  }

  follow(BuildContext context) async {
    setState(() {
      followUnfollowProgress = true;
    });
    SessionProvider provider = p.Provider.of<SessionProvider>(context, listen: false);
    FollowingFollowerService followingFollowerService = new FollowingFollowerService();
    CPRFollowerFollowing? cPRFollowerFollowing = await followingFollowerService.follow(new CPRFollowerFollowing(
        follower: provider.user!,
        followerId: provider.user!.email!,
        following: widget.user,
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
}
