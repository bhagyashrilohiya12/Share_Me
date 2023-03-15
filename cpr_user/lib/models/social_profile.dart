class SocialProfile {
  String? title;
  bool? hidetitle;
  String? displaytitle;
  List? disableSocial;
  String? profileKey;
  String? refId;
  String? platform;

  SocialProfile(this.title, this.hidetitle, this.displaytitle,
      this.disableSocial, this.profileKey, this.refId, this.platform);

  factory SocialProfile.fromJson(Map<String, dynamic> json) {
    return SocialProfile(
        json['title'],
        json['hidetitle'],
        json['displaytitle'],
        json['disableSocial'],
        json['profileKey'],
        json['refId'],
        json['platform']);
  }

  Map<String, dynamic> toJSON() {
    return {
      "title": title,
      "hidetitle": hidetitle,
      "displaytitle": displaytitle,
      "disableSocial": disableSocial,
      "profileKey": profileKey,
      "refId": refId,
      "platform": platform,
    };
  }
}
