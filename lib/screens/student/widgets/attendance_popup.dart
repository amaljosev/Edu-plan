import 'package:flutter/material.dart';

import 'package:eduplanapp/screens/teacher/profile/widgets/student_attendence_widget.dart';

Future<void> attendanceMessage(
    {required BuildContext context,
    required Size size,
    required bool isTeacher,
    required Map<String, dynamic>? studentsMap,
    required int totalWorkingDaysCompleted}) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        actions: <Widget>[
          StudentAttendenceDetailsWidget(
            isTeacher: isTeacher, 
              size: size,
              studentsMap: studentsMap,
              totalWorkingDaysCompleted: totalWorkingDaysCompleted),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Discard'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
