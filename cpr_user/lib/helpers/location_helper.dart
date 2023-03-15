import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/constants/cpr_urls.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
// import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';

class LocationHelper {
  static Future<GeoPoint> userLocation() async {


    LocationPermission permission  = await Geolocator.requestPermission();
    Log.i( "userLocation() - permission: " + permission.toString() );

    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    Log.i( "userLocation() - position: " + position.toString() );
    return GeoPoint(position.latitude, position.longitude);
  }

  static Future<GeoPoint> lastKnownLocation() async {
    var position = await Geolocator.getLastKnownPosition(
        forceAndroidLocationManager: true);
    return GeoPoint(position!.latitude, position.longitude);
  }

  // static GeoFirePoint convertGeopointToGeoFireLocation(GeoPoint geo) {
  //   if (geo != null) {
  //     return Geoflutterfire()
  //         .point(latitude: geo.latitude, longitude: geo.longitude);
  //   }
  //   return null;
  // }

  static double _degreesToRadians(degrees) {
    return degrees * pi / 180;
  }

  static double distanceInKmBetweenEarthCoordinates(lat1, lon1, lat2, lon2) {
    var earthRadiusKm = 6371;

    var dLat = _degreesToRadians(lat2 - lat1);
    var dLon = _degreesToRadians(lon2 - lon1);

    lat1 = _degreesToRadians(lat1);
    lat2 = _degreesToRadians(lat2);

    var a = sin(dLat / 2) * sin(dLat / 2) +
        sin(dLon / 2) * sin(dLon / 2) * cos(lat1) * cos(lat2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusKm * c;
  }

  static String buildStaticMapUrl(GeoPoint currentLocation,
      {int width = 600, int height = 400, double zoom = 14}) {
    Uri finalUri = Uri();
    var baseUri = new Uri(
        scheme: 'https',
        host: 'maps.googleapis.com',
        port: 443,
        path: '/maps/api/staticmap',
        queryParameters: {});

    // the first case, which handles a user location but no markers
    if (currentLocation != null) {
      finalUri = baseUri.replace(queryParameters: {
        'center': '${currentLocation.latitude},${currentLocation.longitude}',
        'zoom': '20',
        'size': '${width}x$height',
        'markers': '${currentLocation.latitude},${currentLocation.longitude}',
        'key': '${PlacesAPI.googlePlacesKey}'
      });
    }
    // var url = finalUri.toString();

    return finalUri.toString();
  }
}
