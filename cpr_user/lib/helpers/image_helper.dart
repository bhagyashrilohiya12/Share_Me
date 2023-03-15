import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cpr_user/pages/common/components/cpr_header.dart';
import 'package:cpr_user/pages/common/components/cpr_separator.dart';
import 'package:cpr_user/resource/WaitTools.dart';
import 'package:cpr_user/resource/toast/ToolsToast.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:image_picker/image_picker.dart';

typedef PickerImageCallBack = Function(bool status, String msg, String filePath, Image image, Uint8List unitFile  );
typedef PickerCropCallBack = Function(bool status, String msg, CroppedFile? fileCrop   );

class ImageHelper {
  final picker = ImagePicker();

  Future getImageGallery({double maxWidth = 1080, required PickerCropCallBack  callBackCrop}) async {


    AssetImage assetImage = AssetImage(  "assets/images/logo.png");
    await pickerImageGallery( assetImage, (bool status, String msg, String filePath,
        Image image, Uint8List unitFile  )  async {
      //check failed picked
      if( status == false ) {
        return;
      }

      //call back
      cropImage( filePath, callBackCrop );

    } );
  }



  static  Future pickerImageGallery(AssetImage placeHolder, PickerImageCallBack callBack) async {

    Image placeHolderImage = Image(image:  placeHolder);

    try {
      XFile?  photoPickered =  await ImagePicker().pickImage(source: ImageSource.gallery) ;

      //check mobile cancel picker image
      if( photoPickered == null ) {
        Log.i( "pickerImageGallery() - photo == null - stop! "  );
        //return failed
        callBack(false, "Picker Image canceled", "", placeHolderImage, Uint8List ( 0 )  );
        return;
      }

      //get path
      Log.i( "pickerImageGallery() - photoPickered.path: " + photoPickered.path  );


      //get image
      Image myImage;
      Uint8List unitFile = await photoPickered.readAsBytes();
      // Log.i( "pickerImage() - unitFile: " + unitFile.toString()  );

      if( DeviceTools.isPlatformWeb() ) {
        myImage  =  Image.network( photoPickered.path) ;
      } else {
        File myFile =    File( photoPickered.path);
        myImage  =  Image.file( myFile) ;
        Log.i( "pickerImageGallery() - myFile: " + myFile.toString()  );
        Log.i( "pickerImageGallery() - path: " + photoPickered.path.toString()  );
      }


      //log
      /**
          Log.i( "pickerImageGallery() - photoPickered: " + photoPickered.toString()  );
          Log.i( "pickerImageGallery() - photoPickered.path: " + photoPickered.path  );
          Log.i( "pickerImageGallery() - imagePickered: " + imagePickered.toString()  );
          Log.i( "pickerImageGallery() - myImage: " + myImage.toString()  );
       */

      //success
      callBack(true, "success", photoPickered.path, myImage, unitFile );

    } on PlatformException catch(e){
      Log.i( "pickerImageGallery() - exc: " + e.toString() );
      //return failed
      callBack(false, "Picker image failed, error: " + e.toString() ,"", placeHolderImage, Uint8List ( 0 )  );
      return;
    }
  }

  //-------------------------------------------------------------------------- camera

  Future<File?> getImageFromCamera({double maxWidth = 1080}) async {
    Log.i( "getImageFromCamera() - click picker image");
    /**
     * #abdo
     */
    PickedFile? file = await picker.getImage(source: ImageSource.camera, maxWidth: maxWidth);

    if( file == null )return  null ;

    CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.ratio5x4,
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: CPRColors.cprButtonPink,
              toolbarWidgetColor: CPRColors.backgroundColor,
              initAspectRatio: CropAspectRatioPreset.ratio5x4,
              lockAspectRatio: false),

          IOSUiSettings(
            minimumAspectRatio: 0.8,
          )
        ]
    );

    if( croppedFile == null ) return null ;

    return new File( croppedFile.path);

  }

  //---------------------------------------------------------------------------- crop

  static Future cropImage(String filePath, PickerCropCallBack  callBackCrop) async  {

    //crop
    CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: filePath,
        aspectRatioPresets: [
          CropAspectRatioPreset.ratio5x4,
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: CPRColors.cprButtonPink,
              toolbarWidgetColor: CPRColors.backgroundColor,
              initAspectRatio: CropAspectRatioPreset.ratio5x4,
              lockAspectRatio: false),

          IOSUiSettings(
            minimumAspectRatio: 0.8,
          )
        ]
    );

    if( croppedFile == null ) {
      callBackCrop(false, "failed crop", null );
      return ;
    }

    // cropped file success
    Log.i( "cropImage() - success croppedFile: " + croppedFile.path );
    callBackCrop(true, "success crop", croppedFile );

  }

  //---------------------------------------------------------------------------- video

  Future<File?> getVideo({required bool fromCamera}) async {
    PickedFile? file = await picker.getVideo(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
    );
    if (file != null) {
      File f = new File(file.path);
      return f;
    }
    return null;
  }

  //------------------------------------------------------------------------------ show

  Widget showPicker(BuildContext context, Function(File file) callback, {bool isVideo = false}) {
    var bigIconSize;
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: <Widget>[
          CPRHeader(
            height: 48,
            icon: MaterialCommunityIcons.camera_image,
            title: Text(
              isVideo ? "Pick an video" : "Pick an image",
              style: CPRTextStyles.cardTitleBlack,
            ),
            subtitle: Text(
              "Select the source"+(isVideo?" - 5 to 10 sec - 1 to 10 mb":""),
              style: CPRTextStyles.cardSubtitleBlack,
            ),
            backgroundColor: Colors.white,
            textColor: Colors.black,
          ),
          CPRSeparator(),
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    if (!isVideo) {
                      getImageFromCamera().then(
                        (onValue) {
                          if (onValue != null) {
                            callback(File(onValue.path));
                            // provider.addImage(onValue);
                            Navigator.pop(context);
                          }
                        },
                      );
                    } else {
                      getVideo(fromCamera: true).then(
                        (onValue) async {
                          if (onValue != null) {
                            int fileLength = await onValue.length();
                            bool isLarge = (fileLength / pow(1024, 2)) > 10;
                            if (isLarge) {
                              Get.snackbar('Error', 'Video size should not exceed 10 MB!',
                                  snackPosition: SnackPosition.BOTTOM,backgroundColor: Colors.red);
                            } else {
                              callback(File(onValue.path));
                              // provider.addImage(onValue);
                              Navigator.pop(context);
                            }
                          }
                        },
                      );
                    }
                  },
                  child: Column(
                    children: <Widget>[
                      Icon(
                        MaterialCommunityIcons.camera,
                        size: CPRDimensions.bigIconSize,
                      ),
                      Text("Camera", style: CPRTextStyles.cardTitleBlack)
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () async {


                    if (!isVideo) {
                      await _clickGalleryToPicker( context, callback);
                    } else {
                      getVideo(fromCamera: false).then(
                        (onValue) async {
                          if (onValue != null) {
                            int fileLength = await onValue.length();
                            bool isLarge = (fileLength / pow(1024, 2)) > 10;
                            if (isLarge) {
                              Get.snackbar('Error', 'Video size should not exceed 10 MB!',
                                  snackPosition: SnackPosition.BOTTOM,backgroundColor: Colors.red);
                            } else {
                              callback(File(onValue.path));
                              // provider.addImage(onValue);
                              Navigator.pop(context);
                            }
                          }
                        },
                      );
                    }
                  },
                  child: Column(
                    children: <Widget>[
                      Icon(
                        MaterialCommunityIcons.image,
                        size: CPRDimensions.bigIconSize,
                      ),
                      Text(
                        "Gallery",
                        style: CPRTextStyles.cardTitleBlack,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }


  _clickGalleryToPicker(BuildContext context, Function(File file) callback) {
  Log.i( "_clickGalleryToPicker()");

    getImageGallery( callBackCrop:  (bool status, String msg, CroppedFile? croppedFile ) async  {
    //check failed picked
    if( status == false ) {
    return;
    }

    if( status == false || croppedFile == null  ) {
      ToolsToast.i(context, msg);

      //dismiss dialog choose type "Cam or gallery"
      Navigator.pop(context);

      return;
    }


    //dismiss dialog choose type "Cam or gallery"
    Navigator.pop(context);

    //map object
    File fileFromCrop = File( croppedFile.path);

    //call back
    await callback(fileFromCrop);

    // //Wait after dismiss dialog
    // ToolsWait.waitToDo(300, ()  {
    //
    //   //map objects
    //   File fileFromCrop = File( croppedFile.path);
    //   provider!.addImage(fileFromCrop );
    // });
    //
    // getImageGallery().then( (onValue) async {
    //     if (onValue != null) {
    //       await callback(onValue);
    //       Navigator.pop(context);
    //     }

      },
    );
  }




}

/**
 * #abdo
    PickedFile? file = await picker.getImage(source: ImageSource.gallery, maxWidth: maxWidth);
    CroppedFile? croppedFile = await ImageCropper().cropImage(
    sourcePath: file!.path,
    aspectRatioPresets: [
    CropAspectRatioPreset.ratio5x4,
    ]);
    return croppedFile as File;
 */

/**
 * #abdo
    androidUiSettings: AndroidUiSettings(
    toolbarTitle: 'Crop Image',
    toolbarColor: CPRColors.cprButtonPink,
    toolbarWidgetColor: CPRColors.backgroundColor,
    initAspectRatio: CropAspectRatioPreset.ratio5x4,
    lockAspectRatio: false),
    iosUiSettings: IOSUiSettings(
    minimumAspectRatio: 0.8,
    ));
 */
