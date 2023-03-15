import 'package:cpr_user/providers/session_provider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart' as p;

class CPRCardTopImage extends StatelessWidget {
   CPRCardTopImage({

    required this.image,
    //this.imageHelper,
    this.scrollable = false,
    required this.child,
  })  ;
  final String image;
  final bool scrollable;

  //final ImageHelper imageHelper;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    Widget childToRender;
    var provider = p.Provider.of<SessionProvider>(context);
    if (scrollable) {
      childToRender = Container(
        child: SingleChildScrollView(
          child: child,
        ),
      );
    } else {
      childToRender = child;
    }
    CircleAvatar centeredImage;
    if (image == null) {
      centeredImage = CircleAvatar(
        radius: 60,
        child: Icon(MaterialCommunityIcons.account),
      );
    } else {
      centeredImage = CircleAvatar(
        radius: 60,
        backgroundImage: getImageBackground()
      );
    }

    return Stack(
      children: <Widget>[
        Card(
          margin: EdgeInsets.only(top: 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: SizedBox(
            //height: height,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Column(
                children: <Widget>[
                  LayoutBuilder(
                    builder: (context, constraint) {
                      return childToRender;
                    },
                  )
                  //child,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Center(
            child: GestureDetector(
              onTap: () async {
                try {
                  showModalBottomSheet(
                      builder: (modalContext) => provider.imageHelper.showPicker(modalContext, provider.changeUserProfilePicture),
                      context: context);
                } catch (e) {}
              },
              child: centeredImage,
            ),
          ),
        )
      ],
    );
  }


  getImageBackground() {

    return image != null ? ExtendedNetworkImageProvider(image, cache: true) : AssetImage("assets/images/bg_image_not_available_squre.jpg");
  }


}
