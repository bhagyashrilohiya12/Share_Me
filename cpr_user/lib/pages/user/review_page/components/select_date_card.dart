import 'package:cpr_user/constants/cpr_routes.dart';
import 'package:cpr_user/pages/common/components/cpr_button.dart';
import 'package:cpr_user/pages/common/components/cpr_card.dart';
import 'package:cpr_user/pages/common/components/review_calendar_table.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// double cardHeight = 500;
// double textHeight = 100;

class SelectDateCard extends StatelessWidget {
  // const SelectDateCard({
  //   Key key,
  // }) : super(key: key);

  BuildContext? context;


  @override
  Widget build(BuildContext ctx) {
    this.context = ctx;

   // return EmptyView.colored( DeviceTools.getWidth(context!),
   //     cardHeight, Colors.brown);

    return ColumnTemplate.t( children: [
      _getTextViews(),

      _getCalendarBox(),

    ]);

  }


 Widget _getCalendarBox() {
    return Container(
      // height: cardHeight,
      child: ColumnTemplate.t(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const ReviewCalendarTable(),

          createButton(),

          // Padding(
          //   padding: const EdgeInsets.only(left: 8.0, right: 8),
          //   child:   ReviewCalendarTable(),
          // ),
          // Padding(
          // padding: EdgeInsets.zero,
          // padding: const EdgeInsets.only(top: 8 , bottom: 8),
          // child: createButton(),
          // ),

          //   EmptyView.colored(10, 10, Colors.white),
        ],
      ),
    );
  }

  _getTextViews() {
    var col = ColumnTemplate.t(
        margin: EdgeInsets.symmetric(horizontal: 8), //8
        padding: EdgeInsets.all(10), //15

        children: [
          TextTemplate.t("Select a Date",
              color: Colors.white,
              dimen: 15, //17
              padding: EdgeInsets.all(10) //15
              // style: CPRTextStyles.cardTitle,
              ),
          TextTemplate.t(
              "Please select a date from the calendar to see the reviews",
              color: Colors.grey,
              dimen: 13, //14
              padding: EdgeInsets.symmetric(horizontal: 15)
              // style: CPRTextStyles.cardTitle,
              ),
          decorationButton()
        ]);

    return col;
  }

  Widget decorationButton() {
    return Container(
      height: 10,
      // margin: EdgeInsets.symmetric(  horizontal: 4 ),

      decoration: BoarderHelper.bottom_line(
          colorBackground: Colors.black,
          colorLine: Colors.white,
          // radiusBorder: BorderRadiusTools.get(radius_bottomLeft: 15, radius_bottomRight: 15)
          widthLine: 5),
    );
  }

  Widget createButton() {
    return ButtonTemplate.t("Create Review", () {
      CPRRoutes.createReview(context!);
    },
        margin: const EdgeInsets.only(bottom: 15, top: 15),
        levelDS: LevelDS.l3,
        width: 140,
        height: 40);
    /*
    CPRButton(
              borderRadius: 12,
              width: MediaQuery.of(context!).size.width / 2,
              height: 50,
              onPressed: () {
                CPRRoutes.createReview(context!);
              },
              color: CPRColors.cprButtonPink,
              child: Text(
                "Create Review",
                style: CPRTextStyles.buttonMediumWhite,

              ),
            )
     */
  }
}


// return Stack(   children: [
//
//
//   EmptyView.empty( DeviceTools.getWidth(context!),
//       cardHeight + textHeight ),
//
//   Positioned(child:  _getCalendarBox(), top: textHeight, ),
//
//
//   Positioned(child: _getTextViews(), top: 0, )
//
//
// ] );
// Widget cardCpr(){
//   return CPRCard(
//     halfScreenHeight: false,
//     title: Text(
//       "Select a Date",
//       style: CPRTextStyles.cardTitle,
//     ),
//     icon: Icons.remove_red_eye,
//     subtitle: Text(
//       "Please select a date from the calendar to see the reviews",
//       style: CPRTextStyles.cardSubtitle,
//     ),
//     child:   _getCalendarBox(),
//   );
// }