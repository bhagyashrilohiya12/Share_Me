import 'package:cpr_user/models/business_internal_promotion.dart';
import 'package:cpr_user/pages/user/my_prizes_competition_page/components/internal_promotion_mini_card.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:cpr_user/services/business_internal_promotions_service.dart';
import 'package:cpr_user/services/reviews_service.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart' as p;

class MyPrizesCompetitionPage extends StatefulWidget {
  @override
  _MyPrizesCompetitionPageState createState() => _MyPrizesCompetitionPageState();
}

class _MyPrizesCompetitionPageState extends State<MyPrizesCompetitionPage> {
  List<CPRBusinessInternalPromotion>? internalPromotions;

  @override
  void initState() {
    getUserPrizesAndCompetitions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Log.i( "page  - MyPrizesCompetitionPage - build");

    return Scaffold(
      body: Stack(
        children: [
          Container(
              width: Get.width,
              height: Get.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/bg_prize.jpg"),
                  fit: BoxFit.cover,
                ),
              )),
          Positioned(
            top: 50,
            right: 16,
            height: 42,
            child: Center(
              child: Container(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                child: Text(
                  "Prizes/Competition",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: Row(
              children: <Widget>[
                Material(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Container(
                      height: 40,
                      width: 40,
                      child: IconButton(
                        color: Colors.white,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                            size: 25,
                          ),
                        ),
                      )),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(16, 112, 16, 16),
            padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
            child: internalPromotions == null
                ? SpinKitThreeBounce(color: Theme.of(context).accentColor,size: 24,)
                : ListView.builder(
                    itemBuilder: (context, i) {
                      return InternalPromotionMiniCard(internalPromotions![i]);
                    },
                    itemCount: internalPromotions!.length,
                  ),
          ),
        ],
      ),
    );
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<List<CPRBusinessInternalPromotion>?> getUserPrizesAndCompetitions() async {
    SessionProvider provider = p.Provider.of<SessionProvider>(context, listen: false);
    List<String>? userPrizesAndCompetitionsIdsList =
        await ReviewService().findReviewsThatUsePromotionByUser(provider.user!);
    Log.i(   "getUserPrizesAndCompetitions() - userPrizesAndCompetitionsIdsList " + userPrizesAndCompetitionsIdsList.toString() );
    List internalPromotionsTemp =
        await BusinessInternalPromotionsService().getInternalPromotionsFromIdsList(userPrizesAndCompetitionsIdsList!);

    Log.i(   "getUserPrizesAndCompetitions() - internalPromotionsTemp " + internalPromotionsTemp.toString() );

    setState(() {
      internalPromotions = internalPromotionsTemp.cast<CPRBusinessInternalPromotion>();
    });
    return internalPromotions;
  }

}
