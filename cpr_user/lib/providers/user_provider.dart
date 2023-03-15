import 'package:cpr_user/constants/main_categories.dart';
import 'package:cpr_user/models/business_server.dart';
import 'package:cpr_user/models/place.dart';
import 'package:cpr_user/models/user.dart';
import 'package:cpr_user/services/server_service.dart';
import 'package:cpr_user/services/places_service.dart';
import 'package:cpr_user/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserProvider with ChangeNotifier {

  UserService userService = UserService();

  Future<List<CPRUser>> searchUsers(String text,String email) async {
      return await userService.searchUsersByUsername(text,email);
  }

}
