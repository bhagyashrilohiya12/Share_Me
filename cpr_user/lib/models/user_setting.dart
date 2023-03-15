class UserSetting {
  bool? receiveNotificationWhenAUserFollowMe;
  bool? otherUserCanFollowMe;
  bool? optOutOfAllMarketingAndCommunications;
  bool? optOutOfSaleOfData;

  UserSetting({this.receiveNotificationWhenAUserFollowMe = false, this.otherUserCanFollowMe = false, this.optOutOfAllMarketingAndCommunications = true, this.optOutOfSaleOfData = true});

  factory UserSetting.fromJson(Map<String, dynamic> map) {
    var userSetting = UserSetting(
      receiveNotificationWhenAUserFollowMe:
          map["receiveNotificationWhenAUserFollowMe"] != null ? map["receiveNotificationWhenAUserFollowMe"] : false,
      otherUserCanFollowMe: map["otherUserCanFollowMe"] != null ? map["otherUserCanFollowMe"] : false,
      optOutOfAllMarketingAndCommunications: map["optOutOfAllMarketingAndCommunications"] != null ? map["optOutOfAllMarketingAndCommunications"] : true,
      optOutOfSaleOfData: map["optOutOfSaleOfData"] != null ? map["optOutOfSaleOfData"] : true,
    );
    return userSetting;
  }

  Map<String, dynamic> toJSON() {
    return {
      "receiveNotificationWhenAUserFollowMe": receiveNotificationWhenAUserFollowMe,
      "otherUserCanFollowMe": otherUserCanFollowMe,
      "optOutOfAllMarketingAndCommunications": optOutOfAllMarketingAndCommunications,
      "optOutOfSaleOfData": optOutOfSaleOfData,
    };
  }
}
