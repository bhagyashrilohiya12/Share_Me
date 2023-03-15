import 'package:cpr_user/constants/main_categories.dart';
import 'package:cpr_user/models/review.dart';
import 'package:cpr_user/pages/common/components/cpr_search.dart';
import 'package:cpr_user/pages/user/home_page/components/categorized_places_list.dart';
import 'package:cpr_user/providers/places_provider.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:cpr_user/resource/TimeTools.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as p;

class ListViewReview extends StatelessWidget {
  BuildContext pageContext;

  bool isTypeDraft = false;
  SessionProvider? sessionProvider;
  List<Widget> getListChildren = [];
  List<dynamic>? places; //used in search
  DateTime? filterByDate;

  ListViewReview(this.pageContext, {
    required this.isTypeDraft,
    DateTime? this.filterByDate
  });

  PlacesProvider? placeProvider;

  @override
  Widget build(BuildContext context) {
    placeProvider = p.Provider.of<PlacesProvider>(pageContext, listen: false);
    Log.i("ListViewReview - build() ");

    //download data
    _downloadData();

    return normalTypeOfCategory();
  }

  Widget normalTypeOfCategory() {
    return Container(
      height: 170,
      padding: const EdgeInsets.only(left: 16, right: 16),
      //color: Colors.cyan,
      child: Column(
        children: <Widget>[
          titleBar(),
          Expanded(
            child: Builder(
              builder: (context) {
                return ListView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.only(top: 10),
                    children: getListChildren);
              },
            ),
          )
        ],
      ),
    );
  }

  String getTitleTxt() {
    if (isTypeDraft) {
      return "Draft Review";
    }
    return "My Review";
  }

  Widget titleBar() {
    var tv_seeAll = Text(
      "See all",
      style: CPRTextStyles.smallHeaderBoldDarkBackground,
    );
    // TextTemplate.t( "See all", color: Colors.white, dimen: 13 );

    var stack = Stack(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          EmptyView.empty(DeviceTools.getWidth(pageContext), 16),
          Text(
            getTitleTxt(),
            style: CPRTextStyles.smallHeaderBoldDarkBackground,
          ),
          Positioned(
            child: tv_seeAll,
            right: 0,
          )
        ]);

    return GestureDetector(
        child: stack,
        onTap: () async {
          clickOnRow();
        });
    // return     Text(
    //   getTitleTxt(),
    //   style: CPRTextStyles.smallHeaderBoldDarkBackground,
    // );
  }

  //--------------------------------------------------------- item list children

  List<Widget> mapDataToView() {
    List<Widget> children = [];
    if (places == null || places!.isEmpty) {
      Log.i("mapDataToView() - case (places == null)  ");

      children = [emptyReview()];
      return children;
    }

    Log.i("mapDataToView() - places: " +
        places.toString() +
        " /size: " +
        places!.length.toString());

    //todo:16-09-22 here we only change normal list to reverse list
    if (isTypeDraft == false) {
      children = places!
          .map((f) => ReviewMiniCard(
                review: f as Review,
                categoryName: MainCategoryUtil.getDisplayName(getCategory()),
                userLocation: sessionProvider!.currentLocation!,
              ))
          .toList()
          .toList();
    } else if (isTypeDraft) {
      //  Log.i( "getCategoryValueListHorizontal() - case (myDraftReviews)  "  );
      //todo:16-09-22 here we only change normal list to reverse list
      children = places!
          .map((f) => ReviewMiniCard(
                review: f as Review,
                categoryName: MainCategoryUtil.getDisplayName(getCategory()),
                userLocation: sessionProvider!.currentLocation!,
                isDraftReview: true,
              ))
          .toList()
          .toList();
    }
    return children;
  }

  //------------------------------------------------------------------ empty view

  Widget emptyReview() {
    return Container(
      width: MediaQuery.of(pageContext).size.width,
      child: Center(
        child: Text(
          msgEmpty(),
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  String msgEmpty() {
    String msg = "No results found";

    if (filterByDate != null) {
      String day = filterByDate!.day.toString();
      String mon = filterByDate!.month.toString();
      msg = "No result found for Date " + mon + "/" + day;
    }

    return msg;
  }

  //----------------------------------------------------------------------------------- click see all list

  void clickOnRow() {
    var subtitle = 'List of all the ${getTitleTxt().toLowerCase()} that has been reviewed.';


    sessionProvider!.startLoading();

    var searchComponent;
    if (isTypeDraft) {
      sessionProvider!.startLoading();
      searchComponent = CPRSearch(
        title: getTitleTxt(),
        subtitle: 'List of all ${getTitleTxt().toLowerCase()}',
        reviews: sessionProvider!.places[getCategory()]!
            .map((f) => f as Review)
            .toList(),
        currentLocation: sessionProvider!.currentLocation!,
        isDraftReview: true,
      );
      sessionProvider!.stopLoading();
      showModalBottomSheet(
          context: pageContext,
          barrierColor: Colors.white.withOpacity(0.25),
          elevation: 7,
          isScrollControlled: true,
          builder: (bottomSheetContext) {
            return Container(
              child: searchComponent,
              height: MediaQuery.of(pageContext).size.height * .85,
            );
          });
    } else {
      searchComponent = CPRSearch(
          title: getTitleTxt(),
          subtitle: 'List of all ${getTitleTxt().toLowerCase()}',
          reviews: places!.map((f) => f as Review).toList(),
          currentLocation: sessionProvider!.currentLocation!);
      sessionProvider!.stopLoading();
      showModalBottomSheet(
          context: pageContext,
          barrierColor: Colors.white.withOpacity(0.25),
          elevation: 7,
          isScrollControlled: true,
          builder: (bottomSheetContext) {
            return Container(
              child: searchComponent,
              height: MediaQuery.of(pageContext).size.height * .85,
            );
          });
    }
  }

  MainCategory getCategory() {
    if (isTypeDraft) {
      return MainCategory.myDraftReviews;
    } else {
      return MainCategory.myReviews;
    }
  }

  void _downloadData() async {
    sessionProvider =
        p.Provider.of<SessionProvider>(pageContext, listen: false);

    var listPlaceFromSession = sessionProvider!.places[getCategory()];

    //check null
    if (listPlaceFromSession == null) {
      getListChildren = mapDataToView();
      return;
    }

    //check need filter
    if (filterByDate != null) {
      _startFilterByDate(listPlaceFromSession);
    } else {
      places = listPlaceFromSession;
    }

    //map to view
    getListChildren = mapDataToView();
  }

  void _startFilterByDate(List listPlaceBeforeFilter) {
    if (filterByDate == null) {
      return;
    }

    places ??= [];

    for (var element in listPlaceBeforeFilter) {
      Review review = element as Review;
      if (review.when == null) {
        continue;
      }

      bool isSameDateOfFilter =
          TimeTools.isSameDate(review.when!, filterByDate!);
      if (isSameDateOfFilter) {
        places!.add(element);
      }
    }
  }
}
