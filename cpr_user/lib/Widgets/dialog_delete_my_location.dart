import 'package:cpr_user/models/my_location.dart';
import 'package:flutter/material.dart';

class DialogDeleteMyLocation extends StatefulWidget {
  CPRMyLocation location;
  Function onDeleteLocation;
  bool showProgress = false;

  DialogDeleteMyLocation(this.location, this.onDeleteLocation);

  @override
  _DialogDeleteMyLocationState createState() => _DialogDeleteMyLocationState();
}

class _DialogDeleteMyLocationState extends State<DialogDeleteMyLocation> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.fromLTRB(0, (MediaQuery.of(context).size.height / 2) - 185, 0, 0),
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Center(
          child: Stack(
            children: [
              Container(
                width: 280,
                height: 185,
                child: Container(
                  padding: EdgeInsets.only(
                    top: 16,
                    bottom: 16,
                    left: 16,
                    right: 16,
                  ),
                  margin: EdgeInsets.only(top: 30),
                  decoration: new BoxDecoration(
                    color: Colors.white,
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
                        padding: EdgeInsets.only(top: 16),
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(
                            "Are you sure?",
                            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(
                            "Are you sure you want to delete ${widget.location.title}?",
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontSize: 12.0, color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Container(
                        padding: EdgeInsets.fromLTRB(widget.showProgress?0:16, 8, 0, 0),
                        width: double.infinity,
                        child: widget.showProgress
                            ? LinearProgressIndicator()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      child: Text(
                                        "No",
                                        style: TextStyle(fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        widget.showProgress = true;
                                      });
                                      widget.onDeleteLocation(widget.location);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                                      child: Text(
                                        "Yes",
                                        style: TextStyle(color: Theme.of(context).accentColor),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      )
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(); // To close the dialog
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: null,
                          borderRadius: BorderRadius.all(Radius.circular(200)),
                          color: Theme.of(context).accentColor),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 38,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
