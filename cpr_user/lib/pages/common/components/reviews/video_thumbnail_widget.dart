import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoThumbnailWidget extends StatefulWidget {
  String videoPath;
  double width;
  double height;

  VideoThumbnailWidget(this.videoPath, {this.width = 65, this.height = 65});

  @override
  _VideoThumbnailWidgetState createState() => _VideoThumbnailWidgetState();
}

class _VideoThumbnailWidgetState extends State<VideoThumbnailWidget> {

  Uint8List? image;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: widget.height,
        width: widget.width,
        child: image != null
            ? Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Image.memory(
                      image!,
                      fit: BoxFit.cover,
                      height: widget.height,
                      width: widget.width,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.play_arrow_outlined,
                      size: 32,
                    ),
                  ),
                ],
              )
            : Shimmer.fromColors(
                baseColor: Colors.grey,
                highlightColor: Colors.grey.shade300,
                child: Container(
                  color: Colors.black,
                )),
      ),
    );
  }

  @override
  void initState() {
    createThumbnail();
    super.initState();
  }

  createThumbnail() async {
    print("widget.videoPath : " + widget.videoPath);
    try {
      Uint8List? imageTemp = await VideoThumbnail.thumbnailData(
        video: widget.videoPath,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
        quality: 25,
      );
      setState(() {
        image = imageTemp;
      });
    } catch (e) {
      print(e);
    }
  }
}
