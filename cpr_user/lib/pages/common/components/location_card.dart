import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/helpers/launcher_helper.dart';
import 'package:cpr_user/helpers/location_helper.dart';
import 'package:cpr_user/helpers/number_helper.dart';
import 'package:cpr_user/models/place.dart';
import 'package:cpr_user/pages/common/components/cpr_button.dart';
import 'package:cpr_user/pages/common/components/cpr_card.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:maps_launcher/maps_launcher.dart';

class LocationCard extends StatelessWidget {

  final Place? place;
  final BuildContext context;
  final double width;
  final GeoPoint? userLocation;


  LocationCard({

    required this.place,
    required this.context,
    required this.width,
    this.userLocation,
  })  ;


  @override
  Widget build(BuildContext context) {
    GeoPoint? point = place?.coordinate;
    if (place?.location != null) {
      try {
        point = place?.location!["geopoint"] ;
      } catch (e) {
        point = place?.location!["geopoint"] != null
            ? new GeoPoint(place?.location!["geopoint"]['_latitude'], place?.location!["geopoint"]['_longitude'])
            : null;
      }

    }
    return CPRCard(
      // height: 390 ,
      // halfScreenHeight: false,
      title: Text(
        "Directions",
        style: CPRTextStyles.cardTitleBlack,
      ),
      subtitle: Text(
        "${place?.address}",
        style: CPRTextStyles.cardSubtitleBlack,
      ),
      backgroundColor: Colors.white,
      iconOnClick: (){
        if(Platform.isAndroid){
          LauncherHelper.openGoogleMaps(place!.coordinate!);
        }if(Platform.isIOS){
          LauncherHelper.openAppleMaps(place!.coordinate! );
        }
      },
      icon: MaterialCommunityIcons.compass,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: ExtendedImage.network(
                    LocationHelper.buildStaticMapUrl( place!.coordinate!,  //point ?? //#abdo
                        zoom: 4),
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
          Builder(
            builder: (context) {
              var distance;
              try {
                distance = LocationHelper.distanceInKmBetweenEarthCoordinates(
                    userLocation?.latitude,
                    userLocation?.longitude,
                    point?.latitude,
                    point?.longitude);
                distance /= 1.60934;
                print("Distance $point");
              } catch (e) {}
              return Container(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(distance != null
                    ? "You are ${NumberHelper.formattedDistance(distance)} miles away from this location"
                    : 'Distance not available'),
              );
            },
          )
        ],
      ),
      footer: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              // Expanded(
              //   flex: 8,
              //   child: Container(
              //     // padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              //     child: CPRButton(
              //       color: CPRColors.cprButtonPink,
              //       onPressed: () {
              //         MapsLauncher.launchCoordinates(place.coordinate.latitude, place.coordinate.longitude);
              //         // LauncherHelper.openAppleMaps(place.coordinate);
              //       },
              //       // width: width * 0.9,
              //       horizontalPadding: 0,
              //       verticalPadding: 0,
              //       borderRadius: 10,
              //       height: 50,
              //       child: Text(
              //         "View on Maps",
              //         style: CPRTextStyles.buttonMediumWhite,
              //       ),
              //     ),
              //   ),
              // ),
              // Expanded(
              //   flex: 1,
              //   child: Container(),
              // ),
              Expanded(
                flex: 8,
                child: Container(
                  child: CPRButton(
                    color: CPRColors.cprButtonGreen,
                    height: 50,
                    borderRadius: 10,
                    verticalPadding: 0,
                    horizontalPadding: 0,
                    onPressed: () {
                      MapsLauncher.launchCoordinates(place!.coordinate!.latitude , place!.coordinate!.longitude );
                      // LauncherHelper.openGoogleMaps(place.coordinate);
                    },
                    child: Text(
                      Platform.isIOS?"View on Maps":"View on Google Maps",
                      style: CPRTextStyles.buttonMediumWhite,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
