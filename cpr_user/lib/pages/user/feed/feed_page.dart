import 'package:cpr_user/constants/network_error_codes.dart';
import 'package:cpr_user/main.dart';
import 'package:cpr_user/models/events/menu_changes.dart';
import 'package:cpr_user/models/feed_review.dart';
import 'package:cpr_user/models/get_user_feed_dto.dart';
import 'package:cpr_user/models/user.dart';
import 'package:cpr_user/pages/common/components/cpr_container.dart';
import 'package:cpr_user/pages/common/components/cpr_loading.dart';
import 'package:cpr_user/pages/user/feed/components/feed_review_list_item.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:cpr_user/services/network_service.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:incrementally_loading_listview/incrementally_loading_listview.dart';
import 'package:provider/provider.dart' as p;

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> with TickerProviderStateMixin {
  bool showProgress = false;
  bool showProgressForNavigateRoute = false;
  GetUserFeedDto? getUserFeedDto;
  List<FeedReview> reviews = [];
  CPRUser? loginedUser;
  CPRUser? user;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var sessionProvider = p.Provider.of<SessionProvider>(context, listen: false);
      user = sessionProvider.user;
      getUserFeed();
    });
  }

  @override
  Widget build(BuildContext context) {
    Log.i( "page - FeedScreen - build");

    getUser(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: CPRContainer(
        loadingWidget: Builder(
          builder: (context) {
            return CPRLoading(
              loading: showProgressForNavigateRoute,
            );
          },
        ),
        child: getContentPage(), // EmptyView.allDeviceScreen( context), //getContentPage(),
      ),
    );
  }

  void getUser(BuildContext context) {
    var provider = p.Provider.of<SessionProvider>(context);
    setState(() {
      loginedUser = provider.user;
    });
  }

  Future<void> getUserFeed() async {
    if (reviews.isEmpty)
      setState(() {
        showProgressForNavigateRoute  = true ;
        showProgress  = true ;
      });

    String creationTime = "";
    if (reviews.length > 0) {
      int x = reviews.last.creationTimeLocal!.iSeconds!;
      int y = reviews.last.creationTimeLocal!.iNanoseconds!;
      String ct = x.toString() + (y ~/ 1000000).toString();
      creationTime = "creationTime=$ct";
    }
    var res = await networkService.callApi(
        url: BASE_URL + "app/feed?user=${user!.email}&limit=10&$creationTime",
        requestMethod: RequestMethod.GET);

    if (reviews.isEmpty) if (mounted)
      setState(() {
        showProgress = false;
        showProgressForNavigateRoute = false;
      });

    if (res == NetworkErrorCodes.RECEIVE_TIMEOUT || res == NetworkErrorCodes.CONNECT_TIMEOUT || res == NetworkErrorCodes.SEND_TIMEOUT)
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Time Out Error !"),
      ));
    else if (res == NetworkErrorCodes.SOCKET_EXCEPTION)
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("No Internet Connection !"),
      ));
    else {
      setState(() {
        getUserFeedDto = GetUserFeedDto.fromJson(res);
        reviews.addAll(getUserFeedDto!.reviews!);
      });
    }
  }

   isHaseMorePage() {
    return (getUserFeedDto != null && reviews.length < getUserFeedDto!.count!) ? true : false;
    //     return true;
  }

  Widget getContentPage() {

    //check progress
    if( showProgress ) {
      return showProgressView();
    }

    return Container(
      margin: EdgeInsets.fromLTRB(0, 24, 0, 0),
      color: Colors.black,
      child: getUserFeedDto != null && getUserFeedDto!.reviews != null && reviews != null && reviews.length > 0
          ? columnHaveDataForListView()
          : columPlaceHolderEmptyListView()
    );
  }

  Widget columnHaveDataForListView() {
    Log.i("columnHaveDataForListView()");

    return  Column(
      children: [
        SizedBox(height: 16,),
        Image(image:AssetImage("assets/images/ic_cpr_feed.jpg"),height: 64,),

        Expanded(
          child: IncrementallyLoadingListView(
            itemBuilder: (context, i) {
              return FeedReviewListItem(
                  reviews[i],
                      (bool v) {
                    setState(() {
                      showProgressForNavigateRoute = v;
                    });
                  },
                      (bool showLikeProgress) {
                    setState(() {
                      reviews[i].showLikeProgress = showLikeProgress;
                    });
                  },
                  loginedUser!,
                      (reviewLike) {
                    setState(() {
                      if (reviews[i].likes == null) reviews[i].likes = [];
                      reviews[i].likes!.add(reviewLike);
                    });
                  },
                      (reviewLike) {
                    setState(() {
                      reviews[i].likes!.remove(reviewLike);
                    });
                  });
            },
            hasMore: () =>  isHaseMorePage(),
            itemCount: () =>  reviews.length,
            loadMore: () async {
              var x = await getUserFeed();
            },
            loadMoreOffsetFromBottom: 9,
            shrinkWrap: true,
          )

          ,
        ),
      ],
    );
  }

  Widget columPlaceHolderEmptyListView() {
    Log.i("columPlaceHolderEmptyListView()");

    return  Column(
      children: [
        Image.asset(
          "assets/images/ic_feed_no_item.png",
          width: Get.width - 64,
          height: Get.width - 64,
          fit: BoxFit.fill,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16,0,16,0),
          child: Text(
            "You’re not following anyone yet!",
            style: TextStyle(color: Colors.white,fontSize: 18),
          ),
        ),
        InkWell(
          onTap: (){
            eventBus.fire(MenuChanges(2));
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16,8,16,0),
            child: Text(
              "click here to start",
              style: TextStyle(color: Colors.white,fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }

  Widget showProgressView() {
    Log.i("showProgressView()");
    return  SpinKitSquareCircle(
      color: Theme.of(context).accentColor,
      size: 50.0,
      /**
       * #abdo
       * this animation make crash due to animation still progressing while Api response
       * return from backend, cause "setState" wile view not show to UI
       */
   //   controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
    );
  }

}
