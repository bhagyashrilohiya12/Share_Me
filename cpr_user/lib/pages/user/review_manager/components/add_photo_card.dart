import 'dart:io';
import 'dart:typed_data';

import 'package:cpr_user/constants/cpr_routes.dart';
import 'package:cpr_user/helpers/image_helper.dart';
import 'package:cpr_user/pages/common/components/cpr_button.dart';
import 'package:cpr_user/pages/common/components/cpr_card.dart';
import 'package:cpr_user/providers/review_manager_provider.dart';
import 'package:cpr_user/resource/WaitTools.dart';
import 'package:cpr_user/resource/toast/ToolsToast.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:extended_image/extended_image.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart' as p;
import 'package:cpr_user/providers/session_provider.dart';
import 'package:image_picker/image_picker.dart';

class AddPhotoCard extends StatelessWidget {
  // const AddPhotoCard({Key key}) : super(key: key);
  SessionProvider? session;
  ReviewManagerProvider? provider;

  @override
  Widget build(BuildContext context) {
    provider = p.Provider.of<ReviewManagerProvider>(context);
    session = p.Provider.of<SessionProvider>(context);

    return Column(
      children: <Widget>[
        CPRCard(
          title: Text(
            "Add Photos",
            style: CPRTextStyles.cardTitle,
          ),
          subtitle: Text(
            "subtitle goes here",
            style: CPRTextStyles.cardSubtitle,
          ),
          icon: MaterialCommunityIcons.camera,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Builder(builder: (context) {
              return CPRButton(
                borderRadius: CPRDimensions.loginTextFieldRadius,
                width: MediaQuery.of(context).size.width / 2,
                color: CPRColors.cprButtonGreen,
                onPressed: () {
                  Scaffold.of(context).showBottomSheet(
                    (_) {
                      return Container(
                        height: 100,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius:
                                  5, // has the effect of softening the shadow
                              spreadRadius:
                                  4.0, // has the effect of extending the shadow
                              offset: Offset(
                                8, // horizontal, move right 10
                                8, // vertical, m
                              ),
                            )
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextButton(
                              onPressed: () {
                                session!.imageHelper.getImageFromCamera().then(
                                  (onValue) {
                                    if (onValue != null) {
                                      provider!.addImage(onValue);
                                      Navigator.pop(context);
                                    }
                                  },
                                );
                              },
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(MaterialCommunityIcons.camera),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Camera"),
                                  )
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                await _galleryPickerClick(context, session!);
                              },
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                          MaterialCommunityIcons.image_area)),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Gallery"),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Text(
                  "Add Photo",
                  style: CPRTextStyles.buttonMediumWhite,
                ),
              );
            }),
          ),
        ),
        if ((provider!.images != null && provider!.images.isNotEmpty) ||
            (provider!.review!.images != null &&
                provider!.review!.images!.isNotEmpty))
          CPRCard(
            title: Text(
              "Photos",
              style: CPRTextStyles.cardTitle,
            ),
            subtitle: Text(
              "subtitle goes here",
              style: CPRTextStyles.cardSubtitle,
            ),
            icon: MaterialCommunityIcons.image,
            child: Container(
              // color: Colors.blue,
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    if (provider!.review!.images != null)
                      ...provider!.review!.images!.map(
                        (f) => GestureDetector(
                          onTap: () {
                            CPRRoutes.photoView(context,
                                path: provider!.getImageUrl(f));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Container(
                              height: 65,
                              width: 65,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: ExtendedNetworkImageProvider(
                                      provider!.getImageUrl(f)),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Container(
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: <Widget>[
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          provider!.removeRemoteImage(f);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.black,
                                              shape: BoxShape.circle),
                                          child: Icon(
                                            MaterialCommunityIcons.close_circle,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ...provider!.images
                        .map(
                          (f) => GestureDetector(
                            onTap: () {
                              CPRRoutes.photoView(context, path: f.path);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Container(
                                height: 65,
                                width: 65,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: FileImage(f),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container(
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: <Widget>[
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            provider!.removeImage(f);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                shape: BoxShape.circle),
                                            child: Icon(
                                              MaterialCommunityIcons
                                                  .close_circle,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList()
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Future _galleryPickerClick(
      BuildContext context, SessionProvider session) async {
    Log.i("_galleryPickerClick()");

    await session.imageHelper.getImageGallery(
        callBackCrop: (bool status, String msg, CroppedFile? croppedFile) {
      if (status == false || croppedFile == null) {
        ToolsToast.i(context, msg);

        //dismiss dialog choose type "Cam or gallery"
        Navigator.pop(context);

        return;
      }

      //dismiss dialog choose type "Cam or gallery"
      Navigator.pop(context);

      //Wait after dismiss dialog
      ToolsWait.waitToDo(300, () {
        //map objects
        File fileFromCrop = File(croppedFile.path);
        provider!.addImage(fileFromCrop);
      });
    });
  }
}
