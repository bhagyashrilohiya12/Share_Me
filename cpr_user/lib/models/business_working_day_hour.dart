import 'package:cpr_user/models/business_hour.dart';

class CPRBusinessWorkingDayHour {
  List<CPRBusinessHour>? Mon;
  List<CPRBusinessHour>? Tue;
  List<CPRBusinessHour>? Wed;
  List<CPRBusinessHour>? Thu;
  List<CPRBusinessHour>? Fri;
  List<CPRBusinessHour>? Sat;
  List<CPRBusinessHour>? Sun;
  bool? isMonOpen;
  bool? isTueOpen;
  bool? isWedOpen;
  bool? isThuOpen;
  bool? isFriOpen;
  bool? isSatOpen;
  bool? isSunOpen;

  CPRBusinessWorkingDayHour({
    this.Mon,
    this.Tue,
    this.Wed,
    this.Thu,
    this.Fri,
    this.Sat,
    this.Sun,
    this.isMonOpen = false,
    this.isTueOpen = false,
    this.isWedOpen = false,
    this.isThuOpen = false,
    this.isFriOpen = false,
    this.isSatOpen = false,
    this.isSunOpen = false,
  });

  CPRBusinessWorkingDayHour.fromJson(Map<String, dynamic> json) {
    if (json['Mon'] != null) {
      Mon = [];
      json['Mon'].forEach((v) {
        Mon!.add(CPRBusinessHour(false).fromJson(v)  );
      });
    }
    if (json['Tue'] != null) {
      Tue = [];
      json['Tue'].forEach((v) {
        Tue!.add(new CPRBusinessHour(false).fromJson(v));
      });
    }
    if (json['Wed'] != null) {
      Wed = [];
      json['Wed'].forEach((v) {
        Wed!.add(new CPRBusinessHour(false).fromJson(v));
      });
    }
    if (json['Thu'] != null) {
      Thu = [];
      json['Thu'].forEach((v) {
        Thu!.add(new CPRBusinessHour(false).fromJson(v));
      });
    }
    if (json['Fri'] != null) {
      Fri = [];
      json['Fri'].forEach((v) {
        Fri!.add(new CPRBusinessHour(false).fromJson(v));
      });
    }
    if (json['Sat'] != null) {
      Sat = [];
      json['Sat'].forEach((v) {
        Sat!.add(new CPRBusinessHour(false).fromJson(v));
      });
    }
    if (json['Sun'] != null) {
      Sun = [];
      json['Sun'].forEach((v) {
        Sun!.add(new CPRBusinessHour(false).fromJson(v));
      });
    }

    json['isMonOpen'] != null ? isMonOpen = json['isMonOpen'] : false;
    json['isTueOpen'] != null ? isTueOpen = json['isTueOpen'] : false;
    json['isWedOpen'] != null ? isWedOpen = json['isWedOpen'] : false;
    json['isThuOpen'] != null ? isThuOpen = json['isThuOpen'] : false;
    json['isFriOpen'] != null ? isFriOpen = json['isFriOpen'] : false;
    json['isSatOpen'] != null ? isSatOpen = json['isSatOpen'] : false;
    json['isSunOpen'] != null ? isSunOpen = json['isSunOpen'] : false;
  }

  Map<String, dynamic> toJSON() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (isMonOpen! && this.Mon!.isNotEmpty  ) {
      data['Mon'] = this.Mon!.map((v) => v.toJson()).toList();
    }
    if (isTueOpen! && this.Tue!.isNotEmpty) {
      data['Tue'] = this.Tue!.map((v) => v.toJson()).toList();
    }
    if (isWedOpen! && this.Wed!.isNotEmpty) {
      data['Wed'] = this.Wed!.map((v) => v.toJson()).toList();
    }
    if (isThuOpen! && this.Thu!.isNotEmpty) {
      data['Thu'] = this.Thu!.map((v) => v.toJson()).toList();
    }
    if (isFriOpen! && this.Fri!.isNotEmpty) {
      data['Fri'] = this.Fri!.map((v) => v.toJson()).toList();
    }
    if (isSatOpen! && this.Sat!.isNotEmpty) {
      data['Sat'] = this.Sat!.map((v) => v.toJson()).toList();
    }
    if (isSunOpen! && this.Sun!.isNotEmpty) {
      data['Sun'] = this.Sun!.map((v) => v.toJson()).toList();
    }
    data['isMonOpen'] = isMonOpen;
    data['isTueOpen'] = isTueOpen;
    data['isWedOpen'] = isWedOpen;
    data['isThuOpen'] = isThuOpen;
    data['isFriOpen'] = isFriOpen;
    data['isSatOpen'] = isSatOpen;
    data['isSunOpen'] = isSunOpen;
    return data;
  }

}
