import 'package:cached_network_image/cached_network_image.dart';
import 'package:cpr_user/constants/login_status.dart';
import 'package:cpr_user/helpers/social_profile_helper.dart';
import 'package:cpr_user/helpers/webview_helper.dart';
import 'package:cpr_user/models/user_social_dto.dart';
import 'package:cpr_user/resource/toast/ToolsToast.dart';
import 'package:cpr_user/services/social_profile_service.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SocailMediaListItem extends StatelessWidget {
  final UserSocialDto social;
  final String twitterUrl = 'https://twitter.com';
  final String facebookUrl = 'https://www.facebook.com';
  final String instagramUrl = 'https://www.instagram.com';
  final user = FirebaseAuth.instance.currentUser!.email;
  List socialmedialist = ['Instagram', 'Twitter', 'Facebook'];
  SocailMediaListItem(this.social);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 48,
          padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedNetworkImage(
                imageUrl: social.icon!,
                fit: BoxFit.cover,
                width: 64,
                height: 64,
                placeholder: (context, url) => Image(
                    image:
                        AssetImage("assets/images/bg_loading_image_gif.gif")),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: Text(social.name!,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
              ),
              SizedBox(
                width: 8,
              ),
              InkWell(
                onTap: () async {
                  if (ToolsValidation.isEmpty(social.urlForLogin)) {
                    ToolsToast.i(context, "No Social Found!");
                    return;
                  } else if (social.urlForLogin != null &&
                      !social.loginStatus!.contains(LoginStatus.Success)) {
                    for (var item in socialmedialist) {
                      SocialProfileService().addSocialAccountStatus(
                          user!, item, LoginStatus.None);
                    }
                  }
                  if (social.name == 'Twitter') {
                    _openTwitter(context);
                  } else if (social.name == 'Facebook') {
                    _openFacebook(context);
                  } else if (social.name == 'Instagram') {
                    _openInstagram(context);
                  }
                },
                child: Container(
                    width: 140,
                    height: 36,
                    padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                    decoration: BoxDecoration(
                        color: social.loginStatus == LoginStatus.Success
                            ? Get.theme.colorScheme.secondary
                            : social.loginStatus == LoginStatus.Disconnect
                                ? Colors.white
                                : Colors.white,
                        borderRadius: BorderRadius.circular(100)),
                    child: Row(
                      children: [
                        Image(
                          image: AssetImage("assets/images/ic_link.png"),
                          width: 24,
                          height: 24,
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                                social.loginStatus == LoginStatus.Success
                                    ? "Connected"
                                    : social.loginStatus ==
                                            LoginStatus.Disconnect
                                        ? "Disconnected"
                                        : "Connect",
                                style: TextStyle(
                                    color: social.loginStatus ==
                                            LoginStatus.Success
                                        ? Colors.white
                                        : social.loginStatus ==
                                                LoginStatus.Disconnect
                                            ? Colors.grey
                                            : Colors.lightBlue,
                                    fontSize: 12)),
                          ),
                        ),
                      ],
                    )),
              )
            ],
          ),
        ),
      ],
    );
  }

  void _openTwitter(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewPage(
          url: twitterUrl,
          onSuccess: () {
            _showConnectionStatus(context, 'Twitter connected successfully');
          },
          onFailure: () {
            _showConnectionStatus(context, 'Twitter connection failed');
          },
        ),
      ),
    );
  }

  void _openFacebook(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewPage(
          url: facebookUrl,
          onSuccess: () {
            _showConnectionStatus(context, 'Facebook connected successfully');
          },
          onFailure: () {
            _showConnectionStatus(context, 'Facebook connection failed');
          },
        ),
      ),
    );
  }

  void _openInstagram(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewPage(
          url: instagramUrl,
          onSuccess: () {
            _showConnectionStatus(context, 'Instagram connected successfully');
          },
          onFailure: () {
            _showConnectionStatus(context, 'Instagram connection failed');
          },
        ),
      ),
    );
  }

  void _showConnectionStatus(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 3),
    ));
  }
}
