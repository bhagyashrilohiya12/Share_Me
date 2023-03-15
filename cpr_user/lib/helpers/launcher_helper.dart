import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class LauncherHelper {
  static void openGoogleMaps(GeoPoint location) async {
    String url =
        "https://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Unable to open in Google Maps';
    }
  }

  static void openAppleMaps(GeoPoint location) async {
    String url =
        'https://maps.apple.com/?sll=${location.latitude},${location.longitude}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Unable to open in Apple Maps';
    }
  }

  static void launchURL(String url) async {
    Uri uri = Uri.parse( url );

    bool can = await canLaunchUrl(uri);
    if(can) {
      await launchUrl(uri);
      // print(url);
    }
    /**
        else
        throw 'Could not launch $url';
     */
  }

  //-------------------------------------------------------------------------- call phone

  static Future call(String phone) async {
    String link = "tel://" +  phone;
    Uri uri = Uri.parse( link );
    var status = await launchUrl(uri );
    return status;
  }


}
