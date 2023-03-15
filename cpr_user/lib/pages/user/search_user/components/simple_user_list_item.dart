import 'package:cpr_user/models/user.dart';
import 'package:cpr_user/pages/user/profile/user_profile_page.dart';
import 'package:cpr_user/services/user_service.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SimpleUserListItem extends StatelessWidget {
  CPRUser user;
  CPRUser loginedUser;
  bool isMiniItem;
  double? width;
  Function showHideProgress;

  SimpleUserListItem(this.user, this.loginedUser, this.showHideProgress, {this.isMiniItem = false, double? this.width});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
          showHideProgress(true);
          UserService userService = new UserService();
          CPRUser? u = await userService.getUserById(user.email!);
          Navigator.push(context, new MaterialPageRoute(builder: (context) => UserProfilePage(u!)));
          showHideProgress(false);
        },
        child: Container(
          width: width != null ? width : Get.width,
          height:  isMiniItem?56:64,
          margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width:  isMiniItem?56:64,
                  height: isMiniItem?56:64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: getUserImageWidget(),
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: isMiniItem ? 38 : 56,
                    width: width != null ? width : Get.width,
                    margin: isMiniItem ?EdgeInsets.fromLTRB(44, 6, 4, 8):EdgeInsets.fromLTRB(44, 0, 4, 0),
                    padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                    decoration: BoxDecoration(color: Get.theme.accentColor, borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                user.username ?? ((user.firstName ?? "") + " " + (user.surname ?? "")),
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14,color: Colors.white),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (!isMiniItem)
                                SizedBox(
                                  height: 4,
                                ),
                              if (!isMiniItem)
                                Text(
                                  user.email!.substring(0, 4) +
                                      "*******" +
                                      user.email!.substring(user.email!.indexOf("@"), user.email!.length),
                                  style: TextStyle(fontSize: 10,color: Colors.white),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ));
  }

  Widget getUserImageWidget() {

    //placeholder image
    var imgProvider ;
    if( ToolsValidation.isValid( user.profilePicture ) ) {
      imgProvider = NetworkImage(user.profilePictureURL!);
    } else {
      imgProvider = AssetImage("assets/images/no_avatar_image_choosed.png");
    }

    /**
     * #abdo
     * -- old code
     *
        return Image(
        image: user.profilePictureURL! != null && user.profilePictureURL!.length > 0
        ? NetworkImage(user!.profilePictureURL!)
        : AssetImage("assets/images/no_avatar_image_choosed.png"),
        width:  isMiniItem?56:64,
        height:  isMiniItem?56:64,
        fit: BoxFit.cover,
        );
     */
    return Image(
      image: imgProvider,
      width:  isMiniItem?56:64,
      height:  isMiniItem?56:64,
      fit: BoxFit.cover,
    );
  }

}
