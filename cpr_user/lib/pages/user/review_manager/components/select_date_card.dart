import 'package:cpr_user/pages/common/components/cpr_card.dart';
import 'package:cpr_user/providers/add_review_provider.dart';
import 'package:cpr_user/providers/review_manager_provider.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart' as p;
import 'package:table_calendar/table_calendar.dart';

class SelectDateCard extends StatefulWidget {

  @override
  _SelectDateCardState createState() => _SelectDateCardState();
}

class _SelectDateCardState extends State<SelectDateCard> {

  ReviewManagerProvider? provider;

  CalendarState? calenderState;

  @override
  Widget build(BuildContext context) {
    provider = p.Provider.of<ReviewManagerProvider>(context);

    return CPRCard(
      // height: 270+90,
      title: const Text(
        "Select a date",
        style: CPRTextStyles.cardTitleBlack,
      ),
      subtitle: Text(
        "subtitle goes here",
        style: CPRTextStyles.cardSubtitleBlack,
      ),
      backgroundColor: Colors.white,
      icon: MaterialCommunityIcons.calendar,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: calenderView(),
      ),
    );
  }


  Widget calenderView() {
    return TableCalendar(
      availableCalendarFormats: const {CalendarFormat.month: "Months"},
      headerStyle: const HeaderStyle(titleCentered: true),
      firstDay: DateTime(2018),
      lastDay: DateTime.now(),
      focusedDay: provider?.review!.when ?? DateTime.now(),
      currentDay: provider?.review!.when ?? DateTime.now(),
      rowHeight: 42,
      onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
        provider?.review!.when = selectedDay;
        setState(() {

        });
      },
      availableGestures: AvailableGestures.none,
      calendarStyle: const CalendarStyle(
        weekendTextStyle: TextStyle(color: Colors.black),
        outsideTextStyle: TextStyle(color: Colors.black),
        selectedTextStyle: TextStyle(color: CPRColors.cprButtonPink),
        todayTextStyle: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}


