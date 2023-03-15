import 'package:cpr_user/theming/styles.dart';
import 'package:flutter/material.dart';

class CPRConfirmDialog extends StatelessWidget {
  final Function proceedAction;
   Function? cancelAction;
  final String title;
  final String content;


    CPRConfirmDialog(
      {
       this.cancelAction,
        required this.proceedAction,
        required this.content,
        required this.title});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            proceedAction();
            Navigator.pop(context);
          },
          child: const Text(
            "Yes",
            style: TextStyle(color: CPRColors.cprButtonPink),
          ),
        ),
        TextButton(
          onPressed: () {
            if (cancelAction != null) {
              cancelAction!();
            }
            Navigator.pop(context);
          },
          child: Text(
            "No",
          ),
        )
      ],
    );
  }
}
