// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cpr_user/helpers/image_helper.dart';
import 'package:cpr_user/helpers/other_helper.dart';
import 'package:cpr_user/helpers/string_helper.dart';
import 'package:cpr_user/helpers/user_helper.dart';
import 'package:cpr_user/models/place.dart';
import 'package:cpr_user/models/review.dart';
import 'package:cpr_user/pages/common/components/cpr_button.dart';
import 'package:cpr_user/pages/common/components/cpr_container.dart';
import 'package:cpr_user/pages/common/components/cpr_loading.dart';
import 'package:cpr_user/pages/common/components/cpr_page_title.dart';
import 'package:cpr_user/pages/common/components/location_card.dart';
import 'package:cpr_user/pages/common/components/review_text_field.dart';
import 'package:cpr_user/pages/common/components/reviews/add_photo_card.dart';
import 'package:cpr_user/pages/common/components/reviews/add_video_card.dart';
import 'package:cpr_user/pages/common/components/reviews/select_place_card.dart';
import 'package:cpr_user/pages/common/components/share_bottom_sheet.dart';
import 'package:cpr_user/pages/user/review_manager/components/additional_info_card.dart';
import 'package:cpr_user/pages/user/review_manager/components/rating_cards.dart';
import 'package:cpr_user/pages/user/review_manager/components/select_date_card.dart';
import 'package:cpr_user/pages/user/social_media/social_media_page.dart';
import 'package:cpr_user/providers/places_provider.dart';
import 'package:cpr_user/providers/review_manager_provider.dart';
import 'package:cpr_user/providers/review_provider.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:extended_image/extended_image.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart' as p;

import '../../../helpers/social_post_helper.dart';

class ReviewManagerPage extends StatefulWidget {
  Review? review; //case edit object

  Place? place;
  bool usePromotion = false;
  bool? canDeleteDraftReview;

  //final String categoryName;
  //final GeoPoint userLocation;

  ReviewManagerPage(
      {this.review,
      this.place,
      this.usePromotion = false,
      this.canDeleteDraftReview = false});

  @override
  _ReviewManagerPageState createState() {
    Log.i("ReviewManagerPage - createState");
    return _ReviewManagerPageState(
        review: review, place: place, usePromotion: usePromotion);
    ;
  }
}

class _ReviewManagerPageState extends State<ReviewManagerPage>
    with SingleTickerProviderStateMixin {
  List<File> images = [];
  Place? place;
  bool usePromotion = false;
  Review? review;

  /**
   * Abdo documenation
   * create = ture; when create new review
   * create = false: when edit old review
   */

  bool create = true;

  ImageHelper imageHelper = ImageHelper();
  var _openerContext;
  final _firstNode = FocusNode();
  final _secondNode = FocusNode();
  final _thirdNode = FocusNode();
  final _fourthNode = FocusNode();
  final _fifthNode = FocusNode();

  _ReviewManagerPageState(
      {Review? review, Place? place, bool usePromotion = false}) {
    Log.i("_ReviewManagerPageState - constructor");
    this.review = review;
    this.usePromotion = usePromotion; //?? false

    /**
     * documentation
     * create = ture; when create new review
     * create = false: when edit old review
     */
    if (place == null && review != null) {
      this.place = review.place;

      create = false;

      //todo:16/09/22 :getting review object..from previous page
      this.review = review;
    } else {
      this.place = place;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    _firstNode.dispose();
    _secondNode.dispose();
    _thirdNode.dispose();
    _fourthNode.dispose();
    _fifthNode.dispose();
  }

  double? width;
  SessionProvider? userProvider;

  @override
  Widget build(BuildContext context) {
    Log.i("page - _ReviewManagerPageState - build");

    userProvider = p.Provider.of<SessionProvider>(context, listen: false);
    _openerContext = context;
    width = MediaQuery.of(context).size.width * 0.45;

    return p.ChangeNotifierProvider(
      create: (context) => ReviewManagerProvider(
          rev: this.review,
          place: this.place,
          userId: userProvider!.user!.email!),
      child: CPRContainer(
          loadingWidget: p.Consumer<ReviewManagerProvider>(
            builder: (context, provider, _) {
              return CPRLoading(
                loading: provider.busy,
              );
            },
          ),
          child:
              getPageContent() //  EmptyView.allDeviceScreen(context) //getPageContent(),
          ),
    );
  }

  Widget buildSharingMenu(BuildContext bottomSheetContext) {
    var provider = p.Provider.of<ReviewManagerProvider>(bottomSheetContext);
    return ShareBottomSheet(
      provider.review!,
      closeableContext: _openerContext,
    );
  }

  Positioned _buildBackButton(BuildContext context) {
    return Positioned(
      top: 50,
      left: 20,
      child: Row(
        children: <Widget>[
          Material(
            elevation: 8,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
                height: 40,
                width: 40,
                child: IconButton(
                  color: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    MaterialCommunityIcons.chevron_left,
                    color: Colors.black,
                    size: 25,
                  ),
                )),
          ),
        ],
      ),
    );
  }

  _saveDraft(
      ReviewManagerProvider provider,
      BuildContext reviewProviderContext,
      SessionProvider userProvider,
      ReviewProvider reviewProvider,
      placeProvider) async {
    try {
      if (provider.place == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("A place must be provided to save draft."),
        ));
        return;
      }

      provider.startLoading();
      _fillReview(provider, userProvider);
      await reviewProvider
          .saveDraftReview(provider.review!, userProvider.user!.email!,
              images: provider.images,
              videos: provider.videos,
              isUpdate: widget.review != null)
          .then((v) {
//          Scaffold.of(_openerContext).showSnackBar(SnackBar(content: Text("Review draft saved"),));
        Navigator.of(reviewProviderContext).pop();
        provider.stopLoading();
      });
      await userProvider.loadCategorizedPlaces();
    } catch (e) {
      provider.stopLoading();
    }
  }

  _fillReview(ReviewManagerProvider provider, userProvider) {
    try {
      provider.review!.address = provider.place!.address;
      provider.review!.archived = false;
      provider.review!.businessDisplayName = provider.place!.displayName;
      provider.review!.category = provider.place!.parentCategory;
      provider.review!.service = provider.secondInputController.text.trim();
      provider.review!.reasonOfVisit =
          provider.thirdInputController.text.trim();
      provider.review!.companion = provider.fourthInputController.text.trim();
      provider.review!.comments = provider.fifthInputController.text.trim();
      provider.review!.usePromotion = provider.usePromotion;
      provider.review!.promotion = provider.selectedPromotion;
      if (provider.selectedPromotion != null)
        provider.review!.promotionDocId =
            provider.selectedPromotion!.documentID;
      if (provider.selectedEmployee != null &&
          provider.selectedEmployee!.id != null) {
        //  print("Getting selected emp details");
        provider.review!.serverId = provider.selectedEmployee!.id;
        provider.review!.server = provider.selectedEmployee;
      } else {
        print("Failed to get selected emp details");

        provider.review!.serverName = provider.firstInputController.text;
      }
      if (create) {
        provider.review!.creationTime = DateTime.now();
      }
      provider.review!.place = provider.place;
      provider.review!.placeID = provider.place!.googlePlaceID;
      provider.review!.location = provider.place!.coordinate;
      provider.review!.locationName = provider.place!.name;
      provider.review!.userID = userProvider.user.documentID;
      provider.review!.userUsername = userProvider.user.username;
      provider.review!.userDisplayName = userProvider.user.displayName;
      provider.review!.userProfilePictureURL =
          userProvider.user.profilePictureURL;

      //set default rating
      if (provider.review!.rating == null) {
        provider.review!.rating = 3;
      }
    } catch (e) {
      print("Error filling fields in the review $e");
    }
  }

  _saveReview(ReviewManagerProvider provider, reviewProviderContext,
      userProvider, ReviewProvider reviewProvider, placeProvider) async {
    if (provider.review!.realRating == null) {
      provider.review!.realRating = findRealReviewByWeighting(
          userProvider.userLevel,
          review: provider.review!.rating ?? 3);
    }

    if (provider.place == null) {
      ScaffoldMessenger.of(reviewProviderContext).showSnackBar(const SnackBar(
        duration: Duration(milliseconds: 800),
        content: Text("You must select a place first."),
      ));
      return;
    }
    // provider.startLoading();
    if (provider.place!.documentId == null) {
      try {
        provider.place = await placeProvider.addPlace(provider.place);
      } catch (e) {
        print("Error $e");
      }
    }
    if ((provider.images == null || provider.images.isEmpty) &&
        (provider.review!.images == null || provider.review!.images!.isEmpty)) {
      ScaffoldMessenger.of(reviewProviderContext).showSnackBar(
        const SnackBar(
          content: Text("You must add at least 1 image"),
        ),
      );
      return;
    }

    if (provider.secondInputController.text.isEmpty) {
      ScaffoldMessenger.of(reviewProviderContext).showSnackBar(
        const SnackBar(
          content: Text("Please select What Did You Get Done"),
        ),
      );
      return;
    }
    if (provider.thirdInputController.text.isEmpty) {
      ScaffoldMessenger.of(reviewProviderContext).showSnackBar(
        const SnackBar(
          content: Text("Please select Why You Are There"),
        ),
      );
      return;
    }

    if (provider.fourthInputController.text.isEmpty) {
      ScaffoldMessenger.of(reviewProviderContext).showSnackBar(
        const SnackBar(
          content: Text("Please select who you came here with"),
        ),
      );
      return;
    }
    if (provider.usePromotion == null) {
      ScaffoldMessenger.of(reviewProviderContext).showSnackBar(
        const SnackBar(
          content: Text("Please Choose Use Promotion Status"),
        ),
      );
      if (provider.usePromotion && provider.selectedPromotion == null) {
        ScaffoldMessenger.of(reviewProviderContext).showSnackBar(
          const SnackBar(
            content: Text("Please Choose Promotion"),
          ),
        );
      }
      return;
    }

    //check when
    if (provider.review!.when == null) {
      ScaffoldMessenger.of(reviewProviderContext).showSnackBar(
        const SnackBar(
          content: Text("Select Calender Date"),
        ),
      );
      return;
    }

    _fillReview(provider, userProvider);
    setState(() {
      provider.fullReviewController.text = formatReview(provider.review!);
    });

    print(context);
    print(provider);
    print(reviewProvider);
    print(reviewProviderContext);
    showDiloagPreviewReview(
        context, provider, reviewProvider, reviewProviderContext);
  }

  String getPlaceImageUrl(ReviewManagerProvider provider) {
    if (provider.place == null) return "";

    return provider.place!.firstGooglePhotoReference!;
  }

  Widget getPageContent() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: p.Consumer<ReviewManagerProvider>(
                builder: (context, provider, _) {
              return Container(
                height: MediaQuery.of(context).size.height / 1.82,
                decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: ExtendedNetworkImageProvider(
                        OtherHelper.findPhotoReference(
                            size: 1024, photoRef: getPlaceImageUrl(provider)),
                        cache: true),
                  ),
                ),
              );
            }),
          ),
          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 100),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  p.Consumer<ReviewManagerProvider>(
                    builder: (_, provider, __) {
                      Widget w = Container();
                      if (provider.place != null) {
                        w = CPRPageTitle(
                          title: provider.place!.name!,
                        );
                      }
                      return w;
                    },
                  ),
                  p.Consumer<ReviewManagerProvider>(builder: (_, provider, __) {
                    return SelectPlaceCard(provider: provider);
                  }),
                  p.Consumer<ReviewManagerProvider>(builder: (_, provider, __) {
                    return AddPhotoCard(
                      provider,
                      create: create,
                    );
                  }),
                  p.Consumer<ReviewManagerProvider>(builder: (_, provider, __) {
                    return AddVideoCard(
                      provider,
                      create: create,
                    );
                  }),
                  // if (provider.place != null)
                  p.Consumer<ReviewManagerProvider>(
                    builder: (context, provider, _) {
                      if (provider.place == null) {
                        return Container();
                      }
                      return LocationCard(
                          userLocation: userProvider!.currentLocation!,
                          place: provider.place!,
                          context: context,
                          width: width!);
                    },
                  ),
                  SelectDateCard(),
                  additionalInformationQuestion(userProvider, context),
                  RatingCards(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    child: p.Consumer<ReviewManagerProvider>(
                      builder: (reviewProviderContext, provider, _) {
                        var reviewProvider = p.Provider.of<ReviewProvider>(
                            context,
                            listen: false);
                        var placeProvider = p.Provider.of<PlacesProvider>(
                            context,
                            listen: false);
                        return Row(
                          children: <Widget>[
                            if (create)
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: CPRButton(
                                    onPressed: () async {
                                      await _saveDraft(
                                          provider,
                                          reviewProviderContext,
                                          userProvider!,
                                          reviewProvider,
                                          placeProvider);
                                    },
                                    color: CPRColors.cprButtonPink,
                                    width: double.infinity,
                                    borderRadius:
                                        CPRDimensions.loginTextFieldRadius,
                                    child: Center(
                                      child: Text(
                                        "Save Draft",
                                        style: CPRTextStyles.buttonSmallWhite
                                            .copyWith(fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: CPRButton(
                                  onPressed: () async {
                                    await _saveReview(
                                        provider,
                                        reviewProviderContext,
                                        userProvider,
                                        reviewProvider,
                                        placeProvider);
                                  },
                                  width: double.infinity,
                                  borderRadius:
                                      CPRDimensions.loginTextFieldRadius,
                                  child: Center(
                                    child: Text(
                                      "Save Review",
                                      style: CPRTextStyles.buttonSmallWhite
                                          .copyWith(fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  if (widget.canDeleteDraftReview != null &&
                      widget.canDeleteDraftReview == true)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: p.Consumer<ReviewManagerProvider>(
                        builder: (reviewProviderContext, provider, _) {
                          var reviewProvider = p.Provider.of<ReviewProvider>(
                              context,
                              listen: false);
                          return Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: CPRButton(
                                    onPressed: () async {
                                      await reviewProvider.deleteDraftReview(
                                          provider.review!,
                                          provider.review!.downloadURLs ?? [],
                                          userProvider!.user!.email!);

                                      userProvider!.loadCategorizedPlaces();
                                      Get.back();
                                    },
                                    width: double.infinity,
                                    borderRadius:
                                        CPRDimensions.loginTextFieldRadius,
                                    child: Center(
                                      child: Text(
                                        "Delete Draft Review",
                                        style: CPRTextStyles.buttonSmallWhite
                                            .copyWith(fontSize: 14),
                                      ),
                                    ),
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
          _buildBackButton(context),
        ],
      ),
    );
  }

  //----------------------------------------------------------------------- previoew

  void showDiloagPreviewReview(
      BuildContext context,
      ReviewManagerProvider provider,
      ReviewProvider reviewProvider,
      reviewProviderContext) {
    showGeneralDialog(
      context: reviewProviderContext,
      pageBuilder: (context, anim1, anim2) {
        return Container();
      },
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.8),
      barrierLabel: 'Check',
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(anim1),
          child: SafeArea(
            child: Container(
              // height: 400,
              margin: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16
                  // top:   MediaQuery.of(context).size.height * 0.25
                  // bottom: 100
                  ),
              child: _contentOfCardPreview(context, provider, reviewProvider),
              // child: SizedBox( child: _contentOfCardPreview(context, provider, reviewProvider),
              //   height: 400,
              // )
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 250),
    );
  }

  Widget _contentOfCardPreview(BuildContext context,
      ReviewManagerProvider provider, ReviewProvider reviewProvider) {
    return CardViewTemplate.t(
      width: DeviceTools.getPercentageWidth(context, 85),
      height: 300,
      radius_all: 20,
      // color: Colors.black,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(20),
      // ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            //todo:16/9/22: Changes in textInputAction
            child: ReviewTextField(
                textInputAction: TextInputAction.done,
                label: "Review preview",
                controller: provider.fullReviewController,
                validator: (String string) {
                  if (string == null || string.isEmpty) {
                    return "Please add who served you";
                  }
                  return null;
                },
                parentContext: context,
                //nextFocus: secondNode,
                maxLines: 8),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CPRButton(
              horizontalPadding: 5,
              verticalPadding: 20,
              borderRadius: 10,
              child: Text(
                "Confirm and Update",
                style: CPRTextStyles.buttonMediumWhite,
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                FocusScope.of(context).unfocus();
                if (provider.review!.rating == null) {
                  provider.review!.rating = 3.0;
                }
                if (provider.review!.waiting == null) {
                  provider.review!.waiting = 3;
                }
                provider.startLoading();
                try {
                  if (provider.review!.when == null) {
                    provider.review!.when = DateTime.now();
                  }
                  provider.review!.fullReview = provider.fullReviewController
                      .text; //?? formatReview(provider.review!);
                  try {
                    if (!create) {
                      await reviewProvider.editReview(
                          provider.review!, userProvider!.user!,
                          images: provider.images,
                          imagesToRemove: provider.removedImages,
                          videos: provider.images,
                          videosToRemove: provider.removedVideos);

                      SocialPostHelper().editReview(review: provider.review!);
                    } else {
                      Review r = await reviewProvider.createReview(
                          provider.review!, userProvider!.user!,
                          images: provider.images, videos: provider.videos);

                      SocialPostHelper().shareReview(review: provider.review!);
                    }

                    userProvider!.user?.reviews?.add(provider.review!);

                    //delete draft review
                    if (widget.canDeleteDraftReview != null &&
                        widget.canDeleteDraftReview == true) {
                      await reviewProvider.deleteDraftReview(
                          provider.review!,
                          provider.review!.downloadURLs ?? [],
                          userProvider!.user!.email!);
                    }

                    await userProvider!.loadCategorizedPlaces();

                    Navigator.of(_openerContext).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) =>
                                SocialMediaPage(review: provider.review!)));
                    provider.stopLoading();
                  } catch (e) {
                    provider.stopLoading();
                  }
                } catch (e) {
                  provider.stopLoading();
                }
//
              },
            ),
          )
        ],
      ),
    );
  }

  Widget additionalInformationQuestion(
      SessionProvider? userProvider, BuildContext context) {
    return p.Consumer<ReviewManagerProvider>(builder: (_, provider, __) {
      if (provider.usePromotion == null) provider.usePromotion = usePromotion;

      if (provider.employees != null) {
        if (provider.selectedEmployee != null &&
            provider.employees!
                .any((element) => element!.id == provider.selectedEmployee!.id))
          provider.selectedEmployee = provider.employees![provider.employees!
              .indexWhere(
                  (element) => element!.id == provider.selectedEmployee!.id)];
      }

      return AdditionalInfoCard(
        firstInputController: provider.firstInputController,
        secondInputController: provider.secondInputController,
        thirdInputController: provider.thirdInputController,
        fourthInputController: provider.fourthInputController,
        fifthInputController: provider.fifthInputController,
        firstNode: _firstNode,
        secondNode: _secondNode,
        thirdNode: _thirdNode,
        fourthNode: _fourthNode,
        fifthNode: _fifthNode,
        employees: provider.employees!,
        selectedEmployee: provider.selectedEmployee,
        // check this value
        singleSelectedEmployee: provider.singleEmployee,
        onSelectEmployee: (v) {
          provider.selectedEmployee = v;
          provider.notifyListeners();
        },
        promotions: provider.promotions,
        selectedPromotion: provider.selectedPromotion,
        onSelectPromotion: (v) {
          // print("provider.selectedPromotion  $v");
          provider.selectedPromotion = v;
          provider.notifyListeners();
        },
        usePromotion: provider.usePromotion,
        onUsePromotionChange: (v) {
          provider.usePromotion = v;
          if (v &&
              provider.promotions != null &&
              provider.selectedPromotion == null)
            provider.selectedPromotion = provider.promotions.first;
          if (!v) provider.selectedPromotion = null;
          provider.notifyListeners();
        },
      );
    });
  }
}
