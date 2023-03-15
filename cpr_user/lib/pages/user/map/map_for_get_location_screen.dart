import 'dart:async';
import 'package:cpr_user/theming/styles.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapForGetLocationScreen extends StatefulWidget {
  double lat = 0.0;
  double lon = 0.0;

  MapForGetLocationScreen(
    this.lat,
    this.lon,
  );

  @override
  _MapForGetLocationScreenState createState() => _MapForGetLocationScreenState();
}

class _MapForGetLocationScreenState extends State<MapForGetLocationScreen> {
  var currentLocation = LocationData;
  var location = new Location();
  LatLng? gg;
  bool getCurrentLocation = false;
  GoogleMapController? mapController;
  bool showProgress = false;
  bool enabled = true;

  _getLocation() async {
    location.onLocationChanged.listen((LocationData currentLocation) {
      if (!getCurrentLocation && mapController != null) {
        mapController!.moveCamera(CameraUpdate.newLatLng(LatLng(currentLocation.latitude!, currentLocation.longitude!)));
        gg = new LatLng(currentLocation.latitude!, currentLocation.longitude!);
        getCurrentLocation = true;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.lat != null) {
      if (!getCurrentLocation && mapController != null) {
        mapController!.moveCamera(CameraUpdate.newLatLng(LatLng(widget.lat, widget.lon)));
      }
    } else
      _getLocation();
  }

  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    Log.i( "page - MapForGetLocationScreen - build");

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          centerTitle: true,
          title: Text("Choose Location"),
        ),
        body: Stack(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: GoogleMap(
                  zoomGesturesEnabled: true,
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(widget.lat == 0 ? 51.5287718 : widget.lat, widget.lon == 0 ? 0.0384831 : widget.lon), zoom: 18.5),
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  mapToolbarEnabled: true,
                  indoorViewEnabled: true,
                  compassEnabled: true,
                  scrollGesturesEnabled: true,
                  tiltGesturesEnabled: true,
                  rotateGesturesEnabled: true,
                  onCameraMove: (camera) {
                    setState(() {
                      gg = camera.target;
                      print(gg!.longitude);
                    });
                  },
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    mapController = controller;
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 0.0),
                child: Icon(Icons.location_on, size: 35.0, color: Colors.red),
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30.0, right: 50.0, left: 50.0),
                  child: Container(
                    color: Colors.transparent,
                    height: 50.0,
                    child: Material(
                      color: Colors.blue,
                      elevation: 4.0,
                      borderRadius: BorderRadius.circular(15.0),
                      child: getButton(),
                    ),
                  ),
                )),
          ],
        ));
  }

  void showMessage(BuildContext context, message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 1500),
        content: Text(message),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  getButton() {
    /** - #abdo
        OutlineButton(
        onPressed: () async {
        if (gg != null && gg.latitude != null && gg.longitude != null) {
        Navigator.pop(context, [gg.latitude, gg.longitude]);
        } else {
        showMessage(context, "Please select a location first");
        }
        },
        shape: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Center(
        child: Text(
        "Confirm",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 17.0),
        )),
        )
     */
    return ElevatedButton(
      onPressed: () async {
        if (gg != null && gg!.latitude != null && gg!.longitude != null) {
          Navigator.pop(context, [gg!.latitude, gg!.longitude]);
        } else {
          showMessage(context, "Please select a location first");
        }
      },
      child: Center(
          child: Text(
            "Confirm",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 17.0),
          )),
    );
  }

}
