import 'package:cpr_user/constants/main_categories.dart';
import 'package:cpr_user/constants/network_error_codes.dart';
import 'package:cpr_user/models/get_top_followed_users.dart';
import 'package:cpr_user/models/get_top_rate_near_palce.dart';
import 'package:cpr_user/models/place.dart';
import 'package:cpr_user/models/user.dart';
import 'package:cpr_user/pages/common/components/cpr_header.dart';
import 'package:cpr_user/pages/common/components/cpr_separator.dart';
import 'package:cpr_user/pages/common/components/result_list_tile.dart';
import 'package:cpr_user/pages/user/search_user/components/simple_user_list_item.dart';
import 'package:cpr_user/services/network_service.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class TopRatedUsersFullList extends StatefulWidget {

  CPRUser loginedUser;

  TopRatedUsersFullList(this.loginedUser);

  @override
  _TopRatedUsersFullListState createState() => _TopRatedUsersFullListState();
}

class _TopRatedUsersFullListState extends State<TopRatedUsersFullList> {
  GetTopFollowedUsers? topFollowedUsers;

  @override
  void initState() {
    getTopFollowedUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 16,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 0),
            padding: const EdgeInsets.all(8.0),
            child: CPRHeader(
              height: 64,
              title: Text(
                "Top rated users",
                style: CPRTextStyles.cardTitle.copyWith(fontSize: 12),
              ),
              subtitle: Text("Top users with most followers", style: CPRTextStyles.cardSubtitle.copyWith(fontSize: 10)),
              icon: MaterialCommunityIcons.compass,
            ),
          ),
          CPRSeparator(),
          CPRSeparator(),
          Expanded(
            child: topFollowedUsers == null
                ? SpinKitThreeBounce(
                    color: Theme.of(context).accentColor,
                    size: 24,
                  )
                : topFollowedUsers!.topFollowers != null && topFollowedUsers!.topFollowers!.isNotEmpty
                    ? ListView.builder(
                        itemBuilder: (context, i) {
                          CPRUser user = topFollowedUsers!.topFollowers![i];
                          return SimpleUserListItem(
                              user,
                              widget.loginedUser,
                              (v){

                              }
                          );
                        },
                        itemCount: topFollowedUsers!.topFollowers!.length,
                      )
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Text(
                            "No results found",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
          )
        ],
      ),
    );
  }


  Future<void> getTopFollowedUsers() async {
    var res = await networkService.callApi(
        url: BASE_URL + "app/getTopFollowedUsers?top=100", requestMethod: RequestMethod.GET);

    if (res == NetworkErrorCodes.RECEIVE_TIMEOUT ||
        res == NetworkErrorCodes.CONNECT_TIMEOUT ||
        res == NetworkErrorCodes.SEND_TIMEOUT) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Time Out Error !"),
      ));
    } else if (res == NetworkErrorCodes.SOCKET_EXCEPTION) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("No Internet Connection !"),
      ));
    } else {
      GetTopFollowedUsers topFollowedUsersTemp = GetTopFollowedUsers.fromJson(res);
      setState(() {
          topFollowedUsers = topFollowedUsersTemp;
      });
    }
  }
}
