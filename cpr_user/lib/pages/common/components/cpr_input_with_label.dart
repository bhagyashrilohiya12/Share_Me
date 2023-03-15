import 'package:cpr_user/theming/styles.dart';
import 'package:flutter/material.dart';

class CPRInputWithLabel extends StatelessWidget {
  final String label;
  String? hint;
  final TextEditingController controller;

    CPRInputWithLabel({
    required this.label,
    required this.controller,
    this.hint,

  })  ;

  @override
  Widget build(BuildContext context) {
    var hintText = hint != null && hint!.isNotEmpty ? hint : label;
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.w200),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
            ),
            child: TextFormField(
              controller: controller,
              decoration:
                  CPRInputDecorations.cprFormInput.copyWith(hintText: hintText),
            ),
          )
        ],
      ),
    );
  }
}
