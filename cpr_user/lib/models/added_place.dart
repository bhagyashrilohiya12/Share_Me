import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/models/place.dart';

class AddedPlace {
  Place? place;
  DateTime? addedOn;
  String? documentId;

  AddedPlace({  this.addedOn,    this.place});

  factory AddedPlace.fromSnapshot(DocumentSnapshot snap) {
    var place = AddedPlace(   );
    place.documentId = snap.id;

    /**
     * #abdo
     */
    var myData = snap.data() as Map<String,dynamic>;

    try {
      place.addedOn =
          DateTime.fromMillisecondsSinceEpoch(myData["addedOn"]!);
    } catch (e) {}
    try {

      place.place = Place.fromJSON( myData);
    } catch (e) {}

    return place;
  }


}
