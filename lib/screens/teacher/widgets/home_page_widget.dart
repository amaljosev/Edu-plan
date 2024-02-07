import 'package:flutter/material.dart';
import 'package:eduplanapp/repositories/core/textstyle.dart';
import 'package:eduplanapp/screens/teacher/all_students/allstudents_screen.dart';
import 'package:eduplanapp/screens/teacher/widgets/calender_widget.dart';
import 'package:eduplanapp/screens/teacher/widgets/class_details.dart';
import 'package:eduplanapp/screens/teacher/widgets/teacher_bottom.dart';
import 'package:eduplanapp/screens/teacher/widgets/teacher_studentlist.dart';

class HomePageWidget extends StatelessWidget { 
  const HomePageWidget({
    super.key,
    required this.size,
  }); 

  final Size size;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CalenderWidget(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClassDetailsWidget(size: size),
          ),
          Padding(
            padding: const EdgeInsets.only( 
              left: 15,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Students', style: titleTextStyle),
                TextButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ScreenAllStudentsTeacher(),
                        )),
                    child: const Text('All Students >'))
              ],
            ),
          ),
          const TeacherStudentsList(),
          TeacherActions(size: size),
        ],
      ),
    );
  }
}
