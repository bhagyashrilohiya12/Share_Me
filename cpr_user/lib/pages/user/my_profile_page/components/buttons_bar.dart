import 'package:cpr_user/constants/cpr_routes.dart';
import 'package:cpr_user/constants/weighting.dart';
import 'package:cpr_user/helpers/image_helper.dart';
import 'package:cpr_user/helpers/location_helper.dart';
import 'package:cpr_user/helpers/user_helper.dart';
import 'package:cpr_user/pages/common/components/cpr_confirm_dialog.dart';
import 'package:cpr_user/pages/common/components/cpr_header.dart';
import 'package:cpr_user/pages/user/my_profile_page/components/configure_page.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:cpr_user/services/places_service.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as p;

class ButtonsBar extends StatelessWidget {
  //final ImageHelper imageHelper;
  // const ButtonsBar({
  //   Key key,
  //   //this.imageHelper,
  // }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Log.i( "ButtonsBar - build()");

    var session = p.Provider.of<SessionProvider>(context);
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 20, left: 5, right: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: MaterialButton(
              height: 50,
              color: Colors.pink,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              onPressed: () {
                showModalBottomSheet(
                    builder: (modalContext) => session.imageHelper.showPicker(
                        modalContext,
                        session.changeUserProfilePicture
                    ),


                    context: context);
              },
              child: Text("Profile Picture",
                  style: CPRTextStyles.buttonSmallWhite),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: MaterialButton(
                height: 50,
                color: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                onPressed: () {
                  showGeneralDialog(
                    context: context,
                    pageBuilder: (context, anim1, anim2) {
                      return Container();
                    },
                    barrierDismissible: true,
                    barrierColor: Colors.black.withOpacity(0.8),
                    barrierLabel: 'Check',
                    transitionBuilder: (context, anim1, anim2, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 1),
                          end: Offset.zero,
                        ).animate(anim1),
                        child: AlertDialog(
                          titlePadding: EdgeInsets.only(top: 5),
                          contentPadding: EdgeInsets.all(16),
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: BorderSide.none),
                          title: CPRHeader(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            icon: CupertinoIcons.profile_circled,
                            title: Text(
                              "Profile Information",
                              style: CPRTextStyles.cardTitle,
                            ),
                            subtitle: Text(
                              "Additional Information from you",
                              style: CPRTextStyles.cardSubtitle,
                            ),
                            height: 48,
                          ),
                          content: Container(
                              width: MediaQuery.of(context).size.width,
                              child: ConfigurePage()),
                        ),
                      );
                    },
                    transitionDuration: Duration(milliseconds: 250),
                  );
                },
                child: Text("Configure", style: CPRTextStyles.buttonSmallWhite),
              ),
            ),
          ),
          Expanded(
            child: MaterialButton(
              height: 50,
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return CPRConfirmDialog(
                      title: "Logout",
                      content: "Are you sure you want to logout?",
                      proceedAction: () {

                        Log.i( "ButtonsBar - CPRConfirmDialog() - Logout - click");

                        session.signOut().then((onValue) {
                          CPRRoutes.loginScreen(context);
                        });
                      },
                    );
                  },
                );
              },
              child: Text("Logout", style: CPRTextStyles.buttonSmallWhite),
            ),
          ),
//          extractButton(session.userLevel),
        ],
      ),
    );
  }

  Widget extractButton(Weighting weighting) => Expanded(
        child: MaterialButton(
          color: Colors.green,
          onPressed: () async {
//          print(findRealReviewByWeighting(weighting, 1));
//                PlacesService().refreshLocation();
//            var location = await LocationHelper.userLocation();
//            PlacesService().findAllPlacesLastReviewIdAndImage();
//              PlacesService().findPlacesByCategoryNearBy("restaurant", userLocation: location);
//          PlacesService().findAllPlacesAndUpdateReview();
//          PlacesService().findAllPlacesAndUpdateTotalReview();
            PlacesService().findAllReviewsAndAssignPlaces();
          },
          child: Text("do"),
        ),
      );
}
