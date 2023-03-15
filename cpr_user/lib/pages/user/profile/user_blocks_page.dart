import 'package:cpr_user/helpers/string_helper.dart';
import 'package:cpr_user/models/blocked_user.dart';
import 'package:cpr_user/models/blocked_user_helper.dart';
import 'package:cpr_user/models/user.dart';
import 'package:cpr_user/pages/common/components/cpr_container.dart';
import 'package:cpr_user/pages/common/components/cpr_loading.dart';
import 'package:cpr_user/pages/user/profile/components/blocked_list_item.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:cpr_user/services/block_service.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart' as p;

class UserBlocksPage extends StatefulWidget {
  CPRUser user;

  UserBlocksPage(this.user);

  @override
  _UserBlocksPageState createState() => _UserBlocksPageState();
}

class _UserBlocksPageState extends State<UserBlocksPage> with TickerProviderStateMixin {
  List<CPRBlockedUser>? blocks;
  List<CPRBlockedUserHelper> followingHelpers = [];
  bool showProgress = false;
  bool isYourFollowing = false ;
  bool blockUnblockProgress = false;
  CPRBlockedUser? cPRBlockedUser;
  String searchKey = "";

  @override
  void initState() {
    _getBlocks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Log.i( "page - UserBlocksPage - build - showProgress: " + showProgress.toString());

    _checkIsBlockedByYou(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Blocks"),
        backgroundColor: CPRColors.appBarBackground,
      ),
      body: CPRContainer(
          loadingWidget: CPRLoading(
            loading: showProgress , //showProgress
          ),
          child:  _getContent() //EmptyView.zero() //
      ),
    );
  }

  List<CPRBlockedUser> getFilteredBlocks() {
  //  print(searchKey.capitalize());
    return blocks!
        .where((element) =>
            element.blocked!.fullName != null && element.blocked!.fullName!.contains(searchKey.capitalize()) ||
            element.blocked!.firstName != null && element.blocked!.firstName!.contains(searchKey.capitalize()) ||
            element.blocked!.surname != null && element.blocked!.surname!.contains(searchKey.capitalize()) ||
            element.blocked!.email != null && element.blocked!.email!.contains(searchKey))
        .toList();
  }

  Color rateColorPicker(double rate) {
    if (rate >= 4.0 && rate <= 5.0)
      return Colors.green;
    else if (rate >= 3.0 && rate <= 3.9)
      return Colors.amber;
    else if (rate < 3)
      return Colors.red;
    else
      return Colors.red;
  }

  _getBlocks() async {
    BlockService blockService = new BlockService();
    List<CPRBlockedUser> blocksTemp = await blockService.getBlocks(widget.user.email!);
    setState(() {
      blocks = blocksTemp;
      blocks!.forEach((element) {
        followingHelpers.add(CPRBlockedUserHelper());
      });
    });
  }

  _checkIsBlockedByYou(BuildContext context) async {
    SessionProvider provider = p.Provider.of<SessionProvider>(context, listen: false);
    BlockService blockService = new BlockService();
    CPRBlockedUser? cPRBU = await blockService.isBlockedByYou(provider.user!.email!, widget.user.email!);
    if (cPRBU != null)
      setState(() {
        cPRBlockedUser = cPRBU;
        isYourFollowing = true;
      });
    else {
      cPRBlockedUser = null;
      isYourFollowing = false;
    }
  }

  block(BuildContext context) async {
    setState(() {
      blockUnblockProgress = true;
    });
    SessionProvider provider = p.Provider.of<SessionProvider>(context, listen: false);
    BlockService blockService = new BlockService();
    CPRBlockedUser? cPRBlockedUser = await blockService.block(new CPRBlockedUser(
        blocker: provider.user!, blockerId: provider.user!.email!, blocked: widget.user, blockedId: widget.user.email!, id: '', documentID: ''));
    if (cPRBlockedUser != null && cPRBlockedUser.blockedId != null)
      setState(() {
        isYourFollowing = true;
        _checkIsBlockedByYou(context);
      });
    setState(() {
      blockUnblockProgress = false;
    });
  }

  _getContent() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
        child: Column(
          children: [
            Container(
              height: 42,
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
              padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 1, spreadRadius: 1)],
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                        onChanged: (v) {
                          setState(() {
                            searchKey = v;
                          });
                        },
                        decoration: InputDecoration.collapsed(hintText: "Search User ..."),
                      )),
                  Icon(
                    Icons.search,
                    color: Colors.black,
                  )
                ],
              ),
            ),



          chooseListViewOrMessageNoDataFound()
          ],
        ));
  }


  Widget chooseListViewOrMessageNoDataFound() {
    return   Expanded(
      child: blocks == null
          ? Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitSquareCircle(
              color: Theme.of(context).accentColor,
              size: 50.0,
              // controller:
              // AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Loading",
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            )
          ],
        ),
      )
          : getFilteredBlocks().length == 0
          ? Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "No Blocked User Found !",
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            )
          ],
        ),
      )
          : _listView(),
    );
  }

  Widget _listView() {
    return ListView.builder(
      itemBuilder: (context, i) {
        CPRBlockedUser blocked = getFilteredBlocks()[i];
        return BlockedListItem(blocked, followingHelpers[i], (v) {
          setState(() {
            showProgress = v;
          });

        });
      },
      shrinkWrap: true,
      itemCount: getFilteredBlocks().length,
    );
  }


}

