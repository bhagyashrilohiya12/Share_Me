import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

GoogleMapController? mapController;

class MapOnlyForShowWidget extends StatelessWidget {
  Completer<GoogleMapController> _controller = Completer();
  double lat = 0.0;
  double lon = 0.0;
  double opacity = 0.55;

  MapOnlyForShowWidget(this.lat, this.lon, {required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, right: 0.0, left: 0.0, bottom: 16.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(22)), color: Theme.of(context).primaryColorLight),
              margin: EdgeInsets.only(top: 8),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0, right: 2.0, left: 2.0, bottom: 2.0),
                    child: Container(
                      padding: EdgeInsets.all(0.0),
                      width: double.infinity,
                      height: 210.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                        child: Stack(
                          children: <Widget>[
                            Center(
                                child: Container(
                              child: GoogleMap(
                                mapType: MapType.normal,
                                zoomControlsEnabled: false,
                                initialCameraPosition: CameraPosition(target: LatLng(lat == 0.0 ? 51.5287718 : lat, lon == 0.0 ? 0.0384831 : lon), zoom: 15.2),
                                markers: {Marker(markerId: MarkerId(""), position: LatLng(lat == 0.0 ? 51.5287718 : lat, lon == 0.0 ? 0.0384831 : lon), icon: BitmapDescriptor.defaultMarker)},
                                onMapCreated: (GoogleMapController controller) {
                                  _controller.complete(controller);
                                  mapController = controller;
                                },
                              ),
                            )),
                            opacity != 0
                                ? Container(
                                    color: Theme.of(context).hintColor.withOpacity(0.55),
                                    padding: EdgeInsets.only(top: 32),
                                    child: Center(
                                        child: lat == 0.0
                                            ? Text(
                                                "Click to select a location",
                                                style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w600, color: Colors.black),
                                              )
                                            : SizedBox(
                                                width: 0,
                                                height: 0,
                                              )),
                                  )
                                : Container(color: Colors.transparent),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
