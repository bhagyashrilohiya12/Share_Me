import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DialogChooseImageSource extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        width: 260,
        height: 260,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                top: 32,
                bottom: 0,
                left: 0,
                right: 0,
              ),
              margin: EdgeInsets.only(top: 30),
              decoration: new BoxDecoration(
                color:Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: const Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, // To make the card compact
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        "Pick Image",
                        style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).accentColor
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Flexible(
                    child: Column(
                      children: <Widget>[
                        TextButton(
                          onPressed:  () {
                            Navigator.pop(context, ImageSource.gallery);
                          },
                          child: Container(
                            padding: EdgeInsets.only(right: 0,left: 16),
                            height: 42,
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.image,color: Theme.of(context).primaryColor,),
                                Expanded(
                                  child: Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 16,left: 16),
                                      child: Text(
                                        "Gallery",
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(fontSize: 16.0, color: Theme.of(context).primaryColor),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, ImageSource.camera);
                          },
                          child: Container(
                            padding: EdgeInsets.only(right: 0,left: 16),
                            height: 42,
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.camera,color: Theme.of(context).primaryColor,),
                                Expanded(
                                  child: Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 16,left: 16),
                                      child: Text(
                                        "Camera",
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(fontSize: 16.0, color: Theme.of(context).primaryColor),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              left: 252,
              top: 22,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(); // To close the dialog
                },
                child: Icon(
                  Icons.cancel,
                  color: Theme.of(context).accentColor,
                  size: 38,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
