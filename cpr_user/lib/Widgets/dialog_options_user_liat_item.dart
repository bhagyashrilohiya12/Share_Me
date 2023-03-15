import 'package:cpr_user/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class DialogOptionsUserLiatItem extends StatelessWidget {
  CPRUser user;
  Function blockUnBlock;

  DialogOptionsUserLiatItem(this.user, this.blockUnBlock);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: Get.width ,
              margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey, width: 1),
                  color: Colors.white),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                      onTap: () {
                        blockUnBlock();
                      },
                      onLongPress: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Block - Unblock User"),
                        ));
                      },
                      child: Container(
                        width: Get.width-32,
                        padding: const EdgeInsets.all(16.0),
                        child: user.blockUnBlockProgress!
                            ? const SpinKitThreeBounce(
                          color: Colors.black,
                          size: 16,
                        )
                            : Text(user.isBlockedByYou!
                            ? "Unblock"
                            : "Block"),
                      ))
                ],
              )),
        ],
      ),
    );
  }
}
