import 'package:cpr_user/providers/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart' as p;

class ProfileAvatar extends StatelessWidget {
  final double radius;
    ProfileAvatar({

    this.radius = 30,
  })  ;

  @override
  Widget build(BuildContext context) {
    return p.Consumer<SessionProvider>(
      builder: (context, provider, child) {
        Widget avatar;
        if (provider.profileURL == null) {
          avatar = CircleAvatar(
            radius: radius,
            backgroundImage: AssetImage("assets/images/no_avatar_image_choosed.png"),
          );
        } else {
          avatar = CircleAvatar(
            radius: radius,
            backgroundImage: NetworkImage( provider.profileURL() ),
          );
        }
        return avatar;
      },
    );
  }
}
