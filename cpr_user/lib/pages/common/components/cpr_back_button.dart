import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CPRBackButton extends StatelessWidget {
  final IconData icon;

  const CPRBackButton({
    this.icon = CupertinoIcons.back,

  })  ;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      left: 20,
      child: Row(
        children: <Widget>[
          Material(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
                height: 40,
                width: 40,
                padding: EdgeInsets.only(left: 4),
                child: IconButton(
                  color: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                    size: 25,
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
