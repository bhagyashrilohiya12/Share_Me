class TagItem {
  String? title;
  bool? active;

  TagItem(this.title, {this.active = true});

  TagItem.fromJson(Map<String, dynamic> json) {
    json['title'] != null ? title = json['title'] : null;
    json['active'] != null ? active = json['active'] : false;
  }


  Map<String, dynamic> toJSON() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = title;
    data['active'] = active;
    return data;;
  }
}
