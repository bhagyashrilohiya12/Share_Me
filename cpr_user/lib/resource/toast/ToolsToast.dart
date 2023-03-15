// import 'package:easy_localization/easy_localization.dart';

import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';

import 'package:flutter/material.dart';
// import 'package:toast/toast.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToolsToast {

  static i(BuildContext context, String  msg ){



    //check empty
    if ( ToolsValidation.isEmpty( msg) ) return;
    Log.i( "ToastTools - i() - msg: " + msg );



  Fluttertoast.showToast(
  msg: msg,
  toastLength: Toast.LENGTH_SHORT,
  gravity: ToastGravity.CENTER,
  timeInSecForIosWeb: 1,
  backgroundColor: Colors.red,
  textColor: Colors.white,
  fontSize: 16.0
  );

    // //now
    // Toast.show(st_byLang, context,
    //     duration: Toast.LENGTH_LONG,
    //     backgroundColor: DSColor.ds_toast_background,
    //     textColor: DSColor.ds_toast_text,
    //     gravity:  Toast.BOTTOM);

    // //
    // if( wait_callBack != null ) {
    //   ToolsWait.waitToDo( wait_miliSecond!, ()  {
    //     wait_callBack();
    //   }
    //   );

  }


}
