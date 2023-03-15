import 'package:cpr_user/providers/review_provider.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:cpr_user/resource/TimeTools.dart';
import 'package:cpr_user/resource/WaitTools.dart';
import 'package:fastor_app_ui_widget/resource/boarder/BoarderHelper.dart';
import 'package:fastor_app_ui_widget/resource/boarder/BorderRadiusTools.dart';
import 'package:fastor_app_ui_widget/resource/ds/DesignSystemColor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as p;

import '../../../Widgets/calendar_view.dart';



class ReviewCalendarTable extends StatefulWidget {


  final double rowHeight;


  const ReviewCalendarTable({
    this.rowHeight = 35
  })  ;

  @override
  _ReviewCalendarTableState createState() => _ReviewCalendarTableState();
}

class _ReviewCalendarTableState extends State<ReviewCalendarTable> {


  @override
  void dispose() {

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    print( "ReviewCalendarTable - initState() - start");

    ToolsWait.waitToDo( 300, ()  {
      print( "ReviewCalendarTable - initState() - end");
      provider!.notifyListeners();
    });
  }

  ReviewProvider? provider;

  @override
  Widget build(BuildContext context) {
    var sessionProvider = p.Provider.of<SessionProvider>(context);
    provider = p.Provider.of<ReviewProvider>(context);
    // return p.Consumer<ReviewProvider>(
    //   builder: (context, provider, child) {
    //
    //     provider.loadHistoryEvent(sessionProvider.user );
    //
    //    return _cardView(provider);
    //
    //   },
    // );

    provider!.selectedDateByCalender = null;

    provider!.loadHistoryEvent(sessionProvider.user );

    var card =  _cardView(provider!);

    return  card;  //small size
  }


  Widget calenderView(ReviewProvider provider) {
    var cal =  CalendarView(selectDate: (DateTime value) {
      _userChooseDate(provider, value);
    }, getCalenderInstance: (CalendarState value) {
      provider.calendarState = value as CalendarState?;
    },
      events: provider.monthlyReviews,
        onMonthChanged: (date){
          provider.currentCalenderMonth = date;
        }
    );

    return SizedBox( child:  cal,
      width: MediaQuery.of(context).size.width * 0.70,
    );
  }

  //-------------------------------------------------------------------- scale

  Matrix4 scaleXYZTransform({
    double scaleX = 1.00,
    double scaleY = 1.00,
    double scaleZ = 1.00,
  }) {
    return Matrix4.diagonal3Values(scaleX, scaleY, scaleZ);
  }

  //--------------------------------------------------------------------

  Widget _cardView(ReviewProvider provider){


    var calender = calenderView(provider);

    var fixMarginAnimation = Container( child: calender,
      padding: EdgeInsets.symmetric(horizontal: 5 , vertical: 5 ),
      // color: Colors.brown,
      alignment: Alignment.center,
    );

    var cardCalender = BoarderHelper.cardViewPhysical(
        child:  fixMarginAnimation,
        radiusBorder: BorderRadiusTools.get(
            radius_bottomRight: 15,
            radius_bottomLeft: 15
        ),
        colorBackground: DSColor.calendar_card_background,
        elevation_radius_value: 15
    );


    //margin
    return Container(
      child: cardCalender,

      margin: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 5

      ),
    );
  }

  void _userChooseDate(ReviewProvider provider, DateTime value) {
    print( "calenderView() - value: " + value.toString() );

    provider.selectedDateByCalender = value;

    //set is today
    bool isToday = TimeTools.isToday( value );
    provider.SetIsSelectedDateToday = isToday;
    print( "ReviewCalendarTable - calenderView() - isToday: " + isToday.toString() );


    //update ui
    provider.notifyListeners();

  }


}


/**
    Widget getTableCalender(ReviewProvider provider) {
    return  TableCalendar(
    calendarController: _calendarController,
    rowHeight: widget.rowHeight,
    availableGestures: AvailableGestures.horizontalSwipe,
    initialSelectedDay: null,
    headerStyle:  HeaderStyle(centerHeaderTitle: true, formatButtonVisible: false),
    onDaySelected: (date, list, list2) {
    try {
    provider.selectedReviewDays = list as List<Review>;
    } catch (e) {
    provider.selectedReviewDays = [];
    }
    DateTime sd = DateTime(date.year,date.month,date.day);
    DateTime now = DateTime.now();
    DateTime cd = DateTime(now.year,now.month,now.day);
    if(sd==cd)
    provider.SetIsSelectedDateToday = true;
    else
    provider.SetIsSelectedDateToday = false;
    },
    events: provider.monthlyReviews,
    builders: CalendarBuilders(selectedDayBuilder: (context, date, _) {
    Widget w = Container();
    if (date != null) {
    w = Center(
    child: Container(
    height: 30,
    decoration: BoxDecoration(
    shape: BoxShape.circle,
    color: Colors.pink,
    ),
    child: Center(
    child: Text(
    "${date.day}",
    style: TextStyle(color: Colors.white),
    )),
    ),
    );
    }
    return w;
    },
    markersBuilder: (context, date, events, holiday) {
    final children = <Widget>[];
    if (events.isNotEmpty) {
    children.add(
    Center(
    child: Container(
    decoration: BoxDecoration(
    shape: BoxShape.circle,
    border: Border.all(color: Colors.blue, width: 3),
    ),
    height: 80,
    width: 80,
    ),
    ),
    );
    }
    return children;
    }, todayDayBuilder: (context, date, _) {
    Widget w = Container();
    if (date != null) {
    w = Center(
    child: Container(
    height: 30,
    decoration: BoxDecoration(
    shape: BoxShape.circle,
    color: Colors.green,
    ),
    child: Center(
    child: Text(
    "${date.day}",
    style: TextStyle(
    fontSize: 12,
    color: Colors.white,
    fontWeight: FontWeight.bold),
    )),
    ),
    );
    }
    return w;
    }),
    );
    }

 */
