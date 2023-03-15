import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cpr_user/Widgets/dialog_choose_image_source.dart';
import 'package:cpr_user/constants/main_categories.dart';
import 'package:cpr_user/models/place.dart';
import 'package:cpr_user/pages/common/components/LogoutUI.dart';
import 'package:cpr_user/pages/common/components/cpr_search.dart';
import 'package:cpr_user/pages/user/edit_profile_info_page/edit_profile_info_page.dart';
import 'package:cpr_user/pages/user/user_setting/user_setting_page.dart';
import 'package:cpr_user/providers/places_provider.dart';
import 'package:cpr_user/pages/common/components/cpr_card_top_image.dart';
import 'package:cpr_user/pages/common/components/cpr_confirm_dialog.dart';
import 'package:cpr_user/pages/user/login/login_screen.dart';
import 'package:cpr_user/pages/user/my_profile_page/components/buttons_bar.dart';
import 'package:cpr_user/pages/user/my_profile_page/components/cpr_level.dart';
import 'package:cpr_user/pages/user/my_profile_page/components/follower_following_counter_bar.dart';
import 'package:cpr_user/pages/user/my_profile_page/components/review_counter_bar.dart';
import 'package:cpr_user/pages/user/my_profile_page/components/user_personal_info.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:cpr_user/resource/DrawableProject.dart';
import 'package:cpr_user/resource/validation/ImageProviderValidation.dart';
import 'package:cpr_user/services/auth_service.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart' as p;

class MyProfilePageNew extends StatelessWidget {
  // const MyProfilePageNew({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Log.i( "page - MyProfilePageNew - build() - dialog popup");

    var session = p.Provider.of<SessionProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        margin: EdgeInsets.fromLTRB(16,40,16,16),
        child:SingleChildScrollView(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                      onTap: (){
                        Navigator.of(context).push(new MaterialPageRoute(builder: (context)=>EditProfileInfoPage()));
                      },
                      child: Image(image:AssetImage("assets/images/ic_edit.png"),width: 24,height: 24,)),
                  Expanded(
                    child: Center(
                      child: Column(
                        children: [
                          Image(image:AssetImage("assets/images/ic_cpr_profile.jpg"),height: 64,),
                          SizedBox(height: 32,),
                          Container(
                            width: 100,
                            height: 100,
                            child: Center(
                              child: Stack(
                                children: [
                                  Align(
                                      alignment: Alignment.center,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(200),
                                        child: ImageProviderValidation.chooseImageCacheOrUrl(   session.user!.profilePictureURL ),
                                      )),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      width: 36,
                                      height: 36,
                                      child: GestureDetector(
                                        onTap: () async {
                                          if (FocusScope.of(context).isFirstFocus) {
                                            FocusScope.of(context).requestFocus(new FocusNode());
                                          }
                                          try {
                                            var image = await _getImage(context);
                                            if(image!=null)
                                            session.changeUserProfilePicture(image);
                                          } catch (e) {}
                                        },
                                        child: circleImagePicker(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                      onTap: (){
                        Navigator.of(context).push(new MaterialPageRoute(builder: (context)=>UserSettingPage()));
                      },
                      child: Icon(Icons.settings,size: 24,color: Colors.white,))
                ],
              ),
              SizedBox(height: 16,),
              UserPersonalInfo(),
              SizedBox(height: 16,),
              ReviewCounterBar(),
              SizedBox(height: 16,),
              FollowerFollowingCounterBar(session.user!),
              SizedBox(height: 16,),
              CPRLevel(),
              SizedBox(height: 16,),
              GestureDetector(
                onTap: (){

                  LogoutUI.showDialogCheckOutLogin(context);


                },
                child:  Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.logout,color: Colors.white,),
                    SizedBox(width: 16,),
                    Text("Logout",style: TextStyle(
                        color: Colors.white,
                      fontWeight: FontWeight.w600
                    ),)
                  ],
                ),
              )
            ],
          ),
        )
      ),
    );
  }


  Future<File?>_getImage(BuildContext context) async {
    Log.i( "_getImage() - ");

    //show dialog type
    ImageSource imageSource = await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return DialogChooseImageSource();
          },
        );
      },
    );


    ImagePicker imagePicker = new ImagePicker();
    var image = await imagePicker.getImage(source: imageSource, imageQuality: 75);


    if (image != null) {
      Log.i( "_getImage() - image ImagePicker: " + image.path );
      CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: image.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Crop Image',
                toolbarColor: Theme.of(context).accentColor,
                toolbarWidgetColor: Theme.of(context).primaryColor,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: true),
            IOSUiSettings(minimumAspectRatio: 1.0, aspectRatioLockEnabled: true)
          ]
      );

      if (croppedFile != null) {
        /** ------- #abdo
         * make cast to "File"
         */
        var file =  File( croppedFile.path);
        Log.i( "_getImage() - file: " + file.path );
        return file;
      } else {
        showMessage(context, "No Image Selected !");
      }
    } else {
      showMessage(context, "No Image Selected !");
    }
    return null;
  }

  void showMessage(BuildContext context, message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 1500),
        content: Text(message),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget circleImagePicker() {

    var icon =  Icon(
      Icons.camera_enhance,
      color:  CPRColors.pink_hex, //Colors.red,
      size: 24,
    );
    return icon;

    // var asset = DrawableProject.images( "");
    // return ImageCircleView(image: asset, size: 24, changeSate: (s) {});
  }

}
