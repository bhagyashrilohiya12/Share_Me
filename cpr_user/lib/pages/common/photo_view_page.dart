import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class PhotoViewPage extends StatelessWidget {
  String? imageUrl;
 String? imagePath;
   PhotoViewPage({  this.imageUrl, this.imagePath}) ; // : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget image = Container();
    if (imageUrl != null) {
      try {
        image = ExtendedImage.network(
          imageUrl!,
          fit: BoxFit.contain,
          //enableLoadState: false,
          mode: ExtendedImageMode.gesture,
          initGestureConfigHandler: (state) {
            return GestureConfig(
                minScale: 0.9,
                animationMinScale: 0.7,
                maxScale: 3.0,
                animationMaxScale: 3.5,
                speed: 1.0,
                inertialSpeed: 100.0,
                initialScale: 1.0,
                inPageView: false);
          },
        );
      } catch (e) {}
    } else if (imagePath != null) {
      image = ExtendedImage.asset(
        imagePath!,
        fit: BoxFit.contain,
        //enableLoadState: false,
        mode: ExtendedImageMode.gesture,
        initGestureConfigHandler: (state) {
          return GestureConfig(
              minScale: 0.9,
              animationMinScale: 0.7,
              maxScale: 3.0,
              animationMaxScale: 3.5,
              speed: 1.0,
              inertialSpeed: 100.0,
              initialScale: 1.0,
              inPageView: false);
        },
      );
    } else {
      image = Container();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Center(
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: image),
          ),
        ],
      ),
    );
  }
}
