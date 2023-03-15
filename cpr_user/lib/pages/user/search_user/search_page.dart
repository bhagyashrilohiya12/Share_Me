import 'package:cpr_user/constants/main_categories.dart';
import 'package:cpr_user/constants/network_error_codes.dart';
import 'package:cpr_user/models/blocked_user.dart';
import 'package:cpr_user/models/follower_following.dart';
import 'package:cpr_user/models/get_top_followed_users.dart';
import 'package:cpr_user/models/get_top_rate_near_palce.dart';
import 'package:cpr_user/models/place.dart';
import 'package:cpr_user/models/user.dart';
import 'package:cpr_user/pages/common/components/cpr_container.dart';
import 'package:cpr_user/pages/common/components/cpr_loading.dart';
import 'package:cpr_user/pages/common/components/cpr_search.dart';
import 'package:cpr_user/pages/user/search_user/components/serach_user__list_item.dart';
import 'package:cpr_user/pages/user/search_user/components/top_rated_places.dart';
import 'package:cpr_user/pages/user/search_user/components/top_rated_users.dart';
import 'package:cpr_user/providers/places_provider.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:cpr_user/services/block_service.dart';
import 'package:cpr_user/services/following_follower_service.dart';
import 'package:cpr_user/services/network_service.dart';
import 'package:cpr_user/services/user_service.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart' as p;

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  /////////////////////////////////////////////////////////////////////////////////////////////
  PageController controller = PageController(initialPage: 0, keepPage: false);
  int slideIndex = 0;

  /////////////////////////////////////////////////////////////////////////////////////////////
  final _searchController = TextEditingController();
  List<CPRUser> suggestedUsers = [];
  List<CPRUser>? followerUsers;

  List<CPRUser>? followingUsers;
  List<String> categoriesNames = [];
  bool showProgress = false;

  String searchKey = "";
  List<CPRFollowerFollowing>? followersTemp;
  List<CPRFollowerFollowing>? followingTemp;
  TabController? _controller;
  GetTopRateNearPalce? topRateNearPalce;
  GetTopFollowedUsers? topFollowedUsers;
  int selectedTabIndex = 0;

  @override
  void initState() {
    _controller = TabController(
      length: 2,
      vsync: this,
    );
    _controller!.addListener(() {
      setState(() {
        selectedTabIndex = _controller!.index;
      });
    });
    loadFollowingFollowersTemp(loadMainObjects: true);
    getTopFollowedUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Log.i("page  - SearchPage - build");

    var sessionProvider = p.Provider.of<SessionProvider>(context, listen: false);
    if (topRateNearPalce == null) getTopRateNearPlace(sessionProvider);

    return Scaffold(
      body: CPRContainer(
        loadingWidget: CPRLoading(
          loading: showProgress,
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          width: Get.width,
          height: Get.height,
          color: Colors.black,
          child: Column(
            children: [
              const SizedBox(
                height: 32,
              ),
              const Image(
                image: AssetImage("assets/images/ic_cpr_search.jpg"),
                height: 64,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(8, 32, 8, 8),
                child: TextField(
                  maxLines: 1,
                  controller: _searchController,
                  autofocus: false,
                  textInputAction: TextInputAction.search,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: 'Enter a name eg. james',
                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.55)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      fillColor: Colors.grey.shade100,
                      prefixIcon: const Icon(Icons.search)),
                  onChanged: (v) async {
                    searchKey = v;
                    if (v.length >= 1) {
                      categoriesNames = [];
                      suggestedUsers = [];
                      getCategoriesByName(v);
                      await getUsersByUsername(v, sessionProvider.user!.email!);
                    } else {
                      setState(() {
                        categoriesNames = [];
                        suggestedUsers = [];
                        followerUsers = null;
                        followingUsers = null;
                      });
                      loadFollowingFollowersTemp(loadMainObjects: true);
                    }
                  },
                ),
              ),
              Expanded(
                child: searchKey.isEmpty
                    ? Container(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(8, 16, 8, 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Container(
                                  decoration: new BoxDecoration(color: Colors.white),
                                  child: new TabBar(
                                    indicatorColor: Colors.transparent,
                                    controller: _controller,
                                    onTap: (v){
                                      setState(() {
                                        selectedTabIndex = v;
                                      });
                                    },
                                    indicatorWeight: 0,
                                    indicator:BoxDecoration(),
                                    labelPadding: EdgeInsets.zero,
                                    indicatorPadding: EdgeInsets.zero,
                                    tabs: [
                                      new Container(
                                        width: double.infinity,
                                        height: 48,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100),
                                            color: selectedTabIndex==0?Get.theme.accentColor:Colors.transparent
                                        ),
                                        child:Center(child: Text('Following',style: TextStyle(color: Colors.black),)),
                                      ),
                                      new Container(
                                        width: double.infinity,
                                        height: 48,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100),
                                            color: selectedTabIndex==1?Get.theme.accentColor:Colors.transparent
                                        ),
                                        child:Center(child: Text('Followers',style: TextStyle(color: Colors.black),)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: TabBarView(
                                  controller: _controller,
                                  children: <Widget>[
                                    Container(
                                        child: ListView(
                                          shrinkWrap: true,
                                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          children: [


                                            TopRatedPlaces("Top rated places near me", topRateNearPalce,
                                                sessionProvider.currentLocation!),


                                            TopRatedUsers(topFollowedUsers, sessionProvider.user!,(v){
                                              setState(() {
                                                showProgress = v;
                                              });
                                            }),
                                            followingUsers != null
                                                ? followingUsers!.isNotEmpty
                                                ? ListView.builder(
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                                              itemBuilder: (context, i) {
                                                return SearchUserListItem(followingUsers![i], sessionProvider.user!,
                                                        () {
                                                      if (followingUsers![i].isBlockedYou!) {
                                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                          content: Text("Can't Follow",style: TextStyle(
                                                            color: Colors.white
                                                          ),),
                                                          duration: Duration(seconds: 1),
                                                        ));
                                                      } else if (!followingUsers![i].followUnfollowProgress!) {
                                                        if (!followingUsers![i].isFollowingByYou!) {
                                                          follow(context, followingUsers!, i);
                                                        } else {
                                                          unFollow(followingUsers!, i, true);
                                                        }
                                                      }
                                                    }, () {
                                                      Navigator.of(context).pop();
                                                      FocusScope.of(context).unfocus();
                                                      if (!followingUsers![i].blockUnBlockProgress!) {
                                                        if (!followingUsers![i].isBlockedByYou!) {
                                                          block(context, followingUsers!, i);
                                                        } else {
                                                          unBlock(followingUsers!, i);
                                                        }
                                                      }
                                                    }, (v) {
                                                      setState(() {
                                                        showProgress = v;
                                                      });
                                                    });
                                              },
                                              itemCount: followingUsers!.length,
                                            )
                                                : const Center(
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(0, 32, 0, 0),
                                                  child: Text("No Following !",style: TextStyle(
                                                      color: Colors.white
                                                  ),),
                                                ))
                                                : SpinKitThreeBounce(
                                              color: Theme.of(context).accentColor,
                                              size: 24,
                                            )
                                          ],
                                        )),
                                    Container(
                                        child: ListView(
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      children: [
                                        followerUsers != null
                                            ? followerUsers!.isNotEmpty
                                                ? ListView.builder(
                                                    shrinkWrap: true,
                                                    physics: const NeverScrollableScrollPhysics(),
                                                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                                                    itemBuilder: (context, i) {
                                                      return SearchUserListItem(followerUsers![i], sessionProvider.user!,
                                                          () {
                                                        if (followerUsers![i].isBlockedYou!) {
                                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                            content: Text("Can't Follow",style: TextStyle(
                                                                color: Colors.white
                                                            ),),
                                                            duration: Duration(seconds: 1),
                                                          ));
                                                        } else if (!followerUsers![i].followUnfollowProgress!) {
                                                          if (!followerUsers![i].isFollowingByYou! ) {
                                                            follow(context, followerUsers!, i);
                                                          } else {
                                                            unFollow(followerUsers!, i, false);
                                                          }
                                                        }
                                                      }, () {
                                                        Navigator.of(context).pop();
                                                        FocusScope.of(context).unfocus();
                                                        if (!followerUsers![i].blockUnBlockProgress! ) {
                                                          if (!followerUsers![i].isBlockedByYou! ) {
                                                            block(context, followerUsers!, i);
                                                          } else {
                                                            unBlock(followerUsers!, i);
                                                          }
                                                        }
                                                      }, (v) {
                                                        setState(() {
                                                          showProgress = v;
                                                        });
                                                      });
                                                    },
                                                    itemCount: followerUsers!.length,
                                                  )
                                                : const Center(
                                                    child: Padding(
                                                    padding: EdgeInsets.fromLTRB(0, 32, 0, 0),
                                                    child: Text("No Follower !",style: TextStyle(
                                                        color: Colors.white
                                                    ),),
                                                  ))
                                            : SpinKitThreeBounce(
                                                color: Theme.of(context).accentColor,
                                                size: 24,
                                              ),
                                      ],
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        child: Column(children: <Widget>[
                          if (categoriesNames.isNotEmpty)
                            Container(
                                child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, i) {
                                return InkWell(
                                  onTap: () async {

                                    var placeProvider = p.Provider.of<PlacesProvider>(context, listen: false);
                                    var cat = MainCategoryUtil.getGooglePlacesCategoryFromName(categoriesNames[i]);
                                    var list = await placeProvider.findPlacesByCategory(sessionProvider.currentLocation!,cat);
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => CPRSearch<Place>(
                                              title: MainCategoryUtil.getDisplayName(cat),
                                              subtitle:
                                                  'List of all the ${MainCategoryUtil.getDisplayName(cat).toLowerCase()} that has been reviewed.',
                                              reviews: list!,
                                              currentLocation: sessionProvider.currentLocation!,
                                              topMargin: 16,
                                            )));
                                  },
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                                        child: Row(
                                          children: [
                                            Text(
                                              categoriesNames[i] ,
                                              maxLines: 1,
                                              style: const TextStyle(fontSize: 18,color: Colors.white),
                                            ),
                                            const Expanded(child: Text("")),
                                            const Icon(
                                              Icons.arrow_forward_ios,
                                              size: 20,
                                            )
                                          ],
                                        ),
                                      ),
                                      const Divider(
                                        height: 1,
                                        color: Colors.black,
                                      )
                                    ],
                                  ),
                                );
                              },
                              itemCount: categoriesNames.length,
                            )),
                          Container(
                              child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, i) {
                              return SearchUserListItem(suggestedUsers[i], sessionProvider.user!, () {
                                if (suggestedUsers[i].isBlockedYou! ) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Text("Can't Follow",style: TextStyle(
                                        color: Colors.white
                                    ),),
                                    duration: Duration(seconds: 1),
                                  ));
                                } else if (!suggestedUsers[i].followUnfollowProgress!) {
                                  if (!suggestedUsers[i].isFollowingByYou!) {
                                    follow(context, suggestedUsers, i);
                                  } else {
                                    unFollow(suggestedUsers, i, false);
                                  }
                                }
                              }, () {
                                Navigator.of(context).pop();
                                FocusScope.of(context).unfocus();
                                if (!suggestedUsers[i].blockUnBlockProgress!) {
                                  if (!suggestedUsers[i].isBlockedByYou!) {
                                    block(context, suggestedUsers, i);
                                  } else {
                                    unBlock(suggestedUsers, i);
                                  }
                                }
                              }, (v) {
                                setState(() {
                                  showProgress = v;
                                });
                              });
                            },
                            itemCount: suggestedUsers.length,
                          )),
                        ]),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<List<CPRUser>?> getUsersByUsername(String text, String email) async {
    List<CPRUser> suggestedUsersTemp = [];
    List<CPRUser> suggestedUsersTempSorted = [];
    try {
      UserService userService = new UserService();
      suggestedUsersTemp = await userService.searchUsersByUsername(text.trim(), email);

      await loadFollowingFollowersTemp();
      BlockService blockService = new BlockService();
      List<CPRBlockedUser> blocks = await blockService.getBlocks(email);
      List<CPRBlockedUser> myBlockers = await blockService.getMyBlockers(email);

      for (int i = suggestedUsersTemp.length - 1; i >= 0; i--) {
        bool filled = false;

        blocks.forEach((element) {
          if (element.blocked!.email  == suggestedUsersTemp[i].email) {
            suggestedUsersTemp[i].isBlockedByYou = true;
          }
        });

        myBlockers.forEach((element) {
          if (element.blocker!.email == suggestedUsersTemp[i].email) {
            suggestedUsersTemp[i].isBlockedYou = true;
          }
        });

        followingTemp!.forEach((following) {
          if (suggestedUsersTemp[i].email == following.following!.email) {
            suggestedUsersTemp[i].isFollowingByYou = true;
            suggestedUsersTempSorted.add(suggestedUsersTemp[i]);
            suggestedUsersTemp.removeAt(i);
            filled = true;
          }
        });

        if (!filled) {
          followersTemp!.forEach((follower) {
            if (suggestedUsersTemp[i].email == follower.follower!.email) {
              suggestedUsersTempSorted.add(suggestedUsersTemp[i]);
              suggestedUsersTemp.removeAt(i);
            }
          });
        }
      }
      suggestedUsersTempSorted.addAll(suggestedUsersTemp);

      setState(() {
        suggestedUsers = suggestedUsersTempSorted;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  loadFollowingFollowersTemp({bool loadMainObjects = false}) async {
    var sessionProvider = p.Provider.of<SessionProvider>(context, listen: false);
    FollowingFollowerService followingFollowerService = FollowingFollowerService();
    followersTemp = await followingFollowerService.getFollowers(sessionProvider.user!.email!);
    followingTemp = await followingFollowerService.getFollowings(sessionProvider.user!.email!);
    if (loadMainObjects) {
      getFollowersFollowingsMainObjects();
    }
  }

  getFollowersFollowingsMainObjects() async {
    var sessionProvider = p.Provider.of<SessionProvider>(context, listen: false);

    BlockService blockService = BlockService();
    List<CPRBlockedUser> blocks = await blockService.getBlocks(sessionProvider.user!.email!);
    List<CPRBlockedUser> myBlockers = await blockService.getMyBlockers(sessionProvider.user!.email!);

    UserService userService = UserService();
    followerUsers = [];
    followingUsers = [];

    if (followersTemp != null && followersTemp!.isNotEmpty) {
      List<String> followersIdList = followersTemp!.map((e) => e.follower!.email!).toList();
      List followerUsersTemp = await userService.searchUsersByIdsList(followersIdList, sessionProvider.user!.email!);
      for (var element in followerUsersTemp) {
        for (var elem in blocks) {
          if (elem.blocked!.email == element.email) {
            element.isBlockedByYou = true;
          }
        }

        for (var elem in myBlockers) {
          if (elem.blocker!.email == element.email) {
            element.isBlockedYou = true;
          }
        }
      }
      if(mounted) {
        setState(() {
        followerUsers = followerUsersTemp.cast<CPRUser>(); //#abdo
      });
      }
    }
    if (followingTemp != null && followingTemp!.isNotEmpty) {
      List<String?> followingsIdList = followingTemp!.map((e) => e.following!.email).toList();
      List followingUsersTemp = await userService.searchUsersByIdsList(followingsIdList, sessionProvider.user!.email!);
      for (var element in followingUsersTemp) {
        element.isFollowingByYou = true;

        for (var elem in blocks) {
          if (elem.blocked!.email == element.email) {
            element.isBlockedByYou = true;
          }
        }

        for (var elem in myBlockers) {
          if (elem.blocker!.email == element.email) {
            element.isBlockedYou = true;
          }
        }
      }

      if(mounted) {
        setState(() {
        followingUsers = followingUsersTemp.cast<CPRUser>(); //#abdo
      });
      }
    }
  }

  getCategoriesByName(String text) {
    List<String> names = MainCategoryUtil.getGooglePlacesNames();
    List<String> namesTemp = names.where((element) => element.contains(text)).toList();
    setState(() {
      categoriesNames = namesTemp;
    });
  }

  follow(BuildContext context, List users, int index) async {
    setState(() {
      users[index].followUnfollowProgress = true;
    });
    SessionProvider provider = p.Provider.of<SessionProvider>(context, listen: false);
    FollowingFollowerService followingFollowerService = FollowingFollowerService();
    CPRFollowerFollowing? cPRFollowerFollowing = await followingFollowerService.follow(CPRFollowerFollowing(
        follower: provider.user!,
        followerId: provider.user!.email!,
        following: users[index],
        followingId: users[index].email));
    if (cPRFollowerFollowing != null && cPRFollowerFollowing.followingId != null) {
      setState(() {
        users[index].isFollowingByYou = true;
      });
    }
    setState(() {
      users[index].followUnfollowProgress = false;
    });
  }

  unFollow(List users, int index, bool remove) async {
    setState(() {
      users[index].followUnfollowProgress = true;
    });
    FollowingFollowerService followingFollowerService = FollowingFollowerService();
    bool isDeleted = await followingFollowerService.unFollow(null, followingEmail: users[index].documentID);
    if (isDeleted) {
      setState(() {
        users[index].isFollowingByYou = false;
        if (remove) users.removeAt(index);
      });
    }
    setState(() {
      users[index].followUnfollowProgress = false;
    });
  }

  block(BuildContext context, List users, int index) async {
    SessionProvider provider = p.Provider.of<SessionProvider>(context, listen: false);
    BlockService blockService = BlockService();

    var blockerUser = CPRBlockedUser(
        blocker: provider.user!, blockerId: provider.user!.email!, blocked: users[index], blockedId: users[index].email, id: '', documentID: '');

    CPRBlockedUser? cPRBlockedUser = await blockService.block( blockerUser);
    if (cPRBlockedUser != null && cPRBlockedUser.blocked != null) {
      setState(() {
        users[index].isBlockedByYou = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("User Blocked"),
        duration: Duration(seconds: 1),
      ));
    }
  }

  unBlock(List users, int index) async {
    BlockService blockService = BlockService();
    bool isDeleted = await blockService.unBlock(null, blockedEmail: users[index].documentID);
    if (isDeleted) {
      setState(() {
        users[index].isBlockedByYou = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("User Unblocked"),
        duration: Duration(seconds: 1),
      ));
    }
  }

  Future<void> getTopRateNearPlace(SessionProvider sessionProvider, {int total = 10}) async { //#abdo //, List list
    var res = await networkService.callApi(
        url: BASE_URL +
            "app/getTopRateNearPlace?lat=${sessionProvider.currentLocation?.latitude}&lng=${sessionProvider.currentLocation?.latitude}&top=$total",
        requestMethod: RequestMethod.GET);

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
      GetTopRateNearPalce topRateNearPalceTemp = GetTopRateNearPalce.fromJson(res);
      if(mounted) {
        setState(() {

        topRateNearPalce = topRateNearPalceTemp;

        /**
         //#abdo

            if (list != null)
            list = topRateNearPalceTemp.nearRatePlaces;
            else
            topRateNearPalce = topRateNearPalceTemp;

         */
      });
      }
    }
  }

  Future<void> getTopFollowedUsers({int total = 10}) async { //List list //#abdo
    var res = await networkService.callApi(
        url: BASE_URL + "app/getTopFollowedUsers?top=$total", requestMethod: RequestMethod.GET);

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
    } else if(res!=null){
      GetTopFollowedUsers topFollowedUsersTemp = GetTopFollowedUsers.fromJson(res);
      setState(() {
        topFollowedUsers = topFollowedUsersTemp;

        /**
         * //#abdo

            if(list!=null)
            list = topFollowedUsersTemp.topFollowers;
            else
            topFollowedUsers = topFollowedUsersTemp;
         */
      });
    }
  }
}
