import 'package:cpr_user/pages/user/get_location/get_location_page.dart';
import 'package:cpr_user/pages/user/my_locations/my_locations_page.dart';
import 'package:cpr_user/providers/places_provider.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as p;

class ChooseLocationButton extends StatelessWidget {
  // const ChooseLocationButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return p.Consumer<PlacesProvider>(
      builder: (context, provider, child) {
        return GestureDetector(
          onTap: () async {
            Navigator.of(context).push(new MaterialPageRoute(builder: (context)=>MyLocationsPage()));
          },
          child: Material(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
                height: 40,
                width: 60,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(20)),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 16,
                      ),
                      Icon(Icons.location_on_outlined),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Text(
                          "Near Me",
                          style: CPRTextStyles.clickPickReviewStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                    ],
                  ),
                )),
          ),
        );
      },
    );
  }
}
