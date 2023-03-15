import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/constants/login_status.dart';
import 'package:cpr_user/constants/network_error_codes.dart';
import 'package:cpr_user/helpers/social_post_helper.dart';
import 'package:cpr_user/models/get_user_social_list_dto.dart';
import 'package:cpr_user/models/review.dart';
import 'package:cpr_user/models/share_review_response.dart';
import 'package:cpr_user/models/user.dart';
import 'package:cpr_user/models/user_social_dto.dart';
import 'package:cpr_user/pages/user/social_media/components/social_media_list_item.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:cpr_user/services/network_service.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart' as p;

class SocialMediaPage extends StatefulWidget {
  Review review;

  SocialMediaPage({super.key, required this.review});

  @override
  _SocialMediaPageState createState() => _SocialMediaPageState();
}

class _SocialMediaPageState extends State<SocialMediaPage>
    with WidgetsBindingObserver {
  List<UserSocialDto> activeSocials = [];
  List<UserSocialDto> allSocials = [];
  GetUserSocialListDto? getUserSocialListDto;
  bool showProgress = true;
  bool shareReviewShowProgress = false;
  CPRUser? user;
  var db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var sessionProvider =
          p.Provider.of<SessionProvider>(context, listen: false);
      user = sessionProvider.user;
      getUserSocialList();
    });

    // add the observer
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // remove the observer
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // These are the callbacks
    switch (state) {
      case AppLifecycleState.resumed:
        setState(() {
          getUserSocialListDto = null;
          activeSocials = [];
        });
        getUserSocialList();
        break;
      case AppLifecycleState.inactive:
        // widget is inactive
        break;
      case AppLifecycleState.paused:
        // widget is paused
        break;
      case AppLifecycleState.detached:
        // widget is detached
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Log.i("page  - SocialMediaPage - build");

    return Scaffold(
      body: Container(
        color: Colors.black,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(0, 40, 0, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage("assets/images/ic_cpr_connect.png"),
              height: 64,
            ),
            const SizedBox(
              height: 48,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                  const Text(
                    " Top social media accounts",
                    style: TextStyle(color: Colors.white),
                  ),
                  const Expanded(
                    child: Text(""),
                  ),
                  const Text(
                    "see all",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(
                child: Container(
                    color: Colors.black,
                    child: getUserSocialListDto != null
                        ? allSocials.isNotEmpty
                            ? ListView.builder(
                                itemBuilder: (context, i) {
                                  return SocailMediaListItem(allSocials[i]);
                                },
                                itemCount: allSocials.length,
                              )
                            : const Center(
                                child: Text(
                                    "No Active Social Network Was Found !"))
                        : SpinKitSquareCircle(
                            color: Theme.of(context).accentColor,
                            size: 50.0,
                          ))),
            widget.review != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                                height: 42,
                                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Text("Close",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14)),
                                    Expanded(child: Text(" ")),
                                    Icon(
                                      Icons.close,
                                      size: 20,
                                      color: Colors.white,
                                    )
                                  ],
                                )),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              if (activeSocials.length >
                                  0) if (!shareReviewShowProgress) {
                                SocialPostHelper()
                                    .shareReview(review: widget.review);
                              }
                            },
                            child: Container(
                                height: 42,
                                margin: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                                decoration: BoxDecoration(
                                    color: activeSocials.length > 0 &&
                                            widget.review.documentId != null
                                        ? Colors.green
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(5)),
                                child: shareReviewShowProgress
                                    ? Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                            const SpinKitThreeBounce(
                                                size: 20, color: Colors.white)
                                          ])
                                    : Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                                  activeSocials.isNotEmpty
                                                      ? "Share Review"
                                                      : "No Active Social Network",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14))),
                                          const Text(" "),
                                          Icon(
                                            activeSocials.isNotEmpty
                                                ? Icons.send
                                                : Icons.assignment_late_sharp,
                                            size: 20,
                                            color: Colors.white,
                                          )
                                        ],
                                      )),
                          ),
                        )
                      ],
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Future<void> getUserSocialList() async {
    setState(() {
      showProgress = true;
    });

    var res = await networkService.callApi(
        url: BASE_URL + "socialMediaApp/userSocialList?email=${user!.email}",
        requestMethod: RequestMethod.GET);

    if (mounted) {
      setState(() {
        showProgress = false;
      });
    }

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
    } else if (res != null) {
      if (mounted) {
        setState(() {
          //get the conected social media list from db
          //set it in 'activeSocials' and update the GUI
          //db.collection('Profiles').doc(user!.email);

          getUserSocialListDto = GetUserSocialListDto.fromJson(res);
          allSocials = getUserSocialListDto?.socials ?? [];
          activeSocials = allSocials
              .where((element) => element.loginStatus == LoginStatus.Success)
              .toList(); //?? []
        });
      }
    }
  }

  Future<void> shareReview() async {
    setState(() {
      shareReviewShowProgress = true;
    });

    var res = await networkService.callApi(
        url: BASE_URL +
            "socialMediaApp/shareReview?reviewId=${widget.review.firebaseId}",
        requestMethod: RequestMethod.GET);

    setState(() {
      shareReviewShowProgress = false;
    });

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
      ShareReviewResponse shareReviewResponse =
          ShareReviewResponse.fromJson(res);
      if (shareReviewResponse.status!) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });
      }
    }
  }
}
