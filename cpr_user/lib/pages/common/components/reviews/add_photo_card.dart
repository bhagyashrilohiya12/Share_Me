import 'dart:io';

import 'package:cpr_user/constants/cpr_routes.dart';
import 'package:cpr_user/helpers/image_helper.dart';
import 'package:cpr_user/pages/common/components/cpr_button.dart';
import 'package:cpr_user/pages/common/components/cpr_card.dart';
import 'package:cpr_user/providers/review_manager_provider.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart' as p;

class AddPhotoCard extends StatelessWidget {
  final ReviewManagerProvider provider;
  final bool create;
  //final ImageHelper imageHelper;

  AddPhotoCard(this.provider, {this.create = true});
  //const AddPhotoCard(this.provider, this.imageHelper, {Key key, this.create = true})

  @override
  Widget build(BuildContext context) {
//    var provider = Provider.of<AddReviewProvider>(context);

    var session = p.Provider.of<SessionProvider>(context, listen: false);
    return Column(
      children: <Widget>[
        CPRCard(
          // height: 130,
          title: const Text(
            "Photos",
            style: CPRTextStyles.cardTitleBlack,
          ),
          subtitle: Text(
            "Add the photos taken ${provider.place != null ? "in ${provider.place!.name}" : ""}",
            style: CPRTextStyles.cardSubtitleBlack,
          ),
          backgroundColor: Colors.white,
          icon: MaterialCommunityIcons.camera,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Builder(builder: (context) {
              return Wrap(
                children: <Widget>[
                  if (provider.hasImagesInReview)
                    ...provider.review!.images!
                        .map(
                          (f) => GestureDetector(
                            onTap: () {
                              CPRRoutes.photoView(context,
                                  url: provider.getImageUrl(f));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Container(
                                height: 65,
                                width: 65,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image:
                                        NetworkImage(provider.getImageUrl(f)),
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
                                            provider.removeRemoteImage(f);
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
                        .toList(),
                  if (provider.images != null && provider.images.isNotEmpty)
                    ...provider.images
                        .map(
                          (f) => ItemImageSelected(context, provider, f),
                        )
                        .toList(),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          builder: (modalContext) => session.imageHelper
                              .showPicker(modalContext, provider.addImage),
                          context: context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Container(
                        height: 65,
                        width: 65,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 1)),
                        child: Icon(
                          MaterialCommunityIcons.plus_circle_outline,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }


  ItemImageSelected(BuildContext context, ReviewManagerProvider provider, File f) {
    Log.i( "ItemImageSelected() - f: " + f.toString() );
    return GestureDetector(
      onTap: () {
        CPRRoutes.photoView(context, path: f.path);
      },
      child: Padding(
        padding: const EdgeInsets.all(2),
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
                      provider.removeImage(f);
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
    );
  }
}
