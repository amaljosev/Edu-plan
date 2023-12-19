import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:eduplanapp/repositories/core/colors.dart';
import 'package:eduplanapp/repositories/core/constants.dart';
import 'package:eduplanapp/repositories/core/textstyle.dart';

class StudentAttendenceDetailsWidget extends StatelessWidget {
  const StudentAttendenceDetailsWidget({
    super.key,
    required this.size,
    required this.studentsMap,
    required this.totalWorkingDaysCompleted,
    required this.isTeacher,
  });

  final Size size;
  final bool isTeacher;
  final Map<String, dynamic>? studentsMap;
  final int totalWorkingDaysCompleted;

  @override
  Widget build(BuildContext context) {
    final String totalpresentDays = "${studentsMap?['total_present_days']}";
    final int totalPresentDays = int.parse(totalpresentDays);
    return SingleChildScrollView(
      child: Container(
        height: isTeacher
            ? MediaQuery.of(context).orientation == Orientation.landscape
                ? 0.9 * MediaQuery.of(context).size.height
                : 0.5 * MediaQuery.of(context).size.height
            : 0.45 * MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).orientation == Orientation.landscape
            ? 0.5 * MediaQuery.of(context).size.width
            : 0.8 * MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: isTeacher ? appbarColor : null,
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment:
                isTeacher ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                'Attendence Details',
                style: titleTextStyle,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Card(
                  elevation: 5,
                  color: Colors.deepPurple.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: CircularPercentIndicator(
                      animation: true,
                      animateFromLastPercent: true,
                      radius: 60.0,
                      lineWidth: 9.0,
                      percent: totalWorkingDaysCompleted != 0
                          ? totalPresentDays / totalWorkingDaysCompleted
                          : 0.0,
                      center: Text(
                        "${(totalWorkingDaysCompleted != 0 ? (totalPresentDays / totalWorkingDaysCompleted * 100).toStringAsFixed(0) : 0)}%",
                      ),
                      progressColor: buttonColor,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total working Days Completed ',
                        style: isTeacher ? contentTextStyle : listViewTextStyle,
                      ),
                      kHeight,
                      Text(
                        'Total Present Days',
                        style: isTeacher ? contentTextStyle : listViewTextStyle,
                      ),
                      kHeight,
                      Text(
                        'Total Missed Days',
                        style: isTeacher ? contentTextStyle : listViewTextStyle,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ': $totalWorkingDaysCompleted',
                        style: isTeacher ? contentTextStyle : listViewTextStyle,
                      ),
                      kHeight,
                      Text(
                        ': ${studentsMap?['total_present_days']}',
                        style: isTeacher ? contentTextStyle : listViewTextStyle,
                      ),
                      kHeight,
                      Text(
                        ': ${studentsMap?['total_missed_days']}',
                        style: isTeacher ? contentTextStyle : listViewTextStyle,
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
