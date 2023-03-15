import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/Widgets/dialog_delete_my_location.dart';
import 'package:cpr_user/models/my_location.dart';
import 'package:cpr_user/models/user.dart';
import 'package:cpr_user/pages/user/get_location/get_location_page.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:cpr_user/services/my_locations_service.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart' as p;

class MyLocationsPage extends StatefulWidget {
  // const MyLocationsPage({Key key}) : super(key: key);

  @override
  _MyLocationsPageState createState() => _MyLocationsPageState();
}

class _MyLocationsPageState extends State<MyLocationsPage> {
  List<CPRMyLocation>? myLocations;
  CPRUser? loginedUser;
  bool showProgressAddNewLocation = false;
  late SessionProvider sessionProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Log.i( "page - MyLocationsPage - build");

    sessionProvider = p.Provider.of<SessionProvider>(context, listen: false);
    if (loginedUser == null) {
      setState(() {
        loginedUser = sessionProvider.user;
      });
      if (myLocations == null) getMyLocations(loginedUser!);
    }

    return Scaffold(
      body: Column(
        children: [
          Container(
            width: Get.width,
            height: 48,
            margin: EdgeInsets.only(top: 24),
            child: Center(
              child: Text(
                "My Recent Locations",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: myLocations != null
                    ? myLocations!.isNotEmpty
                        ? ListView.builder(
                            itemBuilder: (context, i) {
                              return GestureDetector(
                                onTap: () {
                                  sessionProvider.currentLocation =
                                      new GeoPoint(myLocations![i].lat!,
                                          myLocations![i].lon!);
                                  setState(() {});
                                  Get.snackbar(
                                      "Success", "Location was Changed");
                                  Future.delayed(Duration(seconds: 4),
                                      () async {
                                    await sessionProvider
                                        .loadCategorizedPlaces();
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  });
                                },
                                child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                                    height: 42,
                                    width: Get.width,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: (sessionProvider.currentLocation!
                                                        .latitude ==
                                                    myLocations![i].lat &&
                                                sessionProvider.currentLocation!.longitude ==
                                                    myLocations![i].lon)
                                            ? Get.theme.accentColor
                                            : Colors.grey.shade300),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 16,
                                        ),
                                        Expanded(
                                            child: Text(
                                          myLocations![i].title!,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14),
                                        )),
                                        // SizedBox(
                                        //   width: 16,
                                        // ),
                                        // GestureDetector(
                                        //     onTap: () async {
                                        //       List result = await Navigator.of(context).push(
                                        //           new MaterialPageRoute(
                                        //               builder: (context) => GetLocationPage(myLocations[i].lat, myLocations[i].lon)));
                                        //       if (result.length > 0) {
                                        //         double lat = result[0];
                                        //         double lon = result[1];
                                        //         String title = result[2];
                                        //         CPRMyLocation cprMyLocation = new CPRMyLocation(
                                        //             lat: lat, lon: lon, title: title, userId: loginedUser.email,id: myLocations[i].id,documentID: myLocations[i].documentID);
                                        //         editLocationForUser(cprMyLocation,i);
                                        //       }
                                        //     },
                                        //     child: Icon(Icons.edit)),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return DialogDeleteMyLocation(
                                                      myLocations![i],
                                                      (location) {
                                                    deleteMyLocation(location);
                                                  });
                                                });
                                          },
                                          child: Icon(
                                            Icons.delete,
                                            color: Get.theme.accentColor,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 16,
                                        ),
                                      ],
                                    )),
                              );
                            },
                            itemCount: myLocations!.length,
                            shrinkWrap: true,
                          )
                        : Center(child: Text("Nothing found!"))
                    : Center(
                        child: SpinKitThreeBounce(
                          color: Theme.of(context).accentColor,
                          size: 24,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  getMyLocations(CPRUser loginedUser) async {
    MyLocationsService myLocationsService = new MyLocationsService();
    List<CPRMyLocation> myLocationsTemp =
        await myLocationsService.getUserReviewsList(loginedUser);
    setState(() {
      myLocations = myLocationsTemp;
    });
  }

  deleteMyLocation(CPRMyLocation location) async {
    MyLocationsService myLocationsService = new MyLocationsService();
    bool isDeleted =
        await myLocationsService.deleteMyLocation(location.documentID!);
    if (isDeleted) {
      setState(() {
        myLocations!.remove(location);
      });
      Navigator.pop(context);
    }
  }
}
