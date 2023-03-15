import 'package:cpr_user/pages/common/components/cpr_button.dart';
import 'package:cpr_user/pages/common/components/cpr_input_with_label.dart';
import 'package:cpr_user/providers/configure_provider.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as p;

class ConfigurePage extends StatefulWidget {
  @override
  _ConfigurePageState createState() => _ConfigurePageState();
}

class _ConfigurePageState extends State<ConfigurePage> {
  var dataLoaded = false;

  @override
  Widget build(BuildContext context) {
    var provider = p.Provider.of<SessionProvider>(context, listen: false);

    return p.ChangeNotifierProvider(
      create: (context) => ConfigureProvider(provider),
      child: Builder(builder: (context) {
        var configureProvider = p.Provider.of<ConfigureProvider>(context);
        return SingleChildScrollView(
          child: Container(
            // color: Colors.,
            child: Column(
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      CPRInputWithLabel(
                        label: 'Display Name',
                        controller: configureProvider.displayName,
                        hint: 'Your Display Name',
                      ),
                      CPRInputWithLabel(
                        label: 'Birthday',
                        controller: configureProvider.birthday,
                      ),
                      CPRInputWithLabel(
                        label: 'Country Code',
                        controller: configureProvider.countryCode,
                      ),
                      CPRInputWithLabel(
                        label: 'Mobile',
                        hint: 'Mobile Number',
                        controller: configureProvider.mobile,
                      ),
                      CPRInputWithLabel(
                        label: 'Gender',
                        controller: configureProvider.gender,
                      ),
                      CPRInputWithLabel(
                        label: 'Marital Status',
                        controller: configureProvider.maritalStatus,
                      ),
                    ],
                  ),
                ),
                LayoutBuilder(
                  builder: (context, constrant) {
                    return Container(
                      padding: const EdgeInsets.only(top: 5),
                      child: Builder(builder: (context) {
                        if (configureProvider.busy) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        return Row(
                          children: <Widget>[
                            Expanded(
                              flex: 10,
                              child: CPRButton(
                                borderRadius: 10,
                                verticalPadding: 16,
                                onPressed: () async {
                                  try {
                                    configureProvider.startLoading();
                                    await configureProvider.updateUser();
                                  } catch (e) {}
                                  configureProvider.stopLoading();
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "Update",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(),
                              flex: 1,
                            ),
                            Expanded(
                              flex: 10,
                              child: CPRButton(
                                borderRadius: 10,
                                color: CPRColors.googleRed,
                                verticalPadding: 16,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          ],
                        );
                      }),
                    );
                  },
                )
              ],
            ),
          ),

          // CPRBackButton()
        );
      }),
    );
  }
}
