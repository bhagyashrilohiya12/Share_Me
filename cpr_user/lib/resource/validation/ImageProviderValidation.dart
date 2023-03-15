import 'package:cached_network_image/cached_network_image.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/material.dart';

class ImageProviderValidation {

  static networkOrPlaceholder(String? url ) {
    if( ToolsValidation.isEmpty( url )) {
      return  AssetImage("assets/images/no_avatar_image_choosed.png");
    }

    return NetworkImage( url! );
  }



  static chooseImageCacheOrUrl(String? url) {
    /**
        #abdo
        session.user.profilePictureURL == null
        ? Image(fit: BoxFit.cover, image: AssetImage("assets/images/no_avatar_image_choosed.png"))
        :
     */


    if( ToolsValidation.isEmpty( url ) ) {
      return Image(fit: BoxFit.cover, image: AssetImage("assets/images/no_avatar_image_choosed.png"));
    }


    return CachedNetworkImage(
      imageUrl: url!,
      placeholder: (context, url) => Container(width: 100, height: 100, child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }



}