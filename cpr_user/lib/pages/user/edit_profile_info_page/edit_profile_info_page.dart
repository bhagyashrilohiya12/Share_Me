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

class EditProfileInfoPage extends StatefulWidget {

  @override
  _EditProfileInfoPageState createState() => _EditProfileInfoPageState();
}

class _EditProfileInfoPageState extends State<EditProfileInfoPage> {
  var _emailController = TextEditingController();
  var _zipCodeController = TextEditingController();
  var _usernameController = TextEditingController();
  var _firstnameController = TextEditingController();
  var _lastnameController = TextEditingController();
  var _formKey = GlobalKey<FormState>();

  Genders? selectedGender;
  Religions? selectedReligion;
  DateTime? selectedDate;
  List<Genders> genders = [];
  List<Religions> religions = [];
  bool isUserNameFree = true;
  bool isUserNameFreeProgress = false;
  UserService? userService;

  @override
  void initState() {
    genders = Genders.getGendersList();
    religions = Religions.getReligionsList();
    userService = new UserService();
    super.initState();
  }

  SessionProvider? provider;

  @override
  Widget build(BuildContext context) {
    Log.i( "page - EditProfileInfoPage - build");

    provider = p.Provider.of<SessionProvider>(context);

    if(_emailController.text==null || _emailController.text.trim().length==0)
    setState(() {
      _usernameController.text = provider!.user!.username!;
      _firstnameController.text = provider!.user!.firstName!;
      _lastnameController.text = provider!.user!.surname!;
      _emailController.text = provider!.user!.email!;
      _zipCodeController.text = provider!.user!.zipCode!;
      selectedDate = provider!.user!.dateOfBirth!;
      try {
        selectedGender = genders.firstWhere((element) => element.id==provider!.user?.gender);
      } catch (e) {
        print(e);
      }
      try {
        selectedReligion= religions.firstWhere((element) => element.id==provider!.user?.religion);
      } catch (e) {
        print(e);
      }
    });

    // return  _getContent();


    //
    return Scaffold(
      appBar: getAppBar(),
      body: _getContent(provider!),
    );
  }

  AppBar getAppBar(){
    return AppBar(
      // title: Text("Edit Profile"),
      title: Text("Personal Information"),
      // title: Text("Edit",style: TextStyle(
      //     color: Colors.black,
      //     fontSize: 20,
      //     fontWeight: FontWeight.bold
      // ),),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: CPRColors.appBarBackButtonColor,
      actions: [
        // IconButton(onPressed:(){
        //
        // }, icon: Icon(Icons.message,color: Colors.black,size: 30,)),
      ],
    );
  }

  void showMessage(BuildContext context, message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 1500),
        content: Text(message),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      ),
    );
  }

  Widget _getContent(SessionProvider  provider) {
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
                          Column(
                            children: <Widget>[
                              CPRLogo(
                                widgetSize: 40,
                              ),


                              /**
                               *
                               *  //abdallah
                                  Padding(
                                  padding: const EdgeInsets.only(right: 8.0, left: 8, bottom: 8),
                                  child: Text(
                                  "Personal Information",
                                  style: CPRTextStyles.avatarProfileNameStyle.apply(color: Colors.black),
                                  ),
                                  )
                               */


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
                                  bool isUserNameFreeTemp = await userService!.isUsernameFree(v.trim(),userEmail: provider.user?.email);
                                  setState(() {
                                    isUserNameFree = isUserNameFreeTemp;
                                    isUserNameFreeProgress = false;
                                  });
                                } else {
                                  setState(() {

                                    isUserNameFree = false ; //#abdo
                                    isUserNameFreeProgress = false;
                                  });
                                }
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
                          IgnorePointer(
                            ignoring: true,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CPRLoginTextFormField(
                                controller: _emailController,
                                color: Colors.black,
                                icon: MaterialCommunityIcons.email,
                                hintText: "Email",
                              ),
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
                                    print('Date  change $date');
                                  }, onConfirm: (date) {
                                    print('confirm $date');
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
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: CPRButton(
                          borderRadius: CPRDimensions.loginTextFieldRadius,
                          verticalPadding: 16,
                          color: CPRColors.cprButtonPink,
                          onPressed: () async {
                            FocusScope.of(scaffoldContext).unfocus();

                            if (_formKey.currentState!.validate()) {
                              if (isUserNameFree != null &&
                                  isUserNameFree &&
                                  _usernameController.text.trim().length > 4) {
                                if (RegExp(r"^[a-z0-9][a-z0-9\- ]{0,10}[a-z0-9]$", caseSensitive: false)
                                    .hasMatch(_zipCodeController.text.trim())) {
                                  if (selectedDate != null) {

                                    try {
                                      provider.startLoading();
                                      provider.user!.username = _usernameController.text.trim();
                                      provider.user!.firstName = _firstnameController.text.trim();
                                      provider.user!.surname = _lastnameController.text.trim();
                                      provider.user!.zipCode = _zipCodeController.text.trim();
                                      provider.user!.gender = selectedGender != null ? selectedGender!.id : null;
                                      provider.user!.religion = selectedReligion != null ? selectedReligion!.id : null;
                                      provider.user!.dateOfBirth = selectedDate;
                                      await provider.updateUser();

                                      provider.stopLoading();
                                      showMessage(scaffoldContext, "Information successfully updated");
                                      Future.delayed(Duration(seconds: 3),(){
                                        CPRRoutes.navigationPage(context);
                                      });
                                    } catch (exception, e) {
                                      print(exception.toString() );
                                      showMessage(scaffoldContext, exception.toString() );
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

                            provider.stopLoading();
                            // await login(scaffoldContext);
                          },
                          child: Text(
                            "Update Info",
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
}
