import 'dart:async';
import 'package:cpr_user/constants/cpr_urls.dart';
import 'package:cpr_user/pages/common/components/cpr_login_text_form_field.dart';
import 'package:cpr_user/pages/user/my_locations/my_locations_page.dart';
import 'package:cpr_user/resource/WaitTools.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:geoflutterfire/geoflutterfire.dart' hide Coordinates;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:location/location.dart';
// import 'package:geocoder/geocoder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/Widgets/dialog_delete_my_location.dart';
import 'package:cpr_user/models/my_location.dart';
import 'package:cpr_user/models/user.dart';
import 'package:cpr_user/pages/user/get_location/get_location_page.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:cpr_user/services/my_locations_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart' as p;

import 'package:geocoding/geocoding.dart';
import 'package:geocoder2/geocoder2.dart';

import 'package:location/location.dart' as local;

class GetLocationPage extends StatefulWidget {
  // double? lat;
  // double? lon;
  //
  // GetLocationPage(this.lat,
  //     this.lon,);

  @override
  _GetLocationPageState createState() => _GetLocationPageState();
}

class _GetLocationPageState extends State<GetLocationPage> {
  var currentLocation = LocationData;
  var location = local.Location();
  LatLng? latLng;
  bool getCurrentLocation = false;
  GoogleMapController? mapController;

  CPRUser? loginedUser;
  bool showProgressAddNewLocation = false;
  late SessionProvider sessionProvider;

  var _addressController = TextEditingController();

  _getCurrentLocationListener() async {
    location.onLocationChanged.listen((LocationData currentLocation) {
      if (getCurrentLocation == false) {
        getCurrentLocation = true; //avoid
        Log.i("_getLocation() - getCurrentLocation " +
            getCurrentLocation.toString());
        Log.i("_getLocation() - location.onLocationChanged - currentLocation " +
            currentLocation.latitude!.toString());

        zoomMapCamera(currentLocation.latitude!, currentLocation.longitude!);

        // mapController!.moveCamera(CameraUpdate.newLatLng(
        //     LatLng(currentLocation.latitude!, currentLocation.longitude! ) ));
        //
        //set current lat lng
        latLng =
        new LatLng(currentLocation.latitude!, currentLocation.longitude!);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // if (widget.lat != null) {
    //
    // } else

    // if (!getCurrentLocation && mapController != null) {
    //   mapController!.moveCamera(CameraUpdate.newLatLng(LatLng(widget.lat, widget.lon)));
    // }

  }

  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    Log.i( "page - GetLocationPage - build");

    sessionProvider = p.Provider.of<SessionProvider>(context, listen: false);
    if (loginedUser == null) {
      setState(() {
        loginedUser = sessionProvider.user;
      });
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Get.theme.accentColor,
          centerTitle: true,
          title: Text("Select Location"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => MyLocationsPage()));
                },
                icon: Icon(Icons.history))
          ],
        ),


        body: Stack(
          children: <Widget>[

            //----------------------------------- map

            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: googleMapView(),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 0.0),
                child: Icon(Icons.location_on,
                    size: 35.0, color: Get.theme.accentColor),
              ),
            ),

            //--------------------------------------------------- center bottom
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(64, 0, 64, 16),
                child: buttonConfirm(),
              ),
            ),
            Align(
                alignment: Alignment.topCenter,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          CPRDimensions.loginTextFieldRadius),
                      color: Colors.white
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: searchFieldPlaceView(),
                )),
          ],
        ));
  }





  void zoomMapCamera(double latitude, double longitude) {
    if (mapController == null) {
      Log.i("zoomMapCamera() - mapController == null - stop");
      return;
    }
    mapController!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(latLng!.latitude, latLng!.longitude),
        zoom: 17.0)));
  }

  Widget googleMapView() {
    Log.i("googleMapView() - start ");
    return GoogleMap(
      zoomGesturesEnabled: true,
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
          target: getTargetDefault(),
          zoom: 10.0),
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
          latLng = camera.target;
          if (latLng == null) return;
         // print(latLng!.longitude);
        });
      },
      onMapCreated: (GoogleMapController controller) {
        Log.i("googleMapView() - GoogleMapController controller " +
            controller.toString());
        _controller.complete(controller);
        mapController = controller;

        //wait for see data of maps to avoid crash
        /**
            W/MobStoreFlagStore(19114): java.util.concurrent.ExecutionException: java.lang.SecurityException: GoogleCertificatesRslt: not allowed: pkg=com.maranta4.cpr_user, sha256=[63499e05905aaeeab5a7733e24fb3c9a17f79cb6571d503fa18dd36fd2ef2935], atk=false, ver=222413022.true (go/gsrlt)
         */
        ToolsWait.waitToDo(300, () {
          //first time go to location current
          _getCurrentLocationListener();
        });
      },
    );
  }

  LatLng getTargetDefault() {
    /**
     * #Abdo
        return LatLng(
        (widget.lat == 0 || widget.lat == null)
        ? 51.5287718
        : widget.lat,
        (widget.lon == 0 || widget.lon == null)
        ? -0.2416802
        : widget.lon);
     *    */
    return LatLng(51.5287718, -0.2416802);
  }

  //--------------------------------------------------------------------- suggest search

  Widget searchFieldPlaceView() {
    return TypeAheadFormField(
      suggestionsBoxVerticalOffset: 0,
      textFieldConfiguration: TextFieldConfiguration(
          controller: _addressController,
          autofocus: false,
          decoration: InputDecoration(
            suffixIcon: Icon(
              Icons.place,
              color: Colors.black,
            ),
            hintText: "Address",
            hintStyle: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w100),
            labelStyle: TextStyle(color: Colors.black),
            helperStyle: TextStyle(color: Colors.black),
            contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                  CPRDimensions.loginTextFieldRadius),
              borderSide: BorderSide(color: Colors.black, width: 0.5),
            ),
          )),
      suggestionsCallback: (pattern) async {
        /**
         * download data suggested here
         */
        if (pattern.isNotEmpty)
          return await getPlaces(pattern);
        else
          return [];
      },
      itemBuilder: (context, suggestion) {

        int sizeSuggested = suggestedPlaces.length.toInt();
        Log.i( "itemBuilder - indexBuilder: " + indexBuilder.toString() + " /sizeSuggested: " + sizeSuggested.toString()  );

        if( sizeSuggested > indexBuilder ) {
          var title = suggestedPlaces[indexBuilder].description!;
          indexBuilder = indexBuilder + 1;
          return ListTile(
            leading: Icon(Icons.place),
            title: Text(
              title,
              // suggestion.addressLine ?? "",
              maxLines: 1,
            ),
            // subtitle: Text(
            //   suggestion.postalCode ?? "",
            //   maxLines: 1,
            // ),
          );
        } else {

          //progress view
          String msg = "\t\tloading";
          return TextTemplate.t( msg,
              height: 30,
              dimen: 14,
              textAlign: TextAlign.start,
              color: Colors.black,
              padding: EdgeInsets.all(5)
          );
        }



      },
      onSuggestionSelected: (suggestion) async {
        Log.i("TypeAheadFormField - onSuggestionSelected - suggestion: " +
            suggestion.toString());
        AutocompletePrediction valueSelected = suggestion as AutocompletePrediction;
        Log.i("TypeAheadFormField - onSuggestionSelected - valueSelected: " +
            valueSelected.description.toString());

        GeoData dataGeoCoder = await Geocoder2.getDataFromAddress(
            address: valueSelected.description ?? "",
            googleMapApiKey: PlacesAPI.googlePlacesKey);


        setState(() {
          //   latLng
          /**
           * #abdo-delay
           *
           *       latLng = LatLng(suggestion.coordinates.latitude,suggestion.coordinates.longitude);
              print(latLng.longitude);
           */
          latLng = LatLng(dataGeoCoder.latitude, dataGeoCoder.longitude);
          Log.i("TypeAheadFormField - onSuggestionSelected - latLng: " +
              latLng.toString());

          zoomMapCamera(latLng!.latitude, latLng!.longitude);
        });
      },
      keepSuggestionsOnSuggestionSelected: false,
      hideSuggestionsOnKeyboardHide: false,
    );
  }


  int indexBuilder = 0;

  /**
   * Abdallah document :
   *
   *  this class "AutocompletePrediction" return from plugin "GooglePlace"
   */
  List<AutocompletePrediction> suggestedPlaces = [];

  Future<List<AutocompletePrediction>> getPlaces(String text) async {
    suggestedPlaces = [];
    indexBuilder = 0 ;

    try {
      var googlePlace = GooglePlace(PlacesAPI.googlePlacesKey);
      AutocompleteResponse? res = await googlePlace.autocomplete.get(text);
      if (res != null) suggestedPlaces = res.predictions!;
    } catch (e) {
      print(e);
    }
    Log.i("getPlaces - suggestion: " + suggestedPlaces.length.toString());
    //log for test
    suggestedPlaces.forEach((element) {
      Log.i( "getPlaces() - loop: " + element.description.toString() );
    });
    return suggestedPlaces;
  }

  //------------------------------------------------------------------------ confirm button

  buttonConfirm() {
    return ButtonTemplate.t("Confirm", () async {
      await _confirmClick();
    },
        background: Get.theme.accentColor,
        borderRadius: 15,
        textDimen: 17,
      width: 200,
      height: 50
    );
  }

  _confirmClick() async {
    if (!showProgressAddNewLocation &&
        latLng != null &&
        latLng!.latitude != null &&
        latLng!.longitude != null) {

      // progress
      setState(() {
        showProgressAddNewLocation = true;
      });

      /** - #abdo
       *
          final coordinates = new Coordinates(
          latLng.latitude, latLng.longitude);


          var addresses = await Geocoder.local
          .findAddressesFromCoordinates(coordinates);

          var address = addresses.first.subAdminArea +
          " | " +
          addresses.first.featureName;
       *
       */

      GeoData geoData = await Geocoder2.getDataFromCoordinates(
          latitude: latLng!.latitude,
          longitude: latLng!.longitude,
          googleMapApiKey: PlacesAPI.googlePlacesKey);

      var address = geoData.address;

      CPRMyLocation cprMyLocation = new CPRMyLocation(
          lat: latLng!.latitude,
          lon: latLng!.longitude,
          title: address,
          userId: loginedUser!.email!);
      addNewLocationForUser(cprMyLocation);


    } else {
      Get.snackbar('Error', 'Please select a location',
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
          backgroundColor: Colors.red);
    }
  }

  addNewLocationForUser(CPRMyLocation location) async {
    MyLocationsService myLocationsService = new MyLocationsService();
    CPRMyLocation? myLocationsTemp = await myLocationsService
        .addNewLocationForUser(location);
    setState(() {
      showProgressAddNewLocation = false;
    });
    if (myLocationsTemp != null) {
      Get.snackbar("Success", "Location was Changed");

      //
      Future.delayed(Duration(seconds: 4), () async {
        sessionProvider.currentLocation = new GeoPoint(myLocationsTemp.lat!, myLocationsTemp.lon!);
        await sessionProvider.loadCategorizedPlaces();
        Navigator.pop(context);
      });
    }
  }


}

/**
    Container(
    color: Get.theme.accentColor, //Colors.transparent,
    height: 50.0,
    child: Material(
    color: Get.theme.accentColor,
    elevation: 4.0,
    borderRadius: BorderRadius.circular(15.0),

    /**
 * - #abdo
 * OutlineButton(
    */
    child: RaisedButton(
    onPressed: () async {
    if (!showProgressAddNewLocation) if (latLng != null &&
    latLng!.latitude != null &&
    latLng!.longitude != null) {
    setState(() {
    showProgressAddNewLocation = true;
    });

    /** - #abdo
 *
    final coordinates = new Coordinates(
    latLng.latitude, latLng.longitude);


    var addresses = await Geocoder.local
    .findAddressesFromCoordinates(coordinates);

    var address = addresses.first.subAdminArea +
    " | " +
    addresses.first.featureName;
 *
    */

    GeoData geoData = await Geocoder2.getDataFromCoordinates(
    latitude: latLng!.latitude,
    longitude: latLng!.longitude,
    googleMapApiKey: PlacesAPI .googlePlacesKey );

    var address = geoData.address;

    CPRMyLocation cprMyLocation = new CPRMyLocation(
    lat: latLng!.latitude,
    lon: latLng!.longitude,
    title: address,
    userId: loginedUser!.email!);
    addNewLocationForUser(cprMyLocation);
    } else {
    Get.snackbar('Error', 'Please select a location',
    snackPosition: SnackPosition.BOTTOM,
    margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
    backgroundColor: Colors.red);
    }
    },

    //line boarder
    shape: OutlineInputBorder(
    borderRadius: BorderRadius.circular(15.0)),
    child: Center(
    child: showProgressAddNewLocation
    ? SpinKitThreeBounce(
    color: Colors.white,
    size: 16,
    )
    : Text(
    "Confirm",
    style: TextStyle(
    backgroundColor: Get.theme.accentColor,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    fontSize: 17.0),
    )),
    ),
    ),
    )
 */

// List<GeoData> suggestedPlaces = [];
//
// Future<List<GeoData>> getPlaces(String address) async {
//   // List<Address> suggestedPlaces = [];
//   /**
//    * old code comment by
//    * - #abdo
//       try {
//       List<Placemark> res = await Geocoder.local.findAddressesFromQuery(address);
//       // List<Address> res = await Geocoder.google(PlacesAPI.googlePlacesKey).findAddressesFromQuery(address);
//       if (res != null) suggestedPlaces = res;
//       } catch (e) {
//       print(e);
//       }
//
//       List<Location> locations = await locationFromAddress("Gronausestraat 710, Enschede");
//
//    */
//
//   GeoData geoData = await Geocoder2.getDataFromAddress(
//       address: address,
//       googleMapApiKey: PlacesAPI .googlePlacesKey );
//
//   suggestedPlaces = geoData.address;
//
//   return suggestedPlaces;
// }