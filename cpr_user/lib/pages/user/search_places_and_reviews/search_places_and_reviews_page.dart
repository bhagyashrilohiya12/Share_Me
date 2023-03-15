import 'package:cpr_user/constants/main_categories.dart';
import 'package:cpr_user/constants/network_error_codes.dart';
import 'package:cpr_user/constants/sort_types.dart';
import 'package:cpr_user/models/get_top_rate_near_palce.dart';
import 'package:cpr_user/models/get_top_rate_near_review.dart';
import 'package:cpr_user/pages/common/components/cpr_container.dart';
import 'package:cpr_user/pages/common/components/cpr_loading.dart';
import 'package:cpr_user/pages/common/components/result_list_place.dart';
import 'package:cpr_user/pages/common/components/result_list_review.dart';
import 'package:cpr_user/pages/user/get_location/get_location_page.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:cpr_user/services/network_service.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// import 'package:geocoder/geocoder.dart'; //#abdo
// import 'package:geocoder2/geocoder2.dart'; //#abdo
import 'package:geocoding/geocoding.dart'; //#abdo
import 'package:get/get.dart';
import 'package:provider/provider.dart' as p;

class SearchPlacesAndReviewsPage extends StatefulWidget {
  MainCategory? category;
  String? categoryName;

  SearchPlacesAndReviewsPage({this.category, this.categoryName});

  @override
  _SearchPlacesAndReviewsPageState createState() => _SearchPlacesAndReviewsPageState();
}

class _SearchPlacesAndReviewsPageState extends State<SearchPlacesAndReviewsPage> with TickerProviderStateMixin {
  bool showProgress = false;
  GetTopRateNearPalce? topRateNearPalce;
  GetTopRateNearReview? topRateNearReview;
  TextEditingController _searchController = new TextEditingController();
  TextEditingController _zipCodeController = new TextEditingController();
  TextEditingController _tagController = new TextEditingController();
  String? selectedLocationName;

  TabController? _controller;
  int selectedTabIndex = 0;

  SortType? sortType;

  @override
  void initState() {
    if (widget.category != null) widget.categoryName = MainCategoryUtil.getGooglePlacesName(widget.category!);
    _controller = TabController(
      length: 2,
      vsync: this,
    );
    _controller!.addListener(() {
      setState(() {
        selectedTabIndex = _controller!.index;
      });
    });
    super.initState();
  }

  SessionProvider? sessionProvider;

  @override
  Widget build(BuildContext context) {
    Log.i("page  - SearchPlacesAndReviewsPage - build");

    sessionProvider = p.Provider.of<SessionProvider>(context, listen: false);
    if (topRateNearPalce == null) getTopRateNearPlace(sessionProvider!);
    if (topRateNearReview == null) getTopRateNearReview(sessionProvider!);

    if (selectedLocationName == null) {
      setCurrentLocation();
      /***-
       * //#abdo
          getAddress( );
       */

    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: CPRContainer(
        loadingWidget: const CPRLoading(
          loading: false,
        ),
        child: Container(
          width: Get.width,
          // height: Get.height + 35 , // fix height when keyboard open
          color: Colors.black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
                    child: Material(
                      elevation: 8,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Container(
                          height: 40,
                          width: 40,
                          padding: const EdgeInsets.only(left: 4),
                          child: IconButton(
                            color: Colors.white,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.black,
                              size: 25,
                            ),
                          )),
                    ),
                  ),
                  const Expanded(child: Text("")),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
                    child: Material(
                      elevation: 8,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Container(
                          height: 40,
                          width: 40,
                          child: PopupMenuButton(
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                  value: SortType.ratingAscending,
                                  child: Text('Rating - Ascending' +
                                      ((sortType != null && sortType == SortType.ratingAscending) ? " ✓" : "")),
                                ),
                                PopupMenuItem(
                                  value: SortType.ratingDescending,
                                  child: Text('Rating - Descending' +
                                      ((sortType != null && sortType == SortType.ratingDescending) ? " ✓" : "")),
                                ),
                                PopupMenuItem(
                                  value: SortType.distanceAscending,
                                  child: Text('Distance - Ascending' +
                                      ((sortType != null && sortType == SortType.distanceAscending) ? " ✓" : "")),
                                ),
                                PopupMenuItem(
                                  value: SortType.distanceDescending,
                                  child: Text('Distance - Descending' +
                                      ((sortType != null && sortType == SortType.distanceDescending) ? " ✓" : "")),
                                )
                              ];
                            },
                            onSelected: (value) {
                              sortType = value as SortType; //#abdo
                              if (value == SortType.ratingAscending) {
                                setState(() {
                                  topRateNearPalce!.nearRatePlaces!
                                      .sort((a, b) => a.place!.iconTile.compareTo(b.place!.iconTile));
                                });
                              }
                              if (value == SortType.ratingDescending) {
                                setState(() {
                                  topRateNearPalce!.nearRatePlaces!
                                      .sort((a, b) => b.place!.iconTile.compareTo(a.place!.iconTile));
                                });
                              }
                              if (value == SortType.distanceAscending) {
                                setState(() {
                                  topRateNearPalce!.nearRatePlaces!.sort((a, b) => a.dis!.compareTo(b.dis!));
                                });
                              }
                              if (value == SortType.distanceDescending) {
                                setState(() {
                                  /**
                                   * #abdo
                                   */
                                  topRateNearPalce!.nearRatePlaces!.sort((a, b) => b.dis!.compareTo(a.dis!));
                                });
                              }
                            },
                            child: const Icon(
                              Icons.filter_alt_outlined,
                              color: Colors.black,
                              size: 25,
                            ),
                          )),
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    child: TabBar(
                      indicatorColor: Colors.transparent,
                      controller: _controller,
                      onTap: (v) {
                        setState(() {
                          selectedTabIndex = v;
                        });
                      },
                      indicatorWeight: 0,
                      indicator: const BoxDecoration(),
                      labelPadding: EdgeInsets.zero,
                      indicatorPadding: EdgeInsets.zero,
                      tabs: [
                        Container(
                          width: double.infinity,
                          height: 48,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: selectedTabIndex == 0 ? Get.theme.accentColor : Colors.transparent),
                          child: const Center(
                              child: Text(
                            'Places',
                            style: TextStyle(color: Colors.black),
                          )),
                        ),
                        Container(
                          width: double.infinity,
                          height: 48,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: selectedTabIndex == 1 ? Get.theme.accentColor : Colors.transparent),
                          child: const Center(
                              child: Text(
                            'Reviews',
                            style: TextStyle(color: Colors.black),
                          )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        maxLines: 1,
                        controller: _searchController,
                        autofocus: false,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: 'Business Name',
                            hintStyle: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.75)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                width: 2,
                                color: Colors.white,
                                style: BorderStyle.solid,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                width: 1,
                                color: Colors.white,
                                style: BorderStyle.solid,
                              ),
                            ),
                            filled: true,
                            contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                            fillColor: Colors.black,
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.white,
                            )),
                        onChanged: (v) async {},
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: TextField(
                        maxLines: 1,
                        controller: _tagController,
                        autofocus: false,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: 'Hashtag',
                            hintStyle: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.75)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                width: 2,
                                color: Colors.white,
                                style: BorderStyle.solid,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                width: 1,
                                color: Colors.white,
                                style: BorderStyle.solid,
                              ),
                            ),
                            filled: true,
                            contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                            fillColor: Colors.black,
                            prefixIcon: const Icon(
                              Icons.tag,
                              color: Colors.white,
                            )),
                        onChanged: (v) async {},
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
                        child: TextField(
                          maxLines: 1,
                          controller: _zipCodeController,
                          autofocus: false,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              hintText: 'Zip/Post Code',
                              hintStyle: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.75)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  width: 2,
                                  color: Colors.white,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: Colors.white,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              filled: true,
                              contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                              fillColor: Colors.black,
                              prefixIcon: const Icon(
                                Icons.location_on,
                                color: Colors.white,
                              )),
                          onChanged: (v) async {},
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) => GetLocationPage()))
                              .then((value) {
                            /**
                                #abdo

                                updateAddress(
                                new Coordinates(sessionProvider.currentLocation.latitude, sessionProvider.currentLocation.longitude)
                                );
                             */
                            setCurrentLocation();
                            getTopRateNearPlace(sessionProvider!);
                          });
                        },
                        child: Container(
                          height: 48,
                          margin: const EdgeInsets.fromLTRB(0, 8, 16, 8),
                          padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 1), borderRadius: BorderRadius.circular(8)),
                          child: Center(
                            child: Text(
                              "Choose Location" + (selectedLocationName != null ? "\n($selectedLocationName)" : ""),
                              style: TextStyle(color: Colors.white),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  Container(
                    height: 80,
                    child: Column(
                      children: [
                        Container(
                          height: 40,
                          color: Colors.black,
                        ),
                        Container(
                          height: 40,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: Get.width,
                    height: 48,
                    margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Get.theme.accentColor),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: const BorderSide(
                              color: Colors.white,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                      child: Text(
                        selectedTabIndex == 0 ? 'Search Places' : 'Search Reviews',
                        style: TextStyle(fontSize: 16),
                      ),
                      onPressed: () {
                        if (selectedTabIndex == 0) {
                          getTopRateNearPlace(sessionProvider!);
                        } else {
                          getTopRateNearReview(sessionProvider!);
                        }
                      },
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  child: TabBarView(
                    controller: _controller,
                    children: <Widget>[
                      Container(
                        color: Colors.white,
                        child: topRateNearPalce == null
                            ? Center(
                                child: SpinKitThreeBounce(
                                  color: Get.theme.accentColor,
                                  size: 24,
                                ),
                              )
                            : SingleChildScrollView(
                                child: getResultListView(),
                              ),
                      ),
                      Container(
                        color: Colors.white,
                        child: topRateNearReview == null
                            ? Center(
                                child: SpinKitThreeBounce(
                                  color: Get.theme.accentColor,
                                  size: 24,
                                ),
                              )
                            : SingleChildScrollView(
                                child: ResultListReview(
                                  list: topRateNearReview!.nearRateReviews!.map((e) => e.review).toList(),
                                  isDraftReview: false,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  updateAddress(double lat, double lng) async {
    List<Placemark> listPlaceMark = await placemarkFromCoordinates(lat, lng);
    if (listPlaceMark == null) return;
    if (listPlaceMark.isEmpty) return;

    Placemark firstPlace = listPlaceMark[0];
    if (firstPlace == null) return;

    setState(() {
      if (firstPlace.administrativeArea != null) {
        selectedLocationName = firstPlace.administrativeArea! + " | " + firstPlace.name!;
      } else if (firstPlace.name != null) {
        selectedLocationName = firstPlace.name!;
      } else {
        selectedLocationName = "";
      }
    });

    /** -- //#abdo
        var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
        setState(() {
        selectedLocationName = addresses.first.subAdminArea + " | " + addresses.first.featureName;
        });
     */
  }

  setCurrentLocation() async {
    var lat = sessionProvider!.currentLocation!.latitude;
    var lng = sessionProvider!.currentLocation!.longitude;
    updateAddress(lat, lng);
    /**
        #abdo
        // new Coordinates(sessionProvider.currentLocation!.latitude, sessionProvider.currentLocation!.longitude)
     */
  }

  Future<void> getTopRateNearPlace(SessionProvider sessionProvider) async {
    setState(() {
      topRateNearPalce = null;
    });
    String url = BASE_URL +
        "app/getTopRateNearPlace?lat=${sessionProvider.currentLocation?.latitude}&lng=${sessionProvider.currentLocation?.longitude}&top=1000&topMode=notFill&category=${widget.categoryName}&";
    if (_searchController.text.trim().isNotEmpty) {
      url += "placeName=${_searchController.text.trim()}&";
    }
    if (_zipCodeController.text.trim().isNotEmpty) {
      url += "postcode=${_zipCodeController.text.trim()}&";
    }
    if (_tagController.text.trim().isNotEmpty) {
      url += "tag=${_tagController.text.trim()}&";
    }
    var res = await networkService.callApi(url: url, requestMethod: RequestMethod.GET);

    if (res == NetworkErrorCodes.RECEIVE_TIMEOUT ||
        res == NetworkErrorCodes.CONNECT_TIMEOUT ||
        res == NetworkErrorCodes.SEND_TIMEOUT) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Time Out Error !"),
      ));
    } else if (res == NetworkErrorCodes.SOCKET_EXCEPTION) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("No Internet Connection !"),
      ));
    } else {
      GetTopRateNearPalce topRateNearPalceTemp = GetTopRateNearPalce.fromJson(res);
      if (mounted) {
        setState(() {
          topRateNearPalce = topRateNearPalceTemp;
        });
      }
    }
  }

  Future<void> getTopRateNearReview(SessionProvider sessionProvider) async {
    setState(() {
      topRateNearPalce = null;
    });
    String url = BASE_URL +
        "app/getTopRateNearReview?lat=${sessionProvider.currentLocation?.latitude}&lng=${sessionProvider.currentLocation?.longitude}&top=1000&topMode=notFill&category=${widget.categoryName}&";
    if (_searchController.text.trim().isNotEmpty) {
      url += "placeName=${_searchController.text.trim()}&";
    }
    if (_zipCodeController.text.trim().isNotEmpty) {
      url += "postcode=${_zipCodeController.text.trim()}&";
    }
    if (_tagController.text.trim().isNotEmpty) {
      url += "tag=${_tagController.text.trim()}&";
    }
    var res = await networkService.callApi(url: url, requestMethod: RequestMethod.GET);

    if (res == NetworkErrorCodes.RECEIVE_TIMEOUT ||
        res == NetworkErrorCodes.CONNECT_TIMEOUT ||
        res == NetworkErrorCodes.SEND_TIMEOUT) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Time Out Error !"),
      ));
    } else if (res == NetworkErrorCodes.SOCKET_EXCEPTION) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("No Internet Connection !"),
      ));
    } else {
      GetTopRateNearReview topRateNearReviewTemp = GetTopRateNearReview.fromJson(res);
      if (mounted) {
        setState(() {
          topRateNearReview = topRateNearReviewTemp;
        });
      }
    }
  }

  getResultListView() {
    return ResultListPlace(
      list: topRateNearPalce!.nearRatePlaces!.map((e) => e.place).toList(),
      isDraftReview: false,
    );
  }
}
