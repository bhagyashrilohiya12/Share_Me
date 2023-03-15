import 'package:cpr_user/constants/network_error_codes.dart';
import 'package:cpr_user/models/business_review_report.dart';
import 'package:cpr_user/models/review.dart';
import 'package:cpr_user/services/network_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class ModalBottomSheetReportReview extends StatefulWidget {
  Review review;
  String title;
  String question;
  int reportType;
  CPRBusinessReviewReport reviewReport;
  String email;

  bool showProgressReport = false;

  ModalBottomSheetReportReview(this.review, this.title, this.question, this.reportType,this.email,this.reviewReport);

  @override
  _ModalBottomSheetReportReviewState createState() => _ModalBottomSheetReportReviewState();
}

class _ModalBottomSheetReportReviewState extends State<ModalBottomSheetReportReview> {
  ///////////////////////////////////////////////////
  TextEditingController descriptionController = new TextEditingController();
  bool showProgress = false;


  @override
  void initState() {
    if(widget.reviewReport!=null)
      if(widget.reviewReport.description!="'null'")
      descriptionController.text = widget.reviewReport.description!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.title,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 24,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  widget.question,
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
          if (widget.reportType != 5)
            SizedBox(
              height: 16,
            ),
          if (widget.reportType != 5)
            TextFormField(
                controller: descriptionController,
                maxLines: 3,
                minLines: 1,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  labelText: "Enter Description",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).accentColor,
                      width: 2.0,
                    ),
                  ),
                )),
          SizedBox(
            height: 16,
          ),
          TextButton(
            onPressed: () async {
              if (widget.reportType == 5) {
                Get.back();
              } else if (!showProgress) {

                insertReviewReport(widget.email,descriptionController.text.trim(),widget.review.documentId!,widget.reportType);

                Future.delayed(Duration(seconds: 3),(){
                  Get.back();
                });
              }
            },
            child: showProgress
                ? SpinKitThreeBounce(
                    color: Colors.white,
                    size: 20,
                  )
                : Text(
                    widget.reportType != 5 ? "Send" : "Ok",
                  ),
          ),
        ],
      ),
    );
  }
  Future<void> insertReviewReport(String email,String description,String reviewId,int reviewType) async {
    setState(() {
      showProgress = true;
    });
    String url;
    if(description==null)
      url = BASE_URL + "/app/insertReviewReport?email=$email&des='null'&reviewId=$reviewId&reportType=$reviewType&isBusiness=true";
    else
      url = BASE_URL + "/app/insertReviewReport?email=$email&des=$description&reviewId=$reviewId&reportType=$reviewType&isBusiness=true";

    var res = await networkService.callApi(url: url, requestMethod: RequestMethod.GET);

    if (res == NetworkErrorCodes.RECEIVE_TIMEOUT || res == NetworkErrorCodes.CONNECT_TIMEOUT || res == NetworkErrorCodes.SEND_TIMEOUT) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Time Out Error !"),
      ));
    } else if (res == NetworkErrorCodes.SOCKET_EXCEPTION) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("No Internet Connection !"),
      ));
    } else {
      setState(() {
        showProgress = false;
      });
      CPRBusinessReviewReport cPRBusinessReviewReport = CPRBusinessReviewReport.fromJson(res);
      if (cPRBusinessReviewReport.reviewId != null) {
        Get.snackbar("Review reported successfully", "", snackPosition: SnackPosition.BOTTOM);
        Future.delayed(Duration(seconds: 3),(){
          Get.back();
        });
      } else {
        Get.snackbar("Error!", "An error has occurred", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
      }
    }
  }

}
