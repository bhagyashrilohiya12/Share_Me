import 'package:cpr_user/models/place.dart';

class NearRatePlaces {
  String? placeId;
  double? dis;
  var rate;
  Place? place;

  NearRatePlaces({this.placeId, this.dis, this.rate, this.place});

  NearRatePlaces.fromJson(Map<String, dynamic> json) {
    placeId = json['placeId'];
    dis = json['dis'];
    rate = json['rate'];
    place = json['place'] != null ? new Place.fromJSON(json['place']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['placeId'] = this.placeId;
    data['dis'] = this.dis;
    data['rate'] = this.rate;

    try {
      /**
       * #abdo
          if (this.place  != null) {
          data['place'] = this.place.toJSON();
          }
       */
      data['place'] = this.place!.toJSON();
    } catch ( e) {
    }



    return data;
  }
}