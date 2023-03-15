import 'package:cpr_user/models/business_owner.dart';
import 'package:cpr_user/models/business_working_day_hour.dart';
import 'package:cpr_user/models/place.dart';
import 'package:cpr_user/pages/user/places_details_page/components/show_working_day_widget.dart';
import 'package:cpr_user/services/business_owner_service.dart';
import 'package:expandable/expandable.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/material.dart';

class CPRWorkingHours extends StatefulWidget {
  Place place;

  CPRWorkingHours(this.place);

  @override
  _CPRWorkingHoursState createState() => _CPRWorkingHoursState();
}

class _CPRWorkingHoursState extends State<CPRWorkingHours> {

  CPRBusinessWorkingDayHour? openingHours;

  @override
  void initState() {
    getWorkingHours();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //       ShowWorkingDayWidget("Mon", openingHours!.isMonOpen!, openingHours!.Mon!),
    Log.i( "_CPRWorkingHoursState - openingHours " + openingHours.toString() );

    return Container(
      child: ExpandablePanel(
        theme: const ExpandableThemeData(
            collapseIcon: Icons.keyboard_arrow_up,
            expandIcon: Icons.keyboard_arrow_down,
            iconColor: Colors.white,
            iconSize: 42,
            headerAlignment: ExpandablePanelHeaderAlignment.center),
        header: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.access_time,
                color: Colors.white,
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                  child: Text(
                "Working Hours",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              )),
              SizedBox(
                width: 16,
              )
            ],
          ),
        ),
        expanded: Container(
          margin: EdgeInsets.fromLTRB(16, 0, 8, 0),
          padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
          decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 0.5), borderRadius: BorderRadius.circular(5)),
          child:  getOpeninigContentHourView(),
        ),
        collapsed: SizedBox(),
      ),
    );
  }

  getWorkingHours() async {
    BusinessOwnerService businessOwnerService = new BusinessOwnerService();
    CPRBusinessOwner? owner = await businessOwnerService.findOwner(widget.place.googlePlaceID!);

    if(owner!=null && owner.openingHours!=null)
    setState(() {
      openingHours = owner.openingHours;
    });
  }

  Widget getOpeninigContentHourView() {

    //check not found
    if( openingHours == null ) {
      return Text("Opening HoursNot Set Yet !",style: TextStyle(
          color: Colors.white
      ),);
      // return Text(
      //   "No Opening Hours Available"
      // );
    }

    return Column(
      children: [

        ShowWorkingDayWidget("Mon", openingHours!.isMonOpen, openingHours!.Mon),
        ShowWorkingDayWidget("Tue", openingHours!.isTueOpen, openingHours!.Tue),
        ShowWorkingDayWidget("Wed", openingHours!.isWedOpen, openingHours!.Wed),
        ShowWorkingDayWidget("Thu", openingHours!.isThuOpen, openingHours!.Thu),
        ShowWorkingDayWidget("Fri", openingHours!.isFriOpen, openingHours!.Fri),
        ShowWorkingDayWidget("Sat", openingHours!.isSatOpen, openingHours!.Sat),
        ShowWorkingDayWidget("Sun", openingHours!.isSunOpen, openingHours!.Sun),
      ],
    );
  }
}
