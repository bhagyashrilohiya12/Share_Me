import 'package:cpr_user/pages/common/components/cpr_container.dart';
import 'package:cpr_user/pages/common/components/cpr_loading.dart';
import 'package:cpr_user/pages/user/search_places_and_reviews/category_list_item.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart' as p;

class CategoriesPage extends StatefulWidget {
  CategoriesPage();

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> with TickerProviderStateMixin {
  bool showProgress = false;
  List categories = ["accounting", "airport", "amusement_park", "aquarium", "art_gallery", "atm", "bakery", "bank", "bar", "beauty_salon", "bicycle_store", "book_store", "bowling_alley", "bus_station", "cafe", "campground", "car_dealer", "car_rental", "car_repair", "car_wash", "casino", "cemetery", "church", "city_hall", "clothing_store", "convenience_store", "courthouse", "dentist", "department_store", "doctor", "drugstore", "electrician", "electronics_store", "embassy", "fire_station", "florist", "funeral_home", "furniture_store", "gas_station", "gym", "hair_care", "hardware_store", "hindu_temple", "home_goods_store", "hospital", "insurance_agency", "jewelry_store", "laundry", "lawyer", "library", "light_rail_station", "liquor_store", "local_government_office", "locksmith", "lodging", "meal_delivery", "meal_takeaway", "mosque", "movie_rental", "movie_theater", "moving_company", "museum", "night_club", "painter", "park", "parking", "pet_store", "pharmacy", "physiotherapist", "plumber", "police", "post_office", "primary_school", "real_estate_agency", "restaurant", "roofing_contractor", "rv_park", "school", "secondary_school", "shoe_store", "shopping_mall", "spa", "stadium", "storage", "store", "subway_station", "supermarket", "synagogue", "taxi_stand", "tourist_attraction", "train_station", "transit_station", "travel_agency", "university", "veterinary_care", "zoo"];
  List favCategories = ["restaurant","hair_care","bar","lodging","health","cafe"];
  List favCategoriesImages = ["assets/images/ic_fork_knife.png","assets/images/ic_seat.png","assets/images/ic_glass.png",
    "assets/images/ic_hotel.png","assets/images/ic_health_and_safety.png","assets/images/ic_coffee.png"];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Log.i( "page - CategoriesPage - build");
    var sessionProvider = p.Provider.of<SessionProvider>(context, listen: false);

    return Scaffold(
      body: CPRContainer(
        loadingWidget: CPRLoading(
          loading: false,
        ),
        child: Container(
          width: Get.width,
          height: Get.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 80,
                color: Colors.black,
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                child: Row(
                  children: [
                    Container(
                        height: 40,
                        width: 40,
                        padding: EdgeInsets.only(left: 4),
                        child: IconButton(
                          color: Colors.white,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 25,
                          ),
                        )),
                    Expanded(
                        child: Center(
                      child: Text(
                        "More Categories",
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    )),
                    Container(
                      height: 40,
                      width: 40,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: Get.width,
                  color: CPRColors.grayLight,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(24, 16, 16, 0),
                          transform: Matrix4.translationValues(0.0, 16.0, 0.0),
                          child: Text(
                            "Popular Categories",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, i) {
                            return CategoryListItem(favCategories[i],i,favCategories.length,imageAddress: favCategoriesImages[i]);
                          },
                          itemCount: favCategories.length,
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(24, 16, 16, 0),
                          transform: Matrix4.translationValues(0.0, 16.0, 0.0),
                          child: Text(
                            "All Categories",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, i) {
                          return CategoryListItem(categories[i],i,favCategories.length);
                        },
                        itemCount: categories.length,
                        ),
                      ],
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

// Future<void> getTopRateNearReview(SessionProvider sessionProvider) async {
//   setState(() {
//     topRateNearPalce = null;
//   });
//   String url = BASE_URL +
//       "app/getTopRateNearReview?lat=${sessionProvider?.currentLocation?.latitude}&lng=${sessionProvider?.currentLocation?.longitude}&top=1000&topMode=notFill&category=${MainCategoryUtil.getGooglePlacesName(widget.category)}&";
//   if (_searchController.text.trim().length > 0) {
//     url += "placeName=${_searchController.text.trim()}&";
//   }
//   if (_zipCodeController.text.trim().length > 0) {
//     url += "postcode=${_zipCodeController.text.trim()}&";
//   }
//   if (_tagController.text.trim().length > 0) {
//     url += "tag=${_tagController.text.trim()}&";
//   }
//   var res = await networkService.callApi(url: url, requestMethod: RequestMethod.GET);
//
//   if (res == NetworkErrorCodes.RECEIVE_TIMEOUT || res == NetworkErrorCodes.CONNECT_TIMEOUT || res == NetworkErrorCodes.SEND_TIMEOUT)
//     Scaffold.of(context).showSnackBar(SnackBar(
//       content: Text("Time Out Error !"),
//     ));
//   else if (res == NetworkErrorCodes.SOCKET_EXCEPTION)
//     Scaffold.of(context).showSnackBar(SnackBar(
//       content: Text("No Internet Connection !"),
//     ));
//   else {
//     GetTopRateNearReview topRateNearReviewTemp = new GetTopRateNearReview.fromJson(res);
//     if (mounted)
//       setState(() {
//         topRateNearReview = topRateNearReviewTemp;
//       });
//   }
// }

}
