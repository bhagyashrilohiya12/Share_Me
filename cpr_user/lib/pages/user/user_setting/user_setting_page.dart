import 'package:cpr_user/models/user_setting.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart' as p;

class UserSettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Log.i( "page  - UserSettingPage - build");

    var session = p.Provider.of<SessionProvider>(context, listen: true);

    return Scaffold(
      body: Stack(
        children: [

          //background
          Container(
            width: Get.width,
            height: Get.height,
            color: Colors.white,
          ),

          //
          Positioned(
            top: 50,
            right: 16,
            height: 42,
            child: Center(
              child: Material(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                    child: Text(
                      "User Settings",
                      style: TextStyle(fontSize: 20),
                    ),
                  )),
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: Row(
              children: <Widget>[
                Material(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Container(
                      height: 40,
                      width: 40,
                      child: IconButton(
                        color: Colors.white,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                            size: 25,
                          ),
                        ),
                      )),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(16, 112, 16, 16),
            width: double.infinity,
            child: Material(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Container(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                child: Column(
                  children: [
                    SwitchListTile(
                      value: session.user!.setting?.receiveNotificationWhenAUserFollowMe ?? false,
                      onChanged: (v) {
                        if (session.user!.setting == null) session.user!.setting = new UserSetting();
                        session.user!.setting!.receiveNotificationWhenAUserFollowMe = v;
                        session.notifyListeners();
                        session.updateUser();
                      },
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Receive Notification",
                          ),
                          Text("When a User Follow Me",style:TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                    SwitchListTile(
                      value: session.user!.setting?.otherUserCanFollowMe ?? false,
                      onChanged: (v) {
                        if (session.user!.setting == null) session.user!.setting = new UserSetting();
                        session.user!.setting!.otherUserCanFollowMe = v;
                        session.notifyListeners();
                        session.updateUser();
                      },
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Public Account"),
                          Text("Other Users Can Follow You",style:TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                    SwitchListTile(
                      value: session.user!.setting?.optOutOfAllMarketingAndCommunications ?? false,
                      onChanged: (v) {
                        if (session.user!.setting == null) session.user!.setting = new UserSetting();
                        session.user!.setting!.optOutOfAllMarketingAndCommunications = v;
                        session.notifyListeners();
                        session.updateUser();
                      },
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Opt out of all marketing and communications"), ],
                      ),
                    ),
                    SwitchListTile(
                      value: session.user!.setting?.optOutOfSaleOfData ?? false,
                      onChanged: (v) {
                        if (session.user!.setting == null) session.user!.setting = new UserSetting();
                        session.user!.setting!.optOutOfSaleOfData = v;
                        session.notifyListeners();
                        session.updateUser();
                      },
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Opt out of sale of data"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
