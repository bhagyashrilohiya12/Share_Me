import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:cpr_user/constants/cpr_urls.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_place/google_place.dart';

import '../../../constants/cpr_urls.dart';
import '../../../theming/styles.dart';

class SerachAndGetPlacePage extends StatefulWidget {
  // SerachAndGetPlacePage({Key key}) : super(key: key);

  @override
  _SerachAndGetPlacePageState createState() => _SerachAndGetPlacePageState();
}

class _SerachAndGetPlacePageState extends State<SerachAndGetPlacePage> {
  var _addressController = TextEditingController();

  /**
   * #abdo
      AutocompletePrediction selectedPlace;
   */

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Log.i("page  - SerachAndGetPlacePage - build");

    return Container(
      child: Scaffold(
        //backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Find Place'),
          backgroundColor: Colors.black,
          elevation: 0.0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Builder(
            builder: (scaffoldContext) {
              return SingleChildScrollView(
                  child: Column(children: <Widget>[
                //Logo and instructions
                Column(
                  children: const <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 10, right: 8.0, left: 0, bottom: 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Search Your Place Here",
                        ),
                      ),
                    ),
                  ],
                ),

                //Column of business text inputs
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TypeAheadFormField(
                    suggestionsBoxVerticalOffset: 0,
                    textFieldConfiguration: TextFieldConfiguration(
                        controller: _addressController,
                        autofocus: false,
                        decoration: InputDecoration(
                          suffixIcon: const Icon(
                            Icons.place,
                            color: Colors.black,
                          ),
                          hintText: "Address",
                          hintStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w100),
                          labelStyle: const TextStyle(color: Colors.black),
                          helperStyle: const TextStyle(color: Colors.black),
                          contentPadding:
                              const EdgeInsets.fromLTRB(16, 8, 16, 8),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                CPRDimensions.loginTextFieldRadius),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 0.5),
                          ),
                        )),
                    suggestionsCallback: (pattern) async {
                      if (pattern.isNotEmpty)
                        return await getPlaces(pattern);
                      else
                        return [];
                    },
                    itemBuilder: (context, suggestion) {
                      int sizeSuggested = suggestedPlaces.length.toInt();
                      Log.i("itemBuilder - indexBuilder: " +
                          indexBuilder.toString() +
                          " /sizeSuggested: " +
                          sizeSuggested.toString());

                      if (sizeSuggested > indexBuilder) {
                        var title = suggestedPlaces[indexBuilder].description!;
                        indexBuilder = indexBuilder + 1;

                        return ListTile(
                          leading: const Icon(Icons.place),
                          title: Text(
                            title,
                            maxLines: 1,
                          ),
                          // subtitle: Text(subtitle,maxLines: 1,),
                        );
                      } else {
                        //progress view
                        String msg = "\t\tloading";
                        return TextTemplate.t(msg,
                            height: 30,
                            dimen: 14,
                            textAlign: TextAlign.start,
                            color: Colors.black,
                            padding: const EdgeInsets.all(5));
                      }
                    },
                    onSuggestionSelected: (suggestion) {
                      Navigator.pop(context, suggestion);
                    },
                    keepSuggestionsOnSuggestionSelected: false,
                    hideSuggestionsOnKeyboardHide: false,
                  ),
                ),
              ]));
            },
          ),
        ),
      ),
    );
  }

  int indexBuilder = 0;
  List<AutocompletePrediction> suggestedPlaces = [];

  Future<List<AutocompletePrediction>> getPlaces(String text) async {
    indexBuilder = 0;
    suggestedPlaces = [];

    try {
      var googlePlace = GooglePlace(PlacesAPI.googlePlacesKey);
      AutocompleteResponse? res = await googlePlace.autocomplete.get(text);
      if (res != null) suggestedPlaces = res.predictions!;
    } catch (e) {
      print(e);
    }
    return suggestedPlaces;
  }
}


/**
 * #abdo
    return ListTile(
    leading: Icon(Icons.place),
    title: Text(suggestion!.structuredFormatting!.mainText??"",maxLines: 1,),
    subtitle: Text(suggestion!.structuredFormatting!.secondaryText??"",maxLines: 1,),
    );
 */
