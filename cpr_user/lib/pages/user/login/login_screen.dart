import 'package:cpr_user/constants/cpr_routes.dart';
import 'package:cpr_user/helpers/fcm_helper.dart';
import 'package:cpr_user/pages/common/components/cpr_button.dart';
import 'package:cpr_user/pages/common/components/cpr_container.dart';
import 'package:cpr_user/pages/common/components/cpr_header.dart';
import 'package:cpr_user/pages/common/components/cpr_loading.dart';
import 'package:cpr_user/pages/common/components/cpr_logo.dart';
import 'package:cpr_user/pages/user/login/password_recovery_screen.dart';
import 'package:cpr_user/pages/user/login/register_screen.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart' as p;

import '../../common/components/cpr_container.dart';

class LoginScreen extends StatefulWidget {
  // LoginScreen({Key key}) : super(key: key);

  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Log.i("page - LoginScreen - build");

    //print("Loading login screen");
    var provider = p.Provider.of<SessionProvider>(context);
    return CPRContainer(
      loadingWidget: Builder(
        builder: (ctx) {
          if (provider.busy) {
            return CPRLoading();
          }
          return Container();
        },
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Builder(
            builder: (scaffoldContext) {
              return SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20), border: Border.all(width: 1, color: Colors.grey)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: <Widget>[
                              CPRLogo(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  style: const TextStyle(color: Colors.white),
                                  controller: _userController,
                                  decoration: CPRInputDecorations.cprInput.copyWith(
                                    suffixIcon: const Icon(
                                      MaterialCommunityIcons.account,
                                      color: Colors.white,
                                    ),
                                    hintText: "Login",
                                    hintStyle: CPRTextStyles.buttonSmallWhite.copyWith(
                                      fontSize: 14,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(CPRDimensions.loginTextFieldRadius),
                                      borderSide: BorderSide(color: Colors.white, width: 0.5),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(CPRDimensions.loginTextFieldRadius),
                                      borderSide: BorderSide(color: Theme.of(context).accentColor),
                                    ),
                                    contentPadding: EdgeInsets.all(16),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  style: const TextStyle(color: Colors.white),
                                  controller: _passController,
                                  obscureText: true,
                                  decoration: CPRInputDecorations.cprInput.copyWith(
                                    suffixIcon: const Icon(
                                      MaterialCommunityIcons.key,
                                      color: Colors.white,
                                    ),
                                    hintText: "Password",
                                    hintStyle: CPRTextStyles.buttonSmallWhite.copyWith(
                                      fontSize: 14,
                                    ),
                                    labelStyle: TextStyle(color: Colors.white),
                                    helperStyle: TextStyle(color: Colors.white),
                                    contentPadding: EdgeInsets.all(16),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(CPRDimensions.loginTextFieldRadius),
                                      borderSide: BorderSide(color: Colors.white, width: 0.5),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(CPRDimensions.loginTextFieldRadius),
                                      borderSide: BorderSide(color: Theme.of(context).accentColor),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: CPRButton(
                            borderRadius: CPRDimensions.loginTextFieldRadius,
                            verticalPadding: 16,
                            color: CPRColors.cprButtonPink,
                            onPressed: () async {
                              FocusScope.of(scaffoldContext).unfocus();
                              await login(scaffoldContext);
                            },
                            child: Text(
                              "LOGIN",
                              style: CPRTextStyles.buttonSmallWhite.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(35),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    loginWithGoogle(scaffoldContext);
                                    // FocusScope.of(ctx).unfocus();
                                    // await login(ctx);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.transparent,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: CPRColors.googleRed,
                                    ),
                                    child: const Icon(
                                      MaterialCommunityIcons.google,
                                      size: 32,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await loginWithTwitter(scaffoldContext);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.transparent,
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: CPRColors.twitterBlue,
                                    ),
                                    child: const Icon(
                                      MaterialCommunityIcons.twitter,
                                      size: 32,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
//                                  await loginWithFacebook(scaffoldContext);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.transparent,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: CPRColors.facebookBlue,
                                    ),
                                    child: const Icon(
                                      MaterialCommunityIcons.facebook,
                                      size: 32,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              //Create account
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                                  );
                                },
                                child: const Text(
                                  "Create Account",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),

                              //Forgot Password
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (modalContext) {
                                        return FractionallySizedBox(
                                          heightFactor: 0.8,
                                          child: Container(
                                            height: MediaQuery.of(context).size.height,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: PasswordRecoveryScreen(),
                                          ),
                                        );
                                      });
                                  // showGeneralDialog(
                                  //   context: context,
                                  //   pageBuilder: (context, anim1, anim2) {
                                  //     return Container();
                                  //   },
                                  //   barrierDismissible: true,
                                  //   barrierColor: Colors.black.withOpacity(0.8),
                                  //   barrierLabel: 'Check',
                                  //   transitionBuilder:
                                  //       (context, anim1, anim2, child) {
                                  //     return SlideTransition(
                                  //       position: Tween<Offset>(
                                  //         begin: const Offset(0, 1),
                                  //         end: Offset.zero,
                                  //       ).animate(anim1),
                                  //       child: Container(
                                  //         margin: EdgeInsets.symmetric(
                                  //             horizontal: 0, vertical: 150),
                                  //         child: Card(
                                  //           // color: Colors.black,
                                  //           shape: RoundedRectangleBorder(
                                  //             borderRadius:
                                  //                 BorderRadius.circular(20),
                                  //           ),
                                  //           child: PasswordRecoveryScreen(),
                                  //         ),
                                  //       ),
                                  //     );
                                  //   },
                                  //   transitionDuration:
                                  //       Duration(milliseconds: 250),
                                  // );
                                },
                                child: const Text(
                                  "Forgot Password?",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> loginWithGoogle(BuildContext context) async {
    var provider = p.Provider.of<SessionProvider>(context, listen: false);
    try {
      var valid = await provider.signInWithGoogle();
      if (!valid) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("An error has occurred"),
          ),
        );
      } else {
        await findUserInformationAndNavigateToHomeScreen(provider, context);
      }
    } on Exception {
      if (kDebugMode) {
        print("Exception catched");
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

//  Future<void> loginWithFacebook(BuildContext context) async {
//    var provider = p.Provider.of<SessionProvider>(context, listen: false);
//    try {
//      var valid = await provider.signInWithFacebook();
//      if (!valid) {
//        // Scaffold.of(context).showSnackBar(
//        //   SnackBar(
//        //     content: Text("An error has occurred"),
//        //   ),
//        // );
//      } else {
//        await findUserInformationAndNavigateToHomeScreen(provider, context);
//      }
//    } on Exception {
//      print("Exception was threw");
//    } catch (e, stacktrace) {
//      print(e.runtimeType);
//      print(stacktrace);
//      Scaffold.of(context)
//          .showSnackBar(SnackBar(content: Text("Error Login with Facebook")));
//    }
//  }

  Future<void> loginWithTwitter(BuildContext context) async {
    // var provider = Provider.of<SessionProvider>(context, listen: false);
    // try {
    //   var valid = await provider.signInWithTwitter();
    //   if (!valid) {
    //     // Scaffold.of(context).showSnackBar(
    //     //   SnackBar(
    //     //     content: Text("An error has occurred"),
    //     //   ),
    //     // );
    //   } else {
    //     await findUserInformationAndNavigateToHomeScreen(provider, context);
    //     // CPRRoutes.splashScreen(context);
    //   }
    // } catch (e) {
    //   Scaffold.of(context).showSnackBar(SnackBar(content: Text("$e")));
    //   print("Error while login with twitter");
    // }
  }

  Future<void> login(BuildContext ctx) async {
    var provider = p.Provider.of<SessionProvider>(ctx, listen: false);
    try {
      provider.startLoading();
      await provider.signInWithEmailAndPassword(_userController.text, _passController.text);
      await findUserInformationAndNavigateToHomeScreen(provider, ctx);
      String fcmToken = await FcmHelper.getToken();
      provider.user!.fcmToken = fcmToken;
      provider.updateUser();
      provider.stopLoading();
    } catch (e) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
      provider.stopLoading();
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> findUserInformationAndNavigateToHomeScreen(SessionProvider provider, context) async {
    try {
      await provider.findUserInformation();
      await provider.loadCategorizedPlaces();
      await provider.getExternalPromotions();
      await provider.getUserCoupons();
      try {
        await provider.findCurrentLocation();
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
      }

      CPRRoutes.navigationPage(context);
    } catch (e) {}
  }
}
