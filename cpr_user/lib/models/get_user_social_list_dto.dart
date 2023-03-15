import 'package:cpr_user/models/feed_review.dart';
import 'package:cpr_user/models/user_social_dto.dart';

class GetUserSocialListDto {
  List<UserSocialDto>? socials;

  GetUserSocialListDto(socials);

  GetUserSocialListDto.fromJson(List<dynamic> json) {
    if (json != null) {
      socials = [];
      json.forEach((v) {
        socials!.add(new UserSocialDto.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.socials != null) {
      data['socials'] = this.socials!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
