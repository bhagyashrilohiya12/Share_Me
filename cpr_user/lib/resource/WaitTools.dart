import 'dart:async';

import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';

class ToolsWait {

  static waitToDo(int mili , Function() callback) {
   // Log.i("waitToDo - waitToDo() - start" );
    Timer(Duration(milliseconds: mili), () {
    //  Log.i("waitToDo - waitToDo() - end" );
      callback();
    });
  }


}