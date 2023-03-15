import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:cpr_user/constants/coupon_status.dart';
import 'package:cpr_user/pages/user/external_promotion_page/external_promotion_detail_page.dart';
import 'package:cpr_user/providers/places_provider.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as p;
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../models/external_promotion_coupon.dart';
import '../../../common/components/cpr_search_user_coupons.dart';

class UserCouponsList extends StatelessWidget {
  const UserCouponsList({super.key});

  @override
  Widget build(BuildContext context) {
    var sessionProvider = p.Provider.of<SessionProvider>(context);
    return Container(
      height: 120,
      padding: const EdgeInsets.only(left: 16, right: 16),
      margin: const EdgeInsets.only(top: 30,bottom: 16),
      //color: Colors.cyan,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "My Coupons",
                style: CPRTextStyles.smallHeaderBoldDarkBackground,
              ),
              GestureDetector(
                onTap: () async {
                  sessionProvider.startLoading();
                  List<CPRExternalPromotionCoupon> coupons = await sessionProvider.getUserCoupons();
                  var searchComponent = CPRSearchUserCoupons(
                    coupons: coupons,
                  );
                  sessionProvider.stopLoading();
                  showModalBottomSheet(
                      context: context,
                      builder: (bottomSheetContext) {
                        return SizedBox(
                          child: searchComponent,
                          height: MediaQuery.of(context).size.height * 0.7,
                        );
                      });
                  // Scaffold.of(context).showBottomSheet();
                },
                child: sessionProvider.externalPromotions == null || sessionProvider.externalPromotions!.isEmpty
                    ? const SizedBox()
                    : Text(
                        "See all",
                        style: CPRTextStyles.smallHeaderNormalDarkBackground,
                      ),
              ),
            ],
          ),
          Expanded(
            child: Builder(
              builder: (context) {
                List<Widget> children;
                if (sessionProvider.userCoupons.isNotEmpty) {
                  children = sessionProvider.userCoupons.map((coupon) => CouponMiniCard(coupon)).toList();
                } else {
                  children = [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: const Center(
                        child: Text(
                          "No results found",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  ];
                }
                return ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.only(top: 10), children: children);
              },
            ),
          )
        ],
      ),
    );
  }
}

class CouponMiniCard extends StatelessWidget {
  CPRExternalPromotionCoupon coupon;

  CouponMiniCard(this.coupon);

  @override
  Widget build(BuildContext context) {
    var placesProvider = p.Provider.of<PlacesProvider>(context);
    var homeProvider = p.Provider.of<SessionProvider>(context, listen: false);

    return GestureDetector(
      onTap: () async {
        homeProvider.startLoading();
        try {
          var updatedPlace = await placesProvider.findPlace(coupon.placeId!);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  ExternalPromotionDetailPage(externalPromotion: coupon.externalPromotion!, place: updatedPlace!)));
          homeProvider.stopLoading();
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
          homeProvider.stopLoading();
        }
      },
      child: CouponCard(
        width: 240,
        height: 96,
        backgroundColor: Colors.white,
        clockwise: false,
        curvePosition: 105,
        curveRadius: 15,
        curveAxis: Axis.vertical,
        borderRadius: 10,
        firstChild: Container(
          color: Theme.of(context).accentColor.withGreen(10),
          child: Stack(
            children: [
              Container(
                child: coupon.externalPromotion?.pictureURL != null
                    ? ExtendedImage.network(
                        coupon.externalPromotion!.pictureURL!,
                        fit: BoxFit.cover,
                        cache: true,
                        height: 160,
                        width: 180,
                      )
                    : const SizedBox(),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
              Container(
                width: 240,
                height: 96,
                decoration: const BoxDecoration(color: Colors.black26),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      coupon.externalPromotion!.title!,
                      style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 12,color: Colors.white),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      CouponStatus.getName(coupon.status),
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16,color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        secondChild: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(coupon.couponCode!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
              GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => Center(
                              child: Container(
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                child: Material(
                                  type: MaterialType.transparency,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: QrImage(
                                            data: coupon.couponCode!,
                                            version: QrVersions.auto,
                                            size: 200,
                                            semanticsLabel: "Scan Me"),
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("Close", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ));
                  },
                  child: const Icon(Icons.qr_code))
            ],
          ),
        ),
      ),
    );
  }
}
