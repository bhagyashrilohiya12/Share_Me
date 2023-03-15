import 'package:cpr_user/Widgets/modal_bottom_sheet_report_review.dart';
import 'package:cpr_user/constants/network_error_codes.dart';
import 'package:cpr_user/models/business_review_report.dart';
import 'package:cpr_user/models/review.dart';
import 'package:cpr_user/pages/common/components/cpr_card.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:cpr_user/services/business_review_reports_service.dart';
import 'package:cpr_user/services/network_service.dart';
import 'package:cpr_user/services/reviews_service.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart' as p;

class ReportReviewPage extends StatefulWidget {
  Review review;

  ReportReviewPage(this.review);

  @override
  _ReportReviewPageState createState() => _ReportReviewPageState();
}

class _ReportReviewPageState extends State<ReportReviewPage> {

  TextEditingController textEditingController = new TextEditingController();
  bool showProgress = false;
  bool showProgressLike = false;
  bool showProgressReport = false;
  ReviewService? reviewService;
  BusinessReviewReportsService? reviewReportsService;
  int selectedReportType = 0;
  CPRBusinessReviewReport? reviewReport;

  @override
  void initState() {
    reviewService = new ReviewService();
    reviewReportsService = new BusinessReviewReportsService();
    getReport(widget.review.firebaseId!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Log.i( "page - ReportReviewPage - build");

    SessionProvider sessionProvider = p.Provider.of<SessionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Report Review'),
      ),
      body: Padding(
          padding: EdgeInsets.fromLTRB(8, 16, 8, 8),
          child: widget.review != null
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      CPRCard(
                          //height: 300,
                          icon: Icons.report,
                          title: Text(
                            "Report Review",
                            style: CPRTextStyles.cardTitle,
                          ),
                          subtitle: Text(
                            "Report a case for this review",
                            style: CPRTextStyles.cardSubtitle,
                          ),
                          iconOnClick: () async {},
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                RadioListTile(
                                    value: 1,
                                    groupValue: selectedReportType,
                                    onChanged: (v) {
                                      setState(() {
                                        selectedReportType = v as int ;
                                      });
                                    },
                                    title: Text("This violates Click Pic Review’s Fair Review Policy")),
                                RadioListTile(
                                    value: 2,
                                    groupValue: selectedReportType,
                                    onChanged: (v) {
                                      setState(() {
                                        selectedReportType = v as int ;
                                      });
                                    },
                                    title: Text("The content contains hateful or foul language")),
                                RadioListTile(
                                    value: 3,
                                    groupValue: selectedReportType,
                                    onChanged: (v) {
                                      setState(() {
                                        selectedReportType = v as int ;
                                      });
                                    },
                                    title: Text("The review is fraudulent/sabotage")),
                                RadioListTile(
                                    value: 4,
                                    groupValue: selectedReportType,
                                    onChanged: (v) {
                                      setState(() {
                                        selectedReportType = v as int ;
                                      });
                                    },
                                    title: Text("The content breaches local, or national law")),
                                RadioListTile(
                                    value: 5,
                                    groupValue: selectedReportType,
                                    onChanged: (v) {
                                      setState(() {
                                        selectedReportType = v as int ;
                                      });
                                    },
                                    title: Text("The review is unfair")),
                                TextButton(
                                  onPressed: () {
                                    if (selectedReportType == 1) {
                                      showModalBottomSheet<void>(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (BuildContext context) {
                                          return Container(
                                              margin: EdgeInsets.only(top: 75),
                                              child: ClipRRect(
                                                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                                                  child: ModalBottomSheetReportReview(
                                                      widget.review,
                                                      "Fair Review Policy",
                                                      "Which part of the CPR FRP does it violate?",
                                                      1,
                                                      sessionProvider.user!.email!, reviewReport!)));
                                        },
                                      ).then((value) => getReport(widget.review.firebaseId!));
                                    } else if (selectedReportType == 2) {
                                      insertReviewReport(sessionProvider.user!.email!, null, widget.review.documentId!,
                                          2,
                                          sessionProvider);

                                    } else if (selectedReportType == 3) {
                                      showModalBottomSheet<void>(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (BuildContext context) {
                                          return Container(
                                              margin: EdgeInsets.only(top: 75),
                                              child: ClipRRect(
                                                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                                                  child: ModalBottomSheetReportReview(
                                                      widget.review,
                                                      "Fraudulent/Sabotage",
                                                      "please complete who and why and any evidence you have.",
                                                      3,
                                                      sessionProvider.user!.email!,
                                                      reviewReport!)));
                                        },
                                      ).then((value) => getReport(widget.review.firebaseId!));
                                    } else if (selectedReportType == 4) {
                                      insertReviewReport(sessionProvider.user!.email!, null, widget.review.documentId, 4,sessionProvider);
                                    } else if (selectedReportType == 5) {
                                      showModalBottomSheet<void>(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (BuildContext context) {
                                          return Container(
                                              margin: EdgeInsets.only(top: 75),
                                              child: ClipRRect(
                                                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                                                  child: ModalBottomSheetReportReview(
                                                      widget.review,
                                                      "Unfair review",
                                                      "unfortunately reviews are subjective, and the user has written how they see it.  Don't worry on CPR you also have a chance to tell your side of the story, so our users can read a balanced review.  This also provides you an opportunity to show how professional you are with dealing with complaints, and you might even win back the reviewer.  Reply to Review now .",
                                                      5,
                                                      sessionProvider.user!.email!,
                                                      reviewReport!)));
                                        },
                                      ).then((value) => getReport(widget.review.firebaseId!));
                                    }
                                  },
                                  child: showProgressReport
                                      ? SpinKitThreeBounce(
                                          color: Colors.white,
                                          size: 20,
                                        )
                                      : const Text(
                                          "Send",
                                        ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                )
              : SpinKitThreeBounce(
                  color: Theme.of(context).accentColor,
                  size: 24,
                )),
    );
  }

  getReport(String reviewId) async {
    CPRBusinessReviewReport reviewReportTemp = await reviewReportsService!.getReport(reviewId);
    setState(() {
      reviewReport = reviewReportTemp;
      if (reviewReportTemp != null) {
        selectedReportType = reviewReportTemp.reviewReportType!;
        print("Review Report Loaded");
      }
    });
  }

  Future<void> insertReviewReport(String email, String? description,
      String? reviewId, int reviewType,SessionProvider sessionProvider) async {
    setState(() {
      showProgressReport = true;
    });
    String url;
    if (description == null)
      url = BASE_URL + "/app/insertReviewReport?email=$email&des='null'&reviewId=$reviewId&reportType=$reviewType&isBusiness=true";
    else
      url = BASE_URL + "/app/insertReviewReport?email=$email&des=$description&reviewId=$reviewId&reportType=$reviewType&isBusiness=true";

    var res = await networkService.callApi(url: url, requestMethod: RequestMethod.GET);

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
        showProgressReport = false;
      });
      CPRBusinessReviewReport cPRBusinessReviewReport = CPRBusinessReviewReport.fromJson(res);
      if (cPRBusinessReviewReport.reviewId != null) {
        setState(() {
          reviewReport = cPRBusinessReviewReport;
        });
        Get.snackbar("Review reported successfully", "", snackPosition: SnackPosition.BOTTOM);
        sessionProvider.loadCategorizedPlaces();
      } else {
        Get.snackbar("Error!", "An error has occurred", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
      }
    }
  }
}
