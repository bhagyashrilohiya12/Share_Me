import 'package:cpr_user/models/blocked_user.dart';
import 'package:cpr_user/models/blocked_user_helper.dart';
import 'package:cpr_user/models/follower_following.dart';
import 'package:cpr_user/models/follower_following_helper.dart';
import 'package:cpr_user/models/user.dart';
import 'package:cpr_user/pages/user/profile/user_profile_page.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:cpr_user/resource/validation/ImageProviderValidation.dart';
import 'package:cpr_user/services/block_service.dart';
import 'package:cpr_user/services/following_follower_service.dart';
import 'package:cpr_user/services/user_service.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as p;

class BlockedListItem extends StatefulWidget {
  CPRBlockedUser block;
  CPRBlockedUserHelper helper;
  Function showProgress;

  BlockedListItem(this.block,this.helper,this.showProgress);

  @override
  _BlockedListItemState createState() => _BlockedListItemState();
}

class _BlockedListItemState extends State<BlockedListItem> {
  CPRBlockedUser? cPRBlockedUser;
  CPRUser? loginedUser;


  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Log.i( "BlockedListItem - build()");

    setState(() {
      loginedUser = p.Provider.of<SessionProvider>(context, listen: false).user;
    });
    if(widget.helper.isBlockedByYou == null) _checkIsBlockedByYou(context);
    return GestureDetector(
      onTap: () async {
        widget.showProgress(true);
        UserService userService = new UserService();
        CPRUser? user = await userService.getUserById(widget.block.blockedId! );
        Navigator.push(context, new MaterialPageRoute(builder: (context)=>UserProfilePage(user!)));
        widget.showProgress(false);
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image(
                  image: ImageProviderValidation.networkOrPlaceholder( widget.block.blocked!.profilePictureURL ),
                  // image: widget.block.blocked.profilePictureURL != null && widget.block.blocked.profilePictureURL.length > 0
                  //     ? NetworkImage(widget.block.blocked.profilePictureURL)
                  //     : AssetImage("assets/images/no_avatar_image_choosed.png"),
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 64,
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (widget.block.blocked!.firstName ?? "") + " " + (widget.block.blocked!.surname ?? "") ,
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            widget.block.blocked!.email!.substring(0, 4) +
                                "*******" +
                                widget.block.blocked!.email!.substring(widget.block.blocked!.email!.indexOf("@"),
                                    widget.block.blocked!.email!.length),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 96,
              height: 42,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(200),
                  border: Border.all(color: Colors.grey.shade500, width: 2),
                  color: widget.helper.isBlockedByYou != null && widget.helper.isBlockedByYou! ? Colors.white : Theme.of(context).accentColor),
              child: GestureDetector(
                  onTap: () {
                    if (!widget.helper.blockUnblockProgress! && widget.helper.isBlockedByYou != null && loginedUser?.email != widget.block.blocked?.email) {
                      if (!widget.helper.isBlockedByYou!)
                        follow(context);
                      else
                        unFollow();
                    }
                  },
                  child:Center(
                child: Text(
                  widget.helper.isBlockedByYou == null
                      ? "Loading..."
                      : widget.helper.isBlockedByYou!
                      ? "UnBlock"
                      : "Block",
                  style: TextStyle(
                      color: widget.helper.isBlockedByYou != null && widget.helper.isBlockedByYou! ? Colors.black : Colors.white, fontSize: 14),
                  maxLines: 1,
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }


  follow(BuildContext context) async {
    setState(() {
      widget.helper.blockUnblockProgress = true;
    });
    SessionProvider provider = p.Provider.of<SessionProvider>(context, listen: false);
    BlockService blockService = new BlockService();
    CPRBlockedUser? cPRBlockedUser = await blockService.block(new CPRBlockedUser(
        blocker: provider.user!, blockerId: provider.user!.email!, blocked: widget.block.blocked,
        blockedId: widget.block.blocked!.email!, documentID: '', id: '')
    );
    if (cPRBlockedUser != null && cPRBlockedUser.blockedId != null)
      setState(() {
        widget.helper.isBlockedByYou = true;
        _checkIsBlockedByYou(context);
      });
    setState(() {
      widget.helper.blockUnblockProgress = false;
    });
  }


  unFollow() async {
    setState(() {
      widget.helper.blockUnblockProgress = true;
    });
    BlockService blockService = new BlockService();
    bool isDeleted = await blockService.unBlock(cPRBlockedUser!.documentID!);
    if (isDeleted)
      setState(() {
        cPRBlockedUser = null;
        widget.helper.isBlockedByYou = false;
      });
    setState(() {
      widget.helper.blockUnblockProgress = false;
    });
  }


  _checkIsBlockedByYou(BuildContext context) async {
    SessionProvider provider = p.Provider.of<SessionProvider>(context, listen: false);
    BlockService blockService = new BlockService();
    CPRBlockedUser? cPRBU = await blockService.isBlockedByYou(provider.user!.email!, widget.block.blocked!.email!);
    if (cPRBU != null)
      setState(() {
        cPRBlockedUser = cPRBU;
        widget.helper.isBlockedByYou = true;
      });
    else {
      cPRBlockedUser = null;
      widget.helper.isBlockedByYou = false;
    }
  }
}
