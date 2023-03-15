class UserSocialDto {
  String? id;
  bool? active;
  String? urlForLogin;
  String? icon;
  String? name;
  String? urlForHelp;
  String? loginStatus;

  UserSocialDto(
      {this.id,
        this.active,
        this.urlForLogin,
        this.icon,
        this.name,
        this.urlForHelp,
        this.loginStatus});

  UserSocialDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    active = json['active'];
    urlForLogin = json['urlForLogin'];
    icon = json['icon'];
    name = json['name'];
    urlForHelp = json['urlForHelp'];
    loginStatus = json['LoginStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['active'] = this.active;
    data['urlForLogin'] = this.urlForLogin;
    data['icon'] = this.icon;
    data['name'] = this.name;
    data['urlForHelp'] = this.urlForHelp;
    data['LoginStatus'] = this.loginStatus;
    return data;
  }
}
