import 'package:flutter/material.dart';

/**
    static AssetImage name  = AssetImage( "assets/shika/images/name.png");
 */
class DrawableProject {

  //images
  static AssetImage images(String nameImage ) {
    AssetImage  ass  = AssetImage( "assets/images/" + nameImage + ".png");
    return ass;
  }

  //images
  static AssetImage images_with_extension(String nameImage ) {
    AssetImage  ass  = AssetImage( "assets/images/" + nameImage );
    return ass;
  }
}