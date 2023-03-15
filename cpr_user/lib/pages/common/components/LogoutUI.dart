
import 'package:cpr_user/pages/common/components/cpr_confirm_dialog.dart';
import 'package:cpr_user/pages/user/login/login_screen.dart';
import 'package:cpr_user/services/auth_service.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/material.dart';

class LogoutUI   {


  //-------------------------------------------------------------------- logout button

  static Widget getWidget(BuildContext context) {
    return IconButton(
      alignment: Alignment.centerRight,
      icon: const Icon(Icons.logout, color: Colors.white),
      onPressed: () {

        showDialogCheckOutLogin(context);


      },
    );
  }

  static showDialogCheckOutLogin(BuildContext context ) {

    // Log.i( "showDialogCheckOutLogin");
    // AwesomeDialog(
    //   context: context,
    //   dialogType: DialogType.INFO,
    //   animType: AnimType.BOTTOMSLIDE,
    //   title: 'Logout',
    //   desc: 'Are you sure you want to logout?' ,
    //   btnCancelOnPress: () {
    //     //  ToolsToast.i(context,  "click cancel");
    //   },
    //   btnOkOnPress: () {
    //     //  ToolsToast.i(context,  "click login ");
    //     _confirmLogoutClick( context);
    //   },
    // ).show();


    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return CPRConfirmDialog(
            title: "Logout",
            content: "Are you sure you want to logout?",
            proceedAction: () {
              AuthService().signOut().then((value) {
                Navigator.pushAndRemoveUntil<dynamic>(
                  context,
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => LoginScreen(),
                  ),
                      (route) => false,//if you want to disable back feature set to false
                );
              });
            });
      },
    );


  }


  static _confirmLogoutClick(BuildContext context ) async {
    AuthService().signOut().then((value) {

      //navigate to login
      Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => LoginScreen(),
        ),
            (route) => false, //if you want to disable back feature set to false
      );
    }
    );
  }

}

