import 'package:cpr_user/pages/user/review_page/components/reviews_by_date_card.dart';
import 'package:cpr_user/pages/user/review_page/components/select_date_card.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/material.dart';

class ReviewPage extends StatelessWidget {
  // const ReviewPage({Key key}) : super(key: key);
//
// class ReviewPage extends StatefulWidget {
//
// }
//
// class ReviewPageState extends State<ReviewPage> {
//

  @override
  Widget build(BuildContext context) {
    Log.i( "page - ReviewPage - build");



    return SafeArea(
      child: Container(
     //   height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(height: 10,),
                  //logo
                  Image(image:AssetImage("assets/images/ic_cpr_reviews.jpg"),height: 50,), //64
                  SelectDateCard(),
                  EmptyView.empty(6, 6) , //padding
                  ReviewsByDateCard(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
