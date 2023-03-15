import 'package:cpr_user/constants/analytics_types.dart';
import 'package:cpr_user/constants/cpr_routes.dart';
import 'package:cpr_user/helpers/launcher_helper.dart';
import 'package:cpr_user/models/place.dart';
import 'package:cpr_user/resource/toast/ToolsToast.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';

class CPRPlaceButtons extends StatelessWidget {
  Place place;
  Function addAnalytic;

  CPRPlaceButtons(this.place, this.addAnalytic);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(12, 12, 12, 12),
      padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
      child: Row(
        children: [
          Expanded(
              child: GestureDetector(
            onTap: () {
              CPRRoutes.createReview(context, place: place);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.rate_review),
                SizedBox(
                  height: 4,
                ),
                Text("Review")
              ],
            ),
          )),
          Container(
            width: 1,
            height: 24,
            color: Colors.grey,
          ),
          Expanded(
              child: GestureDetector(
            onTap: () {

              if( ToolsValidation.isEmpty(this.place.phone ) ) {
                ToolsToast.i( context, "No Phone Number Found!");
                return;
              }

              if (this.place.phone != null) {
                addAnalytic(AnalyticsTypes.HOW_MANY_PEOPLE_CALL_THE_BUSINESS_FROM_CPR.index);
                LauncherHelper.launchURL("tel:" + this.place.phone!);
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.call, color: this.place.phone != null ? Colors.black : Colors.grey),
                SizedBox(
                  height: 4,
                ),
                Text(
                  "Call",
                  style: TextStyle(color: this.place.phone != null ? Colors.black : Colors.grey),
                )
              ],
            ),
          )),
          Container(
            width: 1,
            height: 24,
            color: Colors.grey,
          ),
          Expanded(
              child: GestureDetector(
                  onTap: () {
                    if (this.place.coordinate != null) {
                      addAnalytic(AnalyticsTypes.HOW_MANY_PEOPLE_LOOK_FOR_DIRECTIONS_FROM_CPR.index);
                      MapsLauncher.launchCoordinates(place.coordinate!.latitude, place.coordinate!.longitude);
                    }},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.directions, color: this.place.coordinate != null ? Colors.black : Colors.grey),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "Direction",
                        style: TextStyle(color: this.place.coordinate != null ? Colors.black : Colors.grey),
                      )
                    ],
                  ))),
          Container(
            width: 1,
            height: 24,
            color: Colors.grey,
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if( ToolsValidation.isEmpty(this.place.phone ) ) {
                  ToolsToast.i( context, "No Phone Number Found!");
                  return;
                }

                if (this.place.website != null) {
                  addAnalytic(AnalyticsTypes.HOW_MANY_PEOPLE_CLICK_ON_THE_BUSINESSES_WEBSITE_FROM_CPR.index);
                  LauncherHelper.launchURL(this.place.website!);}
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.web,
                    color: this.place.website != null ? Colors.black : Colors.grey,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Website",
                    style: TextStyle(color: this.place.website != null ? Colors.black : Colors.grey),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
