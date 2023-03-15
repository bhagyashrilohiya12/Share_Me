import 'package:cpr_user/models/business_hour.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/material.dart';

class ShowWorkingDayWidget extends StatelessWidget {
  String title;
  bool? isOpen;
  List<CPRBusinessHour>? hours;

  ShowWorkingDayWidget(this.title, this.isOpen, this.hours){
    if(isOpen==null)
      isOpen = false;
  }

  @override
  Widget build(BuildContext context) {

    if( isOpen == false  || hours == null ) {
      return EmptyView.zero();
    }

    return Container(
        padding: EdgeInsets.only(left:16,bottom: 8,top: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100,
              padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Text(title,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),)],
              ),
            ),
            Expanded(child: Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: isOpen!
                  ? hours != null && hours!.length > 0
                  ? ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, i) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(hours![i].startHour! + " - "+hours![i].endHour!,style: TextStyle(
                        color: Colors.white
                      ),),
                    ],
                  );
                },
                itemCount: hours!.length,
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Text("Not Set Yet !",style: TextStyle(
                    color: Colors.white
                ),)],
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Text("Closed",style: TextStyle(
                    color: Colors.white
                ),)],
              ),
            ),)
          ],
        ));
  }
}
