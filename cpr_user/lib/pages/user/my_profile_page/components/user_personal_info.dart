import 'package:cpr_user/providers/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart' as p;

class UserPersonalInfo extends StatelessWidget {
  // const UserPersonalInfo({
  //   Key key,
  // }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var session = p.Provider.of<SessionProvider>(context, listen: false);
    print("session..$session");
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(color: Get.theme.accentColor, borderRadius: BorderRadius.circular(100)),
          constraints: BoxConstraints(minWidth: 120, maxWidth: 200),
          padding: EdgeInsets.fromLTRB(16,4,16,4),
          child: Text(
            (session.user?.firstName ?? '') + " " + (session.user?.surname ?? 'User'),
            maxLines: 1,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          session.user?.email ?? "",
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
