import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/constants/firebase.dart';
import 'package:cpr_user/constants/weighting.dart';
import 'package:cpr_user/helpers/location_helper.dart';
import 'package:cpr_user/helpers/user_helper.dart';
import 'package:cpr_user/models/business_server.dart';
import 'package:cpr_user/models/place.dart';
import 'package:cpr_user/models/review.dart';
import 'dart:math' as math;


class ServerService {
  var db = FirebaseFirestore.instance;

  Future<List<CPRBusinessServer?>?> findEmployees(String employer) async {
    if(employer!=null && employer.isNotEmpty){
      QuerySnapshot querySnapshot = await db.collection(FirestorePaths.businessServersCollectionRoot)
          .where("employer", isEqualTo: employer)
          .get();

      List<CPRBusinessServer> employees;
      employees = [];
      if (querySnapshot != null && querySnapshot.docs != null && querySnapshot.docs.length > 0) {
        querySnapshot.docs.forEach((element) {
          employees.add(CPRBusinessServer.fromDocumentSnapshot(element));
        });
      }
      return employees;
    }else{
      return null;
    }


  }



   Future<CPRBusinessServer?> findSingleEmployees(String employer) async {
    if(employer!=null && employer.isNotEmpty){
      QuerySnapshot querySnapshot = await db.collection(FirestorePaths.businessServersCollectionRoot)
          .where("employer", isEqualTo: employer)
          .get();

      CPRBusinessServer employees = CPRBusinessServer();
      // employees = null;
      if (querySnapshot != null && querySnapshot.docs != null && querySnapshot.docs.length > 0) {
        querySnapshot.docs.forEach((element) {
          employees=CPRBusinessServer.fromDocumentSnapshot(element);
        });
      }
      return employees;
    }else{
      return null;
    }

  }
}