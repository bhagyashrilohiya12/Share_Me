
import 'package:cpr_user/models/user.dart';

class GetTopFollowedUsers {
  List<CPRUser>? topFollowers;

  // GetTopFollowedUsers({required this.topFollowers});

  GetTopFollowedUsers.fromJson(Map<String, dynamic> json) {
    if (json['topFollowers'] != null) {
      topFollowers = [];
      json['topFollowers'].forEach((v) {
        topFollowers!.add(new CPRUser.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.topFollowers != null) {
      data['topFollowers'] = this.topFollowers!.map((v) => v.toJSON()).toList();
    }
    return data;
  }
}