import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/constants/firebase.dart';
import 'package:cpr_user/models/business_review_report.dart';
import 'package:firebase_storage/firebase_storage.dart';

class BusinessReviewReportsService {
  var db = FirebaseFirestore.instance;
  var storage = FirebaseStorage.instance;

  Future<String?> addReviewReport(CPRBusinessReviewReport cPRBusinessReviewReport) async {
    DocumentReference dr = await db.collection(FirestorePaths.reviewReports).add(cPRBusinessReviewReport.toJSON());
    return dr != null ? dr.id : null;
  }

  Future<void> editReviewReport(CPRBusinessReviewReport cPRBusinessReviewReport) async {
    await db.collection(FirestorePaths.reviewReports).doc(cPRBusinessReviewReport.documentID).update(cPRBusinessReviewReport.toJSON());
  }

  Future<CPRBusinessReviewReport> getReport(String reviewId) async {
    CPRBusinessReviewReport cPRBusinessReviewReport = CPRBusinessReviewReport();
    QuerySnapshot querySnapshot = await db.collection(FirestorePaths.reviewReports).where("reviewId", isEqualTo: reviewId).get();
    if (querySnapshot.docs != null && querySnapshot.docs.length > 0) {
      cPRBusinessReviewReport = CPRBusinessReviewReport.fromDocumentSnapshot(querySnapshot.docs.first);
    }
    return cPRBusinessReviewReport;
  }
}
