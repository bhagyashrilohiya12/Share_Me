import 'package:cpr_user/constants/main_categories.dart';
import 'package:cpr_user/models/place.dart';
import 'package:cpr_user/pages/common/components/cpr_search.dart';
import 'package:cpr_user/pages/user/categories/categories_page.dart';
import 'package:cpr_user/pages/user/search_places_and_reviews/search_places_and_reviews_page.dart';
import 'package:cpr_user/providers/places_provider.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart' as p;

class CategoryBar extends StatelessWidget {
  // const CategoryBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 54),
      child: Material(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          height: 90,
          width: MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width * 0.2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      Get.to(SearchPlacesAndReviewsPage(category: MainCategory.restaurants));
                    },
                    child: const Image(
                      image:
                          const AssetImage("assets/images/ic_fork_knife.png"),
                      height: 28,
                      width: 28,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      Get.to(SearchPlacesAndReviewsPage(category: MainCategory.salons));
                    },
                    child: const Image(
                      image: const AssetImage("assets/images/ic_seat.png"),
                      height: 28,
                      width: 28,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      Get.to(SearchPlacesAndReviewsPage(category: MainCategory.bars));
                    },
                    child: const Image(
                      image: const AssetImage("assets/images/ic_glass.png"),
                      height: 28,
                      width: 28,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      Get.to(SearchPlacesAndReviewsPage(category: MainCategory.hotels));
                    },
                    child: const Image(
                      image: AssetImage("assets/images/ic_hotel.png"),
                      height: 28,
                      width: 28,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      Get.to(SearchPlacesAndReviewsPage(
                          category: MainCategory.wellbeing));
                    },
                    child: const Image(
                      image:
                          AssetImage("assets/images/ic_health_and_safety.png"),
                      height: 28,
                      width: 28,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      Get.to(SearchPlacesAndReviewsPage(
                          category: MainCategory.cafes));
                    },
                    child: const Image(
                      image: const AssetImage("assets/images/ic_coffee.png"),
                      height: 28,
                      width: 28,
                    ),
                  ),
                ],
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: InkWell(
                  onTap: () {
                    Get.to(CategoriesPage());
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.more_horiz,
                        size: 24,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        "More",
                        style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showSearchBar(BuildContext context, MainCategory category) async {
    var displayName = MainCategoryUtil.getDisplayName(category);
    var placeProvider = p.Provider.of<PlacesProvider>(context, listen: false);
    var sessionProvider = p.Provider.of<SessionProvider>(context, listen: false);
    sessionProvider.startLoading();
    List<Place>? list = await placeProvider.findPlacesByCategory(sessionProvider.currentLocation!, category);
    sessionProvider.stopLoading();
    var searchComponent = CPRSearch<Place>(
      title: displayName,
      subtitle: "Showing all the ${displayName.toLowerCase()}",
      reviews: list!,
      currentLocation: sessionProvider.currentLocation,
    );
    showModalBottomSheet(
        builder: (context) {
          return Container(height: MediaQuery.of(context).size.height * .85, child: searchComponent);
        },
        barrierColor: Colors.white.withOpacity(0.25),
        elevation: 7,
        isScrollControlled: true,
        context: context);
  }
}
