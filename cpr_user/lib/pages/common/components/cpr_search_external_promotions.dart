import 'package:cpr_user/models/business_external_promotion.dart';
import 'package:cpr_user/pages/common/components/cpr_header.dart';
import 'package:cpr_user/pages/common/components/cpr_separator.dart';
import 'package:cpr_user/pages/user/external_promotion_page/external_promotion_detail_page.dart';
import 'package:cpr_user/providers/places_provider.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart' as p;

class CPRSearchExternalPromotions extends StatefulWidget {
  // final Place place;
  final List<CPRBusinessExternalPromotion> externalPromotions;
  final String title;
  final String subtitle;

  // final CPRSearchType cprSearchType;
  CPRSearchExternalPromotions(
      {
        this.title: 'External Promotions',
        this.subtitle: 'List of all the External Promotions',
        required this.externalPromotions}) ;

  @override
  _CPRSearchExternalPromotionsState createState() => _CPRSearchExternalPromotionsState();
}

class _CPRSearchExternalPromotionsState<CPRBusinessExternalPromotion> extends State<CPRSearchExternalPromotions> {
  String filter = "";

  @override
  Widget build(BuildContext context) {
    var placesProvider = p.Provider.of<PlacesProvider>(context);
    var homeProvider = p.Provider.of<SessionProvider>(context, listen: false);

    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(color: Colors.black, boxShadow: [
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
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
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(bottom: 16),
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
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
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
                      "Showing ${widget.externalPromotions.where((element) => (element.description)!.contains(filter) || element.title!.contains(filter)).toList().length} results",
                      style: CPRTextStyles.cardSubtitle,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: widget.externalPromotions.where((element) => element.description!.contains(filter) || element.title!.contains(filter)) !=
                      null
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        var externalPromotion = widget.externalPromotions
                            .where((element) => element.description!.contains(filter) || element.title!.contains(filter))
                            .toList()[i];
                        return GestureDetector(
                          onTap: () async {
                            try {
                              var updatedPlace = await placesProvider.findPlace(externalPromotion.placeId!);
                              Navigator.of(context).push(new MaterialPageRoute(
                                  builder: (context) =>
                                      ExternalPromotionDetailPage(externalPromotion: externalPromotion, place: updatedPlace!)));
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 8, 16, 0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                                color: Colors.black,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white24,
                                    blurRadius: 2, // has the effect of softening the shadow
                                    spreadRadius: 1, // has the effect of extending the shadow
                                    offset: Offset(
                                      0, // horizontal, move right 10
                                      0, // vertical, m
                                    ),
                                  )
                                ]),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(0),
                                  child: Stack(
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                            height: 100,
                                            width: 150,
                                            child: ExtendedImage.network(
                                              externalPromotion.pictureURL!,
                                              fit: BoxFit.cover,
                                              cache: true,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(0.3),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
                                                color: Colors.white38),
                                            padding: EdgeInsets.all(16),
                                            height: 100,
                                            width: 150,
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 32),
                                              child: CountdownTimer(
                                                endTime: externalPromotion.endDate!.millisecondsSinceEpoch ,
                                                widgetBuilder: (_, time) {
                                                  if (time == null) {
                                                    return Text('Promotion Was End');
                                                  }
                                                  return Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                        children: [
                                                          Container(
                                                            width: 50,
                                                            child: Text(
                                                              '${time.days.toString().padLeft(2, "0")} days',
                                                              style: TextStyle(color: Colors.black, fontSize: 12),
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 50,
                                                            child: Text(
                                                              '${time.min.toString().padLeft(2, "0")} min',
                                                              style: TextStyle(color: Colors.black, fontSize: 12),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Expanded(
                                                        child: Text(""),
                                                      ),
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                          Container(
                                                            width: 50,
                                                            child: Text(
                                                              '${time.hours.toString().padLeft(2, "0")} hours',
                                                              style: TextStyle(color: Colors.black, fontSize: 12),
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 50,
                                                            child: Text(
                                                              '${time.sec.toString().padLeft(2, "0")} sec',
                                                              style: TextStyle(color: Colors.black, fontSize: 12),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Banner(
                                        message: externalPromotion.discount!.toStringAsFixed(2),
                                        location: BannerLocation.topStart,
                                        textStyle: TextStyle(fontSize: 16),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 100,
                                    padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          externalPromotion.title!,
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,color: Colors.white ),
                                          maxLines: 2,
                                          textAlign: TextAlign.start,
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          externalPromotion.description!,
                                          maxLines: 4,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(color: Colors.white ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: widget.externalPromotions
                          .where((element) => element.description!.contains(filter) || element.title!.contains(filter))
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
