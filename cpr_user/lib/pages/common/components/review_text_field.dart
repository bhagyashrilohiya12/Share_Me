import 'package:cpr_user/theming/styles.dart';
import 'package:flutter/material.dart';

class ReviewTextField extends StatelessWidget {

  final String label;
  final int maxLines;
  final controller;
  final Function? onTap;
  final BuildContext parentContext;
  final textInputAction;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final Function? validator;

  const ReviewTextField({
    this.validator,
    this.controller,
     this.focusNode,
    required this.parentContext,
    this.nextFocus,
    this.textInputAction = TextInputAction.done,
    this.onTap,
    required this.label,
    this.maxLines = 4
  })  ;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5)
                .copyWith(bottom: 0),
            child: Text(
              label,
              style: CPRTextStyles.cardSubtitleBlack.copyWith(
                fontSize: 11,
                // fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: TextFormField(
              textInputAction: textInputAction,
              maxLines: maxLines,
              validator: (string) {
                if (string == null || string.isEmpty) {
                  return "Required";
                }
                return null;
              },
              focusNode: focusNode,
              controller: controller,
              onFieldSubmitted: (_) {
                if( focusNode == null ) return;
                focusNode!.unfocus();
                FocusScope.of(parentContext).requestFocus(nextFocus);
              },
              decoration: InputDecoration(
                filled: true,
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red)),
                fillColor: Colors.grey.withOpacity(0.2),
                errorStyle: TextStyle(fontSize: 10, color: Colors.red),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
