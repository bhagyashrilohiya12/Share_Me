import 'package:cpr_user/models/business_internal_promotion.dart';
import 'package:cpr_user/pages/user/internal_promotion_details_page/internal_promotion_details_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/models/business_external_promotion.dart';
import 'package:cpr_user/pages/common/components/cpr_search.dart';
import 'package:cpr_user/pages/common/components/cpr_search_external_promotions.dart';
import 'package:cpr_user/pages/user/external_promotion_page/external_promotion_detail_page.dart';
import 'package:cpr_user/providers/places_provider.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart' as p;

class InternalPromotionMiniCard extends StatelessWidget {
  
  final CPRBusinessInternalPromotion internalPromotion;

    InternalPromotionMiniCard(
    this.internalPromotion );


  @override
  Widget build(BuildContext context) {
    var placesProvider = p.Provider.of<PlacesProvider>(context);
    var homeProvider = p.Provider.of<SessionProvider>(context, listen: false);

    return GestureDetector(
      onTap: () async {
        try {
          Navigator.of(context).push(new MaterialPageRoute(builder: (context) => internalPromotionDetailPage(internalPromotion)));
        } catch (e) {
          print(e);
        }
      },
      child: Container(
        // color: color,
        margin: EdgeInsets.only( bottom: 16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
        width: Get.width,
        child: Column(children: <Widget>[
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Container(
                  height: Get.width/2,
                  width: Get.width,
                  child: internalPromotion.pictureURL!=null?ExtendedImage.network(
                    internalPromotion.pictureURL!,
                    fit: BoxFit.cover,
                    cache: true,
                  ):SizedBox(),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.black38),
                  padding: EdgeInsets.all(16),
                  height: Get.width/2,
                  width: Get.width,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Text(
                          internalPromotion.title!,
                          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      CountdownTimer(
                        endTime: internalPromotion.endDate!.millisecondsSinceEpoch,
                        widgetBuilder: (_, time) {
                          if (time == null) {
                            return Column(
                              children: [
                                SizedBox(height: 16,),
                                Text('See Winners',
                                  style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
                              ],
                            );
                          }
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      '${time.days!=null?time.days.toString().padLeft(2, "0"):0} days',
                                      style: TextStyle(color: Colors.white,fontSize: 18),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      '${time.min!=null?time.min.toString().padLeft(2, "0"):0} min',
                                      style: TextStyle(color: Colors.white,fontSize: 18),
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Text(""),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    child: Text(
                                      '${time.hours!=null?time.hours.toString().padLeft(2, "0"):0} hours',
                                      style: TextStyle(color: Colors.white,fontSize: 18),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      '${time.sec!=null?time.sec.toString().padLeft(2, "0"):0} sec',
                                      style: TextStyle(color: Colors.white,fontSize: 18),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                      Expanded(child: Text("")),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 16, 0, 4),
                        child: Text(
                          internalPromotion.description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ]),
      ),
    );
  }
}
