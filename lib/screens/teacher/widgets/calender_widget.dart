import 'package:flutter/material.dart';
import 'package:eduplanapp/repositories/core/colors.dart';
import 'package:eduplanapp/repositories/core/textstyle.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderWidget extends StatelessWidget { 
  const CalenderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TableCalendar(
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2035, 10, 16),
        focusedDay: DateTime.now(),
        calendarFormat: CalendarFormat.week,
        calendarStyle: const CalendarStyle(
          todayDecoration: BoxDecoration(
              color: titleColor,
              borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
        daysOfWeekStyle: const DaysOfWeekStyle(
          weekdayStyle: TextStyle(color: headingColor),
          // weekendStyle: TextStyle(color: Colors.red),
        ),
        headerStyle: HeaderStyle(
            rightChevronVisible: false,
            leftChevronVisible: false,
            headerPadding: const EdgeInsets.all(15),
            formatButtonVisible: false,
            titleTextStyle: contentTextStyle),
      ),
    );
  }
}