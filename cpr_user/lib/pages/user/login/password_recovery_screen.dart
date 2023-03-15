import 'package:cpr_user/constants/cpr_routes.dart';
import 'package:cpr_user/pages/common/components/cpr_button.dart';
import 'package:cpr_user/pages/common/components/cpr_container.dart';
import 'package:cpr_user/pages/common/components/cpr_loading.dart';
import 'package:cpr_user/pages/common/components/cpr_login_text_form_field.dart';
import 'package:cpr_user/pages/common/components/cpr_logo.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart' as p;

class PasswordRecoveryScreen extends StatefulWidget {
  // PasswordRecoveryScreen({Key key}) : super(key: key);

  _PasswordRecoveryScreenState createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  var _emailController = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  bool submitted = false;

  @override
  Widget build(BuildContext context) {
    Log.i( "page - PasswordRecoveryScreen - build");

    var provider = p.Provider.of<SessionProvider>(context);

    return CPRContainer(
      // rounded: true,
      loadingWidget: p.Consumer<SessionProvider>(
        builder: (ctx, provider, _) {
          if (provider.busy) {
            return CPRLoading();
          }
          return Container();
        },
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Builder(
            builder: (scaffoldContext) {
              var formToShow;
              if (submitted) {
                formToShow = [
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Recovery instructions have been sent to your email.",
                          style: CPRTextStyles.cardTitle,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: CPRButton(
                      borderRadius: CPRDimensions.loginTextFieldRadius,
                      verticalPadding: 16,
                      color: CPRColors.cprButtonPink,
                      onPressed: () => Navigator.of(scaffoldContext).pop(),
                      child: Text(
                        "Close",
                        style: CPRTextStyles.buttonSmallWhite.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ];
              } else {
                formToShow = [
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CPRLoginTextFormField(
                          controller: _emailController,
                          color: Colors.black,
                          icon: MaterialCommunityIcons.email,
                          hintText: "Email",
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: CPRButton(
                      borderRadius: CPRDimensions.loginTextFieldRadius,
                      verticalPadding: 16,
                      color: CPRColors.cprButtonPink,
                      onPressed: () async {
                        FocusScope.of(scaffoldContext).unfocus();
                        // if (termsAndConditions) {
                        if (_formKey.currentState!.validate()) {
                          try {
                            provider.startLoading();
                            await provider.passwordReset(
                                email: _emailController.text);
                            setState(() {
                              submitted = true;
                            });
                            provider.stopLoading();
                          } catch (  e) {
                            showMessage(scaffoldContext, e.toString() );
                          }
                        } else {
                          showMessage(scaffoldContext, "Something is wrong!");
                        }
                        // }
                        provider.stopLoading();
                        // await login(scaffoldContext);
                      },
                      child: Text(
                        "Recover Password",
                        style: CPRTextStyles.buttonSmallWhite.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ];
              }

              return SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 10, top: 10),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                child: GestureDetector(
                                  onTap: () => Navigator.of(context).pop(),
                                  child: Icon(Icons.close),
                                ),
                              ),
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              CPRLogo(
                                widgetSize: 40,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 8.0, left: 8, bottom: 8),
                                child: Text(
                                  "Password Recovery",
                                  style: CPRTextStyles.avatarProfileNameStyle
                                      .apply(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                          ...formToShow
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void showMessage(BuildContext context, message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 3000),
        content: Text(message),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
