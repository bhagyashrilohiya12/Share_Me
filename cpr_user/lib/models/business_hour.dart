import 'package:cpr_user/helpers/other_helper.dart';
import 'package:flutter/material.dart';

class CPRBusinessHour {
  String? id;
  String? startHour;
  String? endHour;
  bool? is24Hour;
  TextEditingController? startController;
  TextEditingController? endController;

  CPRBusinessHour(this.is24Hour){
    id = OtherHelper.getUUID();
    startController = new TextEditingController();
    endController = new TextEditingController();
    startController!.addListener(() {
      startHour = startController?.text;
    });

    endController!.addListener(() {
      endHour = endController?.text;
    });
  }

  CPRBusinessHour fromJson(Map<String, dynamic> map) {
    id = map["id"];
    startHour = map["startHour"];
    endHour = map["endHour"];
    is24Hour = map["is24Hour"];

    startController = new TextEditingController();
    endController = new TextEditingController();
    startController?.text = startHour??"";
    endController?.text = endHour??"";
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['startHour'] = this.startHour;
    data['endHour'] = this.endHour;
    data['is24Hour'] = this.is24Hour;
    return data;
    ;
  }
}
