import 'package:cpr_user/constants/cpr_urls.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

class OtherHelper {
  static String findPhotoReference({String? photoRef, int size = 130}) {
    String photoReferenceUrl =
        "${PlacesAPI.googlePhotoReferenceUrl}?key=${PlacesAPI.googlePlacesKey}&photoreference=$photoRef&maxwidth=$size";
    return photoReferenceUrl;
  }

  static String getPlataform(BuildContext context) {
    return "";
  }

  static String getUUID() {
    return Uuid().v4();
  }
}
