import 'package:cpr_user/constants/main_categories.dart';
import 'package:cpr_user/models/review.dart';
import 'package:cpr_user/pages/common/components/cpr_card.dart';
import 'package:cpr_user/pages/common/components/result_list_place.dart';
import 'package:cpr_user/pages/common/components/result_list_review.dart';
import 'package:cpr_user/pages/common/components/reviews/listView/ListViewReview.dart';
import 'package:cpr_user/pages/user/home_page/components/categorized_places_list.dart';
import 'package:cpr_user/providers/review_provider.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart' as p;
import 'package:provider/provider.dart';

class ReviewsByDateCard extends StatelessWidget {

  BuildContext pageContext;

  ReviewsByDateCard(this.pageContext);

  ReviewProvider? reviewProvider;

  @override
  Widget build(BuildContext context) {
    Log.i( "ReviewsByDateCard - build()");
    reviewProvider = Provider.of<ReviewProvider>(context);

    // return p.Consumer<ReviewProvider>(
    //     builder: (context, provider, _) {
    //       provider = provider;
    //       return getContent( context, provider);
    //     },
    // );
    return getContent( );
  }

  Widget getContent( ) {
    return getListResult( );
  }


  Widget getListResult( ){
    return  Padding(
      padding:  EdgeInsets.zero, // const EdgeInsets.fromLTRB(0,16,0,16),
      child: SingleChildScrollView(
        child: Column(
          children: [

            /**
              old code before abdallah
                CategorizedPlacesList(category:MainCategory.myReviews),
                CategorizedPlacesList(category:MainCategory.myDraftReviews),
             */

            ListViewReview( pageContext, isTypeDraft: false, filterByDate: reviewProvider!.selectedDateByCalender  ),
            ListViewReview( pageContext, isTypeDraft: true,  filterByDate: reviewProvider!.selectedDateByCalender  ),

          ],
        ),
      ),
    );
  }


  Widget caseAllReview(BuildContext context, ReviewProvider provider) {
    return  CPRCard(
      halfScreenHeight: false,
      //height: cardHeight,
      title: Text(
        "Results",
        style: CPRTextStyles.cardTitle,
      ),
      subtitle: Text(
        "When available reviews will be shown below",
        style: CPRTextStyles.cardSubtitle,
      ),
      icon: MaterialCommunityIcons.calendar,
      child: ResultListReview<Review>(
        list: provider.reviewsByDays,
      ),
    );
  }



}




// const ReviewsByDateCard({
//   Key key,
// }) : super(key: key);

// @override
// Widget build(BuildContext context) {
//   return p.Consumer<ReviewProvider>(
//     builder: (context, provider, _) {
//       Widget widget;
//       if(provider.getIsSelectedToday){
//         widget = Padding(
//           padding: const EdgeInsets.fromLTRB(0,16,0,16),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 CategorizedPlacesList(category:MainCategory.myReviews),
//                 CategorizedPlacesList(category:MainCategory.myDraftReviews),
//               ],
//             ),
//           ),
//         );
//       } else if (provider.reviewsByDays == null || provider.reviewsByDays.isEmpty) {

//       } else {

//       }
//       return widget;
//     },
//   );
// }
//
// Widget _emptyReviewWidget(BuildContext context, ReviewProvider provider) {
//   // var padding = MediaQuery.of(context).padding;
//   var widget = Container(
//     margin: EdgeInsets.symmetric(vertical: 10),
//     // height: (MediaQuery.of(context).size.height -
//     //     kBottomNavigationBarHeight -
//     //     padding.top -
//     //     kTextTabBarHeight -
//     //     100 -
//     //     padding.bottom) /
//     //     2,
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: <Widget>[
//         Container(
//           padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//           decoration: BoxDecoration(
//               color: Colors.blue,
//               borderRadius: BorderRadius.circular(5)),
//           child: Text(
//             "No reviews were found on this date",
//             style: CPRTextStyles.cardTitle,
//           ),
//         ),
//       ],
//     ),
//   );
//
//   return widget;
// }
//