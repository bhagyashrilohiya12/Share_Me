import 'package:cpr_user/helpers/other_helper.dart';
import 'package:cpr_user/models/business_owner.dart';
import 'package:cpr_user/models/place.dart';
import 'package:cpr_user/models/review.dart';
import 'package:cpr_user/services/business_owner_service.dart';
import 'package:cpr_user/services/reviews_service.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class PlacePhotos extends StatefulWidget {
  Place place;

  PlacePhotos(this.place);

  @override
  _PlacePhotosState createState() => _PlacePhotosState();
}

class _PlacePhotosState extends State<PlacePhotos> {
  List<String> images = [];

  @override
  void initState() {
    getImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(12, 12, 12, 12),
        constraints: BoxConstraints(minHeight: 256),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: images.isEmpty
              ? SpinKitThreeBounce(
                  color: Get.theme.accentColor,
                  size: 24,
                )
              : StaggeredGridView.countBuilder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  itemCount: images.length ,
                  padding: EdgeInsets.all(0),
                  //staticData.length,
                  itemBuilder: (context, index) {
                    return Hero(
                      tag: index, // staticData[index].images,
                      child: new Image(
                        image: ExtendedNetworkImageProvider(
                          images[index],
                          cache: true,
                        ),
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                  staggeredTileBuilder: (index) => StaggeredTile.count(2, index.isEven ? 2 : 3),
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                ),
        ));
  }

  getImages() async {
    BusinessOwnerService businessOwnerService = new BusinessOwnerService();
    CPRBusinessOwner? owner = await businessOwnerService.findOwner(widget.place.googlePlaceID!);
    List<String> internalPictureURLs = owner?.internalPictureURLs ?? [];
    List<String> externalPictureURLs = owner?.externalPictureURLs ?? [];
    //////////////////////////////////////////////////////////////////////////////////////////
    ReviewService reviewService = new ReviewService();
    List<Review> reviews = await reviewService.findLastReviewsByPlaceId(widget.place.googlePlaceID!);
    int length = (reviews.length ) > 8 ? 8 : (reviews.length );
    List<String> reviewsImages = [];
    for (int i = 0; i < length; i++) {
      reviewsImages.addAll((reviews[i].downloadURLs ?? []));
    }
    //////////////////////////////////////////////////////////////////////////////////////////
    List<String> googleImages = [];
    widget.place.googlePhotoReferences?.forEach((element) {
      googleImages.add(OtherHelper.findPhotoReference(size: 1024, photoRef: element));
    });
    //////////////////////////////////////////////////////////////////////////////////////////
    images.addAll(internalPictureURLs);
    if (images.length > 6) {
      images = images.sublist(0, 6);
    }

    images.addAll(externalPictureURLs);
    if (images.length > 8) {
      images = images.sublist(0, 8);
    }

    if (images.length < 8) {
      images.addAll(reviewsImages);
      if (images.length > 8) {
        images = images.sublist(0, 8);
      }
    }

    if (images.length < 8) {
      images.addAll(googleImages);
      if (images.length > 8) {
        images = images.sublist(0, 8);
      }
    }
    if (mounted) setState(() {});
  }
}
