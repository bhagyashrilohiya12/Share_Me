import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomSheetOptions extends StatelessWidget {

  bool isBlockedByYou;
  Function onBlock;

  BottomSheetOptions(this.isBlockedByYou,this.onBlock);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
              child: Container(
            width: 24,
            height: 4,
            color: Colors.grey,
          )),
          SizedBox(
            height: 16,
          ),
          InkWell(
            onTap: (){
              onBlock();
              Navigator.pop(context);
            },
            child: Container(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                width: Get.width,
                child: Text(
                  isBlockedByYou?"Unblock":"Block",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                )),
          )
        ],
      ),
    );
  }
}
