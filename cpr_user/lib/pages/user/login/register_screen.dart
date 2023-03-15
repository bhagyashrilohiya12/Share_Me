import 'package:cpr_user/constants/Genders.dart';
import 'package:cpr_user/constants/Religions.dart';
import 'package:cpr_user/constants/cpr_routes.dart';
import 'package:cpr_user/helpers/fcm_helper.dart';
import 'package:cpr_user/pages/common/components/cpr_button.dart';
import 'package:cpr_user/pages/common/components/cpr_container.dart';
import 'package:cpr_user/pages/common/components/cpr_loading.dart';
import 'package:cpr_user/pages/common/components/cpr_login_text_form_field.dart';
import 'package:cpr_user/pages/common/components/cpr_logo.dart';
import 'package:cpr_user/pages/user/login/components/map_only_for_show_widget.dart';
import 'package:cpr_user/pages/user/map/map_for_get_location_screen.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:cpr_user/services/user_service.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart' as p;
import 'package:cpr_user/helpers/string_helper.dart';

class RegisterScreen extends StatefulWidget {
  // RegisterScreen({Key key}) : super(key: key);

  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var _emailController = TextEditingController();
  var _zipCodeController = TextEditingController();
  var _usernameController = TextEditingController();
  var _firstnameController = TextEditingController();
  var _lastnameController = TextEditingController();
  var _passController = TextEditingController();
  var _confirmPassController = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  bool termsAndConditions = false;
  Genders? selectedGender;
  Religions? selectedReligion;
  DateTime? selectedDate;
  List<Genders> genders = [];
  List<Religions> religions = [];
  bool isUserNameFree = false ;
  bool isUserNameFreeProgress = false;
  UserService? userService;

  @override
  void initState() {
    genders = Genders.getGendersList();
    religions = Religions.getReligionsList();
    userService = new UserService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Builder(
            builder: (scaffoldContext) {
              return SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 10, top: 32),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                child: GestureDetector(
                                  onTap: () => {Navigator.of(context).pop()},
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
                                padding: const EdgeInsets.only(right: 8.0, left: 8, bottom: 8),
                                child: Text(
                                  "Personal Information",
                                  style: CPRTextStyles.avatarProfileNameStyle.apply(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CPRLoginTextFormField(
                              controller: _usernameController,
                              color: Colors.black,
                              icon: MaterialCommunityIcons.account,
                              hintText: "UserName (at least 4 character)",
                              onChanged: (String v) async {
                                if (v.isNotEmpty && v.length >= 4) {
                                  setState(() {
                                    isUserNameFreeProgress = true;
                                  });
                                  bool isUserNameFreeTemp = await userService!.isUsernameFree(v.trim());
                                  Log.i( "CPRLoginTextFormField - change - isUserNameFreeTemp: " + isUserNameFreeTemp.toString());
                                  setState(() {
                                    isUserNameFree = isUserNameFreeTemp;
                                    isUserNameFreeProgress = false;
                                  });
                                } else {
                                  setState(() {
                                    isUserNameFree = false ;
                                    isUserNameFreeProgress = false;
                                  });
                                }

                                //log
                                Log.i( "CPRLoginTextFormField - change - v: " + v.toString());

                                Log.i( "CPRLoginTextFormField - change - isUserNameFree: " + isUserNameFree.toString());
                                Log.i( "CPRLoginTextFormField - change - isUserNameFreeProgress: " + isUserNameFreeProgress.toString());

                              },
                              progress: SizedBox(
                                width: 24,
                                height: 24,
                                child: isUserNameFreeProgress
                                    ? SpinKitThreeBounce(
                                        color: Theme.of(context).accentColor,
                                        size: 12,
                                      )
                                    : isUserNameFree != null
                                        ? isUserNameFree
                                            ? Icon(
                                                Icons.check,
                                                color: Colors.green,
                                              )
                                            : Icon(
                                                Icons.close,
                                                color: Colors.red,
                                              )
                                        : SizedBox(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CPRLoginTextFormField(
                              controller: _firstnameController,
                              color: Colors.black,
                              icon: MaterialCommunityIcons.account,
                              hintText: "First Name",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CPRLoginTextFormField(
                              controller: _lastnameController,
                              color: Colors.black,
                              icon: MaterialCommunityIcons.account,
                              hintText: "Surname",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CPRLoginTextFormField(
                              controller: _emailController,
                              color: Colors.black,
                              icon: MaterialCommunityIcons.email,
                              hintText: "Email",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CPRLoginTextFormField(
                              controller: _zipCodeController,
                              color: Colors.black,
                              icon: MaterialCommunityIcons.post,
                              hintText: "Zip/Post Code",
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.black, width: 0.5)),
                            width: MediaQuery.of(context).size.width,
                            child: DropdownButton<String>(
                              isExpanded: true,
                              hint: Text(
                                'Please choose Your Gender',
                                style: TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                              items: genders.map((Genders value) {
                                return DropdownMenuItem<String>(
                                  value: value.name,
                                  child: Text(value.name),
                                );
                              }).toList(),
                              value: selectedGender != null ? selectedGender!.name : null,
                              underline: SizedBox(),
                              onChanged: (v) {
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  selectedGender = genders.firstWhere((element) => element.name == v);
                                });
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.black, width: 0.5)),
                            width: MediaQuery.of(context).size.width,
                            child: DropdownButton<String>(
                              isExpanded: true,
                              hint: Text(
                                'Please choose Your Religion',
                                style: TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                              items: religions.map((Religions value) {
                                return DropdownMenuItem<String>(
                                  value: value.name,
                                  child: Text(value.name),
                                );
                              }).toList(),
                              value: selectedReligion != null ? selectedReligion!.name : null,
                              underline: SizedBox(),
                              onChanged: (v) {
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  selectedReligion = religions.firstWhere((element) => element.name == v);
                                });
                              },
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              DatePicker.showDatePicker(context,
                                  showTitleActions: true,
                                  minTime: DateTime(1900, 1, 1),
                                  maxTime: DateTime.now().add(Duration(days: -(365 * 18))), onChanged: (date) {
                            //    print('Date  change $date');
                              }, onConfirm: (date) {
                              //  print('confirm $date');
                                setState(() {
                                  selectedDate = date;
                                });
                              },
                                  currentTime: selectedDate != null ? selectedDate : DateTime.now(),
                                  locale: LocaleType.en);
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.black, width: 0.5)),
                              width: MediaQuery.of(context).size.width,
                              height: 42,
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    selectedDate != null
                                        ? "${selectedDate!.month.toString().padLeft(2, "0")}/${selectedDate!.day.toString().padLeft(2, "0")}/${selectedDate!.year}"
                                        : "Please Select Your Birth Date",
                                    style: TextStyle(color: selectedDate != null ? Colors.black : Colors.grey),
                                  )),
                                  Icon(Icons.cake)
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CPRLoginTextFormField(
                              controller: _passController,
                              color: Colors.black,
                              oscureText: true,
                              icon: MaterialCommunityIcons.key,
                              hintText: "Password",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CPRLoginTextFormField(
                              controller: _confirmPassController,
                              color: Colors.black,
                              oscureText: true,
                              icon: MaterialCommunityIcons.key,
                              hintText: "Confirm Password",
                            ),
                          ),
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: <Widget>[
                              Checkbox(
                                value: termsAndConditions,
                                onChanged: (b) => setState(() => {termsAndConditions = b!}),
                              ),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(children: [
                                    TextSpan(text: "I agree to your ", style: TextStyle(color: Colors.black)),
                                    TextSpan(
                                        text: "terms and conditions",
                                        style: TextStyle(fontWeight: FontWeight.bold, color: CPRColors.cprButtonPink))
                                  ]),
                                ),
                              )
                            ],
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: CPRButton(
                          borderRadius: CPRDimensions.loginTextFieldRadius,
                          verticalPadding: 16,
                          color: CPRColors.cprButtonPink,
                          onPressed: () async {
                            FocusScope.of(scaffoldContext).unfocus();
                            if (termsAndConditions) {
                              if (_formKey.currentState!.validate()) {
                                if (isUserNameFree != null &&
                                    isUserNameFree &&
                                    _usernameController.text.trim().length > 4) {
                                  if (RegExp(r"^[a-z0-9][a-z0-9\- ]{0,10}[a-z0-9]$", caseSensitive: false)
                                      .hasMatch(_zipCodeController.text.trim())) {
                                    if (selectedDate != null) {
                                      if (_passController.text == _confirmPassController.text) {
                                        try {
                                          provider.startLoading();
                                          String fcmToken = await FcmHelper.getToken();
                                          await provider.register(
                                              email: _emailController.text,
                                              password: _passController.text,
                                              username: _usernameController.text,
                                              firstName: _firstnameController.text.capitalize(),
                                              lastName: _lastnameController.text.capitalize(),
                                              birthDate: selectedDate!,
                                              gender: selectedGender != null ? selectedGender!.id : 0,
                                              religion: selectedReligion != null ? selectedReligion!.id : 0,
                                              zipCode: _zipCodeController.text.trim(),
                                              fcmToken: fcmToken);

                                          await provider.loadCategorizedPlaces();

                                          try {
                                            await provider.findCurrentLocation();
                                          } catch (e) {}
                                          provider.stopLoading();
                                          CPRRoutes.navigationPage(context);
                                        } catch (  e) {
                                          print(e.toString() );
                                          showMessage(scaffoldContext, e.toString()  );
                                        }
                                      } else {
                                        showMessage(scaffoldContext, "The passwords does not match");
                                      }
                                    } else {
                                      showMessage(scaffoldContext, "Please Choose Your Birth Date");
                                    }
                                  } else {
                                    showMessage(scaffoldContext, "Please Enter A Valid Zip/Post Code");
                                  }
                                } else {
                                  showMessage(scaffoldContext, "Please Enter a Valid and Free Username");
                                }
                              }
                            } else {
                              showMessage(scaffoldContext, "Please accept the terms and conditions");
                            }
                            provider.stopLoading();
                            // await login(scaffoldContext);
                          },
                          child: Text(
                            "Register",
                            style: CPRTextStyles.buttonSmallWhite.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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
        duration: Duration(milliseconds: 1500),
        content: Text(message),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      ),
    );
  }
}
