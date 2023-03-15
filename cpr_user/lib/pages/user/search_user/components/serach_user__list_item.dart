import 'package:cpr_user/Widgets/dialog_options_user_liat_item.dart';
import 'package:cpr_user/models/user.dart';
import 'package:cpr_user/pages/user/profile/user_profile_page.dart';
import 'package:cpr_user/services/user_service.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class SearchUserListItem extends StatelessWidget {
  CPRUser user;
  CPRUser loginedUser;
  Function followUnfollow;
  Function blockUnBlock;
  Function showHideProgress;
  bool isMiniItem;
  double? width;

  SearchUserListItem(this.user, this.loginedUser, this.followUnfollow, this.blockUnBlock, this.showHideProgress,
      {this.isMiniItem = false, double? this.width});

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
          margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image(
                            image: getImageProviderUser(),
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 38,
                          width: width != null ? width : Get.width,
                          margin: EdgeInsets.fromLTRB(44, 8, 4, 8),
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
                                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.white),
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
              ),
              if (loginedUser.email != user.email)
                if (user.setting == null || user.setting!.otherUserCanFollowMe!)
                  SizedBox(
                    width: 16,
                  ),
              if (loginedUser.email != user.email)
                if (user.setting == null || user.setting!.otherUserCanFollowMe! )
                  Container(
                    width: 96,
                    height: 36,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: user.isBlockedYou!
                            ? Colors.grey
                            : user.isFollowingByYou!
                                ? Colors.blue
                                : Colors.white),
                    child: GestureDetector(
                        onTap: () {
                          followUnfollow();
                        },
                        onLongPress: () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Follow - Unfollow User"),
                          ));
                        },
                        child: Center(
                          child: user.followUnfollowProgress!
                              ? const SpinKitThreeBounce(
                                  color: Colors.black,
                                  size: 16,
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (!user.isBlockedYou! && !user.isFollowingByYou!)
                                      Container(
                                        margin: const EdgeInsets.only(right: 8),
                                        child: const Image(
                                          image: AssetImage("assets/images/ic_link.png"),
                                          width: 24,
                                          height: 24,
                                        ),
                                      ),
                                    Text(
                                      user.isBlockedYou!
                                          ? "Can't Follow"
                                          : user.isFollowingByYou!
                                              ? "Following"
                                              : "Follow",
                                      style: TextStyle(
                                          fontWeight: user.isFollowingByYou! ? FontWeight.bold : FontWeight.normal,
                                          color: user.isBlockedYou!
                                              ? Colors.black
                                              : user.isFollowingByYou!
                                                  ? Colors.white
                                                  : Colors.blue),
                                    ),
                                    if (!user.isBlockedYou! && !user.isFollowingByYou!  )
                                      const SizedBox(
                                        width: 8,
                                      )
                                  ],
                                ),
                        )),
                  ),
              if (loginedUser.email != user.email)
                InkWell(
                    onTap: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (ctx) {
                          return StatefulBuilder(
                            builder: (ctx, setState) {
                              return DialogOptionsUserLiatItem(user, () {
                                blockUnBlock();
                              });
                            },
                          );
                        },
                      );
                    },
                    child: Container(width: 48, child: const Icon(Icons.more_vert_sharp, color: Colors.grey))),
            ],
          ),
        ));
  }

  getImageProviderUser() {
    /** - #abdo
        user.profilePictureURL != null && user.profilePictureURL.length > 0
        ? NetworkImage(user.profilePictureURL)
        : AssetImage("assets/images/no_avatar_image_choosed.png")
     */

      if( ToolsValidation.isValid( user.profilePictureURL) ) {
        return NetworkImage(user.profilePictureURL!);
      }   else {
        return const AssetImage("assets/images/no_avatar_image_choosed.png");
      }
  }


}
