import 'dart:convert';

import 'package:cpr_user/helpers/fcm_helper.dart';
import 'package:cpr_user/helpers/notification_helper.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cpr_user/pages/user/splash_screen.dart';
import 'package:cpr_user/providers/home_image_provider.dart';
import 'package:cpr_user/providers/places_provider.dart';
import 'package:cpr_user/providers/review_provider.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:event_bus/event_bus.dart';


// FirebaseAnalytics analytics = FirebaseAnalytics();
EventBus eventBus = EventBus();


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
 // print(message.toString());

  RemoteMessage msg = message;
  String title = msg.data['title'] ?? "";
  String body = msg.data['body'] ?? "";
  NotificationHelper().showNotification(title, body, "", jsonEncode(msg.data));

 // print("Handling a background message: ${msg.messageId}");
}


/**
 * import 'package:firebase_analytics/firebase_analytics.dart';
 */
 FirebaseAnalytics analytics = FirebaseAnalytics.instance;
 FirebaseAnalyticsObserver observer = new FirebaseAnalyticsObserver(
    analytics: analytics);


void main() async {

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black, // navigation bar color
    statusBarColor: Colors.black, // status bar color
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  final data = ThemeData(
    primaryColor: Colors.black,
    accentColor: CPRColors.cprButtonPink,
    backgroundColor: CPRColors.cprButtonGreen,
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent),
  );
  await FcmHelper.getToken();
  NotificationHelper().init();


  await SentryFlutter.init(
        (options) {
      options.dsn = 'https://93dca0222ce84be88830206cf463de8d@o1108074.ingest.sentry.io/6135478';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
      options.reportSilentFlutterErrors = true;
    },
    appRunner: () => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<SessionProvider>(
            create: (c) => SessionProvider( ), //required
          ),
          // ChangeNotifierProvider<CategoryStreamProvider>(
          //   create: (c) => CategoryStreamProvider(),
          // ),
          ChangeNotifierProvider<PlacesProvider>(
            create: (c) => PlacesProvider(),
          ),
          ChangeNotifierProvider<ReviewProvider>(
            create: (c) => ReviewProvider(),
          ),
          ChangeNotifierProvider<HomeImageProvider>(
            create: (c) => HomeImageProvider(),
          ),
        ],
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: data,
          title: 'CPR',
          home: SplashScreen(),
          navigatorObservers: [
            FirebaseAnalyticsObserver(analytics: analytics),
          ],
        ),
      ),
    ),
  );



}
