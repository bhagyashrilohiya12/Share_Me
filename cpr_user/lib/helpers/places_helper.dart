import 'package:cpr_user/constants/cpr_urls.dart';
import 'package:dio/dio.dart';

class PlacesHelper {
  static Future<Map<String, dynamic>> findPlaceDetailsByPlaceID(
      String placeId) async {
    var url = PlacesAPI.googlePlaceDetailsUrl
        .replaceFirst("GOOGLE_PLACE_ID", placeId)
        .replaceFirst("GOOGLE_PLACE_API_KEY", PlacesAPI.googlePlacesKey);
    var result = await Dio().get(url);
    return result.data;
  }
}