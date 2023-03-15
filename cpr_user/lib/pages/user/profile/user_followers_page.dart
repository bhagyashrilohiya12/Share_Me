import 'package:cpr_user/helpers/string_helper.dart';
import 'package:cpr_user/models/follower_following.dart';
import 'package:cpr_user/models/follower_following_helper.dart';
import 'package:cpr_user/models/user.dart';
import 'package:cpr_user/pages/common/components/cpr_container.dart';
import 'package:cpr_user/pages/common/components/cpr_loading.dart';
import 'package:cpr_user/pages/user/profile/components/follower_list_item.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:cpr_user/services/following_follower_service.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart' as p;

class UserFollowersPage extends StatefulWidget {
  CPRUser user;

  UserFollowersPage(this.user);

  @override
  _UserFollowersPageState createState() => _UserFollowersPageState();
}

class _UserFollowersPageState extends State<UserFollowersPage> with TickerProviderStateMixin {
  List<CPRFollowerFollowing> followers = [] ;
  List<CPRFollowerFollowingHelper> followingHelpers = [];
  bool showProgress = false;
  int followingsCount = 0;
  int followersCount = 0;
  CPRFollowerFollowing? cPRFollowerFollowing;
  String searchKey = "";

  @override
  void initState() {
    _getFollowers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Log.i( "page - _UserFollowersPageState - build");

    return Scaffold(
      appBar: AppBar(
        title: Text("Followers"),
        backgroundColor: CPRColors.appBarBackground,
      ),
      body: CPRContainer(
          loadingWidget: CPRLoading(
            loading: showProgress,
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
                    child: followers == null
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
                        : getFilteredFollowers().length == 0
                            ? Container(
                                height: MediaQuery.of(context).size.height,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Text(
                                        "No Followers Found !",
                                        style: TextStyle(color: Theme.of(context).accentColor),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : ListView.builder(
                                itemBuilder: (context, i) {
                                  CPRFollowerFollowing follower = getFilteredFollowers()[i];
                                  return FollowerListItem(follower,followingHelpers[i],(v){
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
    return followers
        .where((element) =>
            (element.follower!.fullName??"").contains(searchKey.capitalize()) ||
            (element.follower!.firstName??"").contains(searchKey.capitalize()) ||
            (element.follower!.surname??"").contains(searchKey.capitalize()) ||
            (element.follower!.email??"").contains(searchKey))
        .toList();
  }

  _getFollowers() async {
    FollowingFollowerService followingFollowerService = new FollowingFollowerService();
    List<CPRFollowerFollowing> followersTemp = await followingFollowerService.getFollowers(widget.user.email!);
    setState(() {
      followers = followersTemp;
      followers.forEach((element) {
        followingHelpers.add(CPRFollowerFollowingHelper());
      });
    });
  }
}
