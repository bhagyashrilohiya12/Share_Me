import 'package:cpr_user/pages/common/components/cpr_header.dart';
import 'package:cpr_user/pages/common/components/cpr_separator.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/material.dart';

class CPRCard extends StatelessWidget {
  final Widget child;
  final Text title;
  final Text subtitle;
    double? height;
  final double radius;
  final bool halfScreenHeight;
  final Widget? footer;
  final IconData icon;
  final Function? iconOnClick;
   Color? backgroundColor;

   CPRCard({
    required this.subtitle,
     this.height,
     this.footer,
    this.halfScreenHeight = false,
    required this.title,
    this.radius = 12,
     this.iconOnClick,
     this.backgroundColor,
    required this.icon,
    required this.child
  });

  double headerHeight = 0;
  // double bodyHeight = 0 ;


  @override
  Widget build(BuildContext context) {

    // //default heigth
    // if( height == null ){
    //   height = 90 ;
    // }


    //header default
    if( headerHeight == 0 ) {
      headerHeight = 35;
    }

    if (halfScreenHeight) {
      var padding = MediaQuery.of(context).padding;

      var calculatedHeight =
          (MediaQuery.of(context).size.height - kBottomNavigationBarHeight - padding.top - kTextTabBarHeight - padding.bottom);
      height = calculatedHeight / 2;
      headerHeight = height! * 0.25;
      // bodyHeight = (height! * 0.75);
    }


    //fix cardview corner
    if( height != null ) {
      height = height! + 1.0; //why 1 ? fix corner of cardview
    }

   Log.i( "CPRCard - build - height: " + height.toString() );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
      child: Card(
        color: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
        child: SizedBox(
          height: height ,
          child: Column(
            children: <Widget>[
              //Header
              CPRHeader(
                  // height: headerHeight , //- 1
                  title: title,
                  subtitle: subtitle,
                  icon: icon,
                  iconOnClick: iconOnClick,
                  backgroundColor: backgroundColor,
                  textColor: Colors.black),
              CPRSeparator(),

              child,

              // SizedBox(
              //   height: bodyHeight,
              //   child: SingleChildScrollView(child: child),
              // ),

              footer != null ? CPRSeparator() : Container(),
              footer != null ? footer! : Container(),
              //child,
            ],
          ),
        ),
      ),
    );
  }
}
