import 'package:cpr_user/models/get_top_followed_users.dart';
import 'package:cpr_user/models/get_top_rate_near_palce.dart';
import 'package:cpr_user/models/user.dart';
import 'package:cpr_user/pages/user/search_user/components/serach_user__list_item.dart';
import 'package:cpr_user/pages/user/search_user/components/simple_user_list_item.dart';
import 'package:cpr_user/pages/user/search_user/components/top_rated_users_full_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class TopRatedUsers extends StatelessWidget {

  //topFollowedUsers!.topFollowers!

  TopRatedUsers(this.topFollowedUsers, this.loginedUser, this.showHideProgress) {

    if( topFollowedUsers != null ) {
      topRatedUsers = topFollowedUsers!.topFollowers!;
    }
  }

  GetTopFollowedUsers? topFollowedUsers;
  List<CPRUser>? topRatedUsers;
  CPRUser loginedUser;
  Function showHideProgress;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 118,
      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
      //color: Colors.cyan,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.favorite,color: Colors.red,),
              SizedBox(width: 8,),
              Text(
                "Top users",
                style: TextStyle(
                    color: Colors.white
                ),
              ),
              Expanded(child: Text(""),),
              if (topRatedUsers != null && topRatedUsers!.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (bottomSheetContext) {
                          return Container(
                            child: TopRatedUsersFullList(loginedUser),
                            height: MediaQuery.of(context).size.height * .85,
                          );
                        });
                  },
                  child: Text(
                    "See all",
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Container(
              width: Get.width,
              height: 64,
              child: topRatedUsers == null
                  ? SpinKitThreeBounce(
                      color: Theme.of(context).accentColor,
                      size: 24,
                    )
                  : topRatedUsers!.isNotEmpty
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (context, i) {
                            CPRUser user = topRatedUsers![i];
                            return SimpleUserListItem(user, loginedUser,  (v) {
                              showHideProgress(v);
                            },
                                width: Get.width,// Get.width - 250,

                                isMiniItem: true);
                          },
                          itemCount: topRatedUsers!.length,
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: Text(
                              "No results found",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ))
        ],
      ),
    );
  }

}
