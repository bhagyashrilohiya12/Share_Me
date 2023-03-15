// import 'package:cpr_user/pages/common/components/cpr_card_top_image.dart';
// import 'package:cpr_user/pages/user/my_profile_page/components/buttons_bar.dart';
// import 'package:cpr_user/pages/user/my_profile_page/components/cpr_level.dart';
// import 'package:cpr_user/pages/user/my_profile_page/components/review_counter_bar.dart';
// import 'package:cpr_user/pages/user/my_profile_page/components/user_personal_info.dart';
// import 'package:cpr_user/providers/session_provider.dart';
// import 'package:cpr_user/resource/validation/ImageProviderValidation.dart';
// import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart' as p;
//
// class MyProfilePage extends StatelessWidget {
//   // const MyProfilePage({Key key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     Log.i( "page - MyProfilePage - build()");
//
//     var session = p.Provider.of<SessionProvider>(context, listen: false);
//
//     return LayoutBuilder(
//       builder: (context, constraint) {
//         double height = constraint.maxHeight - 8;
//         double paddingTop = height * 0.2;
//         height = height * 0.6;
//         return Container(
//           child: Stack(
//             children: <Widget>[
//               Positioned(
//                 left: 16,
//                 right: 16,
//                 top: paddingTop / 2,
//                 child: Center(
//                   child: CPRCardTopImage(
//                     image: ImageProviderValidation.networkOrPlaceholder(session.user?.profilePictureURL ),
//                     // image: session.user?.profilePictureURL ?? null,
//                     //height: height,
//                     child: Container(
//                       child: Column(
//                         children: <Widget>[
//                           UserPersonalInfo(),
//                           ReviewCounterBar(),
//                           CPRLevel(),
//                           Container(
//                             height: 1,
//                             color: Colors.grey.withOpacity(0.5),
//                             width: double.infinity,
//                           ),
//                           ButtonsBar()
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
