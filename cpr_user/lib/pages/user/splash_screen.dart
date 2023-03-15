import 'package:cpr_user/constants/cpr_routes.dart';
import 'package:cpr_user/pages/common/components/cpr_loading.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:cpr_user/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as p;
import 'package:sentry/sentry.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: CPRLoading(),
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      SessionProvider provider = context.read<SessionProvider>();
      try {
        AuthService().findCurrentUser().then((user) {
          if (user == null || user.email == null) {
            CPRRoutes.loginScreen(context);
          } else {
            provider.firebaseUser = user;
            provider.findUserInformation().then((onValue) {
              if (provider.user != null) {
                CPRRoutes.navigationPage(context);
                provider.loadCategorizedPlaces().then((val2) {
                  //  print(DateTime.now());
                  provider.getExternalPromotions();
                  provider.getUserCoupons();
                  provider.findCurrentLocation().then((v) {
                    //  print(DateTime.now());
                    // CPRRoutes.navigationPage(context);
                  });
                });
              } else {}
            }).catchError((onError){
              CPRRoutes.loginScreen(context);
            });
          }
        }).catchError((onError) {
          CPRRoutes.loginScreen(context);
        });
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    });

  }
}

