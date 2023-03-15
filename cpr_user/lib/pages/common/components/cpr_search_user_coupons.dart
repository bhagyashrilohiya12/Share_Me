import 'package:cpr_user/models/business_external_promotion.dart';
import 'package:cpr_user/models/external_promotion_coupon.dart';
import 'package:cpr_user/pages/common/components/cpr_header.dart';
import 'package:cpr_user/pages/common/components/cpr_separator.dart';
import 'package:cpr_user/pages/user/external_promotion_page/external_promotion_detail_page.dart';
import 'package:cpr_user/providers/places_provider.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart' as p;
import 'package:ribbon/ribbon.dart';

class CPRSearchUserCoupons extends StatefulWidget {
  // final Place place;
  final List<CPRExternalPromotionCoupon> coupons;
  final String title;
  final String subtitle;

  // final CPRSearchType cprSearchType;
  const CPRSearchUserCoupons(
      {super.key,
        this.title = 'External Promotions',
        this.subtitle = 'List of all the External Promotions',
        required this.coupons}) ;

  @override
  _CPRSearchUserCouponsState createState() => _CPRSearchUserCouponsState();
}

class _CPRSearchUserCouponsState<CPRBusinessExternalPromotion> extends State<CPRSearchUserCoupons> {
  String filter = "";

  @override
  Widget build(BuildContext context) {
    var placesProvider = p.Provider.of<PlacesProvider>(context);
    var homeProvider = p.Provider.of<SessionProvider>(context, listen: false);

    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(color: Colors.black, boxShadow: [
        BoxShadow(
          color: Colors.black,
          blurRadius: 8, // has the effect of softening the shadow
          spreadRadius: 1, // has the effect of extending the shadow
          offset: Offset(
            8, // horizontal, move right 10
            8, // vertical, m
          ),
        )
      ]),
      child: Material(
        elevation: 16,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        color: Colors.black,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CPRHeader(
                height: 64,
                title: Text(
                  widget.title,
                  style: CPRTextStyles.cardTitle.copyWith(fontSize: 12),
                ),
                subtitle: Text(widget.subtitle, style: CPRTextStyles.cardSubtitle.copyWith(fontSize: 10)),
                icon: MaterialCommunityIcons.compass,
              ),
            ),
            CPRSeparator(),
            Container(
              height: 56,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        decoration: CPRInputDecorations.cprFilter,
                        onChanged: (string) {
                          setState(() {
                            filter = string;
                          });
                        },
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Icon(Icons.sort),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    child: Text(
                      "Showing ${widget.coupons.where((element) => (element.couponCode)!.contains(filter)).toList().length} results",
                      style: CPRTextStyles.cardSubtitle,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: widget.coupons.where((element) => element.couponCode!.contains(filter)) !=
                      null
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        var coupon = widget.coupons
                            .where((element) => element.couponCode!.contains(filter))
                            .toList()[i];
                        return GestureDetector(
                          onTap: () async {
                            try {
                              var updatedPlace = await placesProvider.findPlace(coupon.placeId!);
                              //todo when click on coupon
                            } catch (e) {
                              if (kDebugMode) {
                                print(e);
                              }
                            }
                          },
                          child: Container(
                            // color: color,
                            margin: const EdgeInsets.only(right: CPRDimensions.homeMarginBetweenCard, bottom: 16),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                            width: 180,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              child: Ribbon(
                                nearLength: 44,
                                farLength: 68,
                                title: coupon.status.toString(),
                                titleStyle: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                color: const Color(0xffa22664),
                                location: RibbonLocation.topStart,
                                child: SizedBox(
                                    height: 90,
                                    width: 180,
                                    child: Text(coupon.couponCode!)
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: widget.coupons
                          .where((element) => element.couponCode!.contains(filter))
                          .toList()
                          .length,
                    )
                  : Text("Noting Found"),
            ),
          ],
        ),
      ),
    );
  }
}
