import 'package:cpr_user/models/business_internal_promotion.dart';
import 'package:cpr_user/models/business_server.dart';
import 'package:cpr_user/pages/common/components/cpr_card.dart';
import 'package:cpr_user/pages/common/components/review_text_field.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class AdditionalInfoCard extends StatelessWidget {

   AdditionalInfoCard({
    // Key key,
    required TextEditingController firstInputController,
    required TextEditingController secondInputController,
    required TextEditingController thirdInputController,
    required TextEditingController fourthInputController,
    required TextEditingController fifthInputController,
    required FocusNode firstNode,
    required FocusNode secondNode,
    required FocusNode thirdNode,
    required FocusNode fourthNode,
    required FocusNode fifthNode,
    required List<CPRBusinessServer?> employees,
    required CPRBusinessServer? selectedEmployee,
    required CPRBusinessServer? singleSelectedEmployee,
    required Function onSelectEmployee,
    required List<CPRBusinessInternalPromotion> promotions,
    required CPRBusinessInternalPromotion? selectedPromotion,
    required Function onSelectPromotion,
    required bool usePromotion,
    required Function onUsePromotionChange,
  })  : _firstInputController = firstInputController,
        _secondInputController = secondInputController,
        _thirdInputController = thirdInputController,
        _fourthInputController = fourthInputController,
        _firstNode = firstNode,
        _secondNode = secondNode,
        _thirdNode = thirdNode,
        _fourthNode = fourthNode,
        _fifthNode = fifthNode,
        _fifthInputController = fifthInputController,
         employee = employees,
        _selectedEmployee = selectedEmployee,
        _singleSelectedEmployee = singleSelectedEmployee,
        _onSelectEmployee = onSelectEmployee,
        _promotions = promotions,
        _selectedPromotion = selectedPromotion,
        _onSelectPromotion = onSelectPromotion,
        _usePromotion = usePromotion,
        _onUsePromotionChange = onUsePromotionChange  ;

// , super(key: key);

  final TextEditingController _firstInputController;
  final _secondInputController;
  final _thirdInputController;
  final _fourthInputController;
  final FocusNode _firstNode;
  final FocusNode _secondNode;
  final FocusNode _thirdNode;
  final FocusNode _fourthNode;
  final FocusNode _fifthNode;
  final TextEditingController _fifthInputController;

   CPRBusinessServer? _selectedEmployee;
  final CPRBusinessServer? _singleSelectedEmployee;
  final Function _onSelectEmployee;
  final List<CPRBusinessInternalPromotion> _promotions;
  final CPRBusinessInternalPromotion? _selectedPromotion;
  final Function _onSelectPromotion;
  final bool _usePromotion;
  final Function _onUsePromotionChange;

  //------------------------------------------------------------------------------ null safty

   List<CPRBusinessServer> employeesNullSafty = [] ;
  final List<CPRBusinessServer?> employee;

  convertEmployeeToNullSafty( ) {
    employeesNullSafty  = [];

    if( employee == null ) return;
    if( employee.isEmpty ) return;

    employee.forEach((element) {
      employeesNullSafty.add( element! );
    });

    return employeesNullSafty;
  }

  //--------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    convertEmployeeToNullSafty();
   // print("employees...$employees");
    //  print("_selectedEmployee...${_selectedEmployee.surname}");
//    print("_singleSelectedEmployee... ${_singleSelectedEmployee.firstName}");
   // print("_selectedEmployee. in side ${_selectedEmployee.toJSON()}");
   // employees.forEach((element) {print("${element.toJSON()}");});

    return CPRCard(
      // height: 350 + 90,
      title: const Text(
        "Additional Info",
        style: CPRTextStyles.cardTitleBlack,
      ),
      subtitle: Text(
        "subtitle goes here",
        style: CPRTextStyles.cardSubtitleBlack,
      ),
      backgroundColor: Colors.white,
      icon: MaterialCommunityIcons.information_outline,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: Column(
            children: <Widget>[
              if (employeesNullSafty != null && employeesNullSafty.length > 0)
                Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5)
                            .copyWith(bottom: 0),
                        child: Text(
                          "Who helped/served you?",
                          style: CPRTextStyles.cardSubtitleBlack.copyWith(
                            fontSize: 11,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 10),
                        color: Colors.grey.withOpacity(0.2),

                        //todo: 16/09/22: data correction : showing nickname in place of full name
                        child: DropdownButton<CPRBusinessServer>(
                          isExpanded: true,
                          underline: const SizedBox(),
                          hint: const Text("Select One"),
                          value: _selectedEmployee,
                       //   value: _singleSelectedEmployee,
                          items: employeesNullSafty.map((CPRBusinessServer value) {
                             print("value.id...${value.id}");
                            return value.id == null
                                ? DropdownMenuItem<CPRBusinessServer>(
                                    value: value,
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(200),
                                          child: const Image(
                                            image: AssetImage(
                                                "assets/images/no_avatar_image_choosed.png"),
                                            width: 36,
                                            height: 36,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        const Expanded(
                                          child: Text("Other (Not Listed)"),
                                        ),
                                      ],
                                    ),
                                  )
                                : DropdownMenuItem<CPRBusinessServer>(
                                    value: value,
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(200),
                                          child: Image(
                                            image: getImageProvider(value),
                                            width: 36,
                                            height: 36,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          //todo: 16/09/22: here showing nickname in place of full name
                                          child: Text(value.nickname!),

                                          //   Text(value.firstName! +
                                          //       " " +
                                          //       value.surname!),
                                        )
                                      ],
                                    ),
                                  );
                          }).toList(),
                          onChanged: (CPRBusinessServer? v) {
                            print("selected is ${v!.id!}");
                            _onSelectEmployee(v);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              if (employeesNullSafty != null &&
                  employeesNullSafty.length > 0 &&
                  (_selectedEmployee != null && _selectedEmployee!.id == null))

                //todo:16/9/22: Changes in textInputAction
                ReviewTextField(
                    textInputAction: TextInputAction.next,
                    label: "Other",
                    controller: _firstInputController,
                    focusNode: _firstNode,
                    parentContext: context,
                    nextFocus: _secondNode,
                    maxLines: 1),
              if ((employeesNullSafty == null || employeesNullSafty.length == 0) &&
                  _selectedEmployee == null)
                ReviewTextField(
                    textInputAction: TextInputAction.next,
                    label: "Who helped/served you?",
                    controller: _firstInputController,
                    focusNode: _firstNode,
                    parentContext: context,
                    nextFocus: _secondNode,
                    maxLines: 1),
              ReviewTextField(
                  textInputAction: TextInputAction.next,
                  label: "What did you get done?",
                  controller: _secondInputController,
                  focusNode: _secondNode,
                  parentContext: context,
                  nextFocus: _thirdNode,
                  maxLines: 1),
              ReviewTextField(
                  textInputAction: TextInputAction.next,
                  label: "Why are you there?",
                  controller: _thirdInputController,
                  focusNode: _thirdNode,
                  parentContext: context,
                  nextFocus: _fourthNode,
                  maxLines: 1),
              ReviewTextField(
                  textInputAction: TextInputAction.done,
                  label: "With",
                  controller: _fourthInputController,
                  focusNode: _fourthNode,
                  parentContext: context,
                  nextFocus: _fifthNode,
                  maxLines: 1),
              if (_promotions != null && _promotions.length > 0)
                Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5)
                            .copyWith(bottom: 0),
                        child: Text(
                          "Use Promotion?",
                          style: CPRTextStyles.cardSubtitle.copyWith(
                            fontSize: 11,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 10),
                        color: Colors.grey.withOpacity(0.2),
                        child: DropdownButton<bool>(
                          isExpanded: true,
                          underline: const SizedBox(),
                          value: _usePromotion,
                          hint: const Text("Please Select One"),
                          items: [true, false].map((value) {
                            return DropdownMenuItem<bool>(
                              value: value,
                              child: Text(value ? "Yes" : "No"),
                            );
                          }).toList(),
                          onChanged: (v) {
                            _onUsePromotionChange(v);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              if (_usePromotion &&
                  _promotions != null &&
                  _promotions.length > 0)
                Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5)
                            .copyWith(bottom: 0),
                        child: Text(
                          "Select Promotion",
                          style: CPRTextStyles.cardSubtitle.copyWith(
                            fontSize: 11,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 10),
                        color: Colors.grey.withOpacity(0.2),
                        child: DropdownButton<CPRBusinessInternalPromotion>(
                          isExpanded: true,
                          underline: const SizedBox(),
                          value: _selectedPromotion,
                          items: _promotions
                              .map((CPRBusinessInternalPromotion value) {
                            return DropdownMenuItem<
                                CPRBusinessInternalPromotion>(
                              value: value,
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(200),
                                    child: Image(
                                      image: getProviderImage(value),
                                      width: 36,
                                      height: 36,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: Text(
                                      value.title!,
                                      maxLines: 1,
                                    ),
                                  )
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (v) {
                            _onSelectPromotion(v);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ReviewTextField(
                  parentContext: context,
                  controller: _fifthInputController,
                  focusNode: _fifthNode,
                  label:
                      "Write a comment. Explain your experience, use hashtags #",
                  maxLines: 2),
            ],
          ),
        ),
      ),
    );
  }

  getImageProvider(CPRBusinessServer value) {
    /**
     * #abdo
        value.profilePictureURL
        .isNotEmpty
        ? NetworkImage(
        value.profilePictureURL)
        : AssetImage( "assets/images/no_avatar_image_choosed.png")
     */
    if (ToolsValidation.isValid(value.profilePicture)) {
      return NetworkImage(value.profilePictureURL!);
    }

    return const AssetImage("assets/images/no_avatar_image_choosed.png");
  }

  getProviderImage(CPRBusinessInternalPromotion value) {
    /**
        - #abdo

        value.pictureURL.isNotEmpty
        ? NetworkImage(value.pictureURL)
        : AssetImage(
        "assets/images/no_avatar_image_choosed.png")
     */
    if (ToolsValidation.isValid(value.pictureURL)) {
      return NetworkImage(value.pictureURL!);
    }

    return const AssetImage("assets/images/no_avatar_image_choosed.png");
  }
}
