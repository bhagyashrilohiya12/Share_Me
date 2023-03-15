
import 'package:cpr_user/constants/main_categories.dart';
import 'package:cpr_user/pages/common/components/LogoutUI.dart';
import 'package:cpr_user/pages/common/components/category_bar.dart';
import 'package:cpr_user/pages/common/components/click_pick_review_button.dart';
import 'package:cpr_user/pages/user/get_location/get_location_page.dart';
import 'package:cpr_user/pages/user/home_page/components/categorized_places_list.dart';
import 'package:cpr_user/pages/user/login/login_screen.dart';
import 'package:cpr_user/providers/home_image_provider.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:cpr_user/resource/toast/ToolsToast.dart';
import 'package:cpr_user/services/auth_service.dart';
import 'package:extended_image/extended_image.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart' as p;
import 'package:sliver_fab/sliver_fab.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Log.i( "page - HomePage - build");

    var sessionProvider = p.Provider.of<SessionProvider>(context, listen: false);
    double width = MediaQuery.of(context).size.width;

    /**
     * Abdallah document
     *
     * this carry values of all category at home page
     */
    MainCategory.values
        .map((category) => CategorizedPlacesList(
              category: category,
            ))
        .toList();

    return SafeArea(
      child: SliverFab(
        floatingWidget: Center(child: CategoryBar()),
        floatingPosition: const FloatingPosition(right: 10, left: 10, top: 80),
        slivers: <Widget>[
          cardTopView(sessionProvider, context ),
          listViewOfCategory(),
        ],
      ),
    );
  }


  Widget listViewOfCategory() {

    List<Widget> listChildren =  MainCategory.values
        .map((category) => CategorizedPlacesList(
      category: category,
    )).toList();

    return SliverPadding(
      padding: const EdgeInsets.only(top: 116,right: 16,left: 16),
      sliver: SliverList(
        delegate: SliverChildListDelegate(listChildren),
      ),
    );
  }

  Widget cardTopView(SessionProvider sessionProvider, BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: 360,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.fromLTRB(24, 108, 24, 16),
              child: p.Consumer<HomeImageProvider>(builder: (__, pro, _) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: ExtendedImage.network(
                    pro.homeImageUrl,
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              }),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                  margin: const EdgeInsets.fromLTRB(0,290, 0,0),
                  child: ClickPicReviewButton()),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(color: Get.theme.accentColor, borderRadius: BorderRadius.circular(100)),
                    height: 32,
                    constraints: const BoxConstraints(maxHeight: 42),
                    margin: const EdgeInsets.fromLTRB(16, 90, 16, 16),
                    padding: const EdgeInsets.fromLTRB(16,2,16,2),
                    child: Center(
                        child: Text(
                          "Welcome " + (sessionProvider.user?.firstName ?? ''),
                          style: const TextStyle(color: Colors.white,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                        )),
                  ),
                ],
              ),
            ),
            Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                      IconButton(
                        alignment: Alignment.centerLeft,
                        icon: const Icon(Icons.location_on_outlined, color: Colors.white),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => GetLocationPage( )));
                        },
                      ),
                      Expanded(
                        child: Column(
                          children: const [
                            Image(
                              image: AssetImage('assets/images/ic_logo.png'),
                              height: 64,
                              fit: BoxFit.fitHeight,
                            ),
                            // Text(
                            //   'Customer',
                            //   textAlign: TextAlign.center,
                            //   style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                            // ),
                          ],
                        ),
                      ),
                      LogoutUI.getWidget(context),
                    ]),
                  ],
                )),
          ],
        ),
      ),
    );
  }


}

