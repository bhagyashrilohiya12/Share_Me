import 'package:flutter/material.dart';

class CPRHeader extends StatelessWidget {

  final MainAxisAlignment mainAxisAlignment;
    double? height;
  final Text title;
  final Text subtitle;
  final IconData icon;
  final Function? iconOnClick;
  final Color? backgroundColor;
  final Color? textColor;


  CPRHeader({

    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.height,
    // required this.height,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.iconOnClick,
    this.backgroundColor,
    this.textColor = Colors.white,
  })  ;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: backgroundColor??Colors.black,borderRadius: BorderRadius.circular(12)),
      padding: EdgeInsets.only(left: 32, right: 32, top: 15),
      height: height,
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 7,
            child: Container(
              padding: EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[title,SizedBox(height: 4,), subtitle],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: (){
                if(iconOnClick!=null)
                  iconOnClick!();
              },
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Icon(icon,color: textColor??Colors.white,),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
