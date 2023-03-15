import 'package:cpr_user/models/near_rate_places.dart';

class GetTopRateNearPalce {
  List<NearRatePlaces>? nearRatePlaces;

  // GetTopRateNearPalce({this.nearRatePlaces});

  GetTopRateNearPalce.fromJson(Map<String, dynamic> json) {
    if (json['nearRatePlaces'] != null) {
      nearRatePlaces =  [];
      json['nearRatePlaces'].forEach((v) {
        nearRatePlaces!.add(new NearRatePlaces.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.nearRatePlaces != null) {
      data['nearRatePlaces'] =
          this.nearRatePlaces!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
