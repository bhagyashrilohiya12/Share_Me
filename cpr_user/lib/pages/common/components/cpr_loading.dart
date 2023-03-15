import 'dart:ui';

import 'package:cpr_user/pages/common/components/cpr_logo.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class CPRLoading extends StatelessWidget {
  final bool loading;
  const CPRLoading({  this.loading = true})  ;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Container(
        decoration: BoxDecoration(color: Colors.black.withOpacity(0.65)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Padding(
                //   padding: const EdgeInsets.only(top: 50),
                //   child: Icon(
                //     MaterialCommunityIcons.getIconData("camera-enhance"),
                //     color: Colors.white,
                //     size: 60,
                //   ),
                // ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: CPRLogo(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: "Click",
                            style: CPRTextStyles.logoStyle.copyWith(
                              color: CPRColors.cprButtonPink,
                              fontSize: 36,
                            )),
                        TextSpan(
                            text: " Pic",
                            style: CPRTextStyles.logoStyle.copyWith(
                              color: CPRColors.cprButtonGreen,
                              fontSize: 36,
                            )),
                        TextSpan(
                            text: " Review",
                            style: CPRTextStyles.logoStyle.copyWith(
                              color: Colors.blue,
                              fontSize: 36,
                            )),
                      ],
                      style: CPRTextStyles.logoStyle,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: createIcon(
                          iconColor: CPRColors.cprButtonPink,
                          icon: MaterialCommunityIcons.cursor_default_click,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: createIcon(
                          iconColor: CPRColors.cprButtonGreen,
                          icon: MaterialCommunityIcons.camera,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: createIcon(
                            iconColor: Colors.blue,
                            icon: MaterialCommunityIcons.thumb_up),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
    return Container();
  }

  Widget createIcon(
      {IconData icon = Icons.info_outline, Color iconColor = Colors.black}) {
    return ClipRect(
      child: Container(
        height: 68,
        width: 68,
        child: Center(
          child: Icon(
            icon,
            size: 58,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
