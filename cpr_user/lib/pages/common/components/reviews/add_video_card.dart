import 'package:cpr_user/constants/cpr_routes.dart';
import 'package:cpr_user/helpers/image_helper.dart';
import 'package:cpr_user/pages/common/components/cpr_button.dart';
import 'package:cpr_user/pages/common/components/cpr_card.dart';
import 'package:cpr_user/pages/common/components/reviews/video_thumbnail_widget.dart';
import 'package:cpr_user/pages/common/video_view_page.dart';
import 'package:cpr_user/providers/review_manager_provider.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart' as p;
import 'package:video_thumbnail/video_thumbnail.dart';


class AddVideoCard extends StatelessWidget {
  final ReviewManagerProvider provider;
  final bool create;
  //final ImageHelper imageHelper;

   AddVideoCard(this.provider, {  this.create = true});
  //const AddPhotoCard(this.provider, this.imageHelper, {Key key, this.create = true})


  @override
  Widget build(BuildContext context) {
//    var provider = Provider.of<AddReviewProvider>(context);
    var session = p.Provider.of<SessionProvider>(context, listen: false);
    return Column(
      children: <Widget>[
        CPRCard(
          // height: 165,
          title: Text(
            "Videos",
            style: CPRTextStyles.cardTitleBlack,
          ),
          subtitle: Text(
            "Add the Videos taken ${provider.place != null ? "in ${provider.place!.name}\nVideo time should be between 5 and 10 seconds" : "\nVideo time should be between 5 and 10 seconds"}",
            style: CPRTextStyles.cardSubtitleBlack,
          ),
          backgroundColor: Colors.white,
          icon: MaterialCommunityIcons.camera,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Builder(builder: (context) {
              return Wrap(
                children: <Widget>[
                  if (provider.hasVideosInReview)
                    ...provider.review!.videos!
                        .map(
                          (f) => GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => VideoViewPage(
                                    videoUrl:provider.getVideoUrl(f),
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Container(
                                height: 65,
                                width: 65,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),

                                ),
                                child: Container(
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: <Widget>[
                                      VideoThumbnailWidget(provider.getVideoUrl(f)),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            provider.removeRemoteVideo(f);
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
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  if (provider.videos != null && provider.videos.isNotEmpty)
                    ...provider.videos
                        .map(
                          (f) => GestureDetector(
                            onTap: () {

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => VideoViewPage(
                                    videoPath:f.path,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Container(
                                height: 65,
                                width: 65,
                                child: Container(
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: <Widget>[
                                      VideoThumbnailWidget(f.path),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            provider.removeVideo(f);
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
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          builder: (modalContext) => session.imageHelper.showPicker(
                              modalContext, provider.addVideo,isVideo: true),
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
}
