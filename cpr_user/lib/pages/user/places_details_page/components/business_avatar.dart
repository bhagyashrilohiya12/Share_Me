import 'package:cached_network_image/cached_network_image.dart';
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

class BusinessAvatar extends StatefulWidget {
  Place place;

  BusinessAvatar(this.place);

  @override
  _BusinessAvatarState createState() => _BusinessAvatarState();
}

class _BusinessAvatarState extends State<BusinessAvatar> {
  String avatar = '';

  @override
  void initState() {
    getAvatar();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(16, 4, 0, 4),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: avatar,
            fit: BoxFit.cover,
            width: 64,
            height: 64,
            placeholder: (context, url) =>
                Image(image: AssetImage("assets/images/bg_loading_image_gif.gif")),
            errorWidget: (context, url, error) => Image(image: AssetImage("assets/images/no_avatar_image_choosed.png")),
          ),
        ));
  }

  getAvatar() async {
    BusinessOwnerService businessOwnerService = new BusinessOwnerService();
    CPRBusinessOwner? owner = await businessOwnerService.findOwner(widget.place.googlePlaceID!);
    if(owner!=null && owner.profilePictureURL!=null)
    setState(() {
      avatar = owner.profilePictureURL!;
    });
  }
}
