import 'package:cpr_user/constants/main_categories.dart';
import 'package:cpr_user/models/business_server.dart';
import 'package:cpr_user/models/place.dart';
import 'package:cpr_user/services/server_service.dart';
import 'package:cpr_user/services/places_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ServerProvider with ChangeNotifier {

  ServerService service = ServerService();

  Future<List<CPRBusinessServer?>?> findEmployees(String employer) async {
      return await service.findEmployees(employer);
  }


}
