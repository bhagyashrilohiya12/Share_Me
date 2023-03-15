import 'dart:async';
import 'dart:convert';

import 'package:cpr_user/helpers/notification_helper.dart';
import 'package:cpr_user/main.dart';
import 'package:cpr_user/models/events/menu_changes.dart';
import 'package:cpr_user/models/review.dart';
import 'package:cpr_user/pages/common/components/cpr_container.dart';
import 'package:cpr_user/pages/common/components/cpr_loading.dart';
import 'package:cpr_user/pages/user/home_page/home_page.dart';
import 'package:cpr_user/pages/user/feed/feed_page.dart';
import 'package:cpr_user/pages/user/my_profile_page/my_profile_page_new.dart';
import 'package:cpr_user/pages/user/review_page/review_page.dart';
import 'package:cpr_user/pages/user/social_media/social_media_page.dart';
import 'package:cpr_user/pages/user/search_user/search_page.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart' as p;
import 'package:firebase_messaging/firebase_messaging.dart';

NavigationPageState? stateNavigationPage;

class NavigationPage extends StatefulWidget {
  @override
  NavigationPageState createState() {

    stateNavigationPage = NavigationPageState();
    return stateNavigationPage!;
  }
}

class NavigationPageState extends State<NavigationPage> {
  // int currentIndex = 0;
  StreamSubscription? subscription ;
  SessionProvider? provider;

  @override
  Widget build(BuildContext context) {
    return CPRContainer(
      loadingWidget: p.Consumer<SessionProvider>(builder: (context, provider, _) {
        return CPRLoading(
          loading: provider.busy,
        );
      }),
      child: Scaffold(
        bottomNavigationBar: p.Consumer<SessionProvider>(builder: (sessionContext, sessionProvider, _) {
          provider = sessionProvider;
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: sessionProvider.currentIndex,
            onTap: (index) {
              // setState(() {
              sessionProvider.currentIndex = index;
              // });
            },
            backgroundColor: Colors.black,
            selectedItemColor: Get.theme.accentColor,
            unselectedItemColor: Colors.grey,
            items: [
              BottomNavigationBarItem(
                icon: Icon(MaterialCommunityIcons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.rss_feed),
                label: "Feed",
              ),
              BottomNavigationBarItem(
                icon: Icon(MaterialCommunityIcons.account_search),
                label: "Search",
              ),
              BottomNavigationBarItem(
                icon: Icon(MaterialCommunityIcons.star),
                label: "Reviews",
              ),
              BottomNavigationBarItem(
                icon: Icon(MaterialCommunityIcons.instagram),
                label: "Social",
              ),
              BottomNavigationBarItem(
                icon: Icon(MaterialCommunityIcons.account),
                label: "Profile",
              ),
            ],
          );
        }),
        backgroundColor: Colors.black,
        body: Container(
          decoration:
              BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xff00b9f2), width: 2))),
          child: p.Consumer<SessionProvider>(
            builder: (context, sessionProvider, _) {
              return _getBody(sessionProvider.currentIndex);
            },
          ),
        ),
      ),
    );
  }

  Widget _getBody(index) {
    switch (index) {
      case 1:
        return FeedScreen();
      case 2:
        return SearchPage();
      case 3:
        return ReviewPage();
      case 4:
        return SocialMediaPage(review: Review() ,); //#abdo
      case 5:
        return MyProfilePageNew();
      default:
        return HomePage();
    }
  }

  @override
  void initState() {
    super.initState();

    subscription = eventBus.on<MenuChanges>().listen((event) {
    //  print("event.index");
      provider!.currentIndex = event.index;
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {

      if(event.data!=null) {
        RemoteMessage msg = event;
        String title = msg.data['title'] ?? "";
        String body = msg.data['body'] ?? "";
        NotificationHelper()
            .showNotification(title, body, "", jsonEncode(msg.data));
      } else {
        NotificationHelper().showNotification(
            event.notification!.title ?? "",
            event.notification!.body ?? "",
            event.notification!.android?.imageUrl ?? "",
            event.data.toString());
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
     // print('Message clicked!');
    });
  }

  @override
  void dispose() {
    subscription!.cancel();
    super.dispose();
  }
}
