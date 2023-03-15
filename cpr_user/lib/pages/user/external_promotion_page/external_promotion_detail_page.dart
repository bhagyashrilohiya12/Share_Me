import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:cpr_user/constants/coupon_status.dart';
import 'package:cpr_user/helpers/other_helper.dart';
import 'package:cpr_user/models/business_external_promotion.dart';
import 'package:cpr_user/models/place.dart';
import 'package:cpr_user/pages/common/components/cpr_container.dart';
import 'package:cpr_user/pages/common/components/cpr_loading.dart';
import 'package:cpr_user/pages/common/components/location_card.dart';
import 'package:cpr_user/pages/user/places_details_page/components/cpr_rating.dart';
import 'package:cpr_user/pages/user/places_details_page/components/history_card.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:extended_image/extended_image.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart' as p;
import 'package:qr_flutter/qr_flutter.dart';

import '../../../helpers/string_helper.dart';
import '../../../models/external_promotion_coupon.dart';
import '../../../services/business_external_promotions_service.dart';
import '../../../services/external_promotions_coupon_service.dart';

class ExternalPromotionDetailPage extends StatefulWidget {
  final CPRBusinessExternalPromotion externalPromotion;
  final Place place;

  ExternalPromotionDetailPage({required this.externalPromotion, required this.place});

  @override
  _ExternalPromotionDetailPageState createState() => _ExternalPromotionDetailPageState();
}

class _ExternalPromotionDetailPageState extends State<ExternalPromotionDetailPage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  String? couponCode;
  bool getLastCouponCode = true;

  @override
  Widget build(BuildContext context) {
    Log.i("page - ExternalPromotionDetailPage - build");

    double width = MediaQuery.of(context).size.width * 0.45;
    //Reference not listing to refresh
    var provider = p.Provider.of<SessionProvider>(context, listen: false);

    if (getLastCouponCode) {
      getUserExternalPromotionCouponCode(widget.externalPromotion.documentID!, widget.externalPromotion.placeId!, provider.user!.email!);
    }
    return CPRContainer(
      loadingWidget: Builder(
        builder: (context) {
          var loadingProvider = p.Provider.of<SessionProvider>(context);
          return CPRLoading(
            loading: loadingProvider.busy,
          );
        },
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        key: scaffoldKey,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height / 1.82,
                decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: ExtendedNetworkImageProvider(
                        OtherHelper.findPhotoReference(size: 1024, photoRef: widget.place.firstGooglePhotoReference ?? ""),
                        cache: true),
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(top: 100),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: width,
                        child: Material(
                          borderRadius: BorderRadius.circular(10),
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                widget.place.name ?? "",
                                style: CPRTextStyles.clickPickReviewStyle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    CPRRating(widget.place),
//                    p.Consumer<SessionProvider>(
//                      builder: (context, userProvider, _) {
//                        if (widget.place.documentId == null) {
//                          return Container();
//                        }
//                        bool isInSaveForLater = userProvider.isInCategory(widget.place, MainCategory.saveForLaterPlaces);
//                        bool inInFavorites = userProvider.isInCategory(widget.place, MainCategory.myFavoritePlaces);
//
//                        return Padding(
//                          padding: const EdgeInsets.all(8.0),
//                          child: Row(
//                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                            children: <Widget>[
//                              Container(
//                                width: width,
//                                child: GestureDetector(
//                                  onTap: () async {
//                                    homeProvider.startLoading();
//                                    try {
//                                      if (!inInFavorites) {
//                                        await userProvider.addToCategory(widget.place, MainCategory.myFavoritePlaces);
//                                      } else {
//                                        await userProvider.removeFromCategory(widget.place, MainCategory.myFavoritePlaces);
//                                      }
//                                    } catch (e) {}
//
//                                    homeProvider.stopLoading();
//                                  },
//                                  child: Material(
//                                    color: CPRColors.cprButtonGreen,
//                                    borderRadius: BorderRadius.circular(CPRDimensions.miniButtonRadio),
//                                    child: Container(
//                                      padding: EdgeInsets.symmetric(vertical: 12),
//                                      child: Center(
//                                        child: Text(
//                                          "${inInFavorites ? 'Remove from Favorites' : 'Add to Favorites'}",
//                                          style: CPRTextStyles.buttonSmallWhite,
//                                        ),
//                                      ),
//                                    ),
//                                  ),
//                                ),
//                              ),
//                              Container(
//                                width: width,
//                                child: GestureDetector(
//                                  onTap: () async {
//                                    homeProvider.startLoading();
//                                    try {
//                                      if (!isInSaveForLater) {
//                                        await userProvider.addToCategory(widget.place, MainCategory.saveForLaterPlaces);
//                                      } else {
//                                        await userProvider.removeFromCategory(widget.place, MainCategory.saveForLaterPlaces);
//                                      }
//                                    } catch (e) {}
//
//                                    homeProvider.stopLoading();
//                                  },
//                                  child: Material(
//                                    color: CPRColors.cprButtonPink,
//                                    borderRadius: BorderRadius.circular(CPRDimensions.miniButtonRadio),
//                                    child: Container(
//                                      padding: EdgeInsets.symmetric(vertical: 12),
//                                      child: Center(
//                                        child: Text(
//                                          "${isInSaveForLater ? 'Remove from Save For Later' : 'Add to Save For Later'}",
//                                          style: CPRTextStyles.buttonSmallWhite.copyWith(fontWeight: FontWeight.bold),
//                                        ),
//                                      ),
//                                    ),
//                                  ),
//                                ),
//                              ),
//                            ],
//                          ),
//                        );
//                      },
//                    ),

                    Container(
                      // color: color,
                      margin: EdgeInsets.only(
                          right: CPRDimensions.homeMarginBetweenCard, left: CPRDimensions.homeMarginBetweenCard, bottom: 16, top: 16),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                      width: (MediaQuery.of(context).size.width - 20),
                      child: Column(children: <Widget>[
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
                              child: Container(
                                height: (MediaQuery.of(context).size.width - 20) / 2,
                                width: (MediaQuery.of(context).size.width - 20),
                                child: ExtendedImage.network(
                                  widget.externalPromotion.pictureURL!,
                                  fit: BoxFit.cover,
                                  cache: true,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
                                    color: Colors.black38),
                                padding: EdgeInsets.all(16),
                                height: (MediaQuery.of(context).size.width - 20) / 2,
                                width: (MediaQuery.of(context).size.width - 20),
                                child: Column(
                                  children: [
                                    CountdownTimer(
                                      endTime: widget.externalPromotion.endDate!.millisecondsSinceEpoch,
                                      widgetBuilder: (_, time) {
                                        if (time == null) {
                                          return Text(
                                            'Promotion Was End!',
                                            style: TextStyle(color: Colors.white),
                                          );
                                        }
                                        return Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  width: 120,
                                                  child: Text(
                                                    '${time.days.toString().padLeft(2, "0")} days',
                                                    style: TextStyle(color: Colors.white, fontSize: 30),
                                                  ),
                                                ),
                                                Container(
                                                  width: 120,
                                                  child: Text(
                                                    '${time.min.toString().padLeft(2, "0")} min',
                                                    style: const TextStyle(color: Colors.white, fontSize: 30),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Expanded(
                                              child: Text(""),
                                            ),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  width: 120,
                                                  child: Text(
                                                    '${time.hours.toString().padLeft(2, "0")} hours',
                                                    style: TextStyle(color: Colors.white, fontSize: 30),
                                                  ),
                                                ),
                                                Container(
                                                  width: 120,
                                                  child: Text(
                                                    '${time.sec.toString().padLeft(2, "0")} sec',
                                                    style: TextStyle(color: Colors.white, fontSize: 30),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                                      child: Text(
                                        (widget.externalPromotion.discount ?? "").toString() + "%",
                                        style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(16, 6, 16, 8),
                          child: Text(
                            widget.externalPromotion.title ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(16, 6, 16, 8),
                          child: Center(
                            child: Text(
                              widget.externalPromotion.description ?? "",
                              maxLines: 7,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
                                child: Text(
                                  "Start Date : " +
                                      (widget.externalPromotion.startDate != null
                                          ? new DateFormat('yyyy-MM-dd').format(widget.externalPromotion.startDate!)
                                          : ""),
                                  maxLines: 1,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const Expanded(
                                child: Text(""),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 8, 16, 8),
                                child: Text(
                                  "End Date : " +
                                      (widget.externalPromotion.endDate != null
                                          ? new DateFormat('yyyy-MM-dd').format(widget.externalPromotion.endDate!)
                                          : ""),
                                  maxLines: 1,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ),

                    if (couponCode == null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () async {
                            if (widget.externalPromotion.remainedQuantity != null && (widget.externalPromotion.remainedQuantity ?? 0) > 0) {
                              setState(() {
                                widget.externalPromotion.remainedQuantity = widget.externalPromotion.remainedQuantity! - 1;
                              });
                              await _generateCoupon(widget.externalPromotion.placeId, widget.externalPromotion, provider.user?.email);
                            } else {
                              ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(const SnackBar(
                                content: Text("The quantity of this coupon is zero"),
                                duration: Duration(seconds: 1),
                              ));
                            }
                          },
                          child: CouponCard(
                            height: 100,
                            backgroundColor: Colors.white,
                            clockwise: false,
                            curvePosition: 165,
                            curveRadius: 15,
                            curveAxis: Axis.vertical,
                            borderRadius: 10,
                            firstChild: Container(
                              height: 100,
                              color: Theme.of(context).accentColor.withGreen(10),
                              child: const Center(
                                child: Text("Click Here", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
                              ),
                            ),
                            secondChild: Container(
                                height: 100,
                                color: Theme.of(context).accentColor.withGreen(10),
                                child: const Center(
                                  child: Text("To Create A Coupon", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
                                ),
                            ),
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CouponCard(
                          height: 100,
                          backgroundColor: Colors.white,
                          clockwise: false,
                          curvePosition: 165,
                          curveRadius: 15,
                          curveAxis: Axis.vertical,
                          borderRadius: 10,
                          firstChild: Container(
                            height: 100,
                            color: Theme.of(context).accentColor.withGreen(10),
                            child: const Center(
                              child: Text("Your Coupon Code Is", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
                            ),
                          ),
                          secondChild: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(couponCode!, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
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
                                                              data: couponCode!,
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
                                                              child: Text("Close",
                                                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ));
                                    },
                                    child: Icon(Icons.qr_code))
                              ],
                            ),
                          ),
                        ),
                      ),
                    HistoryCard(
                      place: widget.place,
                      usePromotion: true,
                    ),
                    LocationCard(userLocation: provider.currentLocation!, place: widget.place, context: context, width: width),
                  ],
                ),
              ),
            ),
            _buildBackButton()
          ],
        ),
      ),
    );
  }

  Positioned _buildBackButton() {
    return Positioned(
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
    );
  }

  Future<void> getUserExternalPromotionCouponCode(String promotionId, String placeId, String userId) async {
    ExternalPromotionsCouponService externalPromotionsCouponService = ExternalPromotionsCouponService();
    CPRExternalPromotionCoupon? cPRExternalPromotionCoupon =
        await externalPromotionsCouponService.getUserExternalPromotionCouponCode(promotionId, placeId, userId);
    setState(() {
      if (cPRExternalPromotionCoupon != null) {
        couponCode = cPRExternalPromotionCoupon.couponCode;
      } else {
        couponCode = null;
      }
      getLastCouponCode = false;
    });
  }

  Future<void> _generateCoupon(placeId, CPRBusinessExternalPromotion promotion, userId) async {
    String cCode = getRandomCouponCode();
    BusinessExternalPromotionsService businessExternalPromotionsService = BusinessExternalPromotionsService();
    ExternalPromotionsCouponService externalPromotionsCouponService = ExternalPromotionsCouponService();
    await businessExternalPromotionsService.updateExternalPromotion(promotion.documentID!, promotion, null).then((value) async {
      await externalPromotionsCouponService
          .addExternalPromotionCoupon(
              CPRExternalPromotionCoupon(placeId: placeId, promotionId: promotion.documentID, userId: userId, couponCode: cCode,status: CouponStatus.virgin))
          .then((value) {
        setState(() {
          couponCode = cCode;
        });
      });
    });
  }
}
